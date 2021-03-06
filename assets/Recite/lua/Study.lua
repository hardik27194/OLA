	Study = {}


    Study.pos=0;
    --private static byte[] wordStatus;
    Study.wordStatus={}
    --Vector words= new Vector();
    Study.words=  {} --List:new(self)
    Study.currentGroup=0;
	Study.studyTime=0;	-- current book studied time
	Study.fin=nil;
	
    function Study.init()
		Study.pos=0;
        --Study.pos = 1;
		--Study.wordStatus={}
		Study.words=  {} --List:new(self)
		--Study.currentGroup=0;
    end

    function Study.getPos()
        return Study.pos;
    end

    function Study.close()
			Study.writeWordState(Study.wordStatus);
			Global.saveProperties() 
            if (Study.fin~= nil) then
               Study.fin:close();
			   Study.fin= nil;
			end
    end

    function Study.deleteCurrentWord()
            Study.setCurrentWordState( 1);
            Study.writeWordState(Study.wordStatus);
    end
    function Study.getCurrentWordState()
        return Study. wordStatus[(Study.currentGroup - 1) * Global.groupSize + Study.pos - 1 +1];
    end
    function Study.setCurrentWordState(state)
        Study.wordStatus[(Study.currentGroup - 1) * Global.getGroupSize() + Study.pos - 1 +1] = state;
    end

    function Study.openBook()
            --if  Global.isFileSystemSupported == 0 then
			--local dataInputStream = fis:open(Global.currentBookFileName())
			Log:d("Study","book is :".. Global.storage..Global.currentBookFileName..".db")
			Study.fin = fis:open(Global.storage..Global.currentBookFileName..".db")
            --end
			--Log:d("Study","book is existed:".. Study.fin :exists())

            if (not Study.fin :exists()) then
                return false;
			end
			Log:d("Study","readiing Study wordStatus ")
            Study.wordStatus = Study.readWordsState();
			Log:d("Study","Study.wordStatus ="..#Study.wordStatus )
			if Global.currentStudiedGroup==0 then
				Global.currentStudiedGroup=Global.lastStudiedGroup
			end
            Study.seekGroup(Global.currentStudiedGroup);
			Log:d("Study","seekGroup="..Global.currentStudiedGroup)
			Log:d("Study","Study.openBook is successful")
        return true;
    end

	 function Study.readTxt(   len)
		 local bs= Study.fin:readBytes(len)
		 return str:toUTF6LE(bs)
	 end
    function Study.readTxt_old(   len)
			Log:d("Study","Study.readTxt length="..len)
        if len < 2
        then
            return "";
        end
       local buf = "";
        local i = 0;
        if Study.fin  ~= nil
        then
 				--[[
               local k1=Study.fin:readByte();
                local l1=Study.fin:readByte();
                while  k1~= -1 and l1 ~= -1 do
                   buf=buf .. str:UTF6LE(l1,k1)  
                    i = i+2;
                   if (i >= len)
                    then
                        do break end;
                    end
					k1=Study.fin:readByte();
                    l1=Study.fin:readByte();
                end
				]]
				local k1,l1;
                while  i < len do
 					k1=Study.fin:readByte();
                    l1=Study.fin:readByte();
					if k1== -1 and l1 == -1 then do break end end
                    buf=buf .. str:UTF6LE(l1,k1)  
                    i = i+2;
                end
        end
        return buf;
    end

    --public Word Study.nextWord() throws  Exception
    function  Study.nextWord() 
       local  word =nil;
        if  Study.getPos() >= Global.groupSize  then
			--Log:d("Study","Study.getPos() >= Global.groupSize")
            if Global.isStudy  then
               writeReviewInfo(Global.currentStudiedGroup);
               writeStudyInfo(Global.currentStudiedGroup);
			   Global.saveProperties()
			else
			   setReviewInfo(Global.currentStudiedGroup)
			   Global.saveProperties()
           end
           Global.lastStudiedGroup = Global.currentStudiedGroup;
            return nil;
        end

        if Study.pos+1<= #Study.words then
             Study.pos=Study.pos+1;
           word=Study.words[Study.pos]
        else
        
           word=Word.new(self);
 		Log:d("Study","pos="..((Global.currentStudiedGroup - 1) * Global.groupSize) + Study.pos +1)
           local wordPos = WordIndex.getPos(((Global.currentStudiedGroup - 1) * Global.groupSize) + Study.pos +1);
			Study.pos=Study.pos+1
             word.state=wordPos[1];
			    --local b= loadstring('return {'..Study.fin:readBytes(wordPos[2])..'}')()
			    --local b= Study.fin:readBytes(wordPos[2])
			    local b= Study.fin:readString(wordPos[2])
                local spell="";
				--Log:d("Study","b="..b)
				----Log:d("Study","spell="..des3:decypt(b,"lohool@hotmail.com"," "," "))
                local desPwd={};
				--Log:d("Study","Global.encryptMethod ="..Global.encryptMethod )

                if Global.encryptMethod == 0 then
                   -- spell =des3:decypt(b,"lohool@hotmail.com"," "," ");
				   spell=b
                elseif Global.encryptMethod == 1 then
                    --desPwd = new String[]{"lohool@hotmail.com"," "," "};
                    --spell=des3:decypt(b,"lohool@hotmail.com"," "," ")
					spell=b
                elseif Global.encryptMethod == 2 then
                    --desPwd = new String[]{"lohool@hotmail.com"," ",Global.getIMEI()};
                    --spell=DES3Encrypt.decypt(b, desPwd);
					spell=b
                else
                    --throw new Exception("Un recognised words file.\nPlease update the application try to resolve the problem.");
                end

                word.spell=spell;
                
				--Log:d("Study","word.spell="..word.spell )
			    local pron=Study.fin:readString(wordPos[3])
				--Log:d("Study","word.pronunacation="..pron)
                word.pronunacation="["..parseProncation(pron).."]";
				--Log:d("Study","word.pronunacation="..word.pronunacation)
                word.description=(Study.readTxt( wordPos[4]));
				--Log:d("Study","word.description="..word.description)
                word.enMeans=(Study.readTxt( wordPos[5]));
				--Log:d("Study","word.senMeans="..word.enMeans)
                word.example=(Study.readTxt( wordPos[6]));
				--Log:d("Study","word.example="..word.example)
				--Log:d("Study","Study.words length="..#Study.words)
				Study.words[#Study.words+1]=word;
 				--Log:d("Study","Study.words length="..#Study.words)
       end
				--Log:d("Study","Study.currentWordState ="..Study.getCurrentWordState() )
        if Study.getCurrentWordState() == 1 then
            word = Study.nextWord();
        end
				--Log:d("Study","Study.nextWord is end" )
        return word;
    end
function Study.preWord()
    if Study.pos>=2 then
        Study.pos=Study.pos-1
    end
    return Study.words[Study.pos];
end
function Study.seekGroup( group) 
        local gPos = WordIndex.getGroupPos(group);
        Study.fin:skipBytes(gPos);
        Study.currentGroup = group;
        Study.words={}
end

function writeReviewInfo( group) 
		Log:d("Study","grour file ="..Global.storage..Global.currentBookFileName .. "_Groupinfo.dbms")
		local fc = fos:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms",'true') --append
        fc:writeShort(Global.currentStudiedGroup)
		fc:writeByte(0)
		fc:writeLong(os.time()*1000); --milliseconds
		fc:close();
		return 0
end


    function setReviewInfo( reviedGroup)

		Log:d("setReviewInfo","reviedGroup="..reviedGroup)
		local fc = fos:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms") 
		local recordedDate=0;
		local group=0;
		local byte0=0;
		local filePointer=0;
		while group>=0 do
			 group=fc:readShort()
			 if group<0 then do break end end
			 byte0=fc:readByte()
			 if byte0<=0 then byte0=1 end
			 recordedDate=fc:readLong () /1000
				if group == reviedGroup then
					local pointer=fc:getFilePointer()
					fc:seek(pointer-9)
					fc:writeByte(byte0+1)
					fc:writeLong(os.time()*1000)
					do break end
				end
		end
		fc:close()

  
end    

function writeStudyInfo( group) 
		local fc = fos:open(Global.storage..Global.currentBookFileName  .. "_studyinfo.dbms")
        fc:writeShort(group)
		fc:writeLong(Global.wordsCount)
		fc:writeLong(Study.studyTime)
		fc:close()
end

function Study.writeWordState(states)
		Log:d("Study","_studyinfo file ="..Global.storage..Global.currentBookFileName .. "_studyinfo.dbms")
        local fc = fos:open(Global.storage..Global.currentBookFileName .. "_studyinfo.dbms")
		fc:writeShort(Global.lastStudiedGroup);
		fc:writeLong(Global.wordsCount)
		fc:writeLong(Study.studyTime)
        --fos.write(states, 0, states.length);
		for i = 1, #states, 1 do
             fc:writeByte(states[i])
        end
        fc:close();
end

function Study.readWordsState()
	local bs = {}
	local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_studyinfo.dbms")
	Log:d("Study","_studyinfo is opened:"..Global.storage..Global.currentBookFileName  .. "_studyinfo.dbms")
	Global.lastStudiedGroup=	fc:readShort()
	local wordcount = fc:readLong() --- duplicated with WordIndex
	Study.studyTime= fc:readLong()

           --for i = 1, fc:available(), 1 do
            --    bs[i] = f:readByte();
            --end
	bs=loadstring('return {'..fc:readBytes(Global.wordsCount)..'}')()
	fc:close();
    return bs;
end


    function Study.initRSStudyinfo()  
		local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_studyinfo.dbms")

        if fc:exists()then
            Global.lastStudiedGroup = fc:readShort();
			local wordCount=fc:readLong()
			Study.studyTime= fc:readLong()
         else
			fc = fos:open(Global.storage..Global.currentBookFileName  .. "_studyinfo.dbms")

            fc:writeShort(0);
			fc:writeLong(Global.wordsCount)
			fc:writeLong(0)
			for i=1, Global.wordsCount , 1  do
			   fc:writeByte(0)
			end
            --fc:writeStringWithLength(Global.currentBookFileName);
            --fc:writeStringWithLength(Global.currentPronDirName);
        end
        fc:close()
    end


function parseProncation(pron)
	local p="";
	local tmp;
	for c in pron:gmatch"." do
		if c>='a' and c<='z' then
			p=p..c
		elseif c>='A' and c<='Z' then
			tmp=c
		elseif c>='0' and c<='2' then
			tmp=tmp..c
			if tmp=='A1' then p=p..str:toUTF6LE("230,00") end
			if tmp=='B1' then p=p..str:toUTF6LE("81,02") end
			if tmp=='C1' then p=p..str:toUTF6LE("84,02") end
			if tmp=='E1' then p=p..str:toUTF6LE("89,02") end
			if tmp=='F1' then p=p..str:toUTF6LE("131,02") end
			if tmp=='N1' then p=p..str:toUTF6LE("75,01") end
			if tmp=='O1' then p=p..str:toUTF6LE("84,02") end
			if tmp=='Q1' then p=p..str:toUTF6LE("140,02") end
			if tmp=='T1' then p=p..str:toUTF6LE("240,00") end
			if tmp=='U1' then p=p..str:toUTF6LE("138,02") end
			if tmp=='W1' then p=p..str:toUTF6LE("184,03") end
			if tmp=='Z1' then p=p..str:toUTF6LE("91,02") end
			if tmp=='V1' then p=p..str:toUTF6LE("146,02") end
			tmp=''
		elseif c>='3' and c<='9' then  
			if c=='3' then p=p..str:toUTF6LE("89,02") end
			if c=='5' then p=p..str:toUTF6LE("200,02") end
			if c=='7' then p=p..str:toUTF6LE("204,02") end
			tmp=''
		elseif c=='!'then  
			p=":"
		elseif c=='_'then
			p=p..str:toUTF6LE("208,02")
		else
			p=p..c
		end
		--Log:d("Study","pron="..p)
	end
	return p;
end



Log:d("Study","Study.lua is loaded...")

print(string.format("%%c: %c", 230))