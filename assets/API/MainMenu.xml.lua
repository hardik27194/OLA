function initiate()
end


function switch()
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
end
function reload()
	 sys.reload()
end

function show(pageName)
	ui:switchView(pageName..".xml","callback('file opener returned param')","file opener params")
end

function back2Portal()
	LMProperties:printtype()
	LMProperties:exit()
end

function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end
