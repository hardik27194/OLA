//
//  OLASoundPlayer.h
//  Ola
//
//  Created by Terrence Xing on 4/16/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface OLASoundPlayer : NSObject
{
    NSString * mediaURL;
    NSTimer *_timer;
    AVAudioPlayer * player;
}
@property (nonatomic,retain) NSString * mediaURL;
@property (nonatomic,retain)AVAudioPlayer * player;

+ (id) createPlayer:(NSString *) mediaFileURL;
- (void) createPlayer;
- (void) play;
- (void) pause;
- (void) stop;
@end
