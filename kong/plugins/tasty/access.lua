local _M = {}

function _M.execute(conf)

    if conf.insert_header then
        ngx.log(ngx.ERR, "============ Tasty! ============")
        ngx.header["Plugin-Tasty"] = "Tasty!!!"
    else
        ngx.log(ngx.ERR, "============ Bye Tasty! ============")
        ngx.header["Plugin-Tasty"] = "Bye Tasty!!!"
    end

end

function _M.hello()
    return "Tasty !"
end

return _M
