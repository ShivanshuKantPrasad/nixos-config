{ config, pkgs, ... }:

{
  #xdg.configFile."fish/functions/rust.fish".source = ./.config/fish/functions/rust.fish;
  #xdg.configFile."emacs".source = pkgs.fetchFromGitHub {
  #  owner = "doomemacs";
  #  repo = "doomemacs";
  #  rev = "d5ccac5d71c819035fa251f01d023b3f94b4fba4";
  #  sha256 = "1hrhh3fa98nc9dc1a4x7slakmf3gfrqrcx4d4vg65rd8rb9wn37c";
  #}; 

  #xdg.configFile."doom".source = ./.config/doom; 

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
      silver-searcher
      ripgrep
      bmon
      usbutils
      jetbrains.rider
      pciutils
      lshw
      libreoffice
      cmake
      gcc
      gnumake
      update-nix-fetchgit
      ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [ epkgs.vterm ]))
   ];

    stateVersion = "22.11";

  };

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    exa.enable = true;
    fish.enable = true;
  };
}
