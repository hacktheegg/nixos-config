# hacktheegg's NixOS Config

## Highlights

- Modularised Configuration
- Device-Based


## Overview

This is my personal config used on NixOS, a declaration based Linux distro.


### Authors

- [hacktheegg](https://git.hacktheegg.cc/hacktheegg/) 


## Usage

Modify the local copy of the repo then:

```bash
nixos-rebuild switch
```
OR
```bash
./Scripts/nixos-deploy.sh
```

Depending on if modifications were made at `/etc/nixos` or elsewhere


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

  ## WARNING: Modifying this line may induce breaking changes, check before updating
  system.stateVersion = "25.11";
}
```


Create a file `./Configs/hostname` and add a chosen hostname within (e.g. `nixos-laptop`)

Add the following line, with replacements for any `{variable}`
```nix
if deviceName == "{hostname}" then
    [ ./Builds/{your_device_config}.nix ]
else
```

From here your entries in `./Builds/` is what controls each device, allowing for efficient, module-based configuration.


### TODO:

- [ ] Script to quick-setup a dev environment `./Scripts/init.sh`
- [ ] Auto move tags to indicate version each device is at
- [ ] Manual (command `man`) / Tealdeer
- [ ] Fix Dark Mode to be Fully Uniform
- [ ] Keyring
- [ ] Polkit
- [ ] Port Homeserver from Arch/Docker to NixOS
- [ ] Theming
- [ ] Get wallpaper to properly symlinkto `/run/current-system`
- [ ] Look over the XDG standard for paths and figure out what to change
- [ ] Add ssh key for Minix Neo
- [ ] ~~Remove FLAKE support (It's already gone)~~
- [ ] ~~Add flake support (I finally understand why)~~
- [ ] Ignore FLAKE's enitirely (the new `system.nix` thing looks more my style)
- [ ] Setup homeserver with attic (cache.nixos.org alternative) so devices build from non-central server
- [ ] Finish ageless NixOS setup
- [x] ~~Waydroid networking fix cause it currently doesnt open~~


## Feedback and Contributing

Hope and pray that I get a notification on the mirror at github


### Related

- README Template: https://github.com/banesullivan/README/blob/main/TEMPLATE.md
- Tab Completion Guide: https://tldp.org/LDP/abs/html/tabexpansion.html
- Ageless Linux `./Modules/ageless-linux.nix` Source: https://agelesslinux.github.io/age-reporting/distro-specific.html
- Keyring Setup Guide: https://wiki.nixos.org/wiki/Secret_Service#pass-secret-service
