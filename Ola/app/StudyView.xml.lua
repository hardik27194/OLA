
--public class PrepareStudyForm extends Form implements CommandListener

    function initiate()
			Log:d("Study View","initiate is executed..")
            initRSStudyinfo();
			Log:d("Study View","Global.currentBookFileName="..Global.currentBookFileName)
            if (Global.currentBookFileName=="") then
                --Util.showAlert(display, "Please select vocabulary book. \nOr buy a new one by mail to lohool@hotmail.com", AlertType.ALARM, displayable, 2000);
                --display.setCurrent(this.displayable);
            else
			Log:d("Study View","Global.currentBookFileName="..Global.currentBookFileName)
			if Global.lastStudiedGroup <= 0 then
				Global.lastStudiedGroup = 0 
			end
			Log:d("Study View","Global.lastStudiedGroup="..Global.lastStudiedGroup)
			Log:d("Study View","Global.bookGroupAmount="..Group_Amount:getText())
			
			Group_Amount:setText(Global.bookGroupAmount.."")
			Log:d("Study View","Global.bookGroupAmount="..Global.bookGroupAmount)
			Book_Name:setText(Global.currentBookName)
			Log:d("Study View","Global.currentBookName="..Global.currentBookName)
			Last_Group:setText(Global.lastStudiedGroup.."")
			Log:d("Study View","Global.lastStudiedGroup="..Global.lastStudiedGroup)
			Next_Group:setText((Global.lastStudiedGroup+1).."")
			Log:d("Study View","Global.lastStudiedGroup="..Global.lastStudiedGroup)
             end
  end
  	function reset()
			Last_Group:setText(Global.lastStudiedGroup.."")
			Study.init()
			Log:d("Study View","Global.lastStudiedGroup="..Global.lastStudiedGroup)
			Next_Group:setText((Global.lastStudiedGroup+1).."")
	end

	function reload()
		 Log:d("reload","Study View Lua reload is executed..")
		 sys.reload()
	end

	function back()
		ui:switchView("MainMenu.xml","callback('file opener returned param')","file opener params")
	end
    --/**Handle command events*/
    function start()
            local group =tonumber( Next_Group:getText())
 		 Log:d("Study View","start is ="..group)
 		 Log:d("Study View","Global.bookGroupAmount ="..Global.bookGroupAmount)
           if (group  < 0) or (group > Global.bookGroupAmount) then
               -- Util.showAlert(display, "Over words group scope", AlertType.ALARM, this, 2000);
                --return;
            end
		 Log:d("Study View","start is 1..")

			local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms")
		    -- file head
			 Log:d("Study View","start is 3..")
			 if fc:exists()=='true' then
				 local groupTmp=fc:readShort()
				 Log:d("Study View","groupTmp="..groupTmp)
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
			    Log:d("Study View","start is 2..")
			end

			fc:close();

            Global.currentStudiedGroup =  group 
			--start show Word View
            --PrepareStudyWordShower h = new PrepareStudyWordShower(display, this.displayable);
 		 ui:switchView("PrepareStudyView.xml","callback('file opener returned param')","file opener params")
      end

		 Log:d("Study View","start is executed..")


    function initRSStudyinfo()  
		local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_studyinfo.dbms")

        if fc:exists()=="true" then
            Global.lastStudiedGroup = fc:readShort();
            --//Global.setCurrentBookFileName(datainputstream.readUTF());
            --//Global.currentPronDirName = datainputstream.readUTF();
         else
			fc = fos:open(Global.storage..Global.currentBookFileName  .. "_studyinfo.dbms")

            fc:writeShort(0);
		 Log:d("Study View","initiated Global.wordsCount :"..Global.wordsCount)
			fc:writeLong(Global.wordsCount)
			for i=1, Global.wordsCount , 1  do
			   fc:writeByte(0)
			end
            --fc:writeStringWithLength(Global.currentBookFileName);
            --fc:writeStringWithLength(Global.currentPronDirName);
        end
        fc:close()
    end

		 Log:d("Study View","end..")

function testIO()
	local fin = fis:open("/sdcard/test/ITIES1228.dbx")
               local b= fin:readBytesTest(7000)();
			   Log:d("IO  test","b="..b)
	fin:close()
end
