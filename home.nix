{ config, pkgs, ... }:

{
  #xdg.configFile."fish/functions/rust.fish".source = ./.config/fish/functions/rust.fish;
  xdg.enable = true;
  home = {

    sessionVariables = rec {
      ANDROID_HOME = "${config.xdg.dataHome}/android";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      HISTFILE = "${config.xdg.stateHome}/bash/history";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
      GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      WINEPREFIX = "${config.xdg.dataHome}/wine";
      ERRFILE = "${config.xdg.cacheHome}/X11/xsession-errors";
      _Z_DATA = "${config.xdg.dataHome}/z";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      CABAL_CONFIG = "${config.xdg.configHome}/cabal/config";
      CABAL_DIR = "${config.xdg.dataHome}/cabal";
    };


    shellAliases = {
      hello = "echo Hello World";
      cat = "bat";
      g = "git";
      glog = "g lg -10";
      gs = "git status";
      la = "ls -lah";
      ls = "exa --icons";
      lvim = "~/.local/bin/lvim";
    };

    file = {
      "${config.xdg.configHome}/ideavim/intellimacs".source = pkgs.fetchFromGitHub {
        owner = "MarcoIeni";
        repo = "intellimacs";
        rev = "116e566bafb4c7fe9a2962a746281053e59b1f49";
        sha256 = "0agz51awrq029r8khbg4glwmnz9f1ylk051gbgp5lrmnqkbag282";
      };

      "${config.xdg.configHome}/ideavim/ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "/run/media/shivanshu/Dev/nixos-config/.ideavimrc";
      "${config.xdg.configHome}/doom".source = config.lib.file.mkOutOfStoreSymlink "/run/media/shivanshu/Dev/nixos-config/.config/doom";
      "${config.xdg.configHome}/keyboard.kbd".source = config.lib.file.mkOutOfStoreSymlink "/run/media/shivanshu/Dev/nixos-config/.config/keyboard.kbd";
    };

    username = "shivanshu";
    homeDirectory = "/home/shivanshu";

    packages = with pkgs; [

      # Kde integration
      ark
      libsForQt5.bismuth
      libsForQt5.kdegraphics-thumbnailers
      libsForQt5.kaccounts-integration
      libsForQt5.kaccounts-providers
      libsForQt5.kio-gdrive

      # General Apps
      wezterm
      alacritty
      discord
      libreoffice
      masterpdfeditor
      lutris
      steam
      mangohud
      keepassxc
      zeal

      # Virtualization
      virt-manager
      quickemu
      distrobox

      # Terminal commands
      vim
      wget
      xclip
      meld
      gh
      git
      glab
      subversion
      zip
      unzip
      rar
      fd
      fzf
      plocate
      fsearch
      silver-searcher
      ripgrep
      sqlite
      wordnet
      hspell
      android-tools

      # Systems Monitoring
      bmon
      htop
      bpytop
      usbutils
      pciutils
      lshw
      nethogs
      neofetch
      glxinfo
      teamviewer

      # Language
      luarocks
      nodejs
      gcc
      clang-tools
      cmake
      python3
      rustup
      rust-analyzer
      lld
      mold
      gnumake
      statix
      deadnix
      nvd
      nixfmt
      nixpkgs-fmt
      patchelf
      update-nix-fetchgit
      ncdu
      gdu
      tealdeer
      scrcpy
      tmux
      grc

      # Media
      spotify
      qbittorrent
      feh
      gimp
      vlc
      mpv

      # Browsers
      brave
      firefox
      microsoft-edge
      qutebrowser
      vieb

      # IDEs
      jetbrains.clion
      jetbrains.idea-ultimate

      # Editors
      vscode
      kate
      sublime4
      neovide
      emacsPgtk

    ];

    stateVersion = "22.11";

  };

  services.emacs.enable = true;
  services.emacs.package = pkgs.emacsPgtk;
  services.syncthing.enable = true;

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    exa.enable = true;
    bash.enable = true;
    fish.enable = true;
    fish.plugins = [
      {
        name = "grc";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-grc";
          rev = "61de7a8a0d7bda3234f8703d6e07c671992eb079";
          sha256 = "1r4zsf3ndf92p0iqj5nwzk7mq3l7jhahxk4q23v4r51kppcba1im";
        };
      }

    ];
    # oh-my-posh.enable = true;
    # oh-my-posh.useTheme = "robbyrussel";
    # oh-my-posh.useTheme = "tonybaloney";
    starship.enable = true;
    zoxide.enable = true;

    kodi.enable = true;
    kodi.datadir = "${config.xdg.dataHome}/kodi";

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    # doom-emacs = rec {
    #   enable = true;
    #   doomPrivateDir = ./.config/doom;
    #
    #   emacsPackage = pkgs.emacsPgtk;
    #   # emacsPackage = with pkgs; (emacsPackagesFor emacsGit).emacsWithPackages
    #   # (epkgs: [ epkgs.vterm ]);
    #   doomPackageDir =
    #     let
    #       filteredPath = builtins.path {
    #         path = doomPrivateDir;
    #         name = "doom-private-dir-filtered";
    #         filter = path: type:
    #           builtins.elem (baseNameOf path) [ "init.el" "packages.el" ];
    #       };
    #     in
    #     pkgs.linkFarm "doom-packages-dir" [
    #       {
    #         name = "init.el";
    #         path = "${filteredPath}/init.el";
    #       }
    #       {
    #         name = "packages.el";
    #         path = "${filteredPath}/packages.el";
    #       }
    #       {
    #         name = "config.el";
    #         path = pkgs.emptyFile;
    #       }
    #     ];
    # };

  };

}
