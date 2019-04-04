
local kronometrix = {
    {
        host = "127.0.0.1",
        port = 80,
        path = "/api/private/send_data",
        sid = "9ee583c7d0a8b314c947dccfdcd922ca", -- Computer Performance
        tid = "d5e077bb7d043f5bd93391d283072e1d"
    }
}

local mqtt = {
    server = "37.187.106.16",
    topic = "krmx/+/send_data",
    clientid_source = "topic",
    clientid_regexp = "krmx/(%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x)/send_data"
}

return {
    kronometrix = kronometrix,
    mqtt = mqtt
}
