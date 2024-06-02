{ config, lib, pkgs, ... }:

{
  xsession.enable = true;

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
    platformTheme.name = "kde";
  };

  home = {

    pointerCursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 36;
      gtk.enable = true;
    };

    sessionVariables = rec {
      NIXOS_OZONE_WL = "1";
      MANPAGER = "vim +Man!";
      BAT_PAGER = "less";
      W3M_DIR = "${config.xdg.stateHome}/w3m";
      TERMINAL = "kitty";
      ANDROID_HOME = "${config.xdg.dataHome}/android";
      ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      HISTFILE = "${config.xdg.stateHome}/bash/history";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
      # GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      WINEPREFIX = "${config.xdg.dataHome}/wine";
      ERRFILE = "${config.xdg.cacheHome}/X11/xsession-errors";
      USERXSESSION = "${config.xdg.cacheHome}/X11/xsession";
      _Z_DATA = "${config.xdg.dataHome}/z";
      NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      CABAL_CONFIG = "${config.xdg.configHome}/cabal/config";
      CABAL_DIR = "${config.xdg.dataHome}/cabal";
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
      JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
      IPYTHONDIR = "${config.xdg.configHome}/ipython";
      FLAKE = "/home/shivanshu/Dev/nixos-config";
      MYSQL_HISTFILE = "${config.xdg.dataHome}/mysql_history";
    };

    shellAliases = {
      # adb = ''HOME="$XDG_DATA_HOME"/android adb'';
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
      na = "nix profile install";
      nr = "nix profile remove";
      ns = "nix-search";
      no = "~/.local/share/cargo/bin/nox";
      tp = "trash put";
      rm = ''echo "rm is scary😨. Use trashy (tp)🗑️ instead."; false'';
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
      kanata-with-cmd
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
      pyprland
      grimblast
      hyprcursor

      ydotool
      keepmenu

      rofi-bluetooth
      rofi-power-menu

      breeze-icons
      orchis-theme
      themechanger

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
      teams-for-linux
      teamviewer
      libreoffice
      keepassxc
      # obsidian
      protonvpn-cli_2
      kget

      #File Manager
      ranger
      broot
      krusader
      pcmanfm
      # libsForQt5.dolphin
      # libsForQt5.dolphin-plugins

      #Game
      lutris
      mangohud
      wineWowPackages.waylandFull
      winetricks
      mindustry-wayland

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
      devbox
      quickemu
      qemu-utils
      distrobox
      libvirt-glib
      virt-viewer

      # Terminal commands
      trashy
      wget
      xclip
      meld
      steam-run
      appimage-run
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
      # peazip
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
      glab
      subversion

      # Systems Monitoring
      bmon
      htop
      btop
      usbutils
      pciutils
      # lshw
      (lshw.override { withGUI = true; })
      nethogs
      fastfetch
      glxinfo
      hwinfo
      procs

      # Language
      mitscheme
      luarocks
      rustup
      evcxr # rust repl
      lld
      mold
      just
      gnumake
      openjdk
      zig
      go

      # LaTeX
      pandoc
      texlive.combined.scheme-medium
      graphviz
      gnuplot

      # C
      gcc
      bear
      cmake
      libtool
      glslang
      pkg-config
      clang-tools
      cmake-language-server

      # Debugger
      # linuxKernel.packages.linux_6_1.perf
      #linuxPackages_latest.perf
      samply
      kcachegrind
      valgrind
      massif-visualizer
      hyperfine
      hotspot
      ghidra
      lldb
      gdb
      seer
      gf
      rr

      # Nix
      nh
      nvd
      nil
      nixfmt-classic
      cachix
      statix
      deadnix
      patchelf
      nixpkgs-fmt
      nix-search-cli
      nix-output-monitor
      update-nix-fetchgit

      #raku
      rakudo
      zef

      # Web
      phpPackages.composer
      php
      nodejs
      html-tidy
      wireshark
      nodePackages.stylelint
      nodePackages.js-beautify

      #Shell
      shfmt
      shellcheck
      nushell
      vivid
      carapace
      blesh
      jc

      #Python
      pipx
      pipenv
      (python3.withPackages
        (ps: with ps; [ jupyter isort black nose pytest pyflakes setuptools ]))

      # Media
      revanced-cli
      yt-dlp
      spotify
      qbittorrent
      gwenview
      feh
      nomacs
      blender
      gimp
      vlc
      mpv

      # Browsers
      vieb
      (vivaldi.override {
          enableWidevine = true;
          proprietaryCodecs = true;
          commandLineArgs = ["--enable-features=UseOzonePlatform" "--ozone-platform=wayland"];
      })
      (microsoft-edge.override {
          commandLineArgs = ["--enable-features=UseOzonePlatform" "--ozone-platform=wayland"];
      })
      floorp
      qutebrowser
      thunderbird

      # IDEs
      jetbrains.clion
      jetbrains.idea-community
      jetbrains.pycharm-community
      jetbrains.datagrip
      jetbrains.rust-rover
      eclipses.eclipse-sdk
      android-studio

      # Editors
      helix
      vscode
      neovide
      my-emacs

      #Man packages
      #linux-manual
      man-pages-posix
      man-pages
      zeal
      hors
      python3Packages.howdoi

    ];

    stateVersion = "23.05";

  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
  };

  services.emacs = {
    enable = true;
    package = pkgs.my-emacs;
    defaultEditor = true;
    socketActivation.enable = true;
    startWithUserSession = "graphical";
  };
  services.syncthing.enable = true;

  programs = {
    nix-index-database.comma.enable = true;
    nix-index.enable = true;
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
      package = pkgs.rofi-wayland;
      plugins = [
        (pkgs.rofi-file-browser.override { rofi = pkgs.rofi-wayland; })
        (pkgs.rofi-calc.override { rofi-unwrapped = pkgs.rofi-wayland; })
      ];
    };

    gh.enable = true;
    git = {
      enable = true;
      delta.enable = true;
      userName = "Shivanshu Kant Prasad";
      userEmail = "shivanshukantprasad@gmail.com";
      aliases = {
        lg =
          "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
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
