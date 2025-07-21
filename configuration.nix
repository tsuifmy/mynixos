# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #启用flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  security.sudo.wheelNeedsPassword = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.networkmanager.unmanaged = [
  #   "*" "except:type:wwan" "except:type:gsm"
  # ];

  # networking.wireless.networks = {
  #   CMCC-fR3X-5G = {
  #     psk = "fbms5347";
  #   };
  # };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.wayne = {
     isNormalUser = true;
     extraGroups = [ 
	"wheel"
	"networkmanager"
	"audio"
	"video"
	"storage"
     ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       tree
     ];
   };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     curl
     tree
     fzf
     yazi
     ffmpeg
     clash-verge-rev
     ninja
     cmake
     gcc
     google-chrome

    zsh
    tmux

    obsidian
    # Text editor
     helix
     zed-editor
     vscode-fhs

    # Font
     noto-fonts
     noto-fonts-cjk-sans
     noto-fonts-emoji
     nerd-fonts.jetbrains-mono
   
     # Vulkan dev tools
     vulkan-tools
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    vulkan-utility-libraries

    #SPIR-V tools
    spirv-tools
    spirv-headers
    spirv-cross

    # Shader compiler
    glslang
    shaderc

    rustup
    rustc
    cargo

    alacritty
    
    vlc
  ];

  fonts.packages = with pkgs; [
     noto-fonts
     noto-fonts-cjk-sans
     noto-fonts-emoji
     fira-code
     fira-code-symbols
     nerd-fonts.jetbrains-mono
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      vulkan-validation-layers
      vulkan-extension-layer
      vulkan-headers
      vulkan-loader

      #Mesa Vulkan Driver
      # mesa
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-validation-layers
      vulkan-extension-layer
      vulkan-tools
      mesa
    ];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-rime
      fcitx5-nord
      fcitx5-chinese-addons
    ];
  };

# Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # forceFullCompositionPipeline = true;
  };

  programs.clash-verge.package = pkgs.clash-verge-rev;
  programs.clash-verge.enable = true;
  programs.clash-verge.autoStart = true;

  systemd.user.services.clash-verge-rev = {
    enable = true;
    description = "Clash Verge Rev Custom Service";
    after = [ "graphic-session.target" ];
    partOf = [ "graphic-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.clash-verge-rev}/bin/clash-verge --silent";
      Restart = "on-failure";
      RestartSec = 10;
      Environment = [ "DISPLAY=:0" ];
    };

    wantedBy = [ "graphic-session.target" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

  nix.settings = {
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://cache.nixos.org"
    ];
  };
  
  nixpkgs.config.allowUnfree = true;

}
