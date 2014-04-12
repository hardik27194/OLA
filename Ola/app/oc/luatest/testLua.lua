
text="testlua ...";
for i = 0,10 do
    for k = 0,10-i do
        text = "AA" .. text
    end

end
print(text)
print(type(CLuaFun))
CLuaFun:Add()
CLuaFun:d("test push OC function")
function func_Add(x, y)
   return x+y;
end
