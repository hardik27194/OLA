	local study ;
	local word ;
 	local thread=Thread:create(1000)

   function initiate()
		 Log:d("PrepareStudyWord","initiate...")
			Global.isStudy = true;
            study = Study;
			Study.init()
			local isOpened=Study.openBook()
            if (isOpened) then
				 Log:d("PrepareStudyWord","book is opend")
                word = study.nextWord();
				 Log:d("PrepareStudyWord","word1="..word.spell)
                autoNext();
            end
		if(word~=nil) then repaint(word) end
        Global.currentReviewTimes=0;
    end
	function swipe(direction)
		if direction==1 then
			next()
		elseif direction==2 then
			previous()
		end
	end


	function reload()
		 Log:d("reload","Study View Lua reload is executed..")
		 thread:stop()
		 study.close()
		 sys.reload()
	end

	function back()
		Study.close()
		thread:stop()
		ui:switchView("StudyView.xml","reset()","file opener params")
	end


    -- //1: show all the content of the word; 0:only show the spell or description of the word for reviewing
    local showSignal = 1;

    function repaint(word)
		Log:d("Study View","repaint word...")
        --//draw word's spell
        --//print spell when review by word or at the page of show all content of it
        if Global.reviewByChinese~=true or (showSignal ~= 0) then

			local wordStr = "[" .. study.getPos() .. "]" .. word.spell;

                if Global.languageSupport==1  then
                    spell_label:setText(wordStr)
                else
					spell_label:setText(wordStr)
				end


            if word.pronunacation  ~= nil   then
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
				if(word.enMeans~=nil) then english_label:setText( word.enMeans) end
			else
				english_label:setText( "")
            end

            if (Global.showExample) then
				if(word.example~=nil) then example_label:setText(word.example ) end
			else
				example_label:setText( "")
            end
        end


        if (Global.autoPronounce and word ~= nil) then
			play();
        end

    end
    function next()
		if Study.fin ~= nil then
            word = readNextWord();
			if(word==nil ) then
				back()
			else
				repaint(word);
				autoNext();
			end
		end
   end

    function previous()
        word=study.preWord()
        repaint(word);
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
	if Global.autoBrowse then
		Log:d("autoNext","Global.autoBrowse")
		local s = os.date("%s", os.time())
		thread:start("autoNextTimer("..s..")");
		Log:d("autoNext","Global.autoBrowse1")
	end
end

function autoNextTimer(s0)
	if Study.fin ~= nil then
		local s = os.date("%s", os.time())
		if s - s0 >= 10 then
			Log:d("autoNextTimer",s - s0)
			local msg=uiMsg:create()
			msg:updateMessage("next()")
			return true
		end
	else
		return true
	end
end


function delete()
    study.deleteCurrentWord()
end

function play()
	local soundPlayer=MediaPlayer:createPlayer(Global.storage..'/sound/'..word.spell..'.mp3')
	Log:d("Player","URL="..Global.storage..'/sound/'..word.spell..'.mp3')
	soundPlayer:play()
end

function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end

Log:d("PrepareStudyWord","PrepareStudyWord.lua is loaded...")
