# Ground Zero

A [Nix][nixos] [flake][nix-flakes] of personal [NixOS][nixos] and [Home Manager][home-manager] (HM) configurations.

Highlights:

- Fully declarative configurations of multiple NixOS configurations of laptops and workstations
- ZFS-based root file system with optional encryption and automatic partitioning and formatting provided by [disko][disko]
- Ephemeral dataset for `/` (through restoring a blank snapshot on boot) and opt-in persistence with help of the [impermanence][impermanence] module
- Mounted datasets nested under either `local` and `safe` parents, with only the latter group backed up (inspired by [Graham Christensen][erase-your-darlings])
- Hosts in a private mesh network using [tailscale][tailscale]
- TODO: HM highlights

## Warning :warning:

There may be some rough edges as Nix Flakes are still considered experimental.

This flake contains private system configurations; it is not guaranteed to work for anyone but myself, and may change swiftly and randomly without warning!

Therefore, feel free to grab some inspiration from this repo but do not use it as a dependency. *"You don't want my crap, you want your own."* ([dasJ][dasj-dotfiles])

## Installation

### NixOS

Tip: to boot ISO images from a USB key or external SSD, my preferred method is to use [Ventoy][ventoy].

0. (Prerequisite) It is assumed that the NixOS configuration of the target machine has already been created in the flake. Otherwise,
    - Download the latest NixOS ISO image using

        ```sh
        wget -O nixos.iso https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
        ```

      write it onto some external medium and boot it.

    - Find out persistent virtual disk block device paths of the target machine in a live enviromnent by comparing `lsblk` and `ls -l /dev/disk/by-id` outputs.
    - Find out the MAC addresses of network interfaces using `ip a`.
    - Have a look at the output of `nixos-generate-config --show-hardware-config --no-filesystems | less` for recommended kernel modules and other settings.
    - Edit the config of the target machine accordingly.

1. (Optional) Prepare a NixOS ISO image.

    - If you have access to a system where Nix is installed, it is preferred to build the ISO image for yourself as

        ```sh
        nix --experimental-features 'nix-command flakes' build github:ccornix/groundzero#iso
        ```

      The resulting ISO image is then located at `./result/iso/nixos.iso`. This way, you ensure that the Linux kernel, ZFS kernel module, file system tools etc. of the installer are identical to those of the installed system.

    - Otherwise just use the latest minimal NixOS ISO image.

2. Boot the NixOS ISO image on the target machine.

3. Ensure that the machine has Internet access. To connect to a Wifi network, the custom ISO enables NetworkManager and the `nmtui` tool, while in case of the generic ISO image, the [NixOS manual][installation-networking] provides guidance on using `wpa_supplicant` and `wpa_cli`.

4. (If generic ISO image is used) Enable experimental features of Nix and export the `FLAKE0` environment variable to point to the online flake repo as

    ```sh
    export NIX_CONFIG='experimental-features = nix-command flakes'
    export FLAKE0=github:ccornix/groundzero
    ```

5. Enter a host-specific installer devshell of this flake as follows

   ```sh
   nix develop $FLAKE0#<hostname>
   ```

6. Run disko using a custom script. To destroy existing data on the target disks and (re-)create file systems, run

   ```sh
   my-disko --mode disko
   ```

   else to preserve existing file systems and mount them only, run

   ```sh
   my-disko --mode mount
   ```

7. Install NixOS and reboot if successful as

   ```sh
   my-install && sudo reboot
   ```

That's all! :sunglasses:

### Home Manager

0. (If running Nix on an alien Linux distro) Edit `nix.conf` settings:

    - TODO: experimental-features: nix-command flakes

    - TODO: custom flake update commit message

   Moreover, set the `FLAKE0` environment variable as

    ```sh
    export FLAKE0=github:ccornix/groundzero
    ```

1. Run the following[^hmpkg] as the target user

   ```sh
   nix run $FLAKE0#home-manager -- switch --flake $FLAKE0
   ```

[^hmpkg]: This flake exposes a frozen `home-manager` package (as dictated by [`flake.lock`](./flake.lock)) so that the one performing the setup would be the same as the one used afterward.

## Post-install tasks and development

0. Generate SSH keys for the user of the fresh installation and register the public key where needed.

