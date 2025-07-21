{ config, pkgs, lib, ... }:

let
  baseConfig = builtins.fromTOML (builtins.readFile ../helix/config.toml);

in
{
  programs.helix = {
    enable = true;
    settings = baseConfig;
    # settings = baseConfig // {
    # };
  };
}
