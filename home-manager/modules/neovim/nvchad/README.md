# Example_config

This can be used as an example custom config for NvChad, this branch is a minimal one. Do check the feature_full branch if you need all the ease in your config.

## The featureful branch :)
This is the featureful branch for v2.0 release!

To use an extension, add a line of
```lua
    { import = "custom.configs.extras.file_name_without_dot_lua" },
```
to the end of the plugin spec table inside `plugins.lua` use one of the extensions

## Contribution

1. We keep the difference between this and the v2.0 branch minimal :D   
    - Or in other words, all the changes are in `configs/extras/*`
2. It should work normally out of the box with a line of 
```lua
    { import = "custom.configs.extras.file_name_without_dot_lua" },
```
3. For clarity and to hope for people to read the initial lines, each file should start with
    - List of extra plugins to be downloaded
    - What it does
    - What needs to be modified in the default example config (if any)

The goal of this is, like said in `2.`, it should work with just one import line if possible, and furthermore, it should not have any conflicts with other files also inside `extras`

Example module: 
```lua
--- This is a doc about file b
--- The module will do ...
--- This will add "plugin/name" and "authorB/name" plugin to the config
--- Notes: ...

--- Something to do here if you want to put outside spec file for less indentation

---@type NvPluginSpec
local spec = {

}

return spec
```
