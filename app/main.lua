local mqtt = require "mqtt"
local sender = require "sender"
local config = require "conf.config"

local log = ngx.log
local timer_at = ngx.timer.at

local ERR = ngx.ERR
local WARN = ngx.WARN
local INFO = ngx.INFO

local start_mqtt_client, run_timer

run_timer = function()
    local ok, err = timer_at(1, start_mqtt_client)
    if not ok then
        log(ERR, 'Failed to start the MQTT client: ', err)
    end
end

start_mqtt_client = function(premature)    
    log(INFO, "Starting MQTT client")

    local client = mqtt.client{ uri = config.mqtt.server, clean = true, connector = require "mqtt.ngxsocket" }
    if client:connect() then
        if client:subscribe{ topic = config.mqtt.topic } then
            client:on("message", function(msg)
                local client_id
                if config.mqtt.client_id_source == 'topic' and type(config.mqtt.client_id_regexp) == 'string' then
                    client_id = string.match(msg.topic, config.mqtt.client_id_regexp)
                elseif config.mqtt.client_id_source == 'payload' then
                    log(ERR, "Not yet implemented")
                else
                    log(WARN, "Wrong configuration")
                end
                if client_id then
                    log(INFO, "Client ID: ", client_id)

                    local err = sender.send_message(msg.payload, table.concat{client_id, config.mqtt.server})
                    if err then
                        log(WARN, err)
                    end
                end
            end)

            client:on("error", function(err)
                log(ERR, err)
            end)

            client:on("close", function()
                log(INFO, "MQTT connection closed")
                run_timer()
            end)

            client:receive_loop()
        else
            log(INFO, "MQTT failed to subscribe")
            run_timer()
        end
    else
        log(INFO, "MQTT connection failed")
        run_timer()
    end
end


run_timer()