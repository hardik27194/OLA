
local now=os.date("%Y-%m-%d %H:%M:%S", os.time());
local today=os.date("%Y-%m-%d", os.time());
local tomorrow=os.date("%Y-%m-%d", os.time()+60*60*24);
local current = os.time();
	local database=Database:new()
function initiate()
	Log:d('initiate','initiate execute...')
	today_lbl:setText(today)
	loadDiary()
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

function reload()
	 Log:d("reload","MainMenu Lua reload is executed..")
	 sys.reload()
end

local y;
local m;
local d;
local h;
local mi;
local s;
local selectedItem=0;

function selectDate()
	local dp=DatePicker:create(DatePicker.TYPE_DATE)
	dp:onDone("selected")
	dp:open()

end
function selectTime()
	local dp=DatePicker:create(DatePicker.TYPE_TIME)
	dp:onDone("selectedTime")
	dp:open()

end
function selected(dp)
	y=dp:getYear()
	m=dp:getMonth()
	d=dp:getDayOfMonth()
	local selectedDate=string.format("%04d-%02d-%02d", y,m,d);
	--today_lbl:setText(selectedDate)
	
	current=dp:getTime()/1000
	local pre=current+60*60*24
	local preDate=os.date("%Y-%m-%d", pre);
	local currentDate=os.date("%Y-%m-%d", current);
	load(currentDate,preDate)

end

function selectedTime(dp)
	h=dp:getHour()
	mi=dp:getMinute()
	s=dp:getSecond()
	time_label:setText(string.format("%02d:%02d:%02d", h,mi,s))
end


function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end




function save()
	database:open("BabyGo")
	database:exec("CREATE TABLE IF NOT EXISTS Diary(id INTEGER PRIMARY KEY autoincrement,event_time timstamp,item int,amount int,description VARCHAR(256),UNIQUE(id))")
	--database:exec("insert into test values('1','test')")
	local timeStr=string.format("datetime('%04d-%02d-%02d %02d:%02d:%02d')",y,m,d,h,mi,s)
	database:exec("insert into Diary (event_time,item,amount,description) values("..timeStr..","..selectedItemValue..",0,'')")
	--[[
	--stmt=database:query("select * from test where id=?1","1")
	stmt=database:query("select * from Diary order by id desc")

	for i,row in ipairs(stmt) do
	 for k,v in pairs(row) do
	   Log:d("value",k.."="..v)
	 end
	end
	]]
	--database:close()
	loadDiary()

end
function allDairy()
	local pre=current-60*60*24
	local preDate=os.date("%Y-%m-%d", pre);
	local currentDate=os.date("%Y-%m-%d", current);
	current=pre
	today_lbl:setText("All")

	database:open("BabyGo")
	stmt=database:query("select *,event_time as eventtime from Diary  order by event_time desc")
	Log:d("statement",stmt[1].id)
	
	item_table:removeAllViews()
	for i,row in ipairs(stmt) do
	 local r=createTableRow(row)
	  item_table:addView(r)
	end

	--database:close()

end

function loadDiary()
	load(today,tomorrow)
end
function navPre()
	local pre=current-60*60*24
	local preDate=os.date("%Y-%m-%d", pre);
	local currentDate=os.date("%Y-%m-%d", current);
	current=pre
	load(preDate,currentDate)

end
function navNext()
	current=current+60*60*24
	local pre=current+60*60*24
	local preDate=os.date("%Y-%m-%d", pre);
	local currentDate=os.date("%Y-%m-%d", current);
	load(currentDate,preDate)

end

function reloadDairy()
	current=current
	local pre=current+60*60*24
	local preDate=os.date("%Y-%m-%d", pre);
	local currentDate=os.date("%Y-%m-%d", current);
	load(currentDate,preDate)
end
function load(preDate,currentDate)
	today_lbl:setText(preDate)
	item_table:removeAllViews()
	database:conn()
	database:open("BabyGo")


	local sql="select *,time(event_time) as eventtime from Diary where event_time>=datetime('"..preDate.."') and event_time<datetime('"..currentDate.."') order by event_time desc"
	stmt=database:query(sql)
    if stmt~=nil
	then
		for i,row in ipairs(stmt) do
		 local r=createTableRow(row)
		  item_table:addView(r)
		end
	end

	--database:close()

end
function createTableRow(row)
	 local id= row.id
	 local eventTime=row.eventtime
	 local item=Global.getItemText(row.item)
	 local amount=row.amount
	 local r=_G[ui:createView('<TR style="vertical-align:middle"></TR>')]
	 local idLavel=ui:createView("<LABEL style='width:40px;height:25px;background-color:#999900;text-align:center;'>".. id .."</LABEL>")
	 r:addView(idLavel)

	 local nameLabel=ui:createView("<LABEL style='width:auto;height:25px;weight:1px;background-color:#9900CC;text-align:center;' onclick='showDetails("..id..")'>".. eventTime .."</LABEL>")
	 r:addView(nameLabel)

	 local L3=ui:createView("<button style='width:60px;height:25px;background-color:#9999EE;text-align:center;' >"..item.."</button>")
	 r:addView(L3)
	 local L4=ui:createView("<button style='width:60px;height:25px;background-color:#9999EE;text-align:center;' >"..amount.."</button>")
	 r:addView(L4)

	return r
end

local itemId;
local itemType;
function showDetails(id)
	itemId=id
	local sql="select *,time(event_time) as eventtime from Diary where id="..id
	stmt=database:query(sql)
	row=stmt[1]

	itemType=row.item

	l_dairy_date_time:setText(row.event_time)
	l_dairy_date_item:setText(Global.getItemText(row.item))
	l_dairy_date_amount:setText(row.amount)
	lbl_description:setText(row.description)
	if row.image~="" then l_dairy_date_photo:setBackgroundImageUrl("file://"..row.image) end
	
	showLineChart()

	l_dairy_dialog:setVisibility('display')
end
function delete()
	local sql="delete from Diary where id="..itemId
	stmt=database:exec(sql)
	reloadDairy()
	l_dairy_dialog:setVisibility('hidden')
end

function edit()
	local sql="select *,time(event_time) as eventtime from Diary where id="..itemId
	stmt=database:query(sql)
	row=stmt[1]
	l_dairy_date_time_edit:setText(row.event_time)
	l_dairy_date_item_edit:setText(Global.getItemText(row.item))
	l_dairy_dialog:setVisibility('hidden')
	l_dairy_edit_dialog:setVisibility('display')
end

function showLineChart()
	local sql="select *,time(event_time) as eventtime from Diary where item="..itemType.." order by event_time desc limit 7"
	stmt=database:query(sql)
	
	local xa=""
	local ya=""
	local name=""

	for i,row in ipairs(stmt) do
	    if i==1 then
		  xa=row.event_time..xa
		  ya=row.amount..ya
		  name=Global.getItemText(row.item)
		else
		  xa=row.event_time..","..xa
		  ya=row.amount..","..ya

		end
	end
	line_chart:clear()
	line_chart:setXValue(xa)
	line_chart:addYValue_withLabel(ya,name)
	--line_chart:addYValue("Test2","1.5,2,3.5,4.5,15.5")
	line_chart:show()
Log:d("MainMenu","loaded showLineChart")
end


Log:d("MainMenu","loaded successfullly")
