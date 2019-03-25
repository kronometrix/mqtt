local http = require "resty.http.simple"
local config = require "conf.config"

local log = ngx.log
local concat = table.concat

local ERR = ngx.ERR
local WARN = ngx.WARN
local INFO = ngx.INFO

local _M = {
    _VERSION = '0.1'
}

local function urlencode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w ])", function(c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str    
end

function _M.send_message(message, tid)
    if type(message) ~= 'string' or #message == 0 or type(tid) ~= 'string' or tid == 0 then
        return "Wrong parameters"
    end
    
    if type(config.kronometrix) ~= 'table' then
        return "Wrong destination configuration"
    end

    for _, dest in ipairs(config.kronometrix) do
        local res, err = http.request(dest.host, dest.port, {
            path = dest.path,
            method = "POST",
            headers = { 
                ["token"] = tid,
                ["content-type"] = "application/x-www-form-urlencoded"
            },
            body = concat{"payload=", urlencode(message)}
        })
        if not res then
            if err then
                log(WARN, "Failed sending message to ", dest.host, ": "..err)
            else
                log(WARN, "Failed sending message to ", dest.host)
            end
        else
            if res.status ~= 200 then
                if res.body then
                    log(WARN, "Message sending finished with status ", res.status, "; body: ", res.body, "; dest: ", dest.host)
                else
                    log(WARN, "Message sending finished with status ", res.status, "; dest: ", dest.host)
                end
            else
                log(INFO, "Message sent; response: ", res.body, "; dest: ", dest.host)
            end
        end
    end
end

return _M