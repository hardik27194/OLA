//
//  ImgRotationView.m
//  Ola
//
//  Created by lohool on 10/21/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import "ImgRotationView.h"



@implementation ImgRotationView

@synthesize img;
 NSTimer *timer;
CGFloat originStart;
CGFloat originEnd;
BOOL isWise;
bool isStop=FALSE;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isWise=TRUE;
        lock=@"";
        
        self.opaque=NO;
        [self setBackgroundColor:[UIColor clearColor]];
        originStart=0;
        originEnd=M_PI*3/2;
        
        //timer=[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateArc) userInfo:nil repeats:YES];
        //[[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        //[timer fire];
        /*
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                
        
        //[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateArc) userInfo:nil repeats:YES];
        //
        //[[NSRunLoop currentRunLoop]run];
        //[timer fire];
        
        //[NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
            });
        });
         */
    
        //[self start];
        
        
        [self rotate];
        [self setNeedsDisplay];
    }
    return self;
}

//ProgressBar type="rotate" style="type:rotate;progress-image:url($/images/loading.png);width:160px;height:160px;"/


-(void)stop
{
    isStop=TRUE;
}
-(void)start
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //dispatch_async(dispatch_get_main_queue(), ^{
            while(!isStop)
            {
                //NSLog(@"thread.....");
                //@synchronized(lock)
                {
                    //[self updateArc];
                    //[self setNeedsDisplay];
                    [self performSelectorOnMainThread:@selector(updateArc) withObject:nil waitUntilDone:YES];
                    [NSThread sleepForTimeInterval:0.1];
                    
                }
            }
        //});
        
    });
    
    
    ////timer=[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateArc) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    //[timer fire];

    //
    //NSThread *drawUI=[[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    //[drawUI start];
    
    
}

-(void)run{
    @autoreleasepool {
        [self performSelectorOnMainThread:@selector(updateArc) withObject:nil waitUntilDone:NO];
        [NSThread sleepForTimeInterval:0.5];
    }
}


- (void)startTimer

{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateArc) userInfo:nil repeats:YES];
   //[[NSRunLoop currentRunLoop] run];

 }


-(void) setImage:(UIImage *)img
{
    self.img=img;
    [self setBackgroundColor:[UIColor colorWithPatternImage:img]];
}

-(void) rotate
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    animation.fromValue = [NSNumber numberWithFloat:-M_PI / 4];
    
    animation.toValue = [NSNumber numberWithFloat: M_PI/ 4];
    
    
    //animation.autoreverses = ;
    
    animation.duration = 50;
    
    animation.repeatCount = NSNotFound;
    
    
    
    [self.layer addAnimation:animation forKey:@"animationTransform"];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    
    NSLog(@"draw progrssbar:@",@"paint");
    if(self.img==NULL)
    {
        
        [self drawDefault];
    }
    //else
    {
    [super drawRect:rect];
    }
}


-(void) drawDefault
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    
    
    CGPoint center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    int lineWidth=5;
    
    float radius=MIN(self.frame.size.width, self.frame.size.height)/2-lineWidth-2;
    
    //CGFloat startAngle=M_PI;
    //CGFloat endAnfle=2*M_PI;
    

    
    [path addArcWithCenter:center radius:radius startAngle:originStart endAngle:originEnd clockwise:TRUE];
    CGContextAddPath(context, path.CGPath);
    CGContextSetLineWidth(context,lineWidth);
    
    UIColor *color=[UIColor colorWithCIColor:[CIColor colorWithRed:1 green:0.8 blue:0.6]];
    
    //CGContextSetStrokeColor(context, color.CGColor);
    [color setStroke];
    
   //CGContextAddArc(context, 20,20, 10, 0, M_PI, YES);
   //[self drawText:context];
    
    CGContextStrokePath(context);
    
    
    
}


-(void)updateArc
{
    //NSLog(@"update ac,...");
if(originStart>2*M_PI)
{
    originEnd-=2*M_PI;
    originStart-=2*M_PI;
}
            if(originEnd-originStart>2*M_PI)
            {
                isWise=FALSE;
            }
            
            if(isWise)
            {
                originStart+=M_PI/20;
                originEnd+=M_PI/10;
            }
            else{
                originStart+=M_PI/20;
                originEnd+=M_PI/30;
                if(originEnd-originStart<=0)
                {
                    isWise=TRUE;
                    originEnd=originStart+M_PI/10;
                }
            }

    NSLog(@"%f-%f=%f",originStart,originEnd,originStart-originEnd);
            
            [self  setNeedsDisplay];
            

    
}


-(void) drawText:(CGContextRef *)context
{
    CGRect bounds = [self bounds];
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    NSString *text = @"Loading...";
    // Get a font to draw it in
    UIFont *font = [UIFont boldSystemFontOfSize:28];
    // Where am I going to draw it?
    CGRect textRect;
    textRect.size = [text sizeWithFont:font];
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.height / 2.0;
    // Set the fill color of the current context to black
    [[UIColor blackColor] setFill];
    // Set the shadow to be offset 4 points right, 3 points down,
    // dark gray and with a blur radius of 2 points
    CGSize offset = CGSizeMake(4, 3);
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    CGContextSetShadowWithColor(context, offset, 2.0, color);
    // Draw the string
    [text drawInRect:textRect
            withFont:font];
}
@end
