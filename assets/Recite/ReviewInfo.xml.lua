   	Log:d("Review Info","Start to Load ")

    function initiate()
		local group,groups= readReviewInfo()
		if group >=1 then
			groups_text:setText(groups)
			Next_Group:setText(group..'')
		else
			groups_text:setText("No words need to be reviewed.")
		end
	end

   --[[ --From Study.lua 
	function writeReviewInfo( group) 
		Log:d("Study","grour file ="..Global.storage..Global.currentBookFileName .. "_Groupinfo.dbms")
		local fc = fos:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms",'true') --append
		Log:d("Study","file is exists=")
        fc:writeShort(Global.currentStudiedGroup)
		Log:d("Study","writeShort is successful")
		fc:writeByte(0)
		Log:d("Study","writeByte is successful")
		fc:writeLong(os.time()*1000); --milliseconds
		Log:d("Study","writeLong is successful")
		fc:close();
		return 0
	end
]]
  	function reset()
			initiate()
	end

	function back()
		ui:switchView("MainMenu.xml","callback('file opener returned param')","file opener params")
	end
	function reload()
		 Log:d("reload","Review Info Lua reload is executed..")
		 sys.reload()
	end

	function readReviewInfo()
        local now = os.time();--ny seconds
        local groups="";
		local lastGroup=0;
		local a1={86400,86400,172800,259200,604800}
		local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms") 
		local recordedDate=0;
		local group=0;
		local byte0=0;
		while group>=0 do
		 group=fc:readShort()
		 if group<0 then do break end end
		 byte0=fc:readByte()
		 if byte0<=0 then byte0=1 end
		 recordedDate=fc:readLong () /1000
			if byte0<6 and now - recordedDate >= a1[byte0] then
				lastGroup=group
				groups = groups .. group .. ','
            end
		end
		fc:close()
        return lastGroup,groups
    end
    

	    function start()
            local group =tonumber( Next_Group:getText())
            if (group  < 0) or (group > Global.bookGroupAmount) then
					error_mesg:setText("Invalid group ,please choose other groups.")
			else
				Global.currentStudiedGroup =  group 
				ui:switchView("Review.xml","callback('file opener returned param')","file opener params")
			end
      end

function testDialog()
		local view;
		local viewStr="<div id='dialog' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:center;alpha:0.8;background-color:#cccccc'><div id='dialog' layout='LinearLayout'  style='margin:20px;padding:10px;orientation:vertical;width:auto;align:center;alpha:1;background-color:#FFFFFF'><label style='background-image:url(images/10.gif);'>asd</label><label>asd</label><textfield  id=\"Next_Group\" style=\"width:auto;text-align:left;valign:middle\">0</textfield><button onclick='reload()' style='padding:3px;background-image:url(images/10.gif);'>Reload</button><button onclick='close()' style='background-color:#0000ff;background-image:url(images/blue_velvet_029.png)'>Close</button></div></div>"
		 view=ui:createView(viewStr)
		--local alert = Alert:create()
		--alert:show()
		--alert:setContentView(view)
		Log:d("testDialog","view created")
		body:addView(view)
		Log:d("testDialog","view added")
end

function close()
Log:d("Review Info","close start")
	dialog:setVisibility('block');
	Log:d("Review Info","close end")
end
	Log:d("Review Info","Loaded successful")