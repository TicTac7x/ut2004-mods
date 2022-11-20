# Spawn Manager
Save your current location as checkpoint, where you can teleport to manually and automatically on spawn.

- - - -

### Keybinds
Keybinds for checkpoints can be configured from `Settings` -> `Input` -> `Configure Controls` -> `Checkpoints` like all other keybinds.

- - - -

### Default Keybinds
`Insert` - Add checkpoint  
`Delete` - Remove checkpoint  
`Enter` - Teleport to checkpoint

- - - -

### Client Installation
1. Copy `System` folder from `out` folder inside the main directory of UT2004.

- - - -

### Server Installation
1. Copy `System` folder from `out` folder inside the main directory of UT2004.
2. Edit `System/UT2004.ini` and add following lines:
```shell
[Engine.GameEngine]
ServerPackages=SpawnManager
```

__NB! If this mod is used server side, but the mod has not been installed client side, then the players can still use checkpoints, but the keybinds are not configurable from the player side and the player needs to use default keybinds.__
