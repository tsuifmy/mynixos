{ config, pkgs, alacrittyTheme ? "catppuccin-mocha", ... }:

{
  imports = [
    ./modules/alacritty.nix
    ./modules/helix.nix
  ];

  # Home Manager 基本信息
  home.username = "wayne";
  home.homeDirectory = "/home/wayne";
  home.stateVersion = "25.05";

  # 让 Home Manager 管理自身
  programs.home-manager.enable = true;

  # 传递主题参数给 alacritty 模块
  _module.args = {
    selectedTheme = alacrittyTheme;
  };

  # Git 配置
  programs.git = {
    enable = true;
    userName = "Wayne Tsui";
    userEmail = "wayne0tsui@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";

      # 对所有 github.com 的连接使用代理
      http."https://github.com".proxy = "http://127.0.0.1:7897";
    };
  };

  # Zsh 配置
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      hm-switch = "home-manager switch";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

   initContent = ''
      # 设置npm配置
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"
      export PATH="$HOME/.npm-global/bin:$PATH"

      # Set rustup server
      export RUSTUP_DIST_SERVER="https://rsproxy.cn"
      export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

      # 创建npm全局目录（如果不存在）
      [[ ! -d "$HOME/.npm-global" ]] && mkdir -p "$HOME/.npm-global"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" ];
      theme = "robbyrussell";
    };
  };

  # Rust配置
  home.file.".cargo/config.toml".source = ./rust/config.toml;

  # 配置npm全局安装路径
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # 添加npm全局bin到PATH
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  # 其他程序配置
  programs = {
    # 目录跳转工具
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    # 现代化的 ls
    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    # 模糊查找
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # 用户级包
  home.packages = with pkgs; [
    # 终端工具
    ripgrep
    fd
    bat
    delta

    # 开发工具
    nodejs
    python3
    rustc
    cargo
    uv

    # 其他工具
    jq
    yq-go
    unzip
    zip

    wechat-uos
    feishu
    
    gh
  ];

  # XDG 目录配置
  xdg.enable = true;
}
