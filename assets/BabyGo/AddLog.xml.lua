--item dialog view--
local v;
--year--
local y;
local m;
local d;
local h;
local mi;
local s;
local selectedItem=0;
local photoPath="";
local selectedItemValue=0;

function initiate()
	Log:d('initiate','initiate execute...')
	--lbl_run:setText(Global.run_mile..'km');
	--lbl_walk:setText(Global.walk_mile..'km');
	y=tonumber(os.date("%Y",os.time())) 
	m=tonumber(os.date("%m",os.time())) 
	d=tonumber(os.date("%d",os.time())) 
	h=tonumber(os.date("%H",os.time())) 
	mi=tonumber(os.date("%M",os.time())) 
	s=tonumber(os.date("%S",os.time())) 
	date_label:setText(string.format("%04d-%02d-%02d", y,m,d))
	time_label:setText(string.format("%02d:%02d:%02d", h,mi,s))

	item_amount:setInputType(2,8192)

	loadDiary()
end

function initItem(item)
	Log:d("UI","initItem "..item)
	if item>0 then
		local text=Global.getItemText(item)
	Log:d("UI","initItem ="..text)
		item_label:setText(text)
		selectedItemValue=item
	else
		item_label:setText("--选择--")
		selectedItemValue=0

	end
end
function back()
	homepage()
	return 1;
end
function switch()
	Log:d("UI","switch to Study View ")
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
	Log:d("UI","switched to testLua.xml")
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
	date_label:setText(string.format("%04d-%02d-%02d", y,m,d))
	loadDiary()
end

function selectedTime(dp)
	h=dp:getHour()
	mi=dp:getMinute()
	s=dp:getSecond()
	time_label:setText(string.format("%02d:%02d:%02d", h,mi,s))
end

function showList()
	 Log:d("showList","start..")
		v=ListView:new()
		v:create()
		v:addItem(1,"母乳")
		v:addItem(2,"奶粉")
		v:addItem(3,"水")
		v:addItem(4,"药")
		v:addItem(5,"大便")
		v:addItem(6,"小便")
		v:addItem(7,"体重")
		v:addItem(8,"身高")
		v:OK("OK","listOK")
		v:CANCEL("CANCEL","listCancel")
		v:showOn("BabyGo_AddLog_body")
end
function testFlash()
	local fv=FlashView:new()
	fv:create()
	fv:addItem(1,"添加成功")
	fv:CANCEL("CANCEL")
	fv:showOn("BabyGo_AddLog_body")
	n=3
	--sleep1(3)
	--fv:close()
Log:d("testFlash","end")
end
function sleep1(sec)
local n=0
local s=0
local s1=0
while true 
do 
	s=os.time();
		if s~=s1 
		then 
			n=n+1;
			Log:d("sleep","this is the"..n.."seceod");
		end;
		if n>=sec
		then
			break
		end
	s1=s;
end
end

function listOK()
	--local item=v:getSelectedItem()
	item_label:setText(v:getSelectedItemText())
	selectedItemValue=v:getSelectedItemValue()
	v:close()
end
function listCancel()
	v:close()
end

function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end



function add()
	local fv=FlashView:new()
	fv:create()
	fv:addItem(1,"添加日志中...")
	fv:CANCEL("CANCEL")
	fv:showOn("BabyGo_AddLog_body")

	local database=Database:new()
	database:conn()
	database:open("BabyGo")
	--database:exec("insert into test values('1','test')")
	local timeStr=string.format("datetime('%04d-%02d-%02d %02d:%02d:%02d')",y,m,d,h,mi,s)
	database:exec("insert into Diary (event_time,item,amount,image,description,create_time,update_time) values("..timeStr..","..selectedItemValue..","..item_amount:getText()..",'"..photoPath.."','"..description:getText().."',datetime('now','localtime'),datetime('now','localtime'))")
	--stmt=database:query("select * from test where id=?1","1")
	stmt=database:query("select * from Diary order by id desc")

	for i,row in ipairs(stmt) do
	 for k,v in pairs(row) do
	   Log:d("value",k.."="..v)
	 end
	end
	database:close()
	loadDiary()
	fv:setItem(1,"添加成功...")
	fv:CANCEL("CANCEL")

end

function loadDiary()
	local today=date_label:getText()  --os.date("%Y-%m-%d", os.time());
	--local tomorrow=os.date("%Y-%m-%d", os.time()+60*60*24);

	local pattern = "(%d+)-(%d+)-(%d+)"
	local runyear, runmonth, runday= today:match(pattern)
	local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday})
	local tomorrow=os.date("%Y-%m-%d", convertedTimestamp+60*60*24);

	local database=Database:new()
	database:conn()
	database:open("BabyGo")
	local sql="select *,time(event_time) as eventtime from Diary where event_time>=datetime('"..today.."') and event_time<datetime('"..tomorrow.."') order by id desc"
	local stmt=database:query(sql)
	
	add_item_table:removeAllViews()
	for i,row in ipairs(stmt) do
	  local r=createTableRow(row)
	  add_item_table:addView(r)
	end

	database:close()

end

function createTableRow(row)
	 local id= row.id
	 local eventTime=row.event_time
	 local item=Global.getItemText(row.item)
	 local r=_G[ui:createView('<TR style="vertical-align:middle"></TR>')]
	 local idLavel=ui:createView("<LABEL style='width:40px;height:25px;background-color:#999900;text-align:center;'>".. id .."</LABEL>")
	 r:addView(idLavel)

	 local nameLabel=ui:createView("<LABEL style='width:auto;height:25px;weight:1px;background-color:#9900CC;text-align:center;'>".. eventTime .."</LABEL>")
	 r:addView(nameLabel)

	 local L3=ui:createView("<button style='width:60px;height:25px;background-color:#9999EE;text-align:center;' >"..item.."</button>")
	 r:addView(L3)

	return r
end

function takePhoto()
	Camera:openCamera(Global.storage,"getPhoto")
end
function getPhoto(path)
	Log:d("photoPath",path)
	photoPath=path
	photo_lbl:setBackgroundImageUrl("file://"..photoPath)
end
Log:d("MainMenu","loaded successfullly")
