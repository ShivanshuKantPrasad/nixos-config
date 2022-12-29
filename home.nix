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

      brave
      neofetch
      nvd
      nixfmt
      nethogs
      discord
      gh
      git
      zip
      unzip
      rar
      spotify
      qbittorrent
      sublime4
      zeal

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
      cmake
      python3
      rustup
      gcc
      gdb
      gnumake
      update-nix-fetchgit
      alacritty
      quickemu
      neovide
      grc
      gdu
      tldr
      scrcpy
      tmux
      vscode
      feh
      grc

      jetbrains.rider
      jetbrains.clion
      libreoffice
      lutris
      mangohud
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
