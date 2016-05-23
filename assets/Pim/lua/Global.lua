    Global = {}


	Global.storage=OLA.storage.."/Pim/"
	Global.server="http://192.168.0.103:8080/oa/"

    Global.version=0;
	Global.run_mile=0;
	Global.walk_mile=0;
	
	Global.userId=0;
	Global.username="";
	Global.cookies="";

    function Global.loadProperties() 
		local fin = fis:open(Global.storage.."Pim.properties")
         if fin:exists() then
                Global.run_mile=fin:readInt()
                Global.walk_mile=fin:readInt()
	      fin:close()
	    else
                Global.saveProperties();
        end
    end
    function Global.saveProperties() 
		local fout = fos:open(Global.storage.."Pim.properties")
       fout:writeInt(Global.run_mile);
        fout:writeInt(Global.walk_mile);
        fout:close()
    end
    Global.loadProperties()
