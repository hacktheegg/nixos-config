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
- [ ] Manual (command `man`)
- [ ] Fix Dark Mode to be Fully Uniform
- [ ] Keyring
- [ ] Port Homeserver from Arch/Docker to NixOS
- [ ] Theming
- [ ] Look over the XDG standard for paths and figure out what to change
- [ ] Add ssh key for Minix Neo
- [ ] Remove FLAKE support (It's already gone)


## Feedback and Contributing

As of typing this, there is no system for feedback or contributions and there is a good chance that there will never be as this is my own personal config for my devices


### Related

README Template: https://github.com/banesullivan/README/blob/main/TEMPLATE.md
Tab Completion Guide:
- https://tldp.org/LDP/abs/html/tabexpansion.html
