//
//  OLAButton.m
//  Ola
//
//  Created by Terrence Xing on 3/22/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAButton.h"
#import "XMLElement.h"
#import "Button.h"
#import "CSS.h"

@implementation OLAButton

 //UIFont *font ;


- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) rootEle
{
    self=[super initWithParent:parentView withXMLElement:rootEle];
    
    //font = [UIFont fontWithName:@"Arial" size:12];
    
    Button *btn= [Button buttonWithType:UIButtonTypeRoundedRect]; //绘制形状
    //[btn.titleLabel setFont:font];
    
    // 确定宽、高、X、Y坐标
    CGRect frame;
    frame.size.width = 10;
    frame.size.height = 10;
    frame.origin.x = 0;
    frame.origin.y = 0;
    //[btn setFrame:frame];
    
    // 设置Tag(整型)
   // btn.tag = 10;
    
    // 设置标题
    //[btn setTitle:@"Button" forState:UIControlStateNormal];
    /*
    // 设置未按下和按下的图片切换
    [btn setBackgroundImage:[UIImage imageNamed:@"bus.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"plane.png"] forState:UIControlStateHighlighted];
    
    
    // 设置背景色和透明度
    
    [btn setAlpha:0.8];
    
    // 或设置背景色和透明度
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
     */
    //[btn setBackgroundColor:[UIColor blackColor]];
    
    // 设置事件
    //[btn addTarget:self action:@selector(showMessage:) forControlEvents:UIControlEventTouchUpInside];
    //[btn addTarget:self action:@selector(showMessage:) forControlEvents:UIControlEventTouchDown];
    
    

    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
    longPress.minimumPressDuration = 0.2; //定义按的时间
    longPress.delegate=self;
    //[btn addGestureRecognizer:longPress];
    
    //btn.canBecomeFirstResponder=YES;
    //btn.canResignFirstResponder=YES;
    super.v=btn;
    
    [super initiate];
    [self parseAlignment];
    return self;
}

-(void)repaint
{
    [self parseAlignment];
}

- (void) parseAlignment
{
    UIButton * btn=(UIButton *)(self.v);
    if (css.textAlign != nil) {
        if (([css.textAlign caseInsensitiveCompare:@"left"]==NSOrderedSame ))
        {
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        }
        else if (([css.textAlign caseInsensitiveCompare:@"right"]==NSOrderedSame ))
        {
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        }
        else
        {
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        }
    }
    if (css.verticalAlign != nil) {
        if (([css.verticalAlign caseInsensitiveCompare:@"top"]==NSOrderedSame ))
        {
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        }
        else if (([css.verticalAlign caseInsensitiveCompare:@"bottom"]==NSOrderedSame ))
        {
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        }
        if (([css.verticalAlign caseInsensitiveCompare:@"bottom"]==NSOrderedSame ))
        {
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        }
    }

    
}
- (NSString *) getColor
{
    UIButton * btn=(UIButton *)(self.v);
    //without prefix "#"
    return [CSS colorToString: btn.titleLabel.textColor];
}

- (void) setColor:(NSString *) color
{
    NSLog(@"btn set color=%@",color);
    UIButton * btn=(UIButton *)(self.v);
    UIColor *c = [CSS parseColor:color];
    [btn setTitleColor:c forState:UIControlStateNormal];
    
}

-(void)setText:(NSString *) text
{
    
    UIButton * btn1=(UIButton *)(self.v);
    
    //IOS6.0
    //CGSize size = CGSizeMake(0,0);
    //CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:  UILineBreakModeWordWrap];
    
    CGSize actualsize = [text sizeWithAttributes: @{NSFontAttributeName:btn1.titleLabel.font}];
    
    CGFloat w=0,h=0;
    if(css.width>0)w=css.width;else w=actualsize.width+10;
    if(css.height>0)h=css.height; else h=actualsize.height+10;
    
    [btn1 setFrame:CGRectMake(btn1.frame.origin.x,btn1.frame.origin.y, w,h)];
    
    [btn1 setTitle:text forState:UIControlStateNormal];
    if([parent isKindOfClass:[OLAContainer class]])
    {
        NSLog(@"button repaint...");
        OLAContainer * container=(OLAContainer *)parent;
        [container repaint];
    }
}
-(NSString *)getText
{
    UIButton * btn1=(UIButton *)(self.v);
    return btn1.titleLabel.text;
}
-(void) showMessage:(UITapGestureRecognizer *)recognizer
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"您点击了动态按钮！"
                                                   delegate:parent.v
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];

    NSLog(@"show message");
    
}

- (BOOL)isPassthroughView:(UIView *)view {
    
    
    return NO;
}
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    
     NSLog(@"Button block");
    return NO;
}
 */
@end
