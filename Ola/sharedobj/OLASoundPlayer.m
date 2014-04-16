//
//  OLASoundPlayer.m
//  Ola
//
//  Created by Terrence Xing on 4/16/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLASoundPlayer.h"
#import <AVFoundation/AVAudioPlayer.h>

@implementation OLASoundPlayer

@synthesize mediaURL,player;



 int timex;
 NSString * timeStr ;
 int num[];
 int second;

 int duration;
BOOL isPaused = NO;
long pausedTime;

long dura;


- (id)initWithUrl:(NSString *) mediaFileURL
{
    self = [super init];
    mediaURL = mediaFileURL;
    [self createPlayer];
    return self;
}
+ (id) createPlayer:(NSString *) mediaFileURL
{
    return [[OLASoundPlayer alloc] initWithUrl:mediaFileURL];
}

- (void) createPlayer
{
   NSError* err;
    [self stop];
    if (mediaURL != nil)
    {
        //NSString *path = [[NSBundle mainBundle] pathForResource:mediaURL ofType:@"mp3"];
        //    NSURL *url = [NSURL URLWithString:path];//不能这样写，因为是本地路径
        NSURL *url = [NSURL fileURLWithPath:mediaURL];//本地路径应该这样写
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        
        //player = [[AVAudioPlayer alloc]  initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource: @"RHAPSODY IN BLUE" ofType:@"mp3"  inDirectory:@"/"]]  error:&err ];//使用本地URL创建
        
        
        //1.音量
        player.volume=1;//0.0~1.0之间
        //2.循环次数
        player.numberOfLoops = 1;//默认只播放一次
        //3.播放位置
        player.currentTime = 15.0;//可以指定从任意位置开始播放
        //4.声道数
        NSUInteger channels = player.numberOfChannels;//只读属性
        //5.持续时间
        NSTimeInterval duration = player.duration;//获取采样的持续时间
        //6.仪表计数
        player.meteringEnabled = YES;//开启仪表计数功能
        [ player updateMeters];//更新仪表读数
        //读取每个声道的平均电平和峰值电平，代表每个声道的分贝数,范围在-100～0之间。
        for(int i = 0; i<player.numberOfChannels;i++){
            float power = [player averagePowerForChannel:i];  
            float peak = [player peakPowerForChannel:i];  
        }
        //设置支持变速
        player.enableRate = YES;
        //峰值和平均值
        player.meteringEnabled = YES;
        //触发play事件的时候会将mp3文件加载到内存中，然后再播放，所以开始的时候可能按按钮的时候会卡，所以需要prepare
        [player prepareToPlay];
    }
}

- (void) play:(NSString *) url
{
    self.mediaURL = url;
    if (player != nil)
    {
        [self stop];
    }
    [self play];
}

- (void) play
{

		if (player == nil)
		{
			[self createPlayer];
		}
    /*
		if (player == nil)
			throw new Exception("Creater player error: nil.");
     */
		if (player != nil)
		{
            //按播放，开始定时器
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
			[player play];
            
		}

}

- (void) pause
{
    if (player != nil)
    {
        if (!isPaused)
        {
            [_timer invalidate];
            [player pause];
            isPaused = true;
        } else
        {
            
            [_timer fire];
            [player play];
            isPaused = false;
        }
    }
}

- (void) stop
{
    if (player != nil)
    {
        [player stop];

    }
    player = nil;
    timex = 0;
    timeStr = @"00:00";
    second = 0;
    dura = 0;
    duration = 0;
    isPaused = NO;
    pausedTime = 0;
    // player=nil;
}

/*
//进度
- (IBAction)proSlider:(id)sender
{
    //当前时间=总时间*slider.value;
    float curTime = _player.duration*_proSlider.value;
    [_player setCurrentTime:curTime];
}
//声道
- (IBAction)panSlider:(id)sender
{
    _player.pan = _panSlider.value;
}
//速度
- (IBAction)speedSlider:(id)sender
{
    _player.rate = _speedSlider.value;
}
//音量
- (IBAction)volSlider:(id)sender
{
    _player.volume = _volSlider.value;
}
*/

- (void)refresh
{
    //每隔0.1秒刷新一次进度,当前时间/总时间
    float pro = player.currentTime/player.duration;
    //[_proSlider setValue:pro animated:YES];
    
    //averagePowerForChannel和peakPowerForChannel的属性分别为声音的最高振幅和平均振幅
    [player updateMeters];//不刷新就永远是0
    float pead = ([player peakPowerForChannel:0]+50)/50;//0左声道,1右声道
    float ave = ([player averagePowerForChannel:0]+50)/50;//同上
    //[_proV setProgress:pead animated:YES];
    //[_proV2 setProgress:ave animated:YES];
}
/*
- void run
{
    // NSString * str = nil;
    do
    {
        if (player != nil)
        {
            
            long nano = player.getCurrentPosition();

            if (nano >= dura - 300000)// 500000000
            {
                // System.out .println("dura:"+this.dura ) ;
                Thread.currentThread();
                stop();
                break;
            }
        } else
        {
            timeStr = "ALL TIME: 0'0";
        }
        try
        {
            Thread.currentThread();
            Thread.sleep(50L);
        } catch (InterruptedException _ex)
        {
        }
    } while (player != nil);
}
 */
/*
 - final void playerUpdate(MediaPlayer player, NSString * event, Object data)
 {
 
 if (event.equals(PlayerListener.END_OF_MEDIA)
 || event.equals(PlayerListener.STOPPED))
 {
 // try
 {
 if (player != nil)
 {
 // if (player.getState() == Player.STARTED)
 // {
 // player.stop();
 // }
 // if (player.getState() == Player.PREFETCHED)
 // {
 // player.deallocate();
 // }
 // if (player.getState() == Player.REALIZED ||
 // player.getState() == Player.UNREALIZED)
 // {
 // player.close();
 // }
 player.removePlayerListener(this);
 player.close();
 }
 player = nil;
 }
 // catch (MediaException me)
 // {
 // }
 }
 
 }
 */

/*
- (void )searchnum:(NSString *) clock
{
    if (clock.length() > 5 || clock == nil)
    {
        return;
    } else
    {
        num[0] = Integer.parseInt(clock.subNSString *(0, 1));
        num[1] = Integer.parseInt(clock.subNSString *(1, 2));
        num[2] = Integer.parseInt(clock.subNSString *(3, 4));
        num[3] = Integer.parseInt(clock.subNSString *(4, 5));
        return;
    }
}

- NSString * getTimeStr()
{
    return timeStr;
}

- int getTimex()
{
    return timex;
}

- int getSecond()
{
    return second;
}

- int getDuration()
{
    return duration;
}

- MediaPlayer getPlayer()
{
    return player;
}

- boolean isPaused()
{
    return this.isPaused;
}
*/

@end
