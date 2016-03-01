    Global = {}

	Global.storage=OLA.storage
Log:d("Global","Global.storage="..Global.storage)
    Global.charPos=1;
    function Global.getGroupSize()
    
        return Global.groupSize;
    end

    function Global.setGroupSize(aGroupSize)     
        Global.groupSize = aGroupSize;
    end

    --[[
     * version of PocketWords
     public static double version;
     ]]
    Global.version=0;

    --[[
     * 0--support, 1--unsupport
     public static byte languageSupport=0;
     ]]
    Global.languageSupport=0;

    --[[
     * 0-- not encrypt
     * 1-- 3 DES
     public static byte encryptMethod=0;
     ]]
    Global.encryptMethod=0;


    --public static short lastStudiedGroup;
    Global.lastStudiedGroup=0;

    --[[
     * the current group be studied
     public static short currentStudiedGroup;
     ]]
    Global.currentStudiedGroup=0;
    --[[
     * the current times that the group be reviewed.
     public static short currentReviewTimes;
     ]]
    Global.currentReviewTimes=0;
    --[[
     * the count of words in every group
     private static short groupSize = 5;
     ]]
    Global.groupSize = 20;
    --[[
     *book's name
     ]]
    --public static String currentBookName = "";
    Global.currentBookName = "ITIES1228";
    --private static String currentBookFileName = "";--/words.db
    Global.currentBookFileName = "ITIES1228";
   -- public static String currentPronDirName = "";
    Global.currentPronDirName = "";
   -- public static int bookGroupAmount;
    Global.bookGroupAmount=0;
    --[[
     * the count of the vocabulary
     public static int wordsCount;
     ]]
    Global.wordsCount=0;
    --[[
     * Is reciting words or reviewing words now.
     * If the value is TRUE, it means is reciting now, FLASE is reviewing.
     * 1:studying
     * 2:newreview
     public static boolean isStudy = false;
     ]]
    Global.isStudy = false;
    --[[
     * auto play the ward's sound
     Global.autoPronounce = false;
     ]]
    Global.autoPronounce = false;
    --[[
     * 0--supported, 1--not supported
      public static int isFileSystemSupported = 0;
     ]]
    Global.isFileSystemSupported = 0;
    
   -- public static boolean showChinese=true;
    Global.showChinese=true;
    --public static boolean showEnglish=true;
    Global.showEnglish=true;
    --public static boolean showExample=true;
    Global.showExample=true;
    --public static boolean showExampleComment=true;
    Global.showExampleComment=true;
    --sound player's volume level
    --public static short volumeLevel=7;
    Global.volumeLevel=7;
    --public static final short maxVolumeLevel=10;
    Global.maxVolumeLevel=10;
    
    --public static boolean autoBrowse=false;//not persistent to db
    Global.autoBrowse=false;  --not persistent to db
    --[[
     * the second of the auto browsing interval
     * if the variable's value is big than 0, it will auto browse the next word after the gived second
      public static short autoBrowseSecond=0;
     ]]
    Global.autoBrowseSecond=0;
    
   -- public static boolean reviewByChinese=false;
    Global.reviewByChinese=false;

    function Global.loadProperties() 
	local fin = fis:open(Global.storage.."recite.properties")
	Log:d("test Global","loadProperties")
         if fin:exists() then
                Global.groupSize=fin:readShort()
				a=fin:readBoolean()
				Log:d("test Global","showChinese="..a)
                Global.showChinese = loadstring("return "..a)()
                Global.showEnglish = loadstring("return "..fin:readBoolean())()
                Global.showExample = loadstring("return "..fin:readBoolean())()
                Global.showExampleComment = loadstring("return "..fin:readBoolean())()
                Global.autoPronounce = loadstring("return "..fin:readBoolean())()
                Global.autoBrowseSecond = fin:readShort();
                Global.autoBrowse=loadstring("return "..fin:readBoolean())()
                Global.volumeLevel=fin:readShort();
				if Global.autoPronounce then
					Log:d("test Global","Global.autoPronounce=True")
				else
					Log:d("test Global","Global.autoPronounce=False")
				end
				Log:d("test Global","Global.currentBookFileName="..Global.currentBookFileName)
                Global.currentBookFileName=fin:readStringWithLength();
				Log:d("test Global","Global.currentBookFileName="..Global.currentBookFileName)
                Global.currentPronDirName=fin:readStringWithLength();
                Global.reviewByChinese=loadstring("return "..fin:readBoolean())()
                Global.languageSupport=fin:readByte();
	      fin:close()
	    else
                Global.saveProperties();
        end
    end
    function Global.saveProperties() 
	local fout = fos:open(Global.storage.."recite.properties")
       fout:writeShort(Global.getGroupSize());
        fout:writeBoolean(Global.showChinese);
        fout:writeBoolean(Global.showEnglish);
        fout:writeBoolean(Global.showExample);
        fout:writeBoolean(Global.showExampleComment);
        fout:writeBoolean(Global.autoPronounce);
        fout:writeShort(Global.autoBrowseSecond);
        fout:writeBoolean(Global.autoBrowse);
        fout:writeShort(Global.volumeLevel);
        fout:writeStringWithLength(Global.currentBookFileName);
        fout:writeStringWithLength(Global.currentPronDirName);
        fout:writeBoolean(Global.reviewByChinese);
        fout:writeByte(Global.languageSupport);
        fout:close()
    end
    --[[

    function Global.resetProperties() 
        Global.saveProperties();
    end

    function Global.getCurrentBookFileName()
        return Global.currentBookFileName;
    end

    function Global.setCurrentBookFileName( aCurrentBookFileName)
        Global.currentBookFileName = aCurrentBookFileName;
    end
    ]]
    --[[

    function Global.String[] getPlatInfo()
        String[] info =new String[]{" "," "," "};
        String infos= System.getProperty("microedition.platform");
        int pos = infos.indexOf('/');
        if(pos>=0)info[0]=infos.substring(0,pos);
        infos=infos.substring(pos+1);
        pos = infos.indexOf('/');
        if(pos>=0)info[1]=infos.substring(0,pos);
        info[2]=getIMEI();
        return info;
    end
    public static String getIMEI()
    {

        String imei=null;

        String[] brands=new String[]{
         "com.siemens.IMEI",
         "com.samsung.imei",
         "com.sonyericsson.imei",
         "com.motorola.IMEI",
         "IMEI",
         "imei",
         "com.nokia.mid.imei",
         "phone.imei",
         "phone.IMEI",
         "com.nokia.IMEI",
         "com.ktouch.imei",
         "com.k-touch.imei"
        };

        for(int i=0;i<brands.length;i++)
        {
            imei=System.getProperty(brands[i]);
            if(imei!=null)break;
        }
        return imei==null?" ":imei;
    }
    ]]
Log:d("test Global","0")
    Global.loadProperties()
Log:d("test Global","Global.loadProperties executed")

Log:d("test Global","Global.currentBookFileName="..Global.currentBookFileName)