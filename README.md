Spine Sandbox
=============
![Sandbox](/screenshot.png)

This is simple application created using awesome [Godot Engine](https://godotengine.org/) for testing animation prepared in [Spine](http://esotericsoftware.com).

Get it
======
You can download [win32](https://goo.gl/EpWba6)|[win64](https://goo.gl/f3tbFL) binary or [build](#build) app for any OS.

Usage
=====
* Press "Open file" button and select .json file exported from Spine
* Or just drag .json file from file system to window
* Drag animation for positioning and zoom using mouse wheel
* Change animations using buttons under "Animations" menu region
* If you won't simple blend between animation transitions turn off "Blend transitions" 
* Use "Show Bones/Region/Meshes" for debug draws.

Rules
=====
* Sandbox support only text based json animations exported from Spine.
* Sandbox awaits .json, .atlas and .png files with same name at same location.
* Sandbox awaits valid .png file name inside .atlas file

Build
=====
To build sandbox for your OS, you need build Godot 2.1 with [godot-spine-module](https://github.com/jjay/godot-spine-module).
You also need to [configure](http://docs.godotengine.org/en/stable/reference/_compiling.html) enviroment for building godot.
```bash
git clone git@github.com:jjay/godot-spine-sandbox.git
git clone -b 2.1 git@github.com:godotengine/godot.git
cd godot
git submodule add git@github.com:jjay/godot-spine-module modules/spine
scons platform=osx|linux|windows
bin/godot ../godot-spine-sandbox/game
```
