require "lua_ui"

function initiate()
	Log:d('initiate','initiate execute...')
    
	Log:d('initiate',type(OLA.apps))
    Log:d('initiate',type(OLA.apps.sys))
    Log:d('initiate',type(OLA.apps.user_apps))
	local apps=OLA.apps.user_apps
	Log:d('initiate','len='..#apps )
	Log:d('initiate','ui type='..type(ui) )
	local barStr='<div layout="LinearLayout"  style="orientation:horizontal;align:left;width:auto;"></div>'
	local bar=""
	local i=1
	local installedApps={}
	local otherApps={}
	local m=1
	local n=1
	for i=1, #apps do
		if apps[i].state==1 then
			Log:d('apps','installed='..apps[i].app )
			installedApps[m]=apps[i]
			m=m+1
		elseif apps[i].state==0 then
			Log:d('apps','otherApps='..apps[i].app )
			otherApps[n]=apps[i]
			n=n+1
		end
	end
	for i=1, #installedApps do
		if i % 4 == 1 then
			bar=lui.createView(barStr)
			Log:d('initiate','bar='..bar )
			Apps_Panel:addView(bar)
		end 
		--for key, value in pairs(installedApps[i]) do  
		--	Log:d('OLA.apps','key='..key..'; value='..value)  
		--end

			viewStr='<div layout="LinearLayout"  style="orientation:vertical;weight:1px;margin:3px;padding:2px;align:center;"></div>'
			local appPanel=lui.createView(viewStr)
			_G[bar]:addView(appPanel)
			viewStr='<button style="width:56px;height:56px;background-image:url('..apps[i].ico..');valign:middle;" onclick=\'startApplication("'..installedApps[i].app..'")\'></button>'
			local btn=lui.createView(viewStr)
			_G[appPanel]:addView(btn)
			viewStr='<label style="width:auto;align:center;" onclick=\'startApplication("'..installedApps[i].app..'")\'>'..installedApps[i].title..'</label>'
			local appTitle=lui.createView(viewStr)
			_G[appPanel]:addView(appTitle)

	end
	local barCount=#installedApps%4
	Log:d('json',"barCount="..barCount)
	if barCount==0 then barCount=4 end
	barCount=4-barCount
	for j=1,barCount do
			viewStr='<div layout="LinearLayout"  style="orientation:vertical;weight:1px;margin:3px;padding:2px;align:center;"></div>'
			local appPanel=lui.createView(viewStr)
			_G[bar]:addView(appPanel)
			viewStr='<div layout="LinearLayout"  style="orientation:vertical;width:48px;height:48px;valign:middle;"></div>'
			local btn=lui.createView(viewStr)
			_G[appPanel]:addView(btn)
	end

	for i=1, #otherApps do
		if i % 4 == 1 then
			bar=lui.createView(barStr)
			Log:d('initiate','other bar='..bar )
			Apps_Other_Panel:addView(bar)
		end 

			viewStr='<div layout="LinearLayout"  style="orientation:vertical;weight:1px;margin:3px;padding:2px;align:center;"></div>'
			local appPanel=lui.createView(viewStr)
			_G[bar]:addView(appPanel)
			viewStr='<button style="width:48px;height:48px;background-image:url('..apps[i].ico..');valign:middle;" onclick=\'displayInstallMenu("'..otherApps[i].app..'")\'></button>'
			local btn=lui.createView(viewStr)
			_G[appPanel]:addView(btn)
			viewStr='<label style="width:auto;align:center;">'..otherApps[i].title..'</label>'
			local appTitle=lui.createView(viewStr)
			_G[appPanel]:addView(appTitle)

	end
	local barCount=#otherApps%4
	Log:d('json',"barCount="..barCount)
	if barCount==0 then barCount=4 end
	barCount=4-barCount
	for j=1,barCount do
			viewStr='<div layout="LinearLayout"  style="orientation:vertical;weight:1px;margin:3px;padding:2px;align:center;"></div>'
			local appPanel=lui.createView(viewStr)
			_G[bar]:addView(appPanel)
			viewStr='<div layout="LinearLayout"  style="orientation:vertical;width:48px;height:48px;valign:middle;" />'
			local btn=lui.createView(viewStr)
			_G[appPanel]:addView(btn)
	end

	--downloadSimon()
	 Log:d("VideoPlayer","start")

	--clean vew cache pipe
	lui.cleanViewCache()

--lfs has been added as a inner lib, do not use: require "lfs", it is error and cannot be executed
local path="/data/data/com.lohool.ola/apps/lua/"
             local attr1 = lfs.attributes (path)
   for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file
			Log:d("lfs file",f)
            local attr = lfs.attributes (f)
            --assert (type(attr) == "table")
            if attr.mode == "directory" then
				Log:d("lfs dir",f)
			end
		end
	end

end
function initiate1()
    addUIWedgit()
end

function back()
	return 0;
end

function addUIWedgit()
	 Log:d("UI Test","addUIWedgit")
	 local viewStr="<div id='dy_div' layout='LinearLayout'  style='orientation:vertical;width:80px;height:auto;align:center;background-color:#00EF00'><label onclick='addBtn1()'>asd</label><label onclick='addBtn()'>Add Btn</label></div>"
	 local view=lui.createView(viewStr)
	 Log:d("UI Test","id="..view)
     
     local btn=lui.createView("<button>btn</button>")
     Apps_Panel:addView(view)
     --_G[view]:addView(btn)
    --dy_div:addView(btn)

	 Log:d("UI Test","view was added")

end


function addBtn()
    local btn=lui.createView("<button>btn</button>")
    dy_div:addView(btn)
end
function addBtn1()
    local btn=lui.createView("<button>btn1</button>")
    dy_div2:addView(btn)
end


function startApplication(appName)
	--show loginf progress
	--load_wait_panel:setVisibility('display')

	--local rootViewId=ui:getRootViewId()
	--local view=lui.createLoadingView()
	--body:addView(view)


	lui.showLoadingView()
	LMProperties:startApp(appName)
	--load_wait_panel:setVisibility('hidden')
end
function displayInstallMenu(appName)
		local menuStr="<div id='otherAppsMenu' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:center;alpha:0.8;background-color:#cccccc'><label style='background-color:#ffffff'>The new app will provides new Enterprise services for employees.\nDownload and install the app, you will enjoy it.</label><button style='width:auto;align:center;'>Download</button><button  style='width:auto;align:center;' onclick='closeMenu()'>Cancel</button></div>"
	local view=lui.createView(menuStr)
	body:addView(view)
end
function closeMenu ()
	otherAppsMenu:setVisibility('block');
end

function reload()
	 Log:d("reload","MainMenu Lua reload is executed..")
	 sys.reload()
end

function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end
function layerOnRelease1(id)
	_G[id]:setBackgroundColor("#FFFFFF")
end

function showNews(id)
	local titles={"Affect and effect","Compliment and complement","Farther and further"}
	local contents={
	"Verbs first. Affect means to influence; \"Impatient investors affected our roll-out date.\" Effect means to accomplish something; \"The board effected a sweeping policy change.\" How you use effect or affect can be tricky. For example, a board can affect changes by influencing them, or can effect changes by implementing them. Use effect if you're making it happen, and affect if you're having an impact on something someone else is trying to make happen.\n\nAs for nouns, effect is almost always correct; \"Once he was fired he was given 20 minutes to gather his personal effects.\" Affect refers to emotional states so unless you're a psychologist, you're probably not using it.",
	"Compliment is to say something nice. Complement is to add to, enhance, improve, complete or bring close to perfection. So, I can compliment your staff and their service, but if you have no current openings, you have a full complement of staff. And your new app may complement your website.\n\nFor which I may decide to compliment you.",
	"Farther involves a physical distance; \"Florida is farther from New York than Tennessee.\" Further involves a figurative distance; \"We can take our business plan no further.\" So, as we say in the South, \"I don't trust you any farther than I can throw you.\" Or, \"I ain't gonna trust you no further.\"(Seriously. I've uttered both of those sentences. More than once.)"
	}
	showDialog(titles[id],contents[id])
end
function showDialog(title,content)
	local view;
	local viewStr="<div id='dialog' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:center;alpha:0.8;background-color:#cccccc'><div  layout='LinearLayout'  style='margin:20px;padding:10px;orientation:vertical;width:auto;align:center;alpha:1;background-color:#FFFFFF'><label style='width:auto;background-image:url(images/10.gif);'>"..title.."</label><label>"..content.."</label><button onclick='closeDialog(\"dialog\")'>Close dffghgfhfghfg</button></div></div>"
	view=lui.createView(viewStr)
	body:addView(view)
end

function downloadSimon()
		local http=HTTP:create('http://ielts-simon.com/')
		http:setComplitedCallback("analysisSimon")
		http:sendRequest()

end
--<h3 class="entry-header"><a href="http://ielts-simon.com/ielts-help-and-english-pr/2016/08/ielts-listening-similar-words.html">IELTS Listening: similar words</a></h3>
--<h2 class="date-header">(.*)</h2>[\S\s]*?[^((?!<h3).)*]<h3 class="entry-header"><a .*>(.*)</a></h3>[\S\s]*?[^((?!<h3).)*]<div class="entry-body">[\S\s]*?[^((?!</div>).)*]</div>
local news={}

function analysisSimon(response)
	--local content=response:getContent()
	--Log:d("Key", content)

	--for v in string.gmatch(content,'<h3 class="entry-header"><a .*>(.*)</a></h3>') do
	--for v in string.gmatch(content,'<h2 class=".*">(.*)</h2>') do
	--response:match("cont",'<h3 class="entry-header"><a href="(.*)">(.*)</a></h3>')
	--Log:d('HTTP',type(cont))

	local pos=1;
	for u,t in string.gmatch(response:getContent(),'<h3 class="entry%-header"><a href="([^<]-)">(.-)</a></h3>') do

		--Log:d('HTTP',u)
		news[pos]={href=u,title=t}
		pos=pos+1
	end


	New_1:setText(news[1].title);
	New_2:setText(news[2].title);
	New_3:setText(news[3].title);

	--[[
	local account=1
	for k,v in ipairs(cont) do
		if(account>=3)break
		local s=""
		--v[1]is the whole macted string 
		--for k1,v1 in ipairs(v) do
			local href=v[2]
			local title=v[3]
			Log:d("Key", href)
			Log:d("Key", title)
		--end
		account=account+1
		
	end
	]]--

	cont=nil
end
function showSimonDetail(id)
	downloadSimonDetail(news[id].href,news[id].title)
end
function downloadSimonDetail(href,title)
		local http=HTTP:create(href)
		http:sendRequest()
		http:receive()
		--local res=http:getResponse()
		--http:match("data",'<h2 class="date-header">(.*)</h2>')
		--local date=data[1][2]
		--Log:d("date",date)

		--http:match("data2",'<div class=\"entry-body\">([\\W\\w\\S\\s]*?[^((?!</div>).)*])</div>')
		--local content=data2

		--data=nil
		--[[
		Log:d("News Dialog",type(content))
		Log:d("News Dialog","size="..#data2)
		for k,v in ipairs(content) do
		Log:d("News Dialog",k)
		end

		Log:d("News Dialog",content[1])
]]--
		news_title:setText(title);
		--news_content:setText(content);
		local h;
		for v in string.gmatch(http:getContent(),'<div class="entry%-body">(.-)</div>') do
			h=v
		end
		local c=http:getContent()


		news_content:getView():loadData(h, "text/html", "UTF-8");  

		news_dialog:setVisibility('none');
end
function closeDialog(dilogId)
	_G[dilogId]:setVisibility('hidden');
	--news_dialog:setVisibility('hidden');
end

function videoPlay()
	local player=VideoPlayer:create("file:///storage/sdcard1/DCIM/Video/V60211-142540.mp4")
	--local player=VideoPlayer:create("http://192.168.0.104:8080/ct/a.flv")
	player:play()

end
function mapTest()
	local view;
	local viewStr="<div id='map_dialog' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:center;alpha:0.8;background-color:#cccccc'><div  layout='LinearLayout'  style='margin:20px;padding:10px;orientation:vertical;width:auto;align:center;alpha:1;background-color:#FFFFFF'><label style='width:auto;background-image:url(images/10.gif);'>Bai Du Map Test</label><map style='margin:20px;padding:10px;width:auto;height:400px;'/><button onclick='closeDialog(\"map_dialog\")'>Close</button></div></div>"
	view=lui.createView(viewStr)
	body:addView(view)

end

function alipay()
	local pay=AliPay:create()
	pay:pay()
end

