function initiate()
	Log:d('initiate','initiate Recite execute...')
	Log:d('To UTF8 Char','........')
	Log:d('To UTF8 Char',str:toUTF6LE('230,00'))
	--addUIWedgit()
	--testProgressBar1()
	createDatabase()

	local currentTime=os.time()

	listNews("Simon")
	listNews("NewScience")

	--every 1 hour, do not run it too frequently
	if currentTime-Global.newsDownloadTime>=60*60 then 
		downloadSimon()
		downloadNewScientist()
		Global.newsDownloadTime=currentTime
	end


	local words=readLastStuiedWordList()
	showWordList(words)
end
	function back()
		ui:switchView("StudyView.xml","callback('file opener returned param')","file opener params")
		return 1
	end



function addUIWedgit()
	 Log:d("UI Test","addUIWedgit")
	 viewStr="<div layout='LinearLayout'  style='orientation:vertical;width:80px;align:center;background-color:#00EF00'><label>asd</label><label>asd2</label><button>btn</button></div>"
	 --viewStr="<label>asd</label>"
	 view=ui:createView(viewStr)
	 Log:d("UI Test","id="..view)
	 free_area:addView(view)
	 Log:d("UI Test","view was added")
end

function switch()
	Log:d("UI","switch to Study View ")
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
	Log:d("UI","switched to testLua.xml")
end


function test()
	--[[
	rootPath=FileConnector:getSDRoot()
	Log:d("File test",rootPath)
	filesStr=FileConnector:listFiles(Global.storage)
	Log:d("File test",filesStr)
	files=loadstring('return {'..filesStr..'}')()



	for i,row in ipairs(files) do
	  local file=createTableRow(row)
		Log:d("File test",file.name)
	end
	]]
	local o = io.open("/sdcard/test/IELTSCore3000.dbx", 'wb+')
	o:write(1)
	o:write("test")
	o:close()
	--[[
	Log:d("File test","read file:/sdcard/test/ITIES1228.dbx")
	local f = io.open("/sdcard/test/ITIES1228.dbx", 'rb+')
	Log:d("File test","open file successful")
	local line=f:read("*n")
	Log:d("File test","line="..line)
	f:close()


	local index = WordIndex.new(self)
	index.open("/sdcard/test/ITIES1228.dbx")
	local wordPos= index.getPos(1)
	for i=1, 6, 1 do
		Log:d("Word Index","word pos="..wordPos[i])
	end

	]]

end

----test to play a audio file------------ 
function create()
    --Log:d("Player","URL="..OLA.base..'yellow_submarine.mp3')
	soundPlayer=MediaPlayer:createPlayer(OLA.base..'yellow_submarine.mp3')
	soundPlayer:play()
end

function pause()
	soundPlayer:pause()
end
function stop()
	soundPlayer:stop()
end
----------------------------------------


function dialogBtnTest()
	Log:d("dialogBtnTest","running.......")
end



local progressValue=0
function testProgressBar()
	progressValue=progressValue+1
	ProgressBar:setValue(progressValue)
	test_text:setText(progressValue..'%')
end
function testProgressBar2()
		local n,s,s0 = 0 
	Log:d("testProgressBar2","testProgressBar2=")
	while true do    
		--s = os.date("%s", os.time())    
		s=os.time()
		if s0 ~= s then        
			n = n + 10
			s0=s
			Log:d("time second=",''..n)
			--print(n)
			ProgressBar:setValue(n)
			--test_text:setText(n..'%')
			--LMProperties:sleep(1000)
		end    

		if n >= 100 then        
			break 
		end
	end
end

-- <VIEW threadClick=FUN />
--using "threadClick " to invoke the method to runa thred event
--if the method returns TURE, the thread will be terminated
			local msg=uiMsg:create()
			local n=0;
function testProgressBar20(a,b)
		local s,s0 = 0 
	
			n=n+1
			Log:d("time second=",''..n)
			msg:updateMessage("ProgressBar:setValue("..n.."); test_text:setText('"..n.."%')")
			if n>=100 then
				n=0
				return true 
			else
				return false
			end
end


function downloadTest()
	local download=AsyncDownload:create();
	--download:addUrl("http://www.myfrfr.com/chanson/flash/Myfrfr_6Angeli.swf")
	--download:addUrl("http://amis.myfrfr.com/chansons/myfrfrnoelsanstoi.swf")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(1).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(2).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(3).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(4).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(5).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(6).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(7).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(8).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(9).png")
	download:addUrl("http://10.0.2.2:8080/apps/ola/images/ico/(10).png")
	--download:setProgressBar("ProgressBar")
	--download:setTotalProgressBar("ProgressBar2")
	download:setProcessingCallback("downloadMonitor")
	Log:d("download","setProcessingCallback")
	download:setComplitedCallback("finishDownload")
	download:start()

end

function downloadMonitor(state,totalSize, downloadedSize,url,localFileName)
	local percent=(1.0*downloadedSize/totalSize)*100
	ProgressBar:setValue(percent)
	test_text:setText('Current:\n'..math.floor(percent)..'%')
