# BlitzFX

![alt text](https://staticdelivery.nexusmods.com/mods/952/images/6447/6447-1663710601-155152138.jpeg)

A Direct3D 11 graphics effect injector for The Witcher 3.
The binaries are available on [Nexus Mods](https://www.nexusmods.com/witcher3/mods/6447)

## Setup
1. Set the `TW3_DIR` environment variable to your Witcher 3 Installation path, e.g. `F:\GOG Games\The Witcher 3 Wild Hunt GOTY`.
2. Open `blitz-fx.sln` in Visual Studio 2022.
3. Compile the solution with either the `Debug` or the `Performance` configuration and run the game at least once. This will cause BlitzFX to compile all shaders once the game is launched. The shaders can also be edited and recompiled by pressing `F6` while the game runs in these configurations.
4. Now the mod can be compiled and run in the `Release` configuration.

## Features
- Physically based water surface shading and underwater light scattering
- Contact hardening soft shadows
- High-quality temporal anti-aliasing
- HDR bloom
- Dynamic auroras
- Normal map filtering
- Screen space shadows
- Normal mapping shadows
- Refractive raindrops
- Physically based surface shading

## Notes
This mod is only compatible with the game's original version (1.32) and not the ray-traced version.
