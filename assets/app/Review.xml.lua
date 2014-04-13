
--public final class PrepareStudyWordShower extends WordCanvas

local study ;
local word ;
    function initiate()
		 Log:d("PrepareStudyWord","initiate...")
			Global.isStudy = false;
            study = Study;
			Study.init()
			local isOpened=Study.openBook()
			Log:d("PrepareStudyWord","book was opend:")
            if (isOpened) then
				 Log:d("PrepareStudyWord","book is opend")
                word = study.nextWord();
				 Log:d("PrepareStudyWord","word="..word.spell)
                autoNext();
            end
		if(word~=nil) then repaint(word) end
        Global.currentReviewTimes=0;
		 Log:d("PrepareStudyWord","initiate was end...")
  end


	function reload()
		 Log:d("reload","Study View Lua reload is executed..")
		 study.close()
		 sys.reload()
	end

	function back()
		Study.close()
		ui:switchView("ReviewInfo.xml","reset()","file opener params")
	end


    -- //1: show all the content of the word; 0:only show the spell or description of the word for reviewing
    local showSignal = 1;

    function repaint(word)
        --//draw word's spell
        --//print spell when review by word or at the page of show all content of it
        if Global.reviewByChinese~=true or (showSignal ~= 0) then

			local wordStr = "[" .. study.getPos() .. "]" .. word.spell;

                if Global.languageSupport==1  then
                    --drawFrenchSpell(g, Y, font, 'H', new String(s.getBytes(),"utf-8"));
                else
                    --g.drawString( new String(s.getBytes(),"utf-8"), 2, Y, 20);
					spell_label:setText(wordStr)
				end
                

            if word.pronunacation  ~= nil   then
                --drawPronuncation(word.getPronunacation(), g, x, Y + (bigWordFont.getHeight() - 13));
				if(word.pronunacation~=nil) then pron_label:setText(word.pronunacation) end
            end
        else
            -- //only print the index of the word
            local wordStr = "[" .. study.getPos() .. "]";
			spell_label:setText(s)
			pron_label:setText("")

        end
        --g.drawString(String.valueOf(Global.currentReviewTimes), W - 20, Y, 0);


        if (Global.showChinese or Global.showEnglish) then
            --//separator
        end

		--//print description when review by Chinese or at page of show all content
        if (showSignal ~= 0 or (showSignal == 0 and Global.reviewByChinese)) then
            if (Global.showChinese) then
				if(word.description~=nil) then chinese_label:setText(word.description ) end
			end
        end
        
        if (showSignal ~= 0) then
            if (Global.showEnglish) then
                --Y +=  Util.drawEnglishParagraph(g, 4, Y, getWidth() - 9, font, word.enMeans );
				if(word.enMeans~=nil) then english_label:setText( word.enMeans) end
            end

            if (Global.showExample) then
				if(word.example~=nil) then example_label:setText(word.example ) end
            end
        end
         

        if (Global.autoPronounce and word ~= nil) then
            --playWord(word.getSpell());
        end

    end
    function next()
            local word = readNextWord();
			if(word==nil) then
				
				back()
			else
				repaint(word);
			end
   end

    function previous()
        repaint(study.preWord());
    end
    function returnToMenu()
        -- MyDialog md = new MyDialog(display, this, "Exit", "Studying is not finished ,are you sure want to exit?", "YES", "NO");
    end

    function  readNextWord()
        local nextWord = study.nextWord();
        if (nextWord ~= nil) then
        
            --study.close();
            --ReviewWordShower ews = new ReviewWordShower(display, parent);
            --display.setCurrent(ews);
        end
        return nextWord;
    end


	function autoNext()
        if (Global.autoBrowse) then
			--[[
            Thread t = new Thread()
            {

                public void run()
                {
                    while (study.getPos() < 20)
                    {
                        try
                        {
                            Thread.sleep(Global.autoBrowseSecond * 1000);
                        } catch (InterruptedException ex)
                        {
                            ex.printStackTrace();
                        }
                        next();
                    }
                }
            };
            t.start();
			]]
        end
    end


Log:d("PrepareStudyWord","PrepareStudyWord.lua is loaded...")