end
function finishDownload(totalNumber,currentNumber,currentUrl,localFileName)
	local percent=(1.0*currentNumber/totalNumber)*100
	ProgressBar2:setValue(percent)
	test_text2:setText('Total:\n'..math.floor(percent)..'%')
end
function showAbout()
		local view;
		local viewStr="<div id='dialog' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:center;alpha:0.8;background-color:#cccccc'><div id='dialog' layout='LinearLayout'  style='margin:20px;padding:10px;orientation:vertical;width:auto;align:center;alpha:1;background-color:#FFFFFF'><label style='width:auto;background-image:url(images/10.gif);'>About Recite</label><label>This is an application to help recite English words.\n Copyright:lohool@hotmail.com\Production Version: 1.0 </label><button onclick='closeDialog(\"dialog\")' style='background-color:#FFFFCC;'>Close</button></div></div>"
		 view=ui:createView(viewStr)
		--local alert = Alert:create()
		--alert:show()
		--alert:setContentView(view)
		Log:d("testDialog","view created")
		body:addView(view)
		Log:d("testDialog","view added")
end
function closeDialog(dilogId)
	Log:d("Review Info","close start")
	_G[dilogId]:setVisibility('block');
	Log:d("Review Info","close end")
end

----线程函数测试-------------------------------------------
--被执行函数返回true时结束线程
function threadMethodTest()
	local thread=Thread:create(1000)
	local s = os.date("%s", os.time())   
	thread:start("threadMethod("..s..")");
	--thread:start("threadMethod()");
end

function threadMethod(s0)
	--local n,s,s0 = 0 
	local s = os.date("%s", os.time())    
	--[[
		if s0 ~= s then        
			n = n + 1
			s0=s
			Log:d("Timer","this is the "..n.." seceod")    
		end    
	]]
	Log:d("Timer","this is the "..(s-s0).." seceod")
		if s -s0  >= 10 then
			Log:d("Timer","end...")    
			msg:updateMessage("showFirstStudyView()")
			return true
    end

end
------------------------------------------------------------

-----录音测试-----------------------------------------------
local recorder=Recorder:create()
function startRecorder()
	recorder:startRecording()
end

function stopRecorder()
	recorder:stopRecording()
end
--------------------------------------------------------------


-----文章数据库公有函数---------------------------------------
function createDatabase()
	local database=Database:new()
	database:conn()
	database:open("ProcketWords")
	--database:exec("drop TABLE IF EXISTS NewScience;")
	database:exec("CREATE TABLE IF NOT EXISTS NewScience(id INTEGER PRIMARY KEY autoincrement,title VARCHAR(256),url VARCHAR(256), article TEXT,create_time timstamp,UNIQUE(id))")
	database:exec("CREATE TABLE IF NOT EXISTS Simon(id INTEGER PRIMARY KEY autoincrement,title VARCHAR(256),url VARCHAR(256), article TEXT,create_time timstamp,UNIQUE(id))")
	database:close()
end

function insertNews(newsType,title,url, article)
	Log:d("db","insertNews")
	local database=Database:new()
	database:conn()
	database:open("ProcketWords")
	if article==nil then article="" end
	--local timeStr=string.format("datetime('%04d-%02d-%02d %02d:%02d:%02d')",y,m,d,h,mi,s)
	database:exec("insert into "..newsType.." (create_time,title,url,article) values(datetime('now','localtime'),'"..title.."','"..url.."','"..article.."')")

	database:close()

end

function updateNews(newsType,title,article)
	local database=Database:new()
	database:conn()
	database:open("ProcketWords")
	if article==nil then article="" end
	--local timeStr=string.format("datetime('%04d-%02d-%02d %02d:%02d:%02d')",y,m,d,h,mi,s)
	database:exec("update "..newsType.." set article='"..article.."' where title='"..title.."'")

	database:close()

end

function findNews(newsType,title,url)
	Log:d("db","findNewsByTitle")

	local scNews=nil
	local database=Database:new()
	database:conn()
	database:open("ProcketWords")

	local sql="select * from "..newsType.." where title='"..title.."' and url='"..url.."'"
	local stmt=database:query(sql)
	
	if stmt~=nill and #stmt >0 then scNews=stmt[1] end

	database:close()
	return scNews
end
function findNewsById(newsType,id)
	Log:d("db","findNewsById")

	local scNews=nil
	local database=Database:new()
	database:conn()
	database:open("ProcketWords")

	local sql="select * from "..newsType.." where id="..id
	local stmt=database:query(sql)
	
	if stmt~=nill and #stmt >0 then scNews=stmt[1] end

	database:close()
	return scNews
end

local news={}
local Simon={}

