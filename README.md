# gmod-dotenv
A Lua implementation of .env for Garry's Mod.

## Features
- Pure gLua implementation, no binary modules required - far less likely for a game update to break your server.
- Provides an `env()` method which behaves the same as [gmsv_dot_env](https://github.com/owainjones74/gmsv_dot_env), making it easy to switch.
- All `get{X}` methods support fallback values, making it easier to keep your dotenv file concise.
- The parse method is exposed globally, allowing for other means of config distribution depending on your needs.

## Example Usage
```lua
require("dotenv")

env.load(".env") --Loads /garrysmod/.env

--[[
	.env file contents:

	STRING="Hello World!"
	NUMBER=-12.34
	BOOLEAN=true
]]

env.getString("STRING") --"Hello World!"
env.getNumber("NUMBER") --12.34
env.getInteger("NUMBER") --12
env.getBoolean("BOOLEAN") --true

env.getString("I_DONT_EXIST", "Fallback value!") --"Fallback value!"

env.getKeys() --{"STRING", "NUMBER", "BOOLEAN"}
```

## Installation
1. Download the latest release of gmod-dotenv from the [releases page](https://github.com/TomDotBat/ui3d2d/releases).
2. Open the archive with your tool of choice, and extract the "dotenv.lua" file into your server/addon's `includes/modules`.
3. Apply gmod-dotenv wherever you like, refer to the [example usage](#example-usage) and [wiki](https://github.com/TomDotBat/gmod-dotenv/wiki) for further help.

## Credits
- [Owain](https://github.com/owainjones74) for creating [gmsv_dot_env](https://github.com/owainjones74/gmsv_dot_env), which inspired me to make my own implementation.
- [GLuaTest](https://github.com/CFC-Servers/GLuaTest) by [CFC Servers](https://github.com/CFC-Servers), used for automated testing of this library.