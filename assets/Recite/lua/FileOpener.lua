

FileOpener={}
 FileOpener.__index = FileOpener 

function FileOpener:show()
  
end


  
 function FileOpener:new(x,y) 
     local temp = {} 
     setmetatable(temp, FileOpener) 
     temp.x = x 
     temp.y = y 
     return temp 
 end 
  
 function FileOpener:test() 
     print(self.x,self.y) 
 end 
  
  
 object = FileOpener.new(self,10,20) 
 object:test() 

