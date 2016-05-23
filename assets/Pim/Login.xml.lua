require "JSON4Lua"



function initiate()
	Log:d('initiate','initiate execute...')
	Log:d('initiate',Global.server)
	Global.cookies=getCookies()
	refreshCode()
end
function back()
		back2Portal()
	return 1;
end

function exit()

end

function back2Portal()
	LMProperties:printtype()
	LMProperties:exit()
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
	local account=account_txt:getText()
	local password=password_txt:getText()
	local securityCode=code_txt:getText()
	local url=Global.server.."Login.action?account="..account.."&password="..password.."&securityCode="..securityCode.."&logonType=1"
	local http=HTTP:create(url)
	http:setCookies(Global.cookies)
	http:sendRequest()
	http:receive()
	
	local content=http:getContent()
	Log:d("Logon response", content)
	local result=json.decode(content)
	Log:d("Logon response", result.message)

	if result.status=="200" then
		Global.userId=result.user.id
		Global.username=result.user.name
		ui:switchView("Contact.xml","callback('file opener returned param')","file opener params")
	else
		showLogonMessage(result.message)
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


Log:d("MainMenu","loaded successfullly")
