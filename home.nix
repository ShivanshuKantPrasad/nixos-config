{ config, lib, pkgs, ... }:

{
  #xdg.configFile."fish/functions/rust.fish".source = ./.config/fish/functions/rust.fish;
  xdg = {
    enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = "org.kde.okular.desktop";
      "application/octet-stream" = "emacsclient.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/org-protocol" = "emacsclient.desktop";
    };
  };

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  home = {

    sessionVariables = rec {
      MANPAGER = "vim +Man!";
      BAT_PAGER = "less";
      W3M_DIR = "${config.xdg.stateHome}/w3m";
      TERMINAL = "kitty";
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
      NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      CABAL_CONFIG = "${config.xdg.configHome}/cabal/config";
      CABAL_DIR = "${config.xdg.dataHome}/cabal";
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
      JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
      IPYTHONDIR = "${config.xdg.configHome}/ipython";
    };

    shellAliases = {
      wget = ''wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'';
      hello = "echo Hello World";
      cat = "bat";
      g = "git";
      glog = "g lg -10";
      gs = "git status";
      la = "ls -lah";
      ls = "eza --icons";
      lvim = "~/.local/bin/lvim";
      e = "emacsclient -nw";
      ed = "emacsclient -nw";
      centaur = "emacs -init-directory ~/.config/centaur";
      doom = "emacs -init-directory ~/.config/doomemacs";
      space = "emacs -init-directory ~/.config/spacemacs";
    };

    file = {
      "${config.xdg.configHome}/ideavim/intellimacs".source =
        pkgs.fetchFromGitHub {
          owner = "MarcoIeni";
          repo = "intellimacs";
          rev = "116e566bafb4c7fe9a2962a746281053e59b1f49";
          sha256 = "0agz51awrq029r8khbg4glwmnz9f1ylk051gbgp5lrmnqkbag282";
        };

      "${config.xdg.configHome}/ideavim/ideavimrc".source =
        config.lib.file.mkOutOfStoreSymlink
        "/home/shivanshu/Dev/nixos-config/.ideavimrc";

      "${config.xdg.configHome}/doom".source =
        config.lib.file.mkOutOfStoreSymlink
        "/home/shivanshu/Dev/nixos-config/.config/doom";

      "${config.xdg.configHome}/keyboard.kbd".source =
        config.lib.file.mkOutOfStoreSymlink
        "/home/shivanshu/Dev/nixos-config/.config/keyboard.kbd";

      "${config.xdg.configHome}/python/pythonrc".text = ''
        import os
        import atexit
        import readline

        history = os.path.join(os.environ['XDG_CACHE_HOME'], 'python_history')
        try:
            readline.read_history_file(history)
        except OSError:
            pass

        def write_history():
            try:
                readline.write_history_file(history)
            except OSError:
                pass

        atexit.register(write_history)
      '';
    };

    username = "shivanshu";
    homeDirectory = "/home/shivanshu";

    packages = with pkgs; [

      # Hyprland
      kmonad
      networkmanagerapplet
      wlogout
      mpd
      jq
      mako
      brightnessctl
      pamixer
      pavucontrol
      libnotify
      wl-clipboard
      cliphist
      swaybg
      variety
      wlr-randr

      ydotool
      keepmenu

      rofi-bluetooth
      rofi-power-menu

      breeze-icons

      # Kde integration
      libqalculate
      # libsForQt5.kdegraphics-thumbnailers
      # libsForQt5.kaccounts-integration
      # libsForQt5.kaccounts-providers
      # libsForQt5.kio-gdrive
      # libsForQt5.kio-extras

      # General Apps
      anki
      discord
      libreoffice
      keepassxc
      motrix
      obsidian
      protonvpn-cli_2

      #File Manager
      ranger
      broot
      krusader
      pcmanfm
      # libsForQt5.dolphin
      # libsForQt5.dolphin-plugins

      #Game
      lutris
      steam
      mangohud
      wineWowPackages.waylandFull
      winetricks

      #Terminal Emulator
      kitty
      wezterm
      alacritty

      #pdf
      okular
      masterpdfeditor
      zathura
      mupdf

      # Virtualization
      virt-manager
      quickemu
      distrobox

      # Terminal commands
      wget
      xclip
      meld
      steam-run
      tealdeer
      scrcpy
      tmux
      grc
      android-tools

      # System
      acpi
      light
      ncdu
      gdu
      xdg-ninja
      system-config-printer

      # Dictionary
      sqlite
      hspell
      wordnet
      hunspell
      hunspellDicts.en-us

      # Zip
      zip
      unzip
      rar

      # Search
      fd
      fzf
      plocate
      fsearch
      silver-searcher
      ripgrep

      # Version Control
      gh
      git
      glab
      lazygit
      subversion

      # Systems Monitoring
      bmon
      htop
      btop
      usbutils
      pciutils
      lshw
      nethogs
      neofetch
      glxinfo
      teamviewer

      # Language
      mitscheme
      luarocks
      rustup
      lld
      mold
      gnumake

      # LaTeX
      pandoc
      texlive.combined.scheme-medium
      graphviz
      gnuplot

      # C
      gcc
      bear
      cmake
      glslang
      clang-tools

      # Debugger
      gdb
      seer
      gf

      # Nix
      nvd
      nix-index
      cachix
      statix
      deadnix
      rnix-lsp
      nixfmt
      nixpkgs-fmt
      patchelf
      update-nix-fetchgit

      #raku
      rakudo
      zef

      # Web
      nodejs
      html-tidy
      wireshark
      nodePackages.stylelint
      nodePackages.js-beautify

      #Shell
      shfmt
      shellcheck

      #Python
      pipx
      pipenv
      (python3.withPackages
        (ps: with ps; [ jupyter isort black nose pytest pyflakes setuptools ]))

      # Media
      yt-dlp
      spotify
      qbittorrent
      feh
      gimp
      vlc
      mpv

      # Browsers
      vieb
      vivaldi
      qutebrowser

      # IDEs
      jetbrains.clion
      jetbrains.idea-ultimate

      # Editors
      vscode
      #sublime4
      neovide
      my-emacs

      #Man packages
      #linux-manual
      man-pages-posix
      man-pages
      zeal
      hors

    ];

    stateVersion = "23.05";

  };

  services.emacs = {
    enable = true;
    package = pkgs.my-emacs;
    defaultEditor = true;
  };
  services.syncthing.enable = true;

  programs = {
    home-manager.enable = true;
    swaylock.enable = true;
    swaylock.package = pkgs.swaylock-effects;
    bat.enable = true;
    eza.enable = true;
    bash.enable = true;
    bash.initExtra = ''
      source "$(blesh-share)"/ble.sh --attach=none # does not work currently
      [[ $\{BLE_VERSION-} ]] && ble-attach
    '';
    fish = {
      enable = true;
      shellAbbrs = { ni = "nix profile install nixpkgs#"; };
      functions = {
        nlist =
          "nix profile list | sed -n '2~6p' | awk -F '.' '{print NR-1, $3}'";
      };
      plugins = [{
        name = "grc";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-grc";
          rev = "61de7a8a0d7bda3234f8703d6e07c671992eb079";
          sha256 = "1r4zsf3ndf92p0iqj5nwzk7mq3l7jhahxk4q23v4r51kppcba1im";
        };
      }];
    };
    # oh-my-posh.enable = true;
    # oh-my-posh.useTheme = "robbyrussel";
    # oh-my-posh.useTheme = "tonybaloney";
    starship.enable = true;
    zoxide.enable = true;

    # kodi.enable = true;
    kodi.datadir = "${config.xdg.dataHome}/kodi";

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    rofi = {
      enable = true;
      plugins = [ pkgs.rofi-file-browser pkgs.rofi-calc ];
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
