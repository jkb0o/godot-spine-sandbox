Spine Sandbox
=============
![Sandbox](/screenshot.png)

This is simple application created using awesome [Godot Engine](https://godotengine.org/) for testing animation prepared in [Spine](http://esotericsoftware.com).

Get it
======
You can [download](https://firebasestorage.googleapis.com/v0/b/godot-spine-sandbox.appspot.com/o/spine-sandbox.zip?alt=media&token=e3cf218f-602f-4e49-8087-dc3de15e5212) windows binary or [build](#build) app for any OS.

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
* Sandbox awaits .json, .atlas and .png files with same name at sime location.
* Sandbox awaits valid .png file name inside .atlas file

Build
=====
To build sandbox for your OS, you need build Godot with [godot-spine-module](https://github.com/jjay/godot-spine-module).
You also need to [configure](http://docs.godotengine.org/en/stable/reference/_compiling.html) enviroment for building godot.
```bash
git clone git@github.com:jjay/godot-spine-sandbox.git
git clone git@github.com:godotengine/godot.git
cd godot
git submodule add git@github.com:jjay/godot-spine-module modules/spine
scons platform=osx|linux|windows
bin/godot ../godot-spine-sandbox/game
```
