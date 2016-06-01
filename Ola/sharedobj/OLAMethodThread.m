//
//  OLAMethodThread.m
//  Ola
//
//  Created by lohool on 5/31/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import "OLAMethodThread.h"
#import "OLALuaContext.h"

@implementation OLAMethodThread

    @synthesize isStop,interval,runTimes,isRunning;
NSString * lock=@"";

    -(id) initWithInterval:(int) interval
    {
        self.interval=interval;
        runTimes=0;
        isStop=NO;
        isRunning=NO;
        return self;
	}
    
    + (id) create:(int) interval
    {
        id iner= [[OLAMethodThread alloc] initWithInterval:interval];
        return iner;
        
	}
    
    -(void) stop
    {
        self.isStop=YES;
        //while(self.isRunning==YES)
        {
             //NSLog(@"MethodThread -- Info -- still runing ");
            [NSThread sleepForTimeInterval:1];
        }
         //NSLog(@"MethodThread -- Info -- still runing %b",self.isRunning);
    }
    -(void)reset
    {
        self.isStop=NO;
    }
    
    - (void) start:(NSString *) runningMethod
    {
       // bool running=YES;
        isRunning=YES;
        self.isStop=NO;
        CGFloat sleepTime=self.interval/1000;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int count=0;
        while((self.runTimes==0 || count<self.runTimes) && !self.isStop)
        {
            @synchronized(lock)
            {
            //NSLog(@"MethodThread -- Info -- runing times:%d",count);
            long start=[runningMethod rangeOfString:@"(" ].location;
            long end=[runningMethod rangeOfString:@")" ].location;
            NSString *method=[runningMethod substringWithRange:NSMakeRange(0,start)];
            NSString * paramstr=[runningMethod substringWithRange:NSMakeRange(start+1,end-start-1)];
            NSArray * params;
            if([trim(paramstr) caseInsensitiveCompare:@""]==NSOrderedSame)params=[[NSArray alloc] init];
            else params=[paramstr componentsSeparatedByString:@","];
             NSLog(@"MethodThread -- Info -- runing method:%@",runningMethod);
            lua_State * lua=[[OLALuaContext getInstance] getLuaState];
            lua_getfield(lua, LUA_GLOBALSINDEX, [method UTF8String]);
            //NSLog(@"MethodThread -- Info -- Lua method:%@",method);
            //NSLog(@"MethodThread -- Info -- Lua method param:%@",paramstr);
            //NSLog(@"MethodThread -- Info -- Lua method param count:%lu",params.count);
            for(int j=0;j<params.count;j++)
            {
                NSString * p= trim([params objectAtIndex:j]);
                NSLog(@"MethodThread -- Info -- method params:%@",p);
                
                if([p hasPrefix:@"'"] || [p hasPrefix:@"\""])lua_pushfstring(lua, [p UTF8String]);
                else if([p characterAtIndex:0]>='0' && [p characterAtIndex:0]<='9') lua_pushnumber(lua, [p doubleValue]);
                else lua_pushfstring(lua, [p UTF8String]);
                 
            }
            NSLog(@"MethodThread -- Info -- Lua method start");
            //lua_pushnumber(lua, 1464632668);
            lua_call(lua, params.count, 1);
            NSLog(@"MethodThread -- Info -- Lua method executed");
            lua_setfield(lua, LUA_GLOBALSINDEX, "result");
            lua_getglobal(lua, "result");
            int result=lua_toboolean(lua, -1);
            if(result>=1)
            {
               self.isStop=YES;
               
            }
            
            //NSLog(@"MethodThread -- Info -- runing result:%d",result);
            //NSLog(@"MethodThread -- Info -- runing condition:%@",(self.runTimes==0 || count<self.runTimes) && !self.isStop ?@"YES":@"NO");
            //NSLog(@"MethodThread -- Info -- runing condition1:%@",(self.runTimes==0 || count<self.runTimes)  ?@"YES":@"NO");
            //NSLog(@"MethodThread -- Info -- runing condition2:%@",!self.isStop ?@"YES":@"NO");
            [NSThread sleepForTimeInterval:sleepTime];
            count++;
            }
        }
            self.isRunning=NO;
            
             });

        
    }

@end
