{ config, pkgs, ... }:

{
  #xdg.configFile."fish/functions/rust.fish".source = ./.config/fish/functions/rust.fish;
  xdg.enable = true;
  home = {

    file = {
      ".intellimacs".source = pkgs.fetchFromGitHub {
        owner = "MarcoIeni";
        repo = "intellimacs";
        rev = "116e566bafb4c7fe9a2962a746281053e59b1f49";
        sha256 = "0agz51awrq029r8khbg4glwmnz9f1ylk051gbgp5lrmnqkbag282";
      };

      ".ideavimrc".source = ./.ideavimrc;
    };

    username = "shivanshu";
    homeDirectory = "/home/shivanshu";

    packages = with pkgs; [

      alacritty
      discord
      libreoffice
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
      git
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

      # Language
      clang-tools
      cmake
      python3
      rustup
      rust-analyzer
      lld
      mold
      gcc
      gdb
      gnumake
      statix
      deadnix
      nvd
      nixfmt
      patchelf
      update-nix-fetchgit
      grc
      gdu
      tldr
      scrcpy
      tmux
      grc

      # Media
      spotify
      qbittorrent
      feh
      gimp
      vlc

      # Browsers
      brave
      # vieb

      # IDEs
      nur.repos.utybo.jetbrains.clion
      nur.repos.utybo.jetbrains.rider
      nur.repos.utybo.jetbrains.idea-ultimate

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
