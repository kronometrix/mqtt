local mqtt = require "mqtt"
local sender = require "sender"
local config = require "conf.config"

local log = ngx.log
local timer_at = ngx.timer.at

local ERR = ngx.ERR
local WARN = ngx.WARN
local INFO = ngx.INFO

local start_mqtt_client, run_timer

local pattern = string.gsub(config.mqtt.topic, "%+", "%(%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%%x%)", 1)

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
                local tid = string.match(msg.topic, pattern)
                if not tid then
                    log(WARN, "TID not found")
                else
                    local err = sender.send_message(msg.payload, tid)
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