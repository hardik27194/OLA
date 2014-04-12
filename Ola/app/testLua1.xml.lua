
------ database class------------------------------------------------
--local db=require "lua/db.lua"

database = {}
function database.conn ()   
	Log:d('database','conn execute...')
	--api.dbConnection()
end   
function database.open(db_name)
	Log:d('database','open execute...')
	connection:open(db_name,false)
end

function database.exec(sql)
	Log:d('database','createTable execute...')
	connection:execSQL(sql)
end

function database.query(sql,...)
	Log:d('database','execute sql...')
	local data=connection:query(sql,'a,b')
	return loadstring('return {'..data..'}')()
end
function database.close()	
	connection:close()
	Log:d('database','db  was closed ...')
end
------ end database class------------------------------------------------

--[[
text="testlua ...";
for i = 0,10 do
    for k = 0,10-i do
        text = "AA" .. text
    end
end
]]

function initiate()
	Log:d('initiate','initiate execute...')
	txt1:setInputType(2,8192);

	Log:d('test','db test started...')
	database.conn()
	database.open("test")
	database.exec("CREATE TABLE IF NOT EXISTS test(id INT NOT NULL DEFAULT -1,name VARCHAR(32),UNIQUE(id))")
	--database.exec("insert into test values('1','test')")
	--database.exec("insert into test values('2','test')")

	stmt=database.query("select * from test where id=?1","1")
	Log:d("statement",stmt[1].id)

	for i,row in ipairs(stmt) do
	 for k,v in pairs(row) do
	   Log:d("value",k.."="..v)
	 end
	end

	database.close()
	Log:d('test','db test ended...')

end
function cutStr(javaStr) 
	print ('Lua test execute...')
	Log:d('cutStr','Lua test execute...')
	return "cutStr()"..javaStr
end



function addButton(context,layout)
	    btn = luajava.newInstance("android.widget.Button",context)
	    btn:setText("lua add button ")
	    

		button_cb = {
        	onClick = function(v)
				local Toast = luajava.bindClass('android.widget.Toast')
				Toast:makeText(context, v:getText(), Toast.LENGTH_SHORT):show()
        	end
		}
		local listener = luajava.createProxy("android.view.View$OnClickListener", button_cb);

		--[[ -- second mathod to add button
		local listener = luajava.createProxy("android.view.View$OnClickListener", {
			
	        	onClick = function(v)
	        	    print(tostring(v))
					local Toast = luajava.bindClass('android.widget.Toast')
					Toast:makeText(context, v:getText(), Toast.LENGTH_SHORT):show()
	        	end
    		
		})
		]]
	    btn:setOnClickListener(listener)
	    layout:addView(btn)


		btn1_onclick=function()
		    Log:v("click","btn1_onclick")
		    btn2:setBackgroundColor(-56636);
		    btn2:setText("Changed")
		end

	end
function reload()
	 Log:d("reload","Lua reload is executed..")
	 sys.reload()
	
end
function onpress()
	 Log:d("onpress","Lua onpress is executed.")
	 Log:d("onpress","Lua onpress is executed.")
	 btn1:setBackgroundColor("#66CC00")
end
function release()
Log:d("release","Lua release is executed.")
	 btn1:setBackgroundColor("#66CCDD")
end


function showPanel(id)
	 for i=1,3 do
		 _G["h"..i]:setBackgroundColor("#66CCCC")
		 _G["p"..i]:setBackgroundColor("#66CCCC")
	 end
	 _G["h"..id]:setBackgroundColor("#66CC00")
	 _G["p"..id]:setBackgroundColor("#FF0000")
	 --addUIWedgit()
end

function searchUser()

	database.conn()
	database.open("test")

	stmt=database.query("select * from test")
	Log:d("statement",stmt[1].id)

	for i,row in ipairs(stmt) do
	  local r=createTableRow(row)
	  user_table:addView(r)
	end
	database.close()
end
function createTableRow(row)
	 local id= row.id
	 local name=row.name
	 local r=_G[ui:createView('<TR style="vertical-align:middle"></TR>')]
	 local idLavel=ui:createView("<LABEL style='width:40px;height:25px;background-color:#999900;text-align:center;'>".. id .."</LABEL>")
	 r:addView(idLavel)

	 local nameLabel=ui:createView("<LABEL style='width:auto;height:25px;weight:1px;background-color:#9900CC;text-align:center;'>".. name .."</LABEL>")
	 r:addView(nameLabel)

	 local L3=ui:createView("<button style='width:auto;height:25px;weight:1px;background-color:#9999EE;text-align:center;' onclick='showPanel(1)'>D|M</button>")
	 r:addView(L3)

	return r
end

function addUIWedgit()
	 viewStr="<button id='dBtn1' style='top:5px;left:40px;width:150px;height:25px;align:center;background-color:#66CCCC;'>Dy Btn Test</button>"
	 view=ui:createView(viewStr)
	 Log:d("UI Test","id="..view)
	 Log:d("UI Test","panel tag="..userPanel:getRoot():getNodeName())
	 userPanel:addView("dBtn1")
	 --userPanel:addView(view) --equals to the above line
end

function switch()
	--fo FileOpener.new(self)
	ui:switchView("FileOpener.xml","callback","")
end
function callback(param)
	Log:d("CallBack",param)
end

--[[

	btn2.onclick=function()
	    Log:d("click","btn2:Buttontest is clicked,name="..)
	end

local MyLayer = class(
"IButton", function()    
	return CCLayer:create()
	end
)
-- override CCLayer::setVisible 
function MyLayer:setVisible(visible)    
	-- invoke CCLayer::setVisible    
	getmetatable(self).setVisible(self, visible)   
	-- to do something.
end
return MyLayer
]]

