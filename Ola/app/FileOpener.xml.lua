

function initiate()
	Log:d('initiate','initiate execute...')
end


function switch()
	Log:d("UI","switch to testLua.xml")
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
	Log:d("UI","switched to testLua.xml")
end
function reload()
	 Log:d("reload","Lua reload is executed..")
	 sys.reload()
end

function ok()
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
end