 Word={}
 Word.__index=Word
 function Word.new() 
     local temp = {} 
     setmetatable(temp, Word) 
     return temp 
 end 

      Word.state=0;
      Word.spell="";
      Word.pronunacation="";
      Word.description="";
      Word.example="";
      Word.exampleChinese="";
      Word.enMeans="";
--[[
    function  Word.getSpell ()
        return self.spell;
    end
    function Word.setSpell ( spell)
        self.spell = spell;
    end

    function  Word.getPronunacation ()
        return self.pronunacation;
    end
    function Word.setPronunacation ( pronunacation)
        self.pronunacation = pronunacation;
    end
    function  Word.getDescription ()
        return self.description;
    end

    function Word.setDescription ( description)
        self.description = description;
    end

    function  Word.getExample ()
        return self.example;
    end

    function Word.setExample ( example)
        self.example = example;
    end

    function  Word.getExampleChinese ()
        return self.exampleChinese;
    end

    function Word.setExampleChinese ( exampleChinese)
        self.exampleChinese = exampleChinese;
    end

    function  getEnMeans ()
        return self.enMeans;
    end

    function Word.setEnMeans ( enMeans)
        self.enMeans = enMeans;
    end

    function  Word.getState()
        return self.state;
    end

    function Word.setState( state)
        self.state = state;
    end
]]

Log:d("Word","Word.lua is loaded...")
