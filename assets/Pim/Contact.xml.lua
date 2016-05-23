require "JSON4Lua"

--popup list view
local d_dt;
--is popup menu displyed or not
local isPopMenuDisplayed=false;


function initiate()
	loadGroup()
	loadYellowPages(0,20)
end
function back()
	homepage()
	return 1;
end

function homepage()
	ui:switchView("MainMenu.xml","callback('file opener returned param')","file opener params")
end

function exit()

end


function switch()
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
end

function reload()
	 sys.reload()
end

function loadGroup()
	
	local http=HTTP:create(Global.server.."Contact/ContactGroupList.action")
	http:setCookies(Global.cookies)
	http:sendRequest()
	http:receive()
	
	local content=http:getContent()
	local result=json.decode(content)
	local data=result.data

	--if result.status=="200" then

		for i=1, #data do
			row=data[i]		
			local r=createGroupTableRow(row)
			contact_group_list_table:addView(r)
		end
		
	--else
	--	showLogonMessage(result.message)
	--end

end


function createGroupTableRow(row)
	 local id= row.id
	 local name=row.name

	 local r=_G[ui:createView('<TR style="vertical-align:middle"></TR>')]

	 local nameLabel=ui:createView("<LABEL style='width:auto;height:35px;margin:2px;padding:5px;background-color:#FFFFFF;weight:1px;text-align:left;valign:middle' onclick='loadYellowPages("..id..",-1)'>".. name .."</LABEL>")
	 r:addView(nameLabel)

	return r
end



function loadYellowPages(id,pageSize)
	local url=Global.server.."Contact/ContactList.action?pageSize="..pageSize
	if id>0 then url=url.."&groupId="..id end
	local http=HTTP:create(url)
	http:setCookies(Global.cookies)
	http:sendRequest()
	http:receive()
	
	local content=http:getContent()
	local result=json.decode(content)
	local data=result.data
	--if result.status=="200" then
	contact_list_table:removeAllViews()
		for i=1, #data do
			row=data[i]		
			local r,r2=createTableRow(row)
			if r2~=nil then contact_list_table:addView(r2) end
			contact_list_table:addView(r)
			--contact_list_table:addView(r1)
		end
		
	--else
	--	showLogonMessage(result.message)
	--end

end
local initialInx='';

function createTableRow(row)
	 local id= row.id
	 local mobile=row.mobile
	 if mobile==nil or mobile=="" then mobile=row.telphone end
	 local name=row.name
	 local firstChar=row.firstChar
	 local initial=row.initial
	 local r2=nil;
	 if initial~= initialInx then
		r2=_G[ui:createView('<TR style="vertical-align:middle"></TR>')]
		local initialTD=ui:createView("<LABEL style='width:35px;height:35px;color:#00FF00;align:center;valign:middle'>".. initial .."</LABEL>")
		r2:addView(initialTD)
		initialInx=initial
	 end
 	 local r=_G[ui:createView('<TR style="vertical-align:middle"></TR>')]
	 local firstCharTD=ui:createView("<LABEL style='width:35px;height:35px;background-color:#FFFFcc;background-image:url(file://"..OLA.app_path..OLA.base.."Pim/images/green-circle.png);align:center;valign:middle'>"..firstChar.."</LABEL>")

	 local nameLabel=ui:createView("<LABEL style='width:auto;height:35px;background-color:#FFFFFF;weight:1px;text-align:left;valign:middle' onclick='showDetails("..id..")'>".. name .."</LABEL>")
	 r:addView(firstCharTD)
	 r:addView(nameLabel)


	 local idLavel=ui:createView("<LABEL style='width:auto;height:35px;background-color:#FFFFFF;weight:1px;text-align:right;valign:middle' onclick='call(\""..mobile.."\")'>".. mobile .."</LABEL>")
	 r:addView(idLavel)


	return r,r2
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
			local name=string.gsub(ph.name," ","%%20")
			local number=string.gsub(ph.number," ","%%20")

			local phoneType="vo.mobile" 
			if string.len(ph.number)<11 then phoneType="vo.telphone" end
			local url=Global.server.."Contact/ContactAdd.action?vo.user.id=".. Global.userId .."&vo.group.id=10&vo.name="..name.."&"..phoneType.."="..number
			local http=HTTP:create(url) 
			http:setCookies(Global.cookies)
			http:sendRequest()
	end
end


function call(number)
	Pim:dial(number)
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
		d_dt:setTop(h)
		d_dt:showOn("Main_body")
	end
end
function closePopup()
	d_dt:close()
	d_dt=nil
end
Log:d("MainMenu","loaded successfullly")
