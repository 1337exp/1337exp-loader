local hit_effects = require ("__base__.prototypes.entity.hit-effects")

-----------------------------------------------------

local Actor = {
    loader_count = 0
}

---]>

local sprite_shift = { 0, -0.15 }
local shadow_shift = { 0.4, 0.15 }
local graphics_path = "__1337exp-loader__/graphics/"
local dark_suffix = "_dark"

-----------------------------------------------------

data:extend{
    {
        type = "item-subgroup",
        name = "loader",
        group = "logistics",
        order = "b[belt]-d"
    },
}

-----------------------------------------------------

local function make_entity(input)
    local suffix = input.dark and dark_suffix or ""
    local structure = input.structure or "loader"
    local localised_description = { "entity-description.1337exp-loader-desc" }

    ---

    local entity = {
        name = input.name,
        type = "loader-1x1",
        icons = {
            {
                icon = graphics_path .. "icons/" .. (input.icon or "loader") .. suffix .. ".png",
                icon_size = 64
            },
            {
                icon = graphics_path .. "icons/" .. (input.icon or "loader") .. "_mask" .. suffix .. ".png",
                icon_size = 64,
                tint = input.color
            }
        },
        localised_name = input.localised_name,
        localised_description = localised_description,
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},

        minable = { mining_time = 0.1, result = input.name },
        filter_count = 5,

        corpse = "small-remnants",
        dying_explosion = input.transport_belt.dying_explosion,

        collision_box = { {-0.4, -0.45}, {0.4, 0.45} },
        selection_box = { {-0.5, -0.5}, {0.5, 0.5} },
        drawing_box = { {-0.4, -0.4}, {0.4, 0.4} },

        container_distance = 0.75, -- Default: 1.5
        -- belt_distance = 0.5, --Default1x1: 0.0  --Default2x1: 0.5
        belt_length = 0.5, -- Default: 0.5

        structure_render_layer = "object",
        -- structure_render_layer = "transport-belt-circuit-connector", --Default:"lower-object"
        belt_animation_set = input.transport_belt.belt_animation_set,
        animation_speed_coefficient = 32,

        related_underground_belt = input.related_underground_belt or "turbo-underground-belt",
        fast_replaceable_group = input.fast_replaceable_group or "transport-belt",
        next_upgrade = input.next_upgrade,

        speed = input.speed or input.transport_belt.speed,
        max_health = 170,
        resistances =
        {
            {
                type = "fire",
                percent = 60
            }
        },

        -- Integration Patch to render tiny pieces behind the belt
        integration_patch_render_layer = "decals",
        integration_patch = {
            north = util.empty_sprite(),
            east = util.empty_sprite(),
            south = util.empty_sprite(),
            west = util.empty_sprite(),
        },

        heating_energy = "30kW",

        ---

        damaged_trigger_effect = hit_effects.entity(),

        open_sound = input.transport_belt.transport_belt_open,
        close_sound = input.transport_belt.transport_belt_close,
        working_sound = input.transport_belt.working_sound,

        ---

        circuit_connector =  circuit_connector_definitions.create_vector(
                universal_connector_template,
                {
                    { variation = 4, main_offset = util.by_pixel(3, 2), shadow_offset = util.by_pixel(7.5, 7.5), show_shadow = false },
                    { variation = 2, main_offset = util.by_pixel(-11, -5), shadow_offset = util.by_pixel(7.5, 7.5), show_shadow = false },
                    { variation = 0, main_offset = util.by_pixel(-3, -23), shadow_offset = util.by_pixel(7.5, 7.5), show_shadow = false },
                    { variation = 6, main_offset = util.by_pixel(10, -17), shadow_offset = util.by_pixel(7.5, 7.5), show_shadow = false },

                    { variation = 0, main_offset = util.by_pixel(-3, -23), shadow_offset = util.by_pixel(7.5, 7.5), show_shadow = false },
                    { variation = 6, main_offset = util.by_pixel(10, -17), shadow_offset = util.by_pixel(7.5, 7.5), show_shadow = false },
                    { variation = 4, main_offset = util.by_pixel(3, 2), shadow_offset = util.by_pixel(7.5, 7.5), show_shadow = false },
                    { variation = 2, main_offset = util.by_pixel(-11, -5), shadow_offset = util.by_pixel(7.5, 7.5), show_shadow = false },
                }
        ),
        circuit_wire_max_distance = transport_belt_circuit_wire_max_distance,
        structure = {
            direction_in = {
                sheets = {
                    {
                        filename = graphics_path .. "entity/loader/" .. structure .. "_shadows.png",
                        priority = "extra-high",
                        shift = shadow_shift,
                        width = 138,
                        height = 79,
                        scale = 0.5,
                        draw_as_shadow = true
                    },
                    {
                        filename = graphics_path .. "entity/loader/" .. structure .. suffix .. ".png",
                        priority = "extra-high",
                        shift = sprite_shift,
                        width = 99,
                        height = 117,
                        scale = 0.5
                    },
                    {
                        filename = graphics_path .. "entity/loader/" .. structure .. "_tint" .. suffix .. ".png",
                        priority = "extra-high",
                        shift = sprite_shift,
                        width = 99,
                        height = 117,
                        scale = 0.5,
                        tint = input.color,

                        draw_as_light = true
                    },
                }
            },
            direction_out = {
                sheets = {
                    {
                        filename = graphics_path .. "entity/loader/" .. structure .. "_shadows.png",
                        priority = "extra-high",
                        shift = shadow_shift,
                        width = 138,
                        height = 79,
                        y = 79,
                        scale = 0.5,
                        draw_as_shadow = true,
                    },
                    {
                        filename = graphics_path .. "entity/loader/" .. structure .. suffix .. ".png",
                        priority = "extra-high",
                        shift = sprite_shift,
                        width = 99,
                        height = 117,
                        y = 117,
                        scale = 0.5
                    },
                    {
                        filename = graphics_path .. "entity/loader/" .. structure .. "_tint" .. suffix .. ".png",
                        priority = "extra-high",
                        shift = sprite_shift,
                        width = 99,
                        height = 117,
                        y = 117,
                        scale = 0.5,
                        tint = input.color
                    }
                }
            },
            frozen_patch_in = {
                sheet = {
                    filename = graphics_path .. "entity/loader/frozen/" .. structure .. ".png",
                    priority = "extra-high",
                    shift = sprite_shift,
                    width = 99,
                    height = 117,
                    scale = 0.5
                }
            },
            frozen_patch_out = {
                sheet = {
                    filename = graphics_path .. "entity/loader/frozen/" .. structure .. ".png",
                    priority = "extra-high",
                    shift = sprite_shift,
                    width = 99,
                    height = 117,
                    y = 117,
                    scale = 0.5
                }
            },
        }
    }

    ---

    data:extend{ entity }

    ---

    return data.raw['loader-1x1'][input.name]
