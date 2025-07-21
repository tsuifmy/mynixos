{ config, pkgs, lib, selectedTheme ? "catppuccin-mocha", ... }:

let
  # 读取多个配置文件
  baseConfig = builtins.fromTOML (builtins.readFile ../alacritty/alacritty.toml);
  
  # 选择主题
  themeConfig = builtins.fromTOML (builtins.readFile (../alacritty/themes + "/${selectedTheme}.toml"));
  
  # 本地覆盖配置（如果存在）
  localPath = ../alacritty/local.toml;
  localConfig = if builtins.pathExists localPath
                then builtins.fromTOML (builtins.readFile localPath)
                else {};
  
  # 合并所有配置
  mergedConfig = lib.recursiveUpdate 
    (lib.recursiveUpdate baseConfig themeConfig) 
    localConfig;
in
{
  programs.alacritty = {
    enable = true;
    settings = mergedConfig // {
      # 系统特定配置，优先级最高
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "--login" ];
      };
      
      # 根据系统调整字体大小
      font.size = lib.mkForce (if pkgs.stdenv.isDarwin then 13.0 else 11.0);
      
      # 确保有工作目录
      general.working_directory = config.home.homeDirectory;
    };
  };
}