1. Since the HM configuration redefines the `FLAKE0` variable to point to a directory inside the home directory of the user, ensure that this flake is cloned there:

   ```sh
   nix flake clone --dest $FLAKE0 github:ccornix/groundzero
   ```

2. Within the local repo directory, install a `gitlint` commit-msg hook to ensure that future commit messages adhere to the [Conventional Commits][conventional-commits] specification:

   ```sh
   cd $FLAKE0
   gitlint install-hook
   ```

3. (NixOS installation only) Set up [Tailscale][tailscale] if included in the OS configuration:

   ```sh
   sudo tailscale up
   ```

   Visit the given URL to activate the host on the tailnet.

## Management

Below is a table of commands for common management tasks, where environment variable `FLAKE0` can either be a reference to the online flake repo or a path to a local clone.

| Operation | Command (own alias) |
|-----------|---------------------|
| Collect garbage[^gc] | `[sudo] nix-collect-garbage [-d]` |
| Switch to new OS config | `sudo nixos-rebuild {switch\|boot} --flake $FLAKE0` (`nr {switch\|boot}`) |
| Switch to new home config | `home-manager switch --flake $FLAKE0` (`hm switch`) |
| Check the config[^repodir] | `nix flake check` |
| Format source files[^repodir] | `nix fmt` |
| Update the lock file[^repodir] | `nix flake update --commit-lock-file` |

[^gc]: The `-d` option also removes GC roots such as old system  and home configurations, making it impossible to roll back to previous configs. Executing a `nixos-rebuild switch` is needed to clean up boot menu entries.

[^repodir]: To be executed within the repo directory.

## Troubleshooting

### Installation

If you get

    error: filesystem error: cannot rename: Invalid cross-device link [...] [...]

during NixOS installation, then there is likely a different underlying error, which is unfortunately masked by this one. In such a case, try to build the system config first as

    nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

which will then reveal the root cause for the error.

### Mirrored multi-disk setups

#### Single-disk boot

If one is forced to do a single-disk boot (e.g. due to a failed second disk), it may happen that one is dropped into the UEFI shell because the default ESP is missing. In that case, available (mounted) additional spare ESPs are listed when entering the UEFI shell or can be listed using `map -r`. Additional mirrored (non-default) and mounted spare ESP file systems appear as `FSn` where `n` is an integer. Suppose our spare ESP file system is `FS0`. In this case, all you need to do is to change to that file system and find & launch the corresponding EFI executable of the OS (say, `BOOTX64.EFI`) as

    FS0:
    cd EFI/BOOT
    BOOTX64.EFI

If on subsequent reboots, the EFI shell keeps coming up, it is worth examining the boot order inside the EFI shell using

    bcfg boot dump -s

and -- if necessary -- move some entries around specifying their actual number and the target number, e.g.

    bcfg boot mv 02 04

Credits: https://www.youtube.com/watch?v=t_7gBLUa600

## To-do list

NixOS:

- Complete adding all SSH public keys for ccornix
- Complete setting up all interfaces for systemd-network
- Sync dircolors, mc colors

Home Manager:

- Sync dircolors, mc colors
- Add mc directory hotlist, custom quick menu

## References

Some parts of this flake were inspired by the following flakes:

- [github:hlissner/dotfiles](https://github.com/hlissner/dotfiles)
- [github:Misterio77/nix-config](https://github.com/Misterio77/nix-config)
- [github:wagdav/homelab](https://github.com/wagdav/homelab)

In addition, this flake stands on the shoulders of other flake-giants, explicitly referenced in the `inputs` attribute set of `flake.nix`.

[nixos]: https://nixos.org
[nix-flakes]: https://nixos.wiki/wiki/Flakes
[home-manager]: https://github.com/nix-community/home-manager
[erase-your-darlings]: https://grahamc.com/blog/erase-your-darlings/
[nixos-on-arm]: https://nixos.wiki/wiki/NixOS_on_ARM
[disko]: https://github.com/nix-community/disko
[impermanence]: https://github.com/nix-community/impermanence
[tailscale]: https://tailscale.com
[ventoy]: https://www.ventoy.net
[dasj-dotfiles]: https://github.com/dasj/dotfiles
[installation-networking]: https://nixos.org/manual/nixos/stable/#sec-installation
[conventional-commits]: https://www.conventionalcommits.org/en/v1.0.0/
