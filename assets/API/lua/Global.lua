    Global = {}

	Global.storage=OLA.storage.."/BabyGo/"
	Log:d("Global","Global.storage="..Global.storage)

    Global.version=0;
	Global.run_mile=0;
	Global.walk_mile=0;

 function Global.getItemText(index)
	local text="";
	if index=="1" or index==1 then text="母乳" end 
	if index=="2" or index==2 then text="奶粉" end 
	if index=="3" or index==3 then text="水" end 
	if index=="4" or index==4 then text="药" end 
	if index=="5" or index==5 then text="大便" end 
	if index=="6" or index==6 then text="小便" end 
	if index=="7" or index==7 then text="体重" end 
	if index=="8" or index==8 then text="身高" end 
	return text
end   

    function Global.loadProperties() 
	local fin = fis:open(Global.storage.."Health.properties")
	Log:d("test Global","loadProperties")
         if fin:exists() then
                Global.run_mile=fin:readInt()
                Global.walk_mile=fin:readInt()
	      fin:close()
	    else
                Global.saveProperties();
        end
    end
    function Global.saveProperties() 
	local fout = fos:open(Global.storage.."Health.properties")
       fout:writeInt(Global.run_mile);
        fout:writeInt(Global.walk_mile);
        fout:close()
    end
Log:d("test Global","0")
    Global.loadProperties()
Log:d("test Global","Global.loadProperties executed")





Log:d("test Global","Global.currentBookFileName="..Global.currentBookFileName)