{ config, pkgs, ... }:

{
  #xdg.configFile."fish/functions/rust.fish".source = ./.config/fish/functions/rust.fish;
  xdg.enable = true;
  home.sessionVariables = rec {
    ANDROID_HOME = "${config.xdg.dataHome}/android";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    HISTFILE = "${config.xdg.stateHome}/bash/history";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    RUSUTP_HOME = "${config.xdg.dataHome}/rustup";
    WINEPREFIX = "${config.xdg.dataHome}/wine";
    ERRFILE = "${config.xdg.cacheHome}/X11/xsession-errors";
    _Z_DATA = "${config.xdg.dataHome}/z";
    # NPM_CONFIG_USERCONFIG="${config.xdg.configHome}/npm/npmrc";

  };

  home = {

    file = {
      "${config.xdg.configHome}/ideavim/intellimacs".source = pkgs.fetchFromGitHub {
        owner = "MarcoIeni";
        repo = "intellimacs";
        rev = "116e566bafb4c7fe9a2962a746281053e59b1f49";
        sha256 = "0agz51awrq029r8khbg4glwmnz9f1ylk051gbgp5lrmnqkbag282";
      };

      "${config.xdg.configHome}/ideavim/ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "/run/media/shivanshu/Dev/nixos-config/.ideavimrc";
      # "${config.xdg.configHome}/ideavim/ideavimrc".source = ./.ideavimrc;
    };

    username = "shivanshu";
    homeDirectory = "/home/shivanshu";

    packages = with pkgs; [

      alacritty
      discord
      libreoffice
      masterpdfeditor
      lutris
      steam
      mangohud
      zeal

      # Virtualization
      quickemu
      distrobox

      # Terminal commands
      nethogs
      neofetch
      gh
      glab
      git
      subversion
      zip
      unzip
      rar
      fzf
      fsearch
      fd
      android-tools
      silver-searcher
      ripgrep
      sqlite
      wordnet
      bmon
      bpytop
      meld
      hspell
      usbutils
      pciutils
      lshw
      glxinfo

      # Language
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
      grc
      gdu
      tealdeer
      scrcpy
      tmux
      grc

      # Media
      spotify
      qbittorrent
      feh
      gimp-with-plugins
      vlc

      # Browsers
      brave
      # vieb

      # IDEs
      jetbrains.clion
      jetbrains.idea-ultimate

      # Editors
      vscode
      sublime4
      neovide
      ((emacsPackagesFor emacsNativeComp).emacsWithPackages
        (epkgs: [ epkgs.vterm ]))

    ];

    stateVersion = "22.11";

  };

  services.emacs.enable = true;

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    exa.enable = true;
    fish.enable = true;

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

  };

}
