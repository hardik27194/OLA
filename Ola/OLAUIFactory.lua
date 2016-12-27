ui={}
function ui:createView(xml)

    return _ui:createView(xml)
end

function ui:switchView(name)
    _ui:switchView_callback_params(name, nil, nil)

end
function ui:switchView(name, callback)
    _ui:switchView_callback_params(name, callback, nil)

end
function ui:switchView(name, callback, params)
    _ui:switchView_callback_params(name, callback, params)

end
function ui:getRootViewId()
    return _ui:getRootViewId()
end

function ui:getParameters()
    return _ui:getParameters()
end

function ui:cleanViewCache()
end