# Lanscope Cat Uninstaller

This is a script to completely remove Lanscope Cat for macOS.

## Usage

```sh
sudo ./uninstaller.sh
```

## Uninstall Policy

### Why does not this script use pkgutil --forget?  

Using `pkgutil --forget` will wipe out the installed trail.
This script leaves it to each person's decision, as the ability to clear the trail is different for each use case.
