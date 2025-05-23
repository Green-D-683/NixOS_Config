{config, pkgs, lib, system, ...}:
{
  options.isISO = lib.mkEnableOption "ISO-Specific Changes";

  config.boot = lib.mkIf (!config.isISO){
    # Bootloader.
    loader = (
      {
        efi.canTouchEfiVariables = true;
      } // (
        if (builtins.elem "rpi4" config.systemConfig.extraHardware) then # Raspberry Pi 4 Specific Kernel
          {
            systemd-boot.enable = false;
            generic-extlinux-compatible.enable = true;
          }
        else 
          {
            systemd-boot.enable = true;
          }
      )
    );

    initrd = {
      systemd = {enable = true;} // (if (builtins.elem "rpi4" config.systemConfig.extraHardware) then {
        # Raspi Boards don't have TPM
        tpm2.enable = false;
      } else {});
      kernelModules = [
        "psmouse"
        "hid_multitouch"
      ];
    };
    
    # Swappiness - lower is less aggressive
    kernel.sysctl = { "vm.swappiness" = 10;};
    
    # Reading Windows Drives
    supportedFilesystems = [ "ntfs" ];

    # Using latest kernel
    kernelPackages = (
      if (builtins.elem "rpi4" config.systemConfig.extraHardware) then # Raspberry Pi 4 Specific Kernel
        pkgs.linuxKernel.packages.linux_rpi4 
      else if (config.systemConfig.optimiseFor == "laptop") then 
        pkgs.linuxPackages_latest 
      else 
        pkgs.linuxPackages_zen
      );
    kernelModules = [
      "v4l2loopback"
    ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';

    binfmt.emulatedSystems = (lib.lists.remove system [ 
      "aarch64-linux"
      "x86_64-linux" 
    ]);
  };
}