# Egg's NixOS Config

The NixOS config I use for my collection of devices.


## Highlights

- Modularised Configuration
- Host-Based
- No flake usage


## Overview

This is the configuration that I have built up over my time using NixOS, it includes per-device configurations, containerised services, and a complete lack of flake usage.


### Authors

- [hacktheegg](https://git.hacktheegg.cc/hacktheegg/) 


## Usage

Clone the repository then run this script to build the system.
```bash
./rebuild.sh
```

You will be given an interactive selecter on what to build.


### Installation

During a live installation at the partitioning stage, make sure there is at minimum one btrfs partition, preferably the root partition.

Make sure 2 subvolumes exist, one mounted at `/mnt/etc/nixos` (preferably called @nixos), and one at `/mnt/.snapshots` (preferably called @snapshots).

After all partitions and mounts are sorted out you then need to clone the configuration to the @nixos subvolume

```bash
git clone "https://git.hacktheegg.cc/hacktheegg/nixos-config.git" "/mnt/etc/nixos"
```

Then run the following script to add a new host entry in the repo.

```bash
/mnt/etc/nixos/Scripts/host-new.nix
```

From here you then need to edit the created entry in `/mnt/etc/nixos/Hosts/` to however you want it. e.g.

```bash
vim /mnt/etc/nixos/Hosts/Thinkpad-T460/default.nix
```

When you are done configuring your entry, it will finally be time to run the install command:

```bash
nixos-install --file /mnt/etc/nixos/system.nix --attr Thinkpad-T460
```

Make sure to change Thinkpad-T460 with your configurations Hostname


### TODO:

- [ ] Port Homeserver from Arch/Docker to NixOS (PRIORITY: HIGH)
- [ ] Script to quick-setup a dev environment `./Scripts/init.sh` (PRIORITY: MEDIUM)
- [ ] Setup homeserver with attic (cache.nixos.org alternative) so devices build from non-central server
- [ ] Finish ageless NixOS setup
- [ ] Fix Dark Mode to be Fully Uniform
- [ ] Get wallpaper to properly symlink to `/run/current-system`
- [ ] Manual (command `man`) / Tealdeer


## Feedback and Contributing

Hope and pray that I get a notification on the mirror at github


### Related

- README Template: https://github.com/banesullivan/README/blob/main/TEMPLATE.md
- Tab Completion Guide: https://tldp.org/LDP/abs/html/tabexpansion.html
- Ageless Linux `./Modules/ageless-linux.nix` Source: https://agelesslinux.github.io/age-reporting/distro-specific.html
- Keyring Setup Guide: https://wiki.nixos.org/wiki/Secret_Service#pass-secret-service
- BIOS/MBR Boot Help: https://github.com/Linuxury/nixos-config/blob/main/docs/04-install-legacy-bios.md
