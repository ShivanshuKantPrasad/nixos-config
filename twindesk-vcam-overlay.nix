# twindesk-vcam-overlay.nix
#
# Fixes "Camera › Virtual camera: Not in this build of DuoDesk" on Nix/NixOS.
#
# Why it happens: linux/vcam.js only reports the feature as supported when
#   <app>/linux-helper/bin/twindesk-vcam
# exists. linux-helper/build.sh, the .deb installer and the AUR package all build and
# ship that binary (from linux-helper/vcam/vcam.c), but flake.nix never compiles or
# installs it, so the check fails and the toggle is greyed out.
#
# This overlay must come AFTER the flake's own overlay (it extends `pkgs.twindesk`).
final: prev: {
  twindesk = prev.twindesk.overrideAttrs (old: {
    # buildPhase ends with `runHook postBuild`, so this runs after the other helpers
    # are compiled, from the same source root (linux-helper/bin already exists).
    # vcam.c only needs <linux/videodev2.h> (kernel headers, part of stdenv's libc).
    postBuild = (old.postBuild or "") + ''
      $CC -O2 -Wall -Wextra -std=gnu11 linux-helper/vcam/vcam.c \
        -o linux-helper/bin/twindesk-vcam
    '';

    # installPhase ends with `runHook postInstall`; $share/linux-helper/bin is where
    # linux/vcam.js looks (path.join(__dirname, '..', 'linux-helper', 'bin', ...)).
    postInstall = (old.postInstall or "") + ''
      install -Dm755 linux-helper/bin/twindesk-vcam \
        "$out/share/twindesk/linux-helper/bin/twindesk-vcam"
    '';
  });
}
