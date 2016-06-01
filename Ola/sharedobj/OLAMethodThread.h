//
//  OLAMethodThread.h
//  Ola
//
//  Created by lohool on 5/31/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  trim(str)  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

@interface OLAMethodThread : NSObject
    {
        int interval;
        //how many times to run the method,if it is 0, run it with endless until it was terminated
        int runTimes;
        bool isStop;
        bool isRunning;
    }
    
    @property (nonatomic) int interval;
    @property (nonatomic) int runTimes;
    @property (nonatomic)bool isStop ;
    @property (nonatomic)bool isRunning ;
    
@end
