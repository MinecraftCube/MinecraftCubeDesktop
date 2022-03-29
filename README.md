![](_repo_assets/logo.png?raw=true)

# MinecraftCube Desktop

A server management tool for Minecraft, that help players start any kind of minecraft server easier. Mainly support vanilla and forge, but mostly all kind of minecraft server without restriction. For those headache specified java server, the tool also support portable java to assign at the project you needed!

[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)
[![GitHub license](https://img.shields.io/github/license/MinecraftCube/MinecraftCubeDesktop)](https://github.com/MinecraftCube/MinecraftCubeDesktop/blob/main/LICENSE)
![GitHub Workflow Status (branch)](<https://img.shields.io/github/workflow/status/MinecraftCube/MinecraftCubeDesktop/Test%20(All%20platform)/main>)
[![downloads](https://img.shields.io/github/downloads/MinecraftCube/MinecraftCubeDesktop/total)](https://github.com/MinecraftCube/MinecraftCubeDesktop/releases)

## Features

- [x] Cross platform (Mac, Windows, Linux)
- [x] System
  - Public/Gateway/Internal IP detection
  - CPU/MEMORY/GPU detection
  - Java detection
- [x] Server
  - Start any server with same pipeline (forge, vanilla... etc)
  - server.properties configuration support.
  - java portable supports. (put portables under java folder beside servers/installers dir)
  - basic command candidates
- [x] Craft
  - make an reusable installers for anyone at anytime.
- [x] Well-tested (boasting)

## How to open releases

### Windows

No need any extra knowledge.

### Linux (x64/Amd)

#### Option 1. Use `dpkg`

```
sudo dpkg -i linux_the_file.deb
/usr/local/lib/minecraft_cube_desktop/minecraft_cube_desktop
```

> Note: The Path you currently used in terminal will be the root directory for the app, please decide the directory, and use `cd`, then execute the last command above.

#### Option 2. Use `dpkg-deb`

`dpkg-deb -x $DEBFILE $TARGET_DIRECTORY`, then open _mineraft_cube_desktop_ in the target directory.
Don't forget to `chmod -R 755` the direcotry or use open mineraft_cube_desktop as `sudo`.

### Macos

```
chmod -R 755 minecraft_cube_desktop.app
```

and `open ./minecraft_cube_desktop.app` in terminal
or just double click.
