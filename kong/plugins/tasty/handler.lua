-- Extending the Base Plugin handler is optional, as there is no real
-- concept of interface in Lua, but the Base Plugin handler's methods
-- can be called from your child implementation and will print logs
-- in your `error.log` file (where all logs are printed).
local BasePlugin = require "kong.plugins.base_plugin"

-- The actual logic is implemented in those modules
local access = require "kong.plugins.tasty.access"

local TastyHandler = BasePlugin:extend()

TastyHandler.PRIORITY = 2000
TastyHandler.VERSION = "0.1.0"

-- Your plugin handler's constructor. If you are extending the
-- Base Plugin handler, it's only role is to instantiate itself
-- with a name. The name is your plugin name as it will be printed in the logs.
function TastyHandler:new()
    TastyHandler.super.new(self, "kong-plugin-tasty")
end

function TastyHandler:init_worker()
    -- Executed upon every Nginx worker process’s startup.
    TastyHandler.super.init_worker(self)

end

function TastyHandler:certificate(config)
    -- Executed during the SSL certificate serving phase of the SSL handshake.
    TastyHandler.super.certificate(self)

end

function TastyHandler:rewrite(config)
    --[[
     Executed for every request upon its reception from a client as a rewrite phase handler.
     NOTE in this phase neither the api nor the consumer have been identified,
     hence this handler will only be executed if the plugin was configured as a global plugin!
     ]]--
    TastyHandler.super.rewrite(self)

end

function TastyHandler:access(config)
    -- Executed for every request from a client and before it is being proxied to the upstream service.
    TastyHandler.super.access(self)

    --kong.log.inspect(config.insert_header)
    --kong.log.inspect(config.environment) -- "development"
    --kong.log.inspect(config.server.host) -- "http://localhost"
    --kong.log.inspect(config.server.port) -- 8080

    access.execute(config)

end

function TastyHandler:header_filter(config)
    -- Executed when all response headers bytes have been received from the upstream service.
    TastyHandler.super.header_filter(self)

end

function TastyHandler:body_filter(config)
    -- Executed for each chunk of the response body received from the upstream service. Since the response is streamed back to the client, it can exceed the buffer size and be streamed chunk by chunk. hence this method can be called multiple times if the response is large. See the lua-nginx-module documentation for more details.
    TastyHandler.super.body_filter(self)

end

function TastyHandler:log(config)
    -- Executed when the last response byte has been sent to the client.
    TastyHandler.super.log(self)

end

-- This module needs to return the created table, so that Kong
-- can execute those functions.
return TastyHandler