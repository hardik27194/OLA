url_encode={} 

--private
function url_encode:encode(w)
    pattern="[^%w%d%._%-%* ]"
    s=string.gsub(w,pattern,function(c)
        local c=string.format("%%%02X",string.byte(c))
        return c
    end)
    s=string.gsub(s," ","+")
    return s
end

function url_encode:escape(w)
    local t={}
    for i=1,#w do
        c = string.sub(w,i,i)
        b,e = string.find(c,"[%w%d%._%-'%* ]")
        if not b then
            t[#t+1]=string.format("%%%02X",string.byte(c))
        else
            t[#t+1]=c
        end
    end
    s = table.concat(t)
    s = string.gsub(s," ","+")
    return s
end

function url_encode:decode(w)
    s=string.gsub(w,"+"," ")
    s,n = string.gsub(s,"%%(%x%x)",function(c)
        return string.char(tonumber(c,16))
    end)
    return s
end