require "JSON4Lua"

--popup list view
local d_dt;
--is popup menu displyed or not
local isPopMenuDisplayed=false;


function initiate()
	Log:d('initiate','initiate execute...')
	Log:d('initiate',Global.server)
	loadYellowPages()
end
function back()
	homepage()
	return 1;
end

function homepage()
	Log:d("UI","switch to Study View ")
	ui:switchView("MainMenu.xml","callback('file opener returned param')","file opener params")
	Log:d("UI","switched to testLua.xml")
end

function exit()

end


function switch()
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
end

function SwitchLogon()
	ui:switchView("Login.xml","callback('file opener returned param')","file opener params")
end


function reload()
	 sys.reload()
end

function loadYellowPages()
	
	local http=HTTP:create(Global.server.."Addr/AddressList.action")
	http:setCookies(Global.cookies)
	http:sendRequest()
	http:receive()
	
	local content=http:getContent()
	Log:d("content", content)
	local result=json.decode(content)

	--if result.status=="200" then
	item_table:removeAllViews()
		for i=1, #result do
			row=result[i]		
			local r,r1=createTableRow(row)
			item_table:addView(r)
			item_table:addView(r1)
		end
		
	--else
	--	showLogonMessage(result.message)
	--end

end

function showLogonMessage(msg)
	local fv=FlashView:new()
	fv:create()
	fv:addItem(1,msg)
	fv:CANCEL("CANCEL")
	fv:showOn("Main_body")

end


function readContacts()
	local phoneStr=Pim:readContacts()
	local phones=json.decode("["..phoneStr.."]")
	local ph
	for i=1, #phones do
			ph=phones[i]
			Log:d("phone",ph.name)
			local name=string.gsub(ph.name," ","%%20")
			Log:d("phone",name)
			local number=string.gsub(ph.number," ","%%20")

			Log:d("phone",name..","..number)
			local phoneType="vo.mobile" 
			if string.len(ph.number)<11 then phoneType="vo.telphone" end
			local url=Global.server.."Contact/ContactAdd.action?vo.user.id=".. Global.userId .."&vo.group.id=10&vo.name="..name.."&"..phoneType.."="..number
			Log:d("url",url)
			local http=HTTP:create(url) 
			http:setCookies(Global.cookies)
			http:sendRequest()
	end
end


function call(number)
	Pim:dial(number)
end

function createTableRow(row)
	 local id= row.id
	 local mobile=row.mobile
	 local name=row.name
	 local createdBy=row.username
	 local description=row.description
	 local r=_G[ui:createView('<TR style="vertical-align:middle"></TR>')]
	 local idLavel=ui:createView("<LABEL style='width:100px;height:25px;background-color:#CCFFFF;text-align:center;' onclick='call(\""..mobile.."\")'>".. mobile .."</LABEL>")
	 r:addView(idLavel)

	 local nameLabel=ui:createView("<LABEL style='width:auto;height:25px;weight:1px;background-color:#CCCCFF;text-align:center;' onclick='showDetails("..id..")'>".. name .."</LABEL>")
	 r:addView(nameLabel)

	 local L3=ui:createView("<button style='width:60px;height:25px;background-color:#CCCCCC;text-align:center;' >"..createdBy.."</button>")
	 r:addView(L3)
	
	local r1=_G[ui:createView('<TR style="vertical-align:middle"></TR>')]
	local desc=ui:createView("<LABEL style='width:auto;weight:1px;height:25px;background-color:#FFFFCC;text-align:left;'>".. description .."</LABEL>")
	r1:addView(desc)

	return r,r1
end

function ShowPopupMenu()
	if d_dt~=nil and d_dt.isClosed==true then
		closePopup()
	else
		d_dt=RightListView:new()
		d_dt:create()
		d_dt:addItem(nil,"Basic Info","testPop1")
		d_dt:addItem("images/nav/(15).png","Settings","")
		d_dt:addItem("images/nav/(2).png","Reset","resetDb")
		d_dt:addItem("images/nav/(18).png","上传通讯录","readContacts")
		d_dt:addItem("images/nav/(17).png","Import","importDairy")
		local h=Main_body_menu:getHeight()
		Log:d("ShowPopupMenu",'h=')
		d_dt:setTop(h)
		d_dt:showOn("Main_body")
	end
end
function closePopup()
	d_dt:close()
	d_dt=nil
end
Log:d("MainMenu","loaded successfullly")
