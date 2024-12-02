local option = ({...})[1] or {chunk_func = true}
local lib = {};
do
    if option.chunk_func then
        assert(bit32,"dsakdksakdaskdksakdksa")
        local func_compare = bit32
        function lib.chunk_compare(c,s,mask) --chunk compare func
            for i=1,#s do
                if mask:sub(i,i) == "x" and s[i] ~= c[i] then
                    return false
                end
            end
            return true
        end
        function lib.chunk_sreach(c,s,mask,sindex)
            sindex = sindex or 1
            local s_len = #s
            for i = sindex,#c-s_len + 1 do
                local sub_c = {table.unpack(c,i,i+s_len-1)}
                if lib.chunk_compare(sub_c,s,mask) then
                    return i
                end
            end
            return nil
        end
        function lib.chunk_find_sub(chunk,chunkf) --[[ chunkf[1] = 0x2D chunkf[2] = 0x87 ]]
            for i = 1, math.min(16,#chunk) do
                if chunk[i] == chunkf[1] then
                    local constants = chunk[i+1] + func_compare.lshift(chunk[i+2],8) + func_compare.lshift(chunk[i+3],16) + func_compare.lshift(chunk[i+4],24)
                    return i,5,constants
                elseif chunk[i - 1] == chunkf[2] then
                    local constants = chunk[i+1] + func_compare.lshift(chunk[i+2],8) + func_compare.lshift(chunk[i+3],16) + func_compare.lshift(chunk[i+4],24)
                    return i-1,6,constants
                end
            end
            return nil
        end
    end
end
return lib
--[[
Exmaple : 
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/SEFLASe32/chunk/refs/heads/main/lib.lua"))({
	chunk_func = true
})
local chunk_sim = {0x2D,0x00,0x01,0x02,0x03,0x9,0x87,0x04,0x065}
local sig_sim = {0x2D,0x00,0x01,0x02,0x03}
local mask = "x"
if lib.chunk_compare(chunk_sim,sig_sim,mask) then
	print("Signature Match Chunk")
end
local index = lib.chunk_sreach(chunk_sim,sig_sim,mask)
if index then
	print("lib Chunk Sreach Found ", index)
end
local udex,size,con = lib.chunk_find_sub(chunk_sim,{0x2D,0x87})
if udex then
	print("sub instruction index",udex)
	print("Instruction Size",size)
	print("Constant",con)
end

]]