end

local function make_recipe(input)
    if not input.recipe then return end

    ---

    local recipe_template = table.deepcopy(input.recipe)

    local recipe = {
        name = recipe_template.name or input.name,
        type = "recipe",
        category = recipe_template.crafting_category,
        surface_conditions = recipe_template.surface_conditions or nil,
        order = input.order or string.format("d[loader]-a%02d[%s]", input.count, input.name),
        localised_name = input.localised_name
    }

    recipe.ingredients = recipe_template.ingredients or {}
    recipe.enabled = false
    recipe.energy_required = recipe_template.energy_required
    recipe.results = {{type = "item", name = input.name, amount = 1}}

    data:extend{ recipe }

    return data.raw.recipe[recipe.name]
end

local function make_technology(input)
    local suffix = input.dark and dark_suffix or ""
    local name = input.technology and input.technology.name or input.name

    ---

    if not data.raw.technology[name] and input.technology then
        local localised_description = {"technology-description.1337exp-loader-desc"}

        local tech = {
            name = name,
            type = "technology",
            icons = {
                {
                    icon = graphics_path .. "technology/loader-tech-icon" .. suffix .. ".png" ,
                    icon_size = 256
                },
                {
                    icon = graphics_path .. "technology/loader-tech-icon_mask" .. suffix .. ".png",
                    icon_size = 256, tint = input.color}
            },
            order = input.order or string.format("d[loader]-a%02d[%s]", input.count, input.name),
            localised_name = input.localised_name,
            localised_description = localised_description
        }

        tech.unit = input.technology.unit
        tech.upgrade = false
        tech.prerequisites = input.technology.prerequisites or {}

        data:extend{tech}
    end

    ---

    return data.raw.technology[name]
