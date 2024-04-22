# NoteTool

A simple tool to write down and manage stuff you want to do using touch monitors.

## Demo

https://github.com/zekroTJA/ComputerCraftStuff/assets/16734205/83922073-002c-41f1-8e2c-be24b7b488c4

## Setup

You can simply use the `wget` tool to download the script directly from GitHub. After that, create a `startup.lua` which executes the script on a defined monitor.

Assuming your monitor is on the `right` next to the computer, the setup would look as following.

```
> wget https://raw.githubusercontent.com/zekroTJA/ComputerCraftStuff/master/NoteTool/v1/notetool.lua notetool.lua
> edit startup.lua
```

> `startup.lua`
```
shell.run("monitor right notetool")
```

If you are using an older version of CC: Tweaked or ComputerCraft, `wget` might not be available. Alternatively, you can use `pastebin` to install the tool.

```
> pastebin get reVGU1Kw notetool.lua
```