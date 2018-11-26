local client = require "kong.plugins.tasty.client"

local _M = {}

local function get_authz_health()
    url = "http://authz-svc.api-gw-authz.svc.cluster.local:8000/h"
    method = "GET"
    status_code, response_body = client.send_request(url, method)

    if status_code >= 200 and response_body then
        ngx.log(ngx.ERR, "============ Tasty! ============")
        ngx.header["Plugin-Tasty"] = "Checkout health of Authz: " .. response_body.message
    else
        ngx.log(ngx.ERR, "============ Bad Tasty! ============")
        ngx.header["Plugin-Tasty"] = "Checkout health of Authz Failed!!!"
    end

end

function _M.execute(conf)
    get_authz_health()
end

function _M.hello()
    return "Tasty !"
end

return _M
