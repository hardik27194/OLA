function initiate()
	Log:d('initiate','initiate execute...')
	Log:d('To UTF8 Char','........')
	Log:d('To UTF8 Char',str:toUTF6LE('230,00'))
	--addUIWedgit()
end

function addUIWedgit()
	 viewStr="<div layout='LinearLayout'  style='margin:3px;orientation:vertical;width:auto;align:center;background-color:#00EF00'><label>asd</label><label>asd2</label><button>btn</button></div>"
	 view=ui:createView(viewStr)
	 Log:d("UI Test","id="..view)
	 free_area:addView(view)
	 --userPanel:addView(view) --equals to the above line
end

function switch()
	Log:d("UI","switch to Study View ")
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
	Log:d("UI","switched to testLua.xml")
end
function reload()
	 Log:d("reload","MainMenu Lua reload is executed..")
	 sys.reload()
end

function showFirstStudyView()
	ui:switchView("StudyView.xml","callback('file opener returned param')","file opener params")
end
function showReviewInfo()
	ui:switchView("ReviewInfo.xml","callback('file opener returned param')","file opener params")
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


function create()
	Log:d("Player","start")
	soundPlayer=MediaPlayer:createPlayer(OLA.base..'yellow_submarine.mp3')
	Log:d("Player","URL="..OLA.base..'yellow_submarine.mp3')
	Log:d("Player","created")
	soundPlayer:play()
	Log:d("Player","playing")
end

function pause()
	soundPlayer:pause()
end
function stop()
	soundPlayer:stop()
end
Log:d("test Global","Global.volumeLevel=")
Log:d("test Global","Global.volumeLevel="..Global.volumeLevel)