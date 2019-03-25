-- module table
local luasocket = {}


-- Open network connection to .host and .port in conn table
-- Store opened socket to conn table
-- Returns true on success, or false and error text on failure
function luasocket.connect(conn)
    local socket = ngx.socket.tcp()
    socket:settimeout(2147483647) -- timeout in ~24 days
    local sock, err = socket:connect(conn.host, conn.port)
    if not sock then
        return false, "socket.connect failed: "..err
    end

    conn.sock = socket
    return true
end

-- Shutdown network connection
function luasocket.shutdown(conn)
    local ok, err = conn.sock:close()
end

-- Send data to network connection
function luasocket.send(conn, data, i, j)
    return conn.sock:send(data)
end

-- Receive given amount of data from network connection
function luasocket.receive(conn, size)
    local ok, err = conn.sock:receive(size)
    return ok, err
end

-- export module table
return luasocket