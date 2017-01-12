function initiate()
end


function reload()
	 sys.reload()
end

function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end

function back2Portal()
	LMProperties:printtype()
	LMProperties:exit()
end
