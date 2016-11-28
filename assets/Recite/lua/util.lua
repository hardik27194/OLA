  function convertTimeForm(second)
     local timeDay                   = math.floor(second/86400)
     local timeHour                  = math.fmod(math.floor(second/3600), 24)
     local timeMinute                = math.fmod(math.floor(second/60), 60)
     local timeSecond                = math.fmod(second, 60)


     return timeDay, timeHour, timeMinute, timeSecond
 end

 function formatTime(time)
     local hour = math.floor(time/3600);
     local minute = math.fmod(math.floor(time/60), 60)
     local second = math.fmod(time, 60)
     local rtTime = string.format("%s:%s:%s", hour, minute, second)

    return rtTime
 end
