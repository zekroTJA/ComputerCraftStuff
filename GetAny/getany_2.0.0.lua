local VERSION = "2.0.0"

local silentMode = false
local yesMode = false

-------------------------------------------

local function printHelp()
    local pname = shell.getRunningProgram()
    print("Usages:")
    print(pname .. " <URL> <Output> [-y] [-s] [-h] [-v]")
end

local function printVersion()
    print("getany v." .. VERSION)
    print("(c) 2020 zekro Development")
end

local function contains(tab, val)
    for _, v in pairs(tab) do
        if v == val then return true end
    end
    return false
end

local function out(str)
    if not silentMode then
        print(str)
    end
end

local function startsWith(str, val)
    return str:sub(1, #val) == val
end

local function getRawArgs(args)
    local out = {}
    for _, v in pairs(args) do
        if not startsWith(v, "-") then
            table.insert(out, v)
        end
    end
    return out
end

local function getBytesStr(bytes)
    if bytes < 1024 then
        return bytes .. " B"
    elseif bytes < 1024 * 1024 then
        return bytes / 1024 .. " kiB"
    else
        return bytes / 1024 / 1024 .. " miB"
    end
end

local function getDownloadURI(inpt)
    if not startsWith(inpt, "http") then
        inpt = "https://" .. inpt
    end

    -- pastebin
    if startsWith(inpt, "https://pastebin.com/") then
        code = inpt:sub(#"https://pastebin.com/" + 1)
        return "https://pastebin.com/raw/" .. code
    end

    -- github
    if startsWith(inpt, "https://github.com/") then
        res, _ = inpt:gsub("/blob/", "/raw/")
        return res
    end

    return inpt
end

local function get(uri)
    res = http.get(uri)
    if not res then
        return false, nil
    end
    return true, res.readAll()
end

-------------------------------------------

local args = {...}
local rawArgs = getRawArgs(args)

silentMode = contains(args, "-s")
yesMode = contains(args, "-y")

if contains(args, "-v") then
    printVersion()
    return
end

if #rawArgs < 2 or contains(args, "-h") then
    printHelp()
    return
end

local uri = getDownloadURI(rawArgs[1])
out("Downloading from:\n" .. uri)

local ok, res = get(uri)
if not ok then
    out("Download failed.")
    return
end

out("Downloaded " .. getBytesStr(#res))

local output = rawArgs[2]

if fs.exists(output) then
    local cont = fs.open(output, "r").readAll()
    if cont == res then
        out("Received content is same as file content.")
        out("Abort.")
        return
    end

    if silentMode and not yesMode then
        return
    end

    if not yesMode then
        write(
            "Do you want to overwrite the existign file '" ..
            output .. "'? [yN] "
        )
        yn = read()
        if yn ~= "y" and yn ~= "Y" then
            print("Abort.")
            return
        end
    end

    out("Overwriting existing file: " .. output)
end

out("Writing file output...")
local fh = fs.open(output, "w")
fh.write(res)
fh.close()

out("Finished.")
