

public class StudyInfo extends Form implements CommandListener
{



    function initiate()
    {
        studyInfo();
    }



    function studyInfo()
    {
        int j1 = 0;
        int k1 = 0;
        int l1 = 0;
	local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms")
            for i = 1, fc:available(), 1 do
                bs[i] = f:readByte();
            end
	fc:close();
        try
        {

            int id;

            while ((id = recordstore.getNextUsedRecordID()) >= 0)
            {
                //int i1 = recordenumeration.nextRecordId();
                ByteArrayInputStream bytearrayinputstream = new ByteArrayInputStream(recordstore.getRecord(id));
                DataInputStream datainputstream;
                (datainputstream = new DataInputStream(bytearrayinputstream)).readShort();
                byte byte0;
                if ((byte0 = datainputstream.readByte()) > 0)
                {
                    j1++;
                }
                if (byte0 > 5)
                {
                    k1++;
                }
                if (byte0 > 0 && byte0 < 6)
                {
                    l1++;
                }
            }

            recordstore.closeRecordStore();
        } catch (Exception _ex)
        {
            recite.showAlert("\u6570\u636E\u5E93\u9519\u8BEF\uFF01", AlertType.ALARM, this, 2000);
            return;
        }
        append("\u5F53\u524D\u8BCD\u5E93\u662F" + Global.currentBookName + "(" +
            String.valueOf((Global.bookGroupAmount) - 1) +
            "\u7EC4\uFF09\n\u521D\u8BB0\u5B8C\u7EC4\u6570\uFF1A" +
            String.valueOf(j1) + "\n\u590D\u4E60\u4E2D\u7EC4\u6570\uFF1A" +
            String.valueOf(l1) + "\n\u638C\u63E1\u7684\u7EC4\u6570\uFF1A" +
            String.valueOf(k1));
        setCommandListener(this);
        recite.display.setCurrent(this);
    }



    /**
     * write the lasted studied group and the book file name into store
     * @param group
     */
    public static void writeStudyInfo(short group) throws Exception
    {
//             if(Global.isStudy)
            {
                MyStore recordStore = MyFileStore.openRecordStore("studyinfo",250, true);

                ByteArrayOutputStream bytearrayoutputstream = new ByteArrayOutputStream();
                DataOutputStream dataoutputstream = new DataOutputStream(bytearrayoutputstream);
//                bytearrayoutputstream.reset();
                dataoutputstream.writeShort(group);
                dataoutputstream.writeUTF(Global.getCurrentBookFileName());
                dataoutputstream.writeUTF(Global.currentPronDirName);
                byte abyte1[] = bytearrayoutputstream.toByteArray();

                recordStore.setRecord(1, abyte1, 0, abyte1.length);
                recordStore.closeRecordStore();
            }

    }

    public static byte setReviewInfo(short group) throws Exception
    {
            byte nextDays = 0;
		local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms",true) --append
        fc:writeShort(Global.currentStudiedGroup)
		fc:writeByte(0)
		fc:writeLong(os.time()*1000)); --milliseconds
		fc:close();
		return 0

            MyStore recordStore = StoreFactory.openStore("Groupinfo",250, true);
            for (int i = recordStore.getNumRecords(); i >= 1; i--)
            {
                ByteArrayInputStream bytearrayinputstream = new ByteArrayInputStream(recordStore.getRecord(i));
                DataInputStream in = new DataInputStream(bytearrayinputstream);
                short cGroup = in.readShort();
                if (cGroup == group)
                {
                    ByteArrayOutputStream outputstream = new ByteArrayOutputStream();
                    DataOutputStream out = new DataOutputStream(outputstream);
                    out.writeShort(group);
                    nextDays = (byte) (in.readByte() + 1);
                    out.writeByte(nextDays);
                    Date date1 = new Date();
                    out.writeLong(date1.getTime());
                    out.flush();
                    byte abyte2[] = outputstream.toByteArray();

                    recordStore.setRecord(i, abyte2, 0, abyte2.length);
                    
                        out.close();
                        outputstream.close();
                    break;
                }
            }
            recordStore.closeRecordStore();
            recordStore = null;
            return nextDays;
  
    }
    
    public static byte getReviewInfo(short group) throws Exception
    {

            byte day = 0;
            MyStore recordStore = StoreFactory.openStore("Groupinfo",250, true);
            for (int i = recordStore.getNumRecords(); i >= 1; i--)
            {
                ByteArrayInputStream bytearrayinputstream = new ByteArrayInputStream(recordStore.getRecord(i));
                DataInputStream in = new DataInputStream(bytearrayinputstream);
                short cGroup = in.readShort();
                if (cGroup == group)
                {
                    day = (byte) (in.readByte());
                    break;
                }
            }
            recordStore.closeRecordStore();
            recordStore = null;
            return day;

    }


    public static byte writeReviewInfo(short group) throws IOException, Exception
    {
		local fc = fis:open(Global.storage..Global.currentBookFileName  .. "_Groupinfo.dbms",true) --append
        fc:writeShort(Global.currentStudiedGroup)
		fc:writeByte(0)
		fc:writeLong(os.time()*1000)); --milliseconds
		fc:close();
		return 0
}
