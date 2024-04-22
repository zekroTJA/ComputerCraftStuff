local watchItems = {
    ["mysticalagriculture:inferium_essence"] = "Inferium Essence",
    ["mysticalagriculture:iron_essence"] = "Iron Essence",
    ["mysticalagriculture:gold_essence"] = "Gold Essence",
    ["mysticalagriculture:diamond_essence"] = "Diamond Essence",
    ["mysticalagriculture:redstone_essence"] = "Redstone Essence",
    ["mysticalagriculture:nether_quartz_essence"] = "Quartz Essence",
    ["minecraft:birch_log"] = "Birch Log",
    ["minecraft:birch_planks"] = "Birch Planks",
}

term.clear()

local bridge = peripheral.find("rsBridge")
if not bridge then
    error("no RS Bridge found attached to the computer!")
end

local width, height = term.getSize()

local function punctuate(s)
    local res = ""
    for i = 1, #s do
        if i ~= 1 and i % 3 == 1 then
            res = "," .. res
        end
        res = string.sub(s, #s - i + 1, #s - i + 1) .. res
    end
    return res
end

local function printCount(item, count, color)
    term.setBackgroundColor(color)
    local countStr = punctuate(tostring(count))
    write(item .. string.rep(" ", width - #item - #countStr))
    term.setTextColor(colors.pink)
    print(countStr)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
end

local function itemCounts()
    local counts = {}
    for item, displayName in pairs(watchItems) do
        local props = bridge.getItem({ name = item })
        counts[#counts + 1] = { name = displayName, count = props.amount }
    end
    table.sort(counts, function(a, b) return a.count > b.count end)
    return counts
end

local lineColors = { colors.black, colors.gray }

local function render()
    term.setCursorPos(1, 1)

    term.setBackgroundColor(colors.red)
    write(string.rep(" ", width))
    term.setCursorPos(width / 2 - 5, 1)
    print("Storage Stock")

    local i = 1
    for i, p in pairs(itemCounts()) do
        printCount(p.name, p.count, lineColors[i % 2 + 1])
        i = i + 1
    end
end

while true do
    render()
    sleep(1)
end
