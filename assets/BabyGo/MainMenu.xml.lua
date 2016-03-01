local currentPhoto="images/029.jpg";
local coverPanel;
--popup list view
local d_dt;
--is popup menu displyed or not
local isPopMenuDisplayed=false;

function initiate()
	Log:d('initiate','initiate execute...')
	--picture:setImageUrl(currentPhoto)
	local height,weight=getBodyStatus()
	body_height_lbl:setText(height.." CM")
	body_weight_lbl:setText(weight.." Kg")
end
function back()
	if isPopMenuDisplayed==true then
		closePopup()
		isPopMenuDisplayed=false;
	else
		back2Portal()
	end
	return 1;
end

function exit()
	 Log:d("BabyGo","MainMenu exit..")
	 Log:d("BabyGo",type(coverPanel))
	if coverPanel~=nil then
	  coverPanel:close() 
	  coverPanel=nil
	end
	 Log:d("BabyGo","MainMenu exit1..")
end

function back2Portal()
	LMProperties:printtype()
	LMProperties:exit()
end


function switch()
	Log:d("UI","switch to Study View ")
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
	Log:d("UI","switched to testLua.xml")
end

function reload()
	 sys.reload()
end

function showDairyView()
	ui:switchView("DailyList.xml","callback('file opener returned param')","file opener params")
end

function showAddLogView(item)
	coverPanel=cover()
	ui:switchView("AddLog.xml","initItem("..item..")","file opener params")
	--cv:close()
end

function cover()
		local cv=ListView:new()
		cv:create()
		cv:setTitle(" ")
		cv:addItem(1,"Loading...")
		cv:CANCEL("Close")
		cv:showOn("Main_body")
		return cv
end
function showPrePhoto()
	local fileStr=FileConnector:listFiles(Global.storage,".jpg,.gif,.png")
	local files=loadstring('return {'..fileStr..'}')()
	local pre;
	local current=currentPhoto;
	local post;
	local first;
	local isFound=false;
	for i,file in ipairs(files) do
		Log:d("showPrePhoto",file.name)
		pre=current
		current=file.name
		if file.name==currentPhoto then
			isFound=true
			currentPhoto=pre
			break
		end
	end

	if isFound==true then
		Log:d("showPrePhoto","pre1=".."file://"..Global.storage.."/"..pre)
		picture:setImageUrl("file://"..Global.storage.."/"..pre)
	else
		Log:d("showPrePhoto","pre2=".."file://"..Global.storage.."/"..files[1].name)
		picture:setImageUrl("file://"..Global.storage.."/"..files[1].name)
		currentPhoto=files[1].name
	end
	
end
function showNextPhoto()
	local fileStr=FileConnector:listFiles(Global.storage,".jpg,.gif,.png")
	local files=loadstring('return {'..fileStr..'}')()
	local pre;
	local current=currentPhoto;
	local post;
	local first;
	local isFound=false;
	for i,file in ipairs(files) do
		Log:d("showPrePhoto",file.name)
		if isFound==true then
			post=file.name
			current=file.name
			currentPhoto=current
			break
		end
		if file.name==currentPhoto then
			isFound=true			
		end
	end

	if isFound==true then
		Log:d("showPrePhoto","post1=".."file://"..Global.storage.."/"..post)
		picture:setImageUrl("file://"..Global.storage.."/"..post)
	else
		Log:d("showPrePhoto","post2=".."file://"..Global.storage.."/"..files[1].name)
		picture:setImageUrl("file://"..Global.storage.."/"..files[1].name)
		currentPhoto=files[1].name
	end
	
end

function resetDb()
		d_dt=ListView:new()
		d_dt:create()
		d_dt:setTitle("初始化")
		d_dt:addItem(1,"是否确定重置系统并清除所有数据？")
		d_dt:OK("YES","dropTable_OK")
		d_dt:CANCEL("NO","closePopup")
		d_dt:showOn("Main_body")
end

function dropTable_OK()
	local database=Database:new()
	database:conn()
	database:open("BabyGo")
	database:exec("drop TABLE IF EXISTS Diary;")
	Log:d("drop TABLE ","Diary")
	database:exec("CREATE TABLE IF NOT EXISTS Diary(id INTEGER PRIMARY KEY autoincrement,event_time timstamp,item int,amount int,image varchar(100),description VARCHAR(256),create_time timstamp,update_time timstamp,UNIQUE(id))")
	Log:d("CREATE TABLE ","Diary")
	database:close()
	d_dt:close();
