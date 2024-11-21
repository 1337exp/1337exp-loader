local transport_belt = mods["space-age"] and "turbo-transport-belt" or "express-transport-belt"
local crafting_category = mods["space-age"] and "metallurgy" or "crafting"
local energy_required = mods["space-age"] and 20 or 10

local crafting_item_1 = mods["space-age"] and "stack-inserter" or "bulk-inserter"

local technology = mods["space-age"] and
        {
            prerequisites = { "stack-inserter", "turbo-transport-belt" },
            unit = {
                count = 2500,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"production-science-pack", 1},
                    {"space-science-pack", 1},
                    {"metallurgic-science-pack", 1},
                    {"agricultural-science-pack", 1}
                },
                time = 120
            }
        } or
        {
            prerequisites = { "bulk-inserter", "logistics-3" },
            unit = {
                count = 1500,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"production-science-pack", 1}
                },
                time = 30
            }
        }

local surface_conditions = mods["space-age"] and
        {
            {
                property = "pressure",
                min = 4000,
                max = 4000
            }
        } or nil

-----------------------------------------------------

Loader.make{
    name = "", -- def: "loader". Empty name will create "1337exp-loader"
    transport_belt = transport_belt,

    technology = technology,

    recipe = {
        crafting_category = crafting_category,
        surface_conditions = surface_conditions,

        ingredients = {
            { type = "item", name = transport_belt, amount = 5 },
            { type = "item", name = "battery", amount = 10 },
            { type = "item", name = crafting_item_1, amount = 1 },
            { type = "item", name = "steel-chest", amount = 1 }
        },
        energy_required = energy_required
    },

    localise = false -- we have baked in localisation, if you don't you might want to set this to true.
}
