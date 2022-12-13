{ config, pkgs, ... }:

{
  #xdg.configFile."fish/functions/rust.fish".source = ./.config/fish/functions/rust.fish;
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
      topgrade
      nethogs
      discord
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
      bmon
      usbutils
      pciutils
      lshw
      cmake
      gcc
      gdb
      gnumake
      update-nix-fetchgit

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

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    exa.enable = true;
    fish.enable = true;
    kodi.enable = true;

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };
}
