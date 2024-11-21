local Actor = {
    event_filters = { { filter = "type", type = "loader-1x1" } },
    snap_targets = {
        "container",
        "logistic-container",
        "linked-container",
        "infinity-container",
        "assembling-machine",
        "furnace",
        "rocket-silo",
        "mining-drill",
        "lab",
        "boiler",
        "reactor",
        "ammo-turret",
        "artillery-turret",
        "straight-rail"
    }
}

-----------------------------------------------------

---Searches for neighbors to determine if loader should be rotated
---@param loader LuaEntity Actor entity
function Actor.attempt_snap(loader)
    local surface = loader.surface
    local force_name = loader.force.name
    local loader_position = loader.position
    local original_direction = loader.direction
    local original_type = loader.loader_type
    local x, y = loader_position.x, loader_position.y
    local from_x, from_y, to_x, to_y
    local snap_targets = Actor.snap_targets
    local is_entity_connected

    ---

    if original_direction == defines.direction.north then
        from_x, from_y = x, y + 1
        to_x, to_y = x, y - 1
    elseif original_direction == defines.direction.east then
        from_x, from_y = x - 1, y
        to_x, to_y = x + 1, y
    elseif original_direction == defines.direction.south then
        from_x, from_y = x, y - 1
        to_x, to_y = x, y + 1
    elseif original_direction == defines.direction.west then
        from_x, from_y = x + 1, y
        to_x, to_y = x - 1, y
    else
        error("Bad direction " .. original_direction)
    end

    ---

    if original_type == "output" then
        -- If loader outputs onto a belt-connectible entity, then exit
        if next(loader.belt_neighbours.outputs) then return end

        -- Note whether loader would output from an entity in original configuration
        loader.update_connections()
        if loader.loader_container then is_entity_connected = true end

        -- Switch loader type and see if it connects to a belt-connectible entity
        loader.loader_type = "input"
        if next(loader.belt_neighbours.inputs) then return end

        -- Flip loader and see if it connects to a belt connectible entity or container
        loader.direction = original_direction --[[@as defines.direction]]
        if next(loader.belt_neighbours.inputs) then return end

        loader.update_connections()

        -- Determine if original configuration should be restored
        if is_entity_connected or
                surface.count_entities_filtered{ ghost_type = snap_targets, position = {from_x, from_y}, force = force_name, limit = 1 } > 0 or
                surface.count_entities_filtered{ type = "straight-rail", position = {from_x, from_y}, force = force_name, limit = 1 } > 0 or
                (not loader.loader_container and
                        surface.count_entities_filtered{ ghost_type = snap_targets, position = {to_x, to_y}, force = force_name, limit = 1 } == 0 and
                        surface.count_entities_filtered{ type = "straight-rail", position = {to_x, to_y}, force = force_name, limit = 1 } == 0) then
            loader.loader_type = original_type
            loader.direction = original_direction --[[@as defines.direction]]
        end
    else
        -- If loader takes input from a belt-connectible entity, then exit
        if next(loader.belt_neighbours.inputs) then return end

        -- Note whether loader would input to an entity in original configuration
        loader.update_connections()
        if loader.loader_container then is_entity_connected = true end

        -- Switch loader type and see if it connects to a belt-connectible entity
        loader.loader_type = "output"
        if next(loader.belt_neighbours.outputs) then return end

        -- Flip loader and see if it connects to a belt connectible entity or container
        loader.direction = original_direction --[[@as defines.direction]]
        if next(loader.belt_neighbours.outputs) then return end

        loader.update_connections()

        -- Determine if original configuration should be restored
        if is_entity_connected or
                surface.count_entities_filtered{ghost_type=snap_targets, position={to_x, to_y}, force=force_name, limit=1} > 0 or
                surface.count_entities_filtered{type="straight-rail", position={to_x, to_y}, force=force_name, limit=1} > 0 or
                (not loader.loader_container and
                        surface.count_entities_filtered{ghost_type=snap_targets, position={from_x, from_y}, force=force_name, limit=1} == 0 and
                        surface.count_entities_filtered{type="straight-rail", position={from_x, from_y}, force=force_name, limit=1} == 0) then
            loader.loader_type = original_type
            loader.direction = original_direction --[[@as defines.direction]]
        end
    end
end

---Handles creation of a new loader.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_entity_cloned|EventData.script_raised_built|EventData.script_raised_revive
function Actor.on_entity_created(event)
    local entity = event.created_entity or event.entity or event.destination

    if not entity.name == "1337exp-loader" then return end

    ---

    Actor.attempt_snap(entity)
end

---]>

script.on_event(defines.events.on_entity_cloned, Actor.on_entity_created, Actor.event_filters)
script.on_event(defines.events.on_built_entity, Actor.on_entity_created, Actor.event_filters)
script.on_event(defines.events.on_robot_built_entity, Actor.on_entity_created, Actor.event_filters)
script.on_event(defines.events.script_raised_built, Actor.on_entity_created, Actor.event_filters)
script.on_event(defines.events.script_raised_revive, Actor.on_entity_created, Actor.event_filters)
