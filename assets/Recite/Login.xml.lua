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
	code_lbl:setBackgroundImageUrl(Global.server.."Security/SecurityCodeImageAction.action",Global.cookies)
end

function logon()
	
	lui.showLoadingView()

	

	local account=account_txt:getText()
	local password=password_txt:getText()
	local securityCode=code_txt:getText()
	local url=Global.server.."CustomerLogin.action?account="..account.."&password="..password.."&securityCode="..securityCode.."&rt=1"
	local http=HTTP:create(url)
	http:setCookies(Global.cookies)
	http:setComplitedCallback("logonLisener")
	http:sendRequest()
	--http:receive()
	
end

function logonLisener(response)
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
	http:receive()
	return http:getCookies()
end


Log:d("Logon","loaded successfullly")
