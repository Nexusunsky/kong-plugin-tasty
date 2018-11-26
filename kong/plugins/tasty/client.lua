---
--- Created by haoliu.
---

-- load required modules
local http_client = require("socket.http")
local https_client = require "ssl.https"
local url_handler = require "socket.url"
local ltn12 = require "ltn12"
local mime = require "mime"
local JSON = require "kong.plugins.tasty.json"

local HTTP = "http"
local HTTPS = "https"

local _CLIENT = {}

local function pre_handle(full_url)
    local client
    local parsed_url = url_handler.parse(full_url)
    if HTTP == parsed_url.scheme then
        client = http_client
    elseif HTTPS == parsed_url.scheme then
        client = https_client
    end

    if not parsed_url.path then
        parsed_url.path = "/"
    end

    return client, parsed_url
end

function _CLIENT.send_request(url, method, headers, body)
    local response_body = {}
    local client, parsed_url = pre_handle(url)
    local _response, status_code, response_headers, _status = client.request {
        url = parsed_url,
        method = method,
        headers = headers,
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(response_body)
    }

    if status_code >= 400 then
        ngx.log(ngx.ERR, method .. url .. " failed. ")
    end

    return status_code, response_body, response_headers
end

return _CLIENT