end
function closePopup()
	d_dt:close()
end

function export()
	local database=Database:new()
	database:conn()
	database:open("BabyGo")
	local sql="select *,date(event_time) as eventtime from Diary order by id asc"
	stmt=database:query(sql)
	
	fc = fos:open(Global.storage.. "Dairy.CSV")
	for i,row in ipairs(stmt) do
	  --write to file
      fc:writeString(row.id);fc:writeString(",");
      fc:writeString(row.event_time);fc:writeString(",");
      fc:writeString(row.item);fc:writeString(",");
      fc:writeString(row.amount);fc:writeString(",");
      fc:writeString(row.image);fc:writeString(",\"");
	  local d=string.gsub(row.description,"\n","\r")
      fc:writeString(d); fc:writeString("\"\n");
	  
	  if row.description~=nil and row.description~='' then Log:d("Export",d) end

	end
	fc:close()

end

function ShowPopupMenu()
	if isPopMenuDisplayed==true then
		closePopup()
		isPopMenuDisplayed=false;
	else
		d_dt=RightListView:new()
		d_dt:create()
		d_dt:addItem(nil,"Basic Info","testPop1")
		d_dt:addItem("images/nav/(15).png","Settings","")
		d_dt:addItem("images/nav/(2).png","Reset","resetDb")
		d_dt:addItem("images/nav/(18).png","Export","export")
		d_dt:addItem("images/nav/(17).png","Import","importDairy")
		local h=Main_body_menu:getHeight()
		Log:d("ShowPopupMenu",'h=')
		d_dt:setTop(h)
		d_dt:showOn("Main_body")
		isPopMenuDisplayed=true
	end
end

function testPop1()
		d_dt=ListView:new()
		d_dt:create()
		d_dt:setTitle("初始化")
		d_dt:addItem(1,"Test")
		d_dt:OK("YES","testPop")
		d_dt:CANCEL("NO","closePopup")
		d_dt:showOn("Main_body")
end

function testPop()
	Log:d("testPop","..................")
	closePopup()
end

function trimCsvCell(s)
	if s==nil then return nil end
	if string.sub(s,1,1)=='"' and string.sub(s,-1,-1)=='"' then
		s=string.sub(s,2,-2)
	end
	s=string.gsub(s,'""','"')
	return s
end

function parseCsvRow(rowStr)
	local arrays={}
	local len=string.len(rowStr)
	local s=''
	local intent=0
	local pos=1

	for i=1,len do
		local c=string.sub(rowStr,i,i)
		if c=='"' then
			intent=intent+1
		end
		if c==',' then
			if intent%2==0 then
				arrays[pos]=trimCsvCell(s)
				pos=pos+1
				s=''
			else
				s=s..c
			end
		else
			s=s..c
		end
	end
	arrays[pos]=trimCsvCell(s)
	return arrays
end



function importDairy()
	local database=Database:new()
	database:conn()
	database:open("BabyGo")
	

	local fc = fos:open(Global.storage.. "Dairy.CSV")
	local line=fc:readLine()
	while  line~=nil do
		Log:d("read line",line)
		--database:exec("insert into Diary (event_time,item,amount,image,description,create_time,update_time) values("..timeStr..","..selectedItemValue..","..item_amount:getText()..",'"..photoPath.."','"..description:getText().."',datetime('now','localtime'),datetime('now','localtime'))")
		
		local row=parseCsvRow(line)
		--database:exec("insert into Diary (event_time,item,amount,image,description,create_time,update_time) values(datetime('"..row[2].."'),"..row[3]..","..row[4]..",'"..row[5].."','"..row[6].."',datetime('now','localtime'),datetime('now','localtime'))")

		line=fc:readLine()
	end
	fc:close()

end

function getBodyStatus()
	local height=0
	local weight=0

	local database=Database:new()
	database:conn()
	database:open("BabyGo")
	local sql="select amount from Diary where item=8 order by event_time desc limit 1"
	stmt=database:query(sql)
	
	if stmt~=nil then
		row=stmt[1]
		height=row.amount
	end

	sql="select amount from Diary where item=7 order by event_time desc limit 1"
	stmt=database:query(sql)
	
	if stmt~=nil  and #stmt>=1 then
		row=stmt[1]
		weight=row.amount
	end
	
	database:close()
	return height,weight
end



Log:d("MainMenu","loaded successfullly")
