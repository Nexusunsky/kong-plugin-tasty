---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by haoliu.
--- DateTime: 2018-12-25 16:10
---

local config = require("lapis.config")

config("development", {
    measure_performance = true,
    port = 9090,
    logging = {
        server = true,
        queries = true,
        requests = true,
    }
})

