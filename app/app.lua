local lapis = require("lapis")
local app = lapis.Application()
local console = require("lapis.console")
local after_dispatch = require("lapis.nginx.context").after_dispatch
local to_json = require("lapis.util").to_json

app:get("/", function()
    ngx.print("Connected! Please type stuff (empty line to stop):")
    return "Welcome to Lapis " .. require("lapis.version")
end)

app:match("/console", console.make())

app:before_filter(function(self)
    after_dispatch(function()
        print(to_json(ngx.ctx.performance))
    end)
end)

return app
