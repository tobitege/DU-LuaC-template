# DU-LuaC-template

## Introduction

This is a project template for using [DU-LuaC](https://github.com/wolfe-labs/DU-LuaC)
to compile LUA files into "ready-to-install" json (or .conf) file for Dual Universe.
**I love that tool! :)**

**As a primer to DU-LuaC:**
It compiles and packages LUA files according to the contents of the "*project.json*" file.
In that file one ore more entry points can be defined, each representing separate lua script files.
During compilation (it will report syntax errors), all "*require*" commands
will be combined into a single collection and end up on the programming board
in the **2nd**(!) library.onStart section.
The remainder of the main script will be placed as usual in the "unit.onStart" section.

By default, pretty much all global elements in the LUA editor (library, unit, player, system...)
will get one or multiple DU-LuaC event handlers assigned (each is just a single line)
so that the main script can assign code to them at runtime.

The "out" folder contains the latest builds of all entry points in the "development"
and "release" sub-folders. The "development" version keeps the source
in a readable format whereas the "release" version is a much compressed
version to save space on the programming board (ingame), but it is no "minified" as such.
The included Windows cmd file "b.cmd" starts the DU-LuaC build for the development target
and copies the "main.json" content to the clipboard (see command line parameter).

Some lines in the code are for allowing debugging of the script(s) within VSCode,
which requires 3rd party extentions like "Lua Debug" (actoboy168) or "Local Lua Debugger"
(Tom Blind); also recommend "Lua" (sumneko) as a language server.

The "globals" file references in commented out lines "mocks", which are not part
of this repo (yet), i.e. code to "emulate" DU objects so scripts won't fail
when run/debugged outside of DU's lua environment.

The "main.lua" files include a lot of comments to describe what code is being used where and why.

Included in the "util" folder is a slightly enhanced version of the "Codex.lua"
generated originally by DU-LuaC. This version has some custom annotations at
the top to avoid language server notifications/errors when working in VSCode.

## Required elements

- 1 programming board
- 1 databank
- 1 screen (any size)

The project file (project.json) has 2 entry points: "main" and "mainWithFixedSlots".
Biggest difference is that the latter defines fixed, named slots, i.e. elements like
the screen and databank must be linked in a specific order.
This approach is required when an event for the screen needs to be assigned,
which does not work with dynamic link detection. DU-LuaC needs to apply its
event handlers during compilation time to that screen's slot.

The first scipt ("main") has "empty" slots in the project file as it uses dynamic
slot detection during runtime (see "startup.lua"). It can assign code to the
onInputText event during runtime since the "system" slot obviously always
must exist within DU constructs.

## Setup

All elements need to be deployed on the same construct, as usual.

- Deploy programming board, a databank and a screen.
- Link the screen, then the databank to the board (important for the 2nd script!).
- Install onto the board on of the "main.json" or "mainWithFixedSlots.json" scripts
    from the "out\development" folder.
- The "out\release" folder only contains files if project was compiled
    without a parameter ("du-lua build" in console) or explicitly for release.

## Script Installation

**General installation steps in DU:**
For *programming boards* open a .json file in the above mentioned out\development
folder, copy its full content to clipboard and in game right click the programming
board to get the "Advanced" menu popup.
Then click the menu item "**Paste Lua configuration from clipboard**" to have DU
install the script onto the board.
Should there appear a red notification ingame, then the slots configuration might be wrong.

*For a screen* script (not part of this repo!), copy the scripts' content to the clipboard.
Then either
-> point at the screen and hit CTRL+L
OR
-> right click the screen, select the "Advanced" menu item, click "Edit content".
The above opens the screen's LUA editor into which the script can now be pasted into.
Then hit "Apply" to save it and turn on the screen (if not already done).
If successful, a notification "LUA script loaded" should appear in game in the bottom screen.

## Example compiler output

Executing the "b.cmd" file will call the DU-LuaC compiler and produce output similar to below text.

The extra parameter "--copy=development/main" will cause the resulting
JSON file for the "main" script to be copied to the Windows clipboard,
so it can then immediately be pasted in-game onto a programming board.
This is a huge timesaver during development!

```D:\github\DU-LuaC-template>du-lua build development --copy=development/main        
Lua CLI Utility for Dual Universe v1.2.1 by Wolfe Labs @ Node v20.5.1

[BUILDER] Starting build main for target development...
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\main.lua
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\globals.lua
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\startup.lua
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\common-library.lua
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\main-sys_onInputText.lua  
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\main-onStart.lua
[BUILDER] Generating output files for target development...
[BUILDER] JSON build size: 14.59 kB out of 200.00 kB (7.29%)
[BUILDER] CONF build size: 11.95 kB out of 180.00 kB (6.64%)
[SUCCESS] Build development/main successfully copied to clipboard!

[BUILDER] Starting build mainWithFixedSlots for target development...
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\mainWithFixedSlots.lua    
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\globals.lua
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\common-library.lua        
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\main-screen.onOutputChanged.lua
[COMPILE] Compiling file: D:\github\DU-LuaC-template\lua\main-onStart.lua
[BUILDER] Generating output files for target development...
[BUILDER] JSON build size: 14.41 kB out of 200.00 kB (7.21%)
[BUILDER] CONF build size: 10.82 kB out of 180.00 kB (6.01%)

[SUCCESS] Build completed successfully!```

### Credits

Big thanks to Matt for creating DU-LuaC and helping out when I had questions!
