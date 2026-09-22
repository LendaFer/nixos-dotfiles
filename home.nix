{ config, pkgs, ... }:

let 
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path : config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    qtile = "qtile";
    nvim = "nvim";
    alacritty = "alacritty";
    rofi = "rofi";
  };

in

{

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home = {
    username = "leah";
    homeDirectory = "/home/leah";
    stateVersion = "26.05";
    packages = with pkgs; [
      neovim
      rofi

      # Tools required for Telescope
      ripgrep
      fd
      fzf

      # Language Servers
      lua-language-server
      nil # nix language server
      nixpkgs-fmt # nix formatter

      # Needed for lazy.nvim
      nodejs


      gcc
      xwallpaper
    ];
  };
  programs = {
    git.enable = true;
    bash = {
      enable = true;
      shellAliases = {
        btw = "echo i use nixos, btw";
        nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-at-home";
        vim = "nvim";
        vi = "nvim";
      };
      initExtra = ''
      	  export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
      	'';
    };
  };
}
