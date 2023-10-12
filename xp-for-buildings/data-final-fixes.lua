require("util_mmd")
require("__" .. "xp-for-buildings" .. "__.mmddata")
local enabled_types = settings.startup["exp_for_buildings_enabled_types"].value

local enabledTypes = {}
for field in enabled_types:gmatch('([^,]+)') do
    table.insert(enabledTypes, field)
end

for _, value in pairs(data.raw["recipe"]) do
    if value.hidden and value.result ~= nil then
        mmddata.skipped_entities[value.result] = 0
    end
end
if isDebug then
    mmddata.qtd = 0
    for key, value in pairs(data.raw) do
        -- print("raw" .. key)
        for keyS, _ in pairs(data.raw[key]) do
            -- print("raw-inner" .. keyS)
            mmddata.qtd = mmddata.qtd + 1
        end
    end
    -- deleteEntities

    print("prototype_count:" .. mmddata.qtd)
end

for _, type in pairs(enabledTypes) do
    for key, value in pairs(data.raw[type]) do
        CalculateTierAndSetReferences(data.raw[type][key])
    end
end

for _, value in pairs(ReferenceBuildings.types) do
    Calculate(value)
    exp_for_buildings.create_leveled_machines(value)
    exp_for_buildings.fix_productivity(value)
end

if isDebug then
    print("prototype_count:" .. mmddata.qtd)
end
