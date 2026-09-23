# Egg's NixOS Config

## Highlights

- Modularised Configuration
- Host-Based
- No flake usage


## Overview

This is my personal config used on NixOS, a declaration based Linux distro.


### Authors

- [hacktheegg](https://git.hacktheegg.cc/hacktheegg/) 


## Usage

Clone the repository then run this script to build the system
```bash
./rebuild.sh
```


### Installation

```bash
git clone "https://git.hacktheegg.cc/hacktheegg/nixos-config.git"
```

Create file within `./Hardware/` and place the output of this command:
```bash
nixos-generate-config --show-hardware-config
```

Create a matching file in `./Builds/` with the following contents:
```nix
{ ... }: {

  imports =
    [
      ./../Hardware/{your_hardware_config}.nix
      ./../Modules/bootloader.nix
    ];
    
  imports = [
    ./../Hardware/{your_hardware_config}.nix
    ./../Modules
  ];

  omelette.boot.efi.enable = true;
  
  ## WARNING: Modifying this line may induce breaking changes, check before updating
  system.stateVersion = "25.11";
}
```


Add an entry in `./hosts.nix` and an `./system.nix`.

From here your entries in `./Builds/` is what controls each device, allowing for efficient, module-based configuration.


### TODO:

- [ ] Port Homeserver from Arch/Docker to NixOS
- [ ] Script to quick-setup a dev environment `./Scripts/init.sh`
- [ ] Ignore FLAKE's enitirely (the new `system.nix` thing looks more my style)
- [ ] Auto move tags to indicate version each device is at
- [ ] Polkit
- [ ] Keyring (keepassxc)
- [ ] Look over the XDG standard for paths and figure out what to change
- [ ] Finish ageless NixOS setup
- [ ] Setup homeserver with attic (cache.nixos.org alternative) so devices build from non-central server
- [ ] Fix Dark Mode to be Fully Uniform
- [ ] Get wallpaper to properly symlink to `/run/current-system`
- [ ] Theming
- [ ] Manual (command `man`) / Tealdeer


## Feedback and Contributing

Hope and pray that I get a notification on the mirror at github


### Related

- README Template: https://github.com/banesullivan/README/blob/main/TEMPLATE.md
- Tab Completion Guide: https://tldp.org/LDP/abs/html/tabexpansion.html
- Ageless Linux `./Modules/ageless-linux.nix` Source: https://agelesslinux.github.io/age-reporting/distro-specific.html
- Keyring Setup Guide: https://wiki.nixos.org/wiki/Secret_Service#pass-secret-service