function listNews(newsType)
	Log:d("db","listNews.."..newsType)
	local database=Database:new()
	database:conn()
	database:open("ProcketWords")
	local sql="select * from "..newsType.." order by id desc limit 10"
	local stmt=database:query(sql)
	Log:d("db","showNewsTitle 1")
	if stmt~=nil then
		local pos=1
		for i,row in ipairs(stmt) do
		  --_G["New_"..pos]:setText(row.title);
		  showNewsTitle(newsType,pos,row.title)
		  if newsType=="NewScience" then
			news[pos]={id=row.id,href=row.url,title=row.title}
		  else
			Simon[pos]={id=row.id,href=row.url,title=row.title}
		  end
		  pos=pos+1
		end
	end
	database:close()

end


function showNewsTitle(newsType,id,title)
	local nt=string.gsub(title,"&#8217;","'")
	local titleLbl=_G[newsType.."_"..id];
	if titleLbl~=nil then titleLbl:setText(nt) end
end
-----文章数据库公有函数--结束-------------------------------------


-----News Scientist download---------------------------------------

function downloadNewScientist()
	Log:d("download","newscientist")
		local http=HTTP:create('https://www.newscientist.com/')
		http:setComplitedCallback("analysisRecommend")
		http:sendRequest()
end

function analysisRecommend(response)
	for u,t in string.gmatch(response:getContent(),'<a href="https://www.newscientist.com([^<]-)" class="recommended%-widget%-link"><h2>(.-)</h2>') do
		local news= findNews("NewScience",t,u)
		if news ==nil then
			insertNews("NewScience",t,u)
		end
	end
	listNews("NewScience")
end

function showScienceNewsDetail(id)
	local new=findNewsById("NewScience",news[id].id)
	if new~=nil and new.article~="" then
		showDetail(new.title,new.article)
	else
		Log:d("url","https://www.newscientist.com"..news[id].href)
		downloadScienceDetail("https://www.newscientist.com"..news[id].href,news[id].title)
	end
end
function downloadScienceDetail(href,title)
		local http=HTTP:create(href)
		http:sendRequest()
		http:receive()
		local h;
		for v in string.gmatch(http:getContent(),'<div class="article%-content">(.-)<%!%-%- ADD article topics at the end of the article %-%->') do
			h=v
		end
		--show the dialog immediately
		news_dialog:setVisibility('none');
		showDetail(title,h)
		updateNews("NewScience",title,h)
end
-----Simon IELTS download---------------------------------------

function showDetail(title,content)
	local t=string.gsub(title,"&#8217;","'")
		news_title:setText(t);
		news_content:getView():loadData(content, "text/html", "UTF-8");  
		--news_panel_title:setText("NewScientist news")
		news_dialog:setVisibility('none');
end





function downloadSimon()
	Log:d("download","simon")
		local http=HTTP:create('http://ielts-simon.com/')
		http:setComplitedCallback("analysisSimon")
		http:sendRequest()

end


function analysisSimon(response)
	local content=response:getContent()
	content=string.gsub(content,"'","&#8217;")
	for u,t in string.gmatch(content,'<h3 class="entry%-header"><a href="([^<]-)">(.-)</a></h3>') do
		local news= findNews("Simon",t,u)
		if news ==nil then
			insertNews("Simon",t,u)
		end
	end
	listNews("Simon")
end

function showSimonDetail(id)
	local new=findNewsById("Simon",Simon[id].id)
	if new~=nil and new.article~="" then
		showDetail(new.title,new.article)
	else
		downloadSimonDetail(Simon[id].href,Simon[id].title)
	end

end
function downloadSimonDetail(href,title)
		local http=HTTP:create(href)
		http:sendRequest()
		http:receive()
		news_title:setText(title);
		--Simon_content:setText(content);
		local content=http:getContent()
		content=string.gsub(content,"'","&#8217;")
		local h;
		for v in string.gmatch(content,'<div class="entry%-body">(.-)</div>') do
			h=v
		end
		news_dialog:setVisibility('none');
		showDetail(title,h)
		updateNews("Simon",title,h)
end
----end Simon--------------------------------------------------------

function closeDialog(dilogId)
	_G[dilogId]:setVisibility('hidden');
	--news_dialog:setVisibility('hidden');
end




function showWordList(words)
	word_list:removeAllViews()
	local row;
	for i=1,#words do
		if i % 5 == 1 then
			local rowId=ui:createView('<TR style="vertical-align:middle;border:solid 1px #cccccc 0px;"></TR>')
			row=_G[rowId]
			word_list:addView(rowId)
		end
		 local idLavel=ui:createView("<LABEL style='weight:1px;height:25px;'>".. words[i].spell .."</LABEL>")
		 row:addView(idLavel)
	end

end


function readLastStuiedWordList()
	local words={}
	local group=Global.currentStudiedGroup 

    Global.currentStudiedGroup =  Global.lastStudiedGroup 
	if Global.currentStudiedGroup ==0 then Global.currentStudiedGroup =1 end
	Study.init()
	local isOpened=Study.openBook()
    if (isOpened) then
		for i=1,20, 1 do
			words[i] = Study.nextWord();
		end
    end

	Global.currentStudiedGroup =group
	return words
end
Log:d("MainMenu","loaded Recite successfullly")
