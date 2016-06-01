function initiate()
end


function switch()
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
end
function reload()
	 sys.reload()
end

function show(pageName)
	ui:switchView("Font.xml","callback('file opener returned param')","file opener params")
end



function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end

function exit()
	LMProperties:printtype()
	LMProperties:exit()
end
