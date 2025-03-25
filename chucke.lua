
return(function()
    local Serialzize = {}
    local ENCYPTION = {}
    local Logical = {}
    local Chunk = {}
    function Logical:C(s)
        local ns = ""
        for i = 1, #s do
            local charCode = string.byte(s, i)
            ns = ns .. "\\" .. charCode
            if charCode > 255 then
                print(charCode)
            end
        end
        return ns
    end
    function Logical:Xor(a,b)
        local p = 1
        local c = 0
    
        while a > 0 and b > 0 do
            local ra = a % 2
            local rb = b % 2
    
            if ra ~= rb then
                c = c + p
            end
            
            a = (a - ra) // 2
            b = (b - rb) // 2
            p = p * 2
        end
    
        if a < b then
            a = b
        end
    
        while a > 0 do
            local ra = a % 2
    
            if ra > 0 then
                c = c + p
            end
    
            a = (a - ra) // 2
            p = p * 2
        end
    
        return c
    end
    function Logical:Eq(n)
        local pole = {
            arthmetic = {
                ["+"] = "-",
                ["-"] = "+",
                ["*"] = "/",
                ["/"] = "*"
            }
        }
        local ran = math.random(1,2)
        local m = (ran == 1 and "+") or (ran == 2 and "-")
        local function hm(a,b)
            if (ran == 1) then
                return a + b
            elseif ran == 2 then
                return a-b
            end
            
        end
        local ra = math.random(100,1000)
        local ms = hm(n,ra)
        return string.format("(%s %s %s)",ms,pole.arthmetic[m],ra)
    end
    function Serialzize:Serialzizing(s)
        local ct = {}
        for i = 1,#s do
            table.insert(ct,string.byte(s,i,i))
        end
        return ct
    end
    function Serialzize:DeSerialzizing(s)
        local rs = ""
        for _, v in ipairs(s) do
            rs = rs .. string.char(v)
        end
        return rs
    end
    function ENCYPTION:Encrypt(s)
        local function Skey(l)
            local frag = {}
            for i = 1,l  do
                table.insert(frag,math.random(1,254))
            end
        end
        local key = Skey(#s)
        local new_s = {}
        for i,v in ipairs(Serialzize:Serialzizing(s)) do
            table.insert(new_s,Logical:Xor(v,key[i]))
        end
        return { string = Serialzize:DeSerialzizing(new_s), key = Serialzize:DeSerialzizing(key)}
    end
    function ENCYPTION:Estr(s,k)
        return string.format(
     [[function(a,b)
        local function c(d,e)
            local f,g=1,0;
            while d>0 and e>0 do 
                local h,i=d%%2,e%%2;
                if h~=i then 
                    g=g+f 
                end;
                d,e,f=(d-h)/2,(e-i)/2,f*2 
            end;
        if d < e then 
            d=e 
        end;
        while d>0 do 
            local h=d%%2;
            if h>0 then 
                g=g+f 
            end
            d,f=(d-h)/2,f*2 
        end;
            return g 
        end;
        local function j(a,b)
            local k={}
            for l=1,#a do 
                k[l]=string.char(c(string.byte(a,l,l),string.byte(b,l,l)))
            end;
            return table.concat(k)
        end;
            return j(a,b)
        end)("%s","%s")]]
        ,Logical:C(s),Logical:C(k))
    end
    function Chunk:Handler(c)
        local args = c.arguments
        local arg = args[1]
        if arg.type == "StringLiteral" then
            local strings = arg.raw:sub(2,-2)
            local data = ENCYPTION:Estr(strings)
            arg.raw = ENCYPTION:Estr(data.string,data.key)
            return arg
        end
    end
    return Chunk
end) 
