package = "kong-plugin-tasty"
version = "0.1.0-1"

supported_platforms = {"linux", "macosx"}

source = {
  url = "https://github.com/Nexusunsky/kong-plugin-tasty.git ",
  tag = "0.1.0"
}

description = {
  summary = "Tasty of development on kong Plugin",
  homepage = "https://github.com/Nexusunsky/kong-plugin-tasty",
  detailed = [[
      Bootstrap of plugin development,
      Add Header in response for upstream,
      Send request and parse it from a service.
  ]],
}

dependencies = {
  "lua >= 5.1"
}

local pluginName = package:match("^kong%-plugin%-(.+)$")  -- "tasty"

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/access.lua",
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}
