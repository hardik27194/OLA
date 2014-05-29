package com.lohool.jproject.recite.ui;
import com.lohool.jproject.mobile.ui.Util;
import java.io.*;
import java.util.*;
import javax.microedition.lcdui.*;
//import javax.microedition.rms.*;
//import javax.microedition.io.file.FileSystemRegistry;
import com.lohool.jmtdb.dbms.store.MyFileStore;
import com.lohool.jmtdb.dbms.store.MyRecordStore;
import com.lohool.jmtdb.dbms.store.MyStore;
import com.lohool.jproject.recite.Global;
import com.lohool.jproject.recite.PrepareStudyWordShower;
import com.lohool.jproject.recite.StudyInfo;

public class PrepareStudyForm extends Form implements CommandListener
{

    /**Construct the displayable*/
//    Recite recite;
    Display display;
    Displayable displayable;
    Command commandStart = new Command("Start", 4, 1);
    Command commandReturn = new Command("Return", 2, 2);
    TextField textField;

    public PrepareStudyForm(Display display, Displayable displayable)
    {
        super("First Study");
        this.display = display;
        this.displayable = displayable;
        setCommandListener(this);
        // add the Exit command
        addCommand(commandReturn);
        addCommand(commandStart);
        init();
    }

    /**Handle command events*/
    public void commandAction(Command command, Displayable displayable)
    {
        if (command == commandReturn)
        {
            display.setCurrent(this.displayable);
            return;
        }
        if (command == commandStart)
        {
            short group;
            if ((group = Integer.valueOf(textField.getString()).shortValue()) < 0 || group > Global.bookGroupAmount)
            {
                Util.showAlert(display, "Over words group scope", AlertType.ALARM, this, 2000);
                return;
            }
            MyStore recordstore = null;
            try
            {
                if(Global.isFileSystemSupported==0)
                {
                    recordstore = MyFileStore.openRecordStore("Groupinfo", 250, true);
                }
                else
                {
                recordstore = MyRecordStore.openRecordStore("Groupinfo", 250, true);
                }
                //RecordEnumeration recordenumeration;
                //if((recordenumeration = (recordstore = RecordStore.openRecordStore ("Groupinfo", true)).enumerateRecords (new MyRecordFilter (word0), null, false)).hasNextElement ())
                recordstore.reset();
                for (int id = recordstore.getNumRecords(); id >= 1; id--)
                {

                    ByteArrayInputStream bytearrayinputstream = new ByteArrayInputStream(recordstore.getRecord(id));
                    DataInputStream datainputstream = new DataInputStream(bytearrayinputstream);
                    if (group == datainputstream.readShort())
                    {
                        Util.showAlert(display, "The group has been studied��", AlertType.ALARM, this, 2000);
                        recordstore.closeRecordStore();
                        return;
                    }
                }

            } catch (Exception ex)
            {
                ex.printStackTrace();
                Util.showAlert(display, "Vocabulary Database error��" + ex.toString(), AlertType.ALARM, this, 2000);
                return;
            } finally
            {
                try
                {
                    if (recordstore != null)
                    {
                        recordstore.closeRecordStore();
                    }
                } catch (Exception ex)
                {
                    ex.printStackTrace();
                }
            }
            Global.currentStudiedGroup = (short) (group);
            try
            {
                PrepareStudyWordShower h = new PrepareStudyWordShower(display, this.displayable);
            } catch (Exception ex)
            {
                ex.printStackTrace();
                Util.showAlert(display, ex.toString(), AlertType.ALARM, this, 2000);
                return;
            }
        }

    }

     final void init()
    {
        try
        {
//            if (Global.getCurrentBookFileName().equals(""))
            {
                StudyInfo.initRSStudyinfo();
            }
            if (Global.getCurrentBookFileName().equals(""))
            {
                Util.showAlert(display, "Please select vocabulary book. \nOr buy a new one by mail to lohool@hotmail.com", AlertType.ALARM, displayable, 2000);
                display.setCurrent(this.displayable);
                return;
            }

            Global.lastStudiedGroup = Global.lastStudiedGroup >= 0 ? Global.lastStudiedGroup : 0;

            append("Current vocabulary:\n" + Global.currentBookName 
                    + "\n(Group Ccount" + String.valueOf(Global.bookGroupAmount)
                    + ")\nLast group studied:" + String.valueOf(Global.lastStudiedGroup)
                    + "\nNext group studied:\n");
            textField = new TextField("", String.valueOf(Global.lastStudiedGroup + 1), 4, 2);
            append(textField);
            append("\nBuy new vocabularies, please contact lohool@hotmail.com");
            addCommand(commandReturn);
            addCommand(commandStart);
            setCommandListener(this);
            display.setCurrent(this);

            return;
        } catch (Exception ex)
        {
            Util.showAlert(display, "study error:" + ex.toString(), AlertType.ALARM, displayable, 2000);
            ex.printStackTrace();
        }

    }
}
