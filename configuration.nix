# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: {
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "shivanshu"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  # time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.gvfs.enable = true;

  services.flatpak.enable = true;
  # services.teamviewer.enable = true;
  # services.accounts-daemon.enable = true;
  
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.tomcat.enable = true;
  services.tomcat.package = pkgs.tomcat10;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "chili";
  services.displayManager.sddm.autoNumlock = true;
  # services.xserver.windowManager.qtile.enable = true;
  # services.xserver.windowManager.qtile.backend = "wayland";
  # services.xserver.windowManager.qtile.extraPackages = python3Packages:
  # [ python3Packages.qtile-extras ];
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  # services.kmonad.enable = true;
  # services.keyd.enable = true;
  # services.kanata.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.nssmdns4 = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  hardware.uinput.enable = true;
  services.pipewire = {
    enable = true;
    systemWide = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    # wireplumber.enable = true;
  };

  security.rtkit.enable = true;
  security.pam.services.swaylock = { };

  # Bluetooth support
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shivanshu = {
    isNormalUser = true;
    description = "Shivanshu";
    extraGroups = [
      "pipewire"
      "vboxusers"
      "input"
      "uinput"
      "docker"
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    shell = pkgs.bash;
  };

  environment.shells = with pkgs; [ fish ];

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      comic-mono
      victor-mono
      fantasque-sans-mono
      jetbrains-mono
      emacs-all-the-icons-fonts
      font-awesome
      nerdfonts
      noto-fonts
    ];
  };

  environment.systemPackages = with pkgs; [ config.boot.kernelPackages.perf sddm-chili-theme ];

  programs = {
    virt-manager.enable = true;
    adb.enable = true;
    nix-ld.enable = true;
    waybar.enable = true;
    hyprland.enable = true;
    fish.enable = true;
    # partition-manager.enable = true;
    gamemode.enable = true;
    dconf.enable = true;
    # kdeconnect.enable = true;
    npm = {
      enable = true;
      npmrc = ''
        prefix=''${XDG_DATA_HOME}/npm
        cache=''${XDG_CACHE_HOME}/npm
        tmp=''${XDG_RUNTIME_DIR}/npm
        init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      '';
    };
  };

  # List services that you want to enable:

  services.logind.lidSwitchExternalPower = "ignore";

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "hourly";
    localuser = null;
  };

  # Enable ipfs service
  # services.kubo.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  hardware = {
    opengl.driSupport32Bit = true;

    bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 6567 8795 ];
  networking.firewall.allowedUDPPorts = [ 6567 8795 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.pathsToLink = [ "/share/nix-direnv" ];

  nix = {
    # nix options for derivations to persist garbage collection
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
        "https://static-haskell-nix.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "static-haskell-nix.cachix.org-1:Q17HawmAwaM1/BfIxaEDKAxwTOyRVhPG5Ji9K3+FvUU="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = [ "ca-derivations" "nix-command" "flakes" ];
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
  };

  virtualisation = {
    # virtualbox.host.enable = true;
    # virtualbox.host.enableExtensionPack = true;
    docker.enable = true;
    waydroid.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
  };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # systemd.services.kmonad = {
  #   enable = true;
  #   description = "kmonad";
  #   script = "source ${config.system.build.setEnvironment}; ${pkgs.kmonad}/bin/kmonad /home/shivanshu/.config/keyboard.kbd";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig = {
  #     User = "shivanshu";
  #     Restart = "always";
  #
  #   };
  # };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
