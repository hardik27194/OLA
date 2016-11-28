Log={}

function Log:d(module,msg)

    _Log:d_message(module,msg)
end

function Log:i(module,msg)

    _Log:i_message(module,msg)
end
function Log:f(module,msg)

    _Log:f_message(module,msg)
end

--print(LMProperties:getRootPath())