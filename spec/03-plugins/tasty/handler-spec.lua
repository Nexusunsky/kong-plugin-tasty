local helpers = require "spec.helpers"

for _, strategy in helpers.each_strategy() do
    describe("my plugin", function()

        local bp = helpers.get_db_utils(strategy)

        setup(function()
            local service = bp.services:insert {
                name = "test-service",
                host = "httpbin.org"
            }

            bp.routes:insert({
                hosts = { "test.com" },
                service = { id = service.id }
            })

            -- start Kong with your testing Kong configuration (defined in "spec.helpers")
            assert(helpers.start_kong({ plugins = "bundled,my-plugin" }))

            admin_client = helpers.admin_client()
        end)

        teardown(function()
            if admin_client then
                admin_client:close()
            end

            helpers.stop_kong()
        end)

        before_each(function()
            proxy_client = helpers.proxy_client()
        end)

        after_each(function()
            if proxy_client then
                proxy_client:close()
            end
        end)

        describe("thing", function()
            it("should do thing", function()
                -- send requests through Kong
                local res = proxy_client:get("/get", {
                    headers = {
                        ["Host"] = "test.com"
                    }
                })

                local body = assert.res_status(200, res)

                -- body is a string containing the response
            end)
        end)
    end)
end