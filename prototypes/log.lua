local Log = {
    debug = false
}

-----------------------------------------------------

local function log_message(level, category, message)
    if not debug then return end

    local formatted_message = string.format("[%s][%s]: %s", level, category, message)
    print(formatted_message) -- Output to the console or log file
end

-----------------------------------------------------

function Log.error(category, message)
    log_message("error", category, message)
end

function Log.warning(category, message)
    log_message("warning", category, message)
end

function Log.success(category, message)
    log_message("success", category, message)
end

function Log.info(category, message)
    log_message("info", category, message)
end

-----------------------------------------------------

return Log