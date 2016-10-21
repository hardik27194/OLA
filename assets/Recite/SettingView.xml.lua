function initiate()
	Log:d('initiate','Setting View initiate execute...')
	
	    if(Global.showChinese) then ec:setChecked(true) end
        if(Global.showEnglish) then ee:setChecked(true) end
        if(Global.showExample) then ex:setChecked(true) end
        if(Global.showExampleComment) then et:setChecked(true) end
        if(Global.autoPronounce) then ap:setChecked(true) end
        if(Global.autoBrowse) then ab:setChecked(true) end

end

function reload()
	 Log:d("reload","Study View Lua reload is executed..")
	 sys.reload()
end

function back()
	ui:switchView("Reading.xml","callback('file opener returned param')","file opener params")
end
function save()
    --short size = Short.parseShort(groupSize.getString());
    --Global.setGroupSize(size);
    if ec:isChecked() then Global.showChinese=true;else Global.showChinese=false; end
    if ee:isChecked() then Global.showEnglish=true; else Global.showEnglish=false;end
    if ex:isChecked() then Global.showExample=true;else Global.showExample=false;end
    if et:isChecked() then Global.showExampleComment=true;else Global.showExampleComment=false;end
    if ap:isChecked() then Global.autoPronounce=true;  else Global.autoPronounce=false;end
    if ab:isChecked() then Global.autoBrowse=true; else Global.autoBrowse=false;end
    --if ee:isChecked() then Global.languageSupport=1; else Global.languageSupport=0;end
    
    --Global.autoBrowseSecond=Short.parseShort(autoBrowseSec.getString());
    --Global.volumeLevel=(short)volume.getValue();
    
    --if(reviewType.getSelectedIndex()==1)Global.reviewByChinese=true;
    --else Global.reviewByChinese=false;
    
    Global.saveProperties();

	back()
end

                


function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end


--[[
public class PropertySettingForm extends Form implements CommandListener
{
    Command commandOK = new Command ("OK", 4, 1);
    Command commandCancel = new Command ("Cancel", 2, 2);
    TextField groupSize=new TextField("Group Size:",Integer.toString(Global.getGroupSize()),2,TextField.NUMERIC);
    TextField autoBrowseSec=new TextField("Auto browse second:",Integer.toString(Global.autoBrowseSecond),2,TextField.NUMERIC);
    ChoiceGroup choices=new ChoiceGroup("",Choice.MULTIPLE);
    ChoiceGroup reviewType = new ChoiceGroup("Review Type",Choice.EXCLUSIVE);
    Gauge volume= new Gauge("Volume",true,10,5);
    Display display;
    Displayable parent;
    public PropertySettingForm(Display display,Displayable parent)
    {
        super("Properties Setting");
        this.display=display;
        this.parent=parent;
        init();
        this.setCommandListener(this);
    }
    void init()
    {
        this.append(groupSize);
        choices.append("English-Chinese", null);
        choices.append("English-English", null);
        choices.append("Example", null);
        choices.append("Example' tranlation", null);
        choices.append("Auto Pronounce", null);
        choices.append("Auto Browse", null);
        choices.append("Lanuage Unsupported", null);
        
        this.append(choices);
        if(Global.showChinese)choices.setSelectedIndex(0, true);
        if(Global.showEnglish)choices.setSelectedIndex(1, true);
        if(Global.showExample)choices.setSelectedIndex(2, true);
        if(Global.showExampleComment)choices.setSelectedIndex(3, true);
        if(Global.autoPronounce)choices.setSelectedIndex(4, true);
        if(Global.autoBrowse)choices.setSelectedIndex(5, true);
        if(Global.languageSupport==1)choices.setSelectedIndex(5, true);
//        this.append(autoBrowse);
        this.append(autoBrowseSec);
        autoBrowseSec.setString(Integer.toString(Global.autoBrowseSecond));
        
        this.append(volume);
        volume.setValue(Global.volumeLevel);
        
        
        reviewType.append("English", null);
        reviewType.append("Chinese", null);
        this.append(reviewType);
        if(Global.reviewByChinese)reviewType.setSelectedIndex(1, true);
        else reviewType.setSelectedIndex(0, true);
        
        this.addCommand(commandOK);
        this.addCommand(commandCancel);

    }

}
]]