end

local function make_item(input)
    local suffix = input.dark and dark_suffix or ""
    local localised_description = { "entity-description.1337exp-loader-desc" }

    local default_src = data.raw.item[input.transport_belt.name]

    ---

    data:extend{
        {
            name = input.name,
            type = "item",
            icons = {
                {
                    icon = graphics_path .. "icons/" .. (input.icon or "loader") .. suffix .. ".png",
                    icon_size = 64
                },
                {
                    icon = graphics_path .. "icons/" .. (input.icon or "loader") .. "_mask" .. suffix .. ".png",
                    icon_size = 64,
                    tint = input.color
                }
            },

            order = input.order or string.format("d[loader]-a%02d[%s]", input.count, input.name),
            subgroup = "belt",

            localised_name = input.localised_name,
            localised_description = localised_description,

            stack_size = 50,
            default_import_location = input.default_import_location or default_src.default_import_location,
            weight = input.weight or (40*kg),

            place_result = input.name,
            pick_sound = "__base__/sound/item/mechanical-inventory-pickup.ogg",
            drop_sound = "__base__/sound/item/mechanical-inventory-move.ogg",
            inventory_move_sound = "__base__/sound/item/mechanical-inventory-move.ogg",

            color_hint = default_src.color_hint,
        }
    }
    return data.raw.item[input.name]
end

-----------------------------------------------------

function Actor.make(input)
    if not input.name then
        Log.error("Actor.make", "`name` field is required")
        return
    end

    ---

    input.name = input.name == "" and "1337exp-loader" or "1337exp-" .. input.name .. "-loader"

    Log.info("Actor.make", "Beginning to create: " .. (input.name or '(empty)'))

    ---

    if not input.transport_belt then
        Log.error("Actor.make", "`transport_belt` field is required.")
        return
    elseif not data.raw['transport-belt'][input.transport_belt] then
        Log.error("Actor.make", "invalid data in field `transport_belt`")
        return
    end

    --- Loading data by name

    input.transport_belt = data.raw['transport-belt'][input.transport_belt]

    ---

    if not input.recipe then
        Log.error("Actor.make", "`recipe` field is required")
        return
    end

    if not input.speed then
        Log.error("Actor.make", "No speed input provided: using default speed")
    end

    if not input.color then
        Log.error("Actor.make", "No color input provided: using default color")
        input.color = { r = 1.0, g = 1.0, b = 1.0 }
    end

    if not input.technology then
        if not data.raw.technology[input.name] then
            Log.error("Actor.make", "No technology input provided: won't be available to unlock")
        else
            Log.error("Actor.make", string.format("No `technology` field provided: will be added to existing technology: %s", input.name))
        end
    end

    ---

    if input.localise then
        input.localised_name = { "1337exp-loader.loader-name", (input.transport_belt.localised_name or { "entity-name." .. input.transport_belt.name }) }
    end

    ---

    Actor.loader_count = Actor.loader_count + 1
    input.count = Actor.loader_count

    ---

    local entity = make_entity(input)
    local item = make_item(input)
    local recipe = make_recipe(input)
    local tech = make_technology(input)

    if tech and recipe then
        tech.effects = tech.effects or {}
        table.insert(tech.effects, { type="unlock-recipe", recipe=recipe.name })
    end

    ---

    return { loader = entity, item = item, recipe = recipe, technology = tech }
end

-----------------------------------------------------

return Actor;