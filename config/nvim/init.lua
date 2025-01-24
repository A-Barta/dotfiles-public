--[[
This is the main configuration file

It is loaded when nvim is launched and it loads all the configuration.
In the current setup, there is only one module: 'bartarian'.

'bartarian' requires first of all lazy, which is the chosen package manager.
'bartarian.lazy' points to a file (lazy.lua).
'bartarian.core' has all the rest of the configuration.
'bartarian.core' points to a directory.

The only mapping needed before loading lazy is mapleader, so it is set here
--]]

vim.g.mapleader = " "

require("bartarian.lazy")
require("bartarian.core")

print("Loaded the custom config for Antonio")
