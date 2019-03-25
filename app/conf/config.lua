
local kronometrix = {
    {
        host = "127.0.0.1",
        port = 80,
        path = "/api/private/send_data"
    }
}

local mqtt = {
    server = "37.187.106.16",
    topic = "krmx/+/send_data"
}

return {
    kronometrix = kronometrix,
    mqtt = mqtt
}
