
--public class PrepareStudyForm extends Form implements CommandListener

    function initiate()
            Study.initRSStudyinfo();
            if (Global.currentBookFileName=="") then
                --Util.showAlert(display, "Please select vocabulary book. \nOr buy a new one by mail to lohool@hotmail.com", AlertType.ALARM, displayable, 2000);
                --display.setCurrent(this.displayable);
            else
				if Global.lastStudiedGroup <= 0 then
					Global.lastStudiedGroup = 0 
				end
			
				Group_Amount:setText(Global.bookGroupAmount.."")
				Book_Name:setText(Global.currentBookName)
				Last_Group:setText(Global.lastStudiedGroup.."")
				Next_Group:setText((Global.lastStudiedGroup+1).."")
				Word_Amount:setText((Global.wordsCount).."")
				local d,h,m,s=convertTimeForm(Global.totalStudyTime)
				Total_Time:setText(d.."天"..h.."小时"..m.."分钟")
				d,h,m,s=convertTimeForm(Study.studyTime)
				Book_Total_Time:setText(d.."天"..h.."小时"..m.."分钟")
             end
  end

  	function reset()
			Last_Group:setText(Global.lastStudiedGroup.."")
			Study.init()
			Next_Group:setText((Global.lastStudiedGroup+1).."")
	end

	function reload()
		 sys.reload()
	end

function back()
	back2Portal()
	return 1;
end

function showFirstStudyView()
	ui:switchView("StudyView.xml","callback('file opener returned param')","file opener params")
end
function showReviewInfo()
	ui:switchView("ReviewInfo.xml","callback('file opener returned param')","file opener params")
end
function showReading()
	ui:switchView("Reading.xml","callback('file opener returned param')","file opener params")
end
function showSettingView()
	ui:switchView("SettingView.xml","callback('file opener returned param')","file opener params")
end
function myInfo()
	if Global.user==nil or Global.user_account=='' then
		ui:switchView("Login.xml")
	else
		ui:switchView("MyInfo.xml")
	end
end

function showBooks()
	ui:switchView("AllBookList.xml","callback('file opener returned param')","file opener params")
end

function back2Portal()
Log:d("Recite","exit...")
	LMProperties:printtype()
	LMProperties:exit()
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



















    --/**Handle command events*/
    function start()
            local group =tonumber( Next_Group:getText())
           if (group  < 0) or (group > Global.bookGroupAmount) then
               -- Util.showAlert(display, "Over words group scope", AlertType.ALARM, this, 2000);
                --return;
            end

			local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms")
		    -- file head
			 --if fc:exists()=='true' then
             if fc:exists() then
				 local groupTmp=fc:readShort()
				while groupTmp~=-1 do
				
						if (group == groupTmp) then
							--Util.showAlert(display, "The group has been studied", AlertType.ALARM, this, 2000);
							fc:close()
							error_mesg:setText("The group has been studied,please choose other groups.")
							return;
						end
						fc:readByte()
						fc:readLong()
						groupTmp=fc:readShort()
				end
			end

			fc:close();

            Global.currentStudiedGroup =  group 
			--start show Word View
            --PrepareStudyWordShower h = new PrepareStudyWordShower(display, this.displayable);
 		 ui:switchView("PrepareStudyView.xml","callback('file opener returned param')","file opener params")
      end



function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end


