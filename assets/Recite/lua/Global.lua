    Global = {}

	--Global.server="http://192.168.0.107:8080/ct/"
	Global.server="http://lohool.imwork.net/ct/"


	Global.storage=OLA.storage.."/Recite/"
	Log:d("Global","Global.storage="..Global.storage)
    Global.charPos=1;
	Global.newsDownloadTime=0
	--the books which are on downloading
	Global.bookOnDownloading={}

    function Global.getGroupSize()
    
        return Global.groupSize;
    end

    function Global.setGroupSize(aGroupSize)     
        Global.groupSize = aGroupSize;
    end

    --version of PocketWords
    Global.version=0;

    -- 0--support, 1--unsupport
    Global.languageSupport=0;

    --[[
     * 0-- not encrypt
     * 1-- 3 DES
     ]]
    Global.encryptMethod=0;


    --public static short lastStudiedGroup;
    Global.lastStudiedGroup=0;

     -- the current group be studied
    Global.currentStudiedGroup=0;

    -- the current times that the group be reviewed.
    Global.currentReviewTimes=0;

     -- the count of words in every group
    Global.groupSize = 20;

    --book's name
    Global.currentBookName = "Please select a book";
    --private static String currentBookFileName = "";--/words.db
    Global.currentBookFileName = "IELTS 1228 WORDS";
   -- public static String currentPronDirName = "";
    Global.currentPronDirName = "";
   -- public static int bookGroupAmount;
    Global.bookGroupAmount=0;

    -- the count of the vocabulary

    Global.wordsCount=0;

    --[[
     * Is reciting words or reviewing words now.
     * If the value is TRUE, it means is reciting now, FLASE is reviewing.
     * 1:studying
     * 2:newreview
     ]]
    Global.isStudy = false;

    -- auto play the ward's sound

    Global.autoPronounce = false;
    --[[
     * 0--supported, 1--not supported
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

	--Create time, the first time that the user start to use the app
	Global.startTime=os.time()
	Global.totalStudyTime=0

    function Global.loadProperties() 
	local fin = fis:open(Global.storage.."recite.properties")
         if fin:exists() then
                Global.groupSize=fin:readShort()
				a=fin:readBoolean()
                Global.showChinese = loadstring("return "..a)()
                Global.showEnglish = loadstring("return "..fin:readBoolean())()
                Global.showExample = loadstring("return "..fin:readBoolean())()
                Global.showExampleComment = loadstring("return "..fin:readBoolean())()
                Global.autoPronounce = loadstring("return "..fin:readBoolean())()
                Global.autoBrowseSecond = fin:readShort();
                Global.autoBrowse=loadstring("return "..fin:readBoolean())()
                Global.volumeLevel=fin:readShort();
                Global.currentBookName=fin:readStringWithLength();
                Global.currentBookFileName=fin:readStringWithLength();
                Global.currentPronDirName=fin:readStringWithLength();
                Global.reviewByChinese=loadstring("return "..fin:readBoolean())()
                Global.languageSupport=fin:readByte();
				Global.startTime=fin:readLong();
				Global.totalStudyTime=fin:readLong();
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
        fout:writeStringWithLength(Global.currentBookName);
        fout:writeStringWithLength(Global.currentBookFileName);
        fout:writeStringWithLength(Global.currentPronDirName);
        fout:writeBoolean(Global.reviewByChinese);
        fout:writeByte(Global.languageSupport);
		fout:writeLong(Global.startTime)										
		fout:writeLong(Global.totalStudyTime)										
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



    Global.loadProperties()



	local viewXml=''
	viewXml=viewXml..'<div id="lui_loading_view" layout="LinearLayout" style="orientation:vertical;height:auto;width:auto;background-color:#6699CC;alpha:0.8;">'
	viewXml=viewXml..'	 <div layout="LinearLayout" style="orientation:vertical;width:auto;height:auto;align:center;valign:middle;">'
	viewXml=viewXml..'			<ProgressBar style="style:rotate;progress-image:url($/images/loading.png);width:60px;height:60px;"></ProgressBar>'
	viewXml=viewXml..'			<label style="margin:10px;align:center;"  onclick="reload()">   Loading...</label>'
	viewXml=viewXml..'    </div>'
	viewXml=viewXml..'</div>'
	Global.loadingViewXml=viewXml
