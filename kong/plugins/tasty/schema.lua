local function server_port(given_value, given_config)
    -- Custom validation
    if given_value > 65534 then
        return false, "port value too high"
    end

    -- If environment is "development", 8080 will be the default port
    if given_config.environment == "development" then
        return true, nil, { port = 8080 }
    end
end

return {
    --[[
    If true, it will not be possible to apply this plugin to a specific Consumer.
    This plugin must be applied to Services and Routes only.
    For example: authentication plugins.
     ]]
    no_consumer = true,

    --[[
      Your plugin’s schema. A key/value table of available properties and their rules.
      ]]
    fields = {
        -- Describe your plugin's configuration's schema here.
        insert_header = { type = "boolean", default = true, required = true },
        environment = { type = "string", required = false, enum = { "prod", "dev" } },
        server = {
            type = "table",
            schema = {
                fields = {
                    host = { type = "url", default = "http://example.com" },
                    port = { type = "number", func = server_port, default = 80 }
                }
            }
        }
    },
    --[[
    A function to implement if you want to perform any custom validation before accepting the plugin’s configuration.
    ]]
    self_check = function(schema, plugin_t, dao, is_updating)
        -- perform any custom verification
        return true
    end
}