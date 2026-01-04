# Mikuboot
A miku boot animation because she's living in my computer.

Inspired by [ooo.eeeee.ooo](https://ooo.eeeee.ooo) and the song Miku by Anamanaguchi.

The theme has a password prompt and works with encryption.

![mikuboot boot animation](mikuboot/source.gif)

## NixOS: Usage as a flake with nixos module

```nix
{
  inputs = {
    nixpkgs.url = "...";
    mikuboot = {
      url = "gitlab:evysgarden/mikuboot";
      inputs.nixpkgs.follows = ""; # only useful for the package output
    };
  };
  
  outputs = { nixpkgs, mikuboot, ...}: {
    nixosConfigurations.teto = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # add mikuboot module
        mikuboot.nixosModules.default 

        # configuration.nix
        {
          boot.plymouth = {
            enable = true;

            # add theme package and name
            themePackages = [ pkgs.mikuboot ];
            theme = "mikuboot";
          };
        }
      ];
    };
  }
}
```

## Arch Linux
A friend of mine packaged the theme in the aur:

https://aur.archlinux.org/packages/plymouth-theme-mikuboot-git

read the arch wiki for instructions on how to configure plymouth

## Generic Linux
With plymouth installed, you can just copy the `mikuboot/` directory to to `/usr/share/plymouth/themes/` and switch the theme to `mikuboot`.

Mikuboot requires plymouth scripting.
If switching to the theme throws this error:

```
/usr/lib64/plymouth/script.so does not exist
```

On Fedora (and maybe other distributions) the script plugin is not shipped with plymouth
directly and a package called `plymouth-plugin-script` needs to be installed.
# mikuboot
