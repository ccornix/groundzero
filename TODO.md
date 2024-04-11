# To-do list

## NixOS

- Revise installation instructions to correctly distinguish between architectures

## Home Manager

- Remove `nix flake clone`, suggest SSH-based `git clone` instead
- Test if Nix & HM can be used seamlessly by users with no root privileges, see, e.g.
    - [`nix-portable`](https://github.com/DavHau/nix-portable), particularly with the latest [Github Actions artifact](https://github.com/DavHau/nix-portable/actions/runs/8641937296/artifacts/1403947011) that should rely on unstable `nixpkgs` instead of the outdated 23.05 ones
    - [nixStatic](https://discourse.nixos.org/t/where-can-i-get-a-statically-built-nix/34253/13)
- If the previous attempt succeeds, convert as many config files as feasible to '.nix' files, mainly Neovim!
- Sync dircolors, mc colors
- Add mc custom quick menu
