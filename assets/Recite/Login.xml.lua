require "JSON4Lua"
require "lua_ui"


function initiate()
	Log:d('initiate','initiate execute...')
	Log:d('initiate',Global.server)
	if Global.cookies==nil or Global.cookies=='' then
		Global.cookies=getCookies()
	end 
	refreshCode()
end
	function back()
		ui:switchView("StudyView.xml","callback('file opener returned param')","file opener params")
		return 1;
	end

function exit()

end




function switch()
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
end

function reload()
	 sys.reload()
end

function refreshCode()
    Log:d('code path',Global.server.."Security/SecurityCodeImageAction.action",Global.cookies)
	code_lbl:setBackgroundImageUrl(Global.server.."Security/SecurityCodeImageAction.action",Global.cookies)
end

function logon()
	
	lui.showLoadingView()

	
Log:d('logon','start to logon')
	local account=account_txt:getText()
	local password=password_txt:getText()
	local securityCode=code_txt:getText()
	local url=Global.server.."CustomerLogin.action?account="..account.."&password="..password.."&securityCode="..securityCode.."&rt=1"
    Log:d('logon','1')
	local http=HTTP:create(url)
    Log:d('logon','2')
	http:setCookies(Global.cookies)
    Log:d('logon','3')
	http:setComplitedCallback("logonLisener")
    Log:d('logon','4')
	http:sendRequest()
	--http:receive()
    Log:d('logon','5')
	
end

function logonLisener(response)
Log:d("Logon response", "start")
	local state=response:getState()
	local rootViewId=ui:getRootViewId()
	_G[rootViewId]:removeView("lui_loading_view")

	Log:d("Logon response statr", "..."..state)
	if state==2 then
		local content=response:getContent()
		local result=json.decode(content)

		if result.status=="200" then
			Global.user=result.user
			ui:switchView("MyInfo.xml","callback('file opener returned param')","file opener params")
		else
			showLogonMessage(result.message)
		end
	else
		showLogonMessage("Cannot caonnect to server...")
	end
end


function showLogonMessage(msg)
	local fv=FlashView:new()
	fv:create()
	fv:addItem(1,msg)
	fv:CANCEL("CANCEL")
	fv:showOn("Main_body")

end

function getCookies()
	local url=Global.server
	local http=HTTP:create(url)
	http:sendRequest()
    Log:d("cookie","1")
	http:receive()
    Log:d("cookie","2")
	local cookie= http:getCookies()
    Log:d("cookie","3")
    return cookie
end


Log:d("Logon","loaded successfullly")
