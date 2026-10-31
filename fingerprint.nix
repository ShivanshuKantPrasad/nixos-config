# fingerprint.nix
#
# ELAN7001 (SPI) fingerprint reader, touchpad HID 04F3:3087, on an ASUS X515JA.
#
# What this does:
#   1. Builds libfprint from the goodix-fp-linux-dev "sigfm" fork (pinned) with
#      SIGFM matching, which can tell fingers apart on tiny sensors where
#      libfprint's stock NBIS/bozorth3 matcher cannot.
#   2. Applies elanspi-touch.patch (from idruvau5/asus-elan7001-fingerprint-linux
#      v0.1.4): press-mode capture of one full frame instead of swipe+stitch,
#      throttled polling, sensor reset on release.
#   3. Points fprintd at that libfprint (no LD_LIBRARY_PATH hacks).
#   4. Binds the ELAN7001 SPI device to spidev and raises spidev's buffer size.
#
# Usage: put this file and elanspi-touch.patch in the same directory as your
# configuration.nix, then add   imports = [ ./fingerprint.nix ];
#
# The patch touches libfprint (LGPL-2.1-or-later) and is distributed under the
# same terms; it was written for the VivoBook S530FN (same touchpad PID 3087),
# NOT specifically for the X515JA. See the notes that accompanied this file.
{ config, lib, pkgs, ... }:

let
  libfprint-sigfm = pkgs.libfprint.overrideAttrs (old: {
    pname = "libfprint-sigfm";
    version = "1.94.5-sigfm-07306bb";

    src = pkgs.fetchFromGitHub {
      owner = "goodix-fp-linux-dev";
      repo = "libfprint";
      rev = "07306bbc9256942595e31fb0f407b364ffa24d07";
      # Computed from `git archive` of the pinned commit. If Nix reports a
      # mismatch on first build, replace this with the hash it prints.
      hash = "sha256-HNFR+5kWHhG4inIn1An4aJ1RoieHbNh5aiTW0g5hAV0=";
    };

    # Replaces any patches nixpkgs applies to its (newer) libfprint, since they
    # target a different source tree than this fork.
    patches = [ ./elanspi-touch.patch ./elanspi-wait-release.patch ];

    # The fork's libsigfm meson.build also builds a unit-test binary that links
    # "-ldoctest". doctest is header-only in nixpkgs, so that link step fails
    # after everything else has compiled. We don't run those tests, so drop the
    # doctest dependency and the test executable (the only two lines mentioning it).
    #
    # Also: fprintd 1.94.5 references FP_DEVICE_RETRY_TOO_FAST, an enum value
    # libfprint added in 1.94.9 (this is why fprintd asks for >= 1.94.9). It is
    # only a retry code that fprintd maps to a D-Bus string; the elanspi driver
    # never emits it. Append it to the enum (end of list, so existing values
    # keep their numbers) and fail the build if the edit did not apply.
    postPatch = (old.postPatch or "") + ''
      sed -i '/doctest/d' libfprint/sigfm/meson.build

      sed -i 's/^  FP_DEVICE_RETRY_REMOVE_FINGER,$/  FP_DEVICE_RETRY_REMOVE_FINGER,\n  FP_DEVICE_RETRY_TOO_FAST,/' libfprint/fp-device.h
      grep -q FP_DEVICE_RETRY_TOO_FAST libfprint/fp-device.h
    '';

    # The fork's installed public header fp-image.h does `#include
    # "sigfm/sigfm.hpp"` but never installs that file, so anything that
    # includes <fprint.h> (fprintd) fails to compile. It is a plain C header
    # (extern "C" guarded, no C++ or OpenCV dependency), so just install it
    # next to the other libfprint-2 headers. postInstall runs in the meson
    # build directory, hence the "../".
    postInstall = (old.postInstall or "") + ''
      install -Dm644 ../libfprint/sigfm/sigfm.hpp \
        "$out/include/libfprint-2/sigfm/sigfm.hpp"
    '';

    buildInputs = (old.buildInputs or [ ]) ++ [
      pkgs.opencv # SIGFM uses SIFT from OpenCV (>= 4.5)
    ];

    # Build only the driver this laptop needs. "-Ddrivers=all" drags in ~30
    # drivers for other readers, some of which need nss (which current nixpkgs
    # libfprint no longer provides) or an old OpenSSL API. Any -Ddrivers flag
    # nixpkgs sets is dropped so ours cannot be overridden by it.
    mesonFlags =
      (lib.filter (f: !(lib.hasPrefix "-Ddrivers=" f)) (old.mesonFlags or [ ]))
      ++ [ "-Ddrivers=elanspi" ];

    # The upstream test suite needs a sandbox-unfriendly environment and the
    # fork's tests were never run against newer toolchains.
    doCheck = false;
    doInstallCheck = false;
  });

  # fprintd's own version number is unrelated to libfprint's, but this fprintd
  # (1.94.5) asks for libfprint >= 1.94.9 and the fork is based on 1.94.5.
  # Relax that check instead of mislabelling the fork. I could not find out
  # *why* fprintd wants 1.94.9, so treat this as an experiment: if fprintd
  # needs a function the fork lacks, the build fails at compile/link time
  # (loudly); if it builds, any gap would be in behavior, not API.
  fprintd-sigfm =
    (pkgs.fprintd.override { libfprint = libfprint-sigfm; }).overrideAttrs
    (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace meson.build --replace-fail "1.94.9" "1.94.5"
      '';
      # fprintd's tests use libfprint's virtual test drivers, which this
      # elanspi-only build does not include.
      doCheck = false;
      doInstallCheck = false;
    });
in {
  services.fprintd = {
    enable = true;
    package = fprintd-sigfm;
  };

  # libfprint's own rule (generated by fprint-list-udev-rules) that hands the
  # ELAN7001 SPI device to the generic spidev driver, so fprintd can talk to it
  # through /dev/spidevX.Y. Written out here so it does not depend on whether
  # the NixOS fprintd module installs the libfprint rules.
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="spi", ENV{MODALIAS}=="acpi:ELAN7001:", RUN{builtin}+="kmod load spi:spidev", RUN+="${pkgs.runtimeShell} -c 'echo spidev > %S%p/driver_override && echo %k > %S%p/subsystem/drivers/spidev/bind'"
  '';

  # The sensor returns a whole frame per SPI message; spidev's default 4096-byte
  # buffer truncates it. Works whether spidev is a module or built in.
  # Needs a reboot to take effect.
  boot.kernelParams = [ "spidev.bufsiz=32768" ];

  # fprintd enables fingerprint auth for every PAM service by default. At a
  # display manager that can delay password entry until the fingerprint prompt
  # times out (nixpkgs issue 171136), so keep it off at the login screen and
  # leave it on for sudo, the KDE lock screen, polkit, etc. Password auth stays
  # available everywhere. Adjust if you use a different display manager.
  security.pam.services = {
    login.fprintAuth = false;
    sddm.fprintAuth = false;
    hyprlock.fprintAuth = false;
  };
}
