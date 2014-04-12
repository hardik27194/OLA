WordIndex = {}
Log:d("WorkIndex","start t0 execute word index...")
WordIndex.__index = WordIndex 

    WordIndex.pos={};  --int[]
    WordIndex.fileProtocal = "file:///";
    WordIndex.bookFileName="" ;
    WordIndex.bookIndexFileName="";
    WordIndex.bookName="";

 function WordIndex:new() 
     local temp = {} 
     setmetatable(temp, WordIndex) 
     return temp 
 end 
function WordIndex.load()
Log:d("WordIndex","start WordIndex.load...")

    WordIndex.bookFileName = Global.currentBookFileName
    WordIndex.bookName = Global.currentBookFileName--bookFileName.substring(bookFileName.lastIndexOf('/'));
    WordIndex.bookIndexFileName = WordIndex.bookFileName .. ".dbx";

	Log:d("WorkIndex","WordIndex.bookIndexFileName="..Global.storage..WordIndex.bookIndexFileName)
	local fin = fis:open(Global.storage..WordIndex.bookIndexFileName)
	Log:d("WorkIndex","WordIndex.bookIndexFileName="..Global.storage..WordIndex.bookIndexFileName)
	if (fin:exists()=="true") then
	Log:d("WorkIndex","file is existed")
	else
	Log:d("WorkIndex","file is not existed")
	end
	Global.bookName=fin:readStringWithLength()
	Log:d("WorkIndex","Global.bookName="..Global.bookName)
	Global.version=fin:readDouble()
	Log:d("WorkIndex","Global.version="..Global.version)
	Global.encyptType=fin:readByte()
	Log:d("WorkIndex","Global.encyptType="..Global.encyptType)
	Global.wordsCount=fin:readInt()
	Log:d("WorkIndex","Global.wordsCount="..Global.wordsCount)
	Global.bookGroupAmount = (Global.wordsCount % Global.groupSize > 0  and Global.wordsCount / Global.groupSize + 1) or Global.wordsCount / Global.groupSize;
	Log:d("WorkIndex","Global.bookGroupAmount="..Global.bookGroupAmount)
	--[[
           for i = 1,Global.wordsCount * 6, 1 do
                WordIndex.pos[i] = fin:readInt();
            end
	]]
	local bytes=fin:readIntArray(Global.wordsCount * 6)
		--Log:d("WordIndex.load","pos bytes="..bytes)
			WordIndex.pos = loadstring('return '..bytes)()
		Log:d("File test","pos length="..#WordIndex.pos)
	fin:close()
end

function WordIndex.getPos(i)
	i=i-1
				Log:d("WordIndex.getPos","i="..i)
        local poss = {}  -- new int[6];
        poss[1] = WordIndex.pos[i * 6 + 1]
        poss[2] = WordIndex.pos[i * 6 + 3] - WordIndex.pos[i * 6 + 2]
        poss[3] = WordIndex.pos[i * 6 + 4] - WordIndex.pos[i * 6 + 3]
        poss[4] = WordIndex.pos[i * 6 + 5] - WordIndex.pos[i * 6 + 4]
        poss[5] = WordIndex.pos[i * 6 + 6] - WordIndex.pos[i * 6 + 5]
        poss[6] = WordIndex.pos[i * 6 + 8] - WordIndex.pos[i * 6 + 6]
           for i = 1,#poss, 1 do
				Log:d("WordIndex.getPos","poss[i]="..poss[i])
            end
        return poss
end

function WordIndex.getGroupPos( groupIndex)

        return WordIndex.pos[(groupIndex - 1) * Global.groupSize * 6 + 1 +1];
end

function readWordsState()
	local bs = {}
	local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_studyinfo.dbms")
		fc:readShort()
		fc:readLong()
            --for i = 1, fc:available(), 1 do
            --    bs[i] = f:readByte();
            --end
			bs=loadstring('return {'..fc:readBytes(Global.wordsCount)..'}')()
	fc:close();
        return bs;
end
--[[
    public static byte[] readWordsState() throws IOException
    {
        byte[] bs = new byte[Global.wordsCount];
        FileConnection fc = (FileConnection) Connector.open(fileProtocal + bookName + "_studyinfo.dbms", Connector.READ);
        if (fc.exists())
        {
            InputStream fis = fc.openInputStream();
            fis.read(bs);
            fis.close();
        }
		fc.close();
        return bs;
    }
]]

function writeWordState(states)
        local fc = fos:open(Global.storage..Global.currentBookFileName .. "_studyinfo.dbms")
		fc:writeShort(0);
		fc:writeLong(Global.wordsCount)
        --fos.write(states, 0, states.length);
		for i = 1, #states, 1 do
             fc:writeByte(states[i])
        end

        fc.close();
end
--[[

    public static void writeWordState(byte[] states) throws IOException
    {
        FileConnection fc = (FileConnection) Connector.open(fileProtocal + bookFileName + "_studyinfo.dbms", Connector.READ_WRITE);
        if (!fc.exists())
        {
            fc.create();
        }
        OutputStream fos = fc.openOutputStream();
        fos.write(states, 0, states.length);
        fos.flush();
        fos.close();
        fc.close();
    }
    ]]

WordIndex.load()
Log:d("WorkIndex","word index executed")