		local fv=ListPanel:new()

    function initiate()
		local group,groups= readReviewInfo()
		if group >=1 then
			--groups_text:setText(groups)
			--Next_Group:setText(group..'')
		else
			groups_text:setText("No words need to be reviewed.")
		end
	end

  	function reset()
			initiate()
	end

	function back()
		ui:switchView("StudyView.xml","callback('file opener returned param')","file opener params")
		return 1
	end

	function readReviewInfo()
        local now = os.time();--ny seconds
        local groups="";
		local lastGroup=0;
		local a1={10,3600,86400,86400,172800,259200,604800}
		local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms") 
		local recordedDate=0;
		local group=0;
		local byte0=0;
		studied_groups_pan:removeAllViews()

		fv:create()

		while group>=0 do
		 group=fc:readShort()
		 if group<0 then do break end end
		 byte0=fc:readByte()
		 if byte0<=0 then byte0=1 end
		 recordedDate=fc:readLong () /1000
			if byte0<6 and now - recordedDate >= a1[byte0] then
				lastGroup=group
				local lastStudyTime=os.date("%Y-%m-%d %H:%M:%S", recordedDate)
				groups = groups .. group .. ':'..lastStudyTime..";"
				fv:addItem(group,"第["..group.."]组",lastStudyTime)
				--addReviewGroup(group,recordedDate)
            end
		end
		fc:close()
		fv:showOn("studied_groups_pan")
        return lastGroup,groups
    end

    function addReviewGroup(group,sec)

		local lastStudyTime=os.date("%Y-%m-%d %H:%M:%S", sec)
		local viewXml=""
		viewXml=viewXml.."<div layout='LinearLayout' style='width:auto;height:auto;'>"
		viewXml=viewXml.."<label style='width:40px;height:auto;'>"..group.."</label>"
		viewXml=viewXml.."<label style='width:auto;height:auto;weight:1px;background-color:#99CCFF'>"..lastStudyTime.."</label>"
		viewXml=viewXml.."</div>"
		local viewId=ui:createView(viewXml)
		studied_groups_pan:addView(viewId)
	end

	function start()
            --local group =tonumber( Next_Group:getText())
 		Log:d("testDialog","...." )
           local group =tonumber(fv:getSelected())
		Log:d("testDialog",""..group..":" )
            if (group  < 0) or (group > Global.bookGroupAmount) then
					error_mesg:setText("Invalid group ,please choose other groups.")
			else
				Global.currentStudiedGroup =  group 
				ui:switchView("Review.xml","callback('file opener returned param')","file opener params")
			end
    end


function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
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
