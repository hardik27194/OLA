//
//  OLALabel.m
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALabel.h"
#import "FDLabelView.h"
#import "UILabelEx.h"
#import "OLALinearLayout.h"
#import "LinearLayout.h"
@implementation OLALabel

UIFont *font ;


- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) rootEle andUIFactory:(OLAUIFactory *)uiFactory
{
    self=[super initWithParent:parentView withXMLElement:rootEle andUIFactory:uiFactory];
    
    
    UILabelEx *label = [[UILabelEx alloc] init];
    
    CGRect frame;
    frame.size.width = 40;
    frame.size.height = 100;
    frame.origin.x = 0;
    frame.origin.y = 0;
    //[label setFrame:frame];
    
    
    //label.text = @"where are you? where are you? \n where are you? where are you? where are you? where are you? where are you? where are you? where are you? where are you?";
    label.text=@"";
    //清空背景颜色
    //label.backgroundColor = [UIColor clearColor];
    //设置字体颜色为白色
    //label.textColor = [UIColor whiteColor];
    //文字居中显示
    label.font=[UIFont  systemFontOfSize:14];
    [label setFont:label.font];
    
    //label.lineHeightScale = 0.70;
    ////label.fixedLineHeight = 0.00;
    //label.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    //label.fdTextAlignment = FDTextAlignmentFill;
    //label.fdAutoFitMode = FDAutoFitModeAutoHeight;
    //label.fdLabelFitAlignment = FDLabelFitAlignmentTop;
    //label.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    //自动折行设置
    //label.lineBreakMode = UILineBreakModeWordWrap;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.verticalAlignment=VerticalAlignmentTop;
    
    //allow touch event
    label.userInteractionEnabled=YES;
/*
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Using NSAttributed String"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(6, 12)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:30.0] range:NSMakeRange(19, 6)];
    attrLabel.attributedText = str;
  */
    //button长按事件
    //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
    //longPress.minimumPressDuration = 0.2; //定义按的时间
    //longPress.delegate=self;
    //[label addGestureRecognizer:longPress];

    super.v=label;
    [super initiate];
    [self parseAlignment];
    return self;
}

-(void)repaint
{
    [self parseAlignment];
}

/*
 
 
 typedef enum {
 FDTextAlignmentLeft = 0,
 FDTextAlignmentCenter = 1,
 FDTextAlignmentRight = 2,
 FDTextAlignmentJustify = 3,
 FDTextAlignmentFill = 4
 } FDTextAlignment;
 */
- (void) parseAlignment
{
    UILabelEx * label=(UILabelEx *)(self.v);
    
    NSLog(@"label align=%@,valign=%@",css.textAlign,css.verticalAlign);
    if (css.textAlign != nil) {
        if (([css.textAlign caseInsensitiveCompare:@"center"]==NSOrderedSame ))
        {
            label.textAlignment=UITextAlignmentCenter;
        }
        else if (([css.textAlign caseInsensitiveCompare:@"right"]==NSOrderedSame ))
        {
            label.textAlignment=UITextAlignmentRight;
        }
        else
        {
            label.textAlignment=UITextAlignmentLeft;
        }
    }
    if (css.verticalAlign != nil) {
        if (([css.verticalAlign caseInsensitiveCompare:@"middle"]==NSOrderedSame ) || ([css.verticalAlign caseInsensitiveCompare:@"center"]==NSOrderedSame ))
        {
            //label.verticalAlignment=VerticalAlignmentMiddle;
            [label setVerticalAlignment:VerticalAlignmentMiddle];
        }
        
        else if (([css.verticalAlign caseInsensitiveCompare:@"bottom"]==NSOrderedSame ))
        {
            //label.verticalAlignment=VerticalAlignmentBottom;
            [label setVerticalAlignment:VerticalAlignmentBottom];
        }
        else
        {
            [label setVerticalAlignment:VerticalAlignmentTop];
        }
        
    }
    
    
    //label.backgroundImageUrl=css.backgroundImageURL;
    //label.backgroundAlpha=css.alpha;
    //label.backgroundColorString=css.backgroundColor;
    
}
- (NSString *) getColor
{
    UILabelEx * label=(UILabelEx *)(self.v);
    //without prefix "#"
    return [CSS colorToString: label.textColor];
}

- (void) setColor:(NSString *) color
{
    UILabelEx * label=(UILabelEx *)(self.v);
    UIColor *c = [CSS parseColor:color];
    label.textColor=c;
    
}
-(void) setFont:(UIFont *)font
{
    //NSLog(@"Label set font:%f",font.pointSize);
    if(font.pointSize>0)
    {
    UILabelEx * label=(UILabelEx *)(self.v);
    [label setFont:font];
    }
}
-(NSString *)getText
{
    UILabelEx * label=(UILabelEx *)(self.v);
    return label.text;
}

/*
 set text and auto adjust the size of it 
 */
-(void)setText:(NSString *) text
{
    text = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    text = [text stringByReplacingOccurrencesOfString:@"\\\n" withString:@"\\n"];
    //text = [text stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    
    UILabelEx * label=(UILabelEx *)(self.v);
    
    //IOS6.0
    //CGSize size = CGSizeMake(0,0);
    //CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:  UILineBreakModeWordWrap];

    
    //CGSize labelsize = [text sizeWithAttributes: @{NSFontAttributeName:label.font}];
    //[label setFrame:CGRectMake(label.frame.origin.x,label.frame.origin.y, labelsize.width+10, labelsize.height+10)];

    //label.numberOfLines =0;
    
    //UIFont * tfont = [UIFont systemFontOfSize:14];
    
    //label.font = tfont;
    
    //label.lineBreakMode =NSLineBreakByTruncatingTail ;
    label.text=text;

    CGSize origionSize=label.frame.size;
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGFloat initWidth=self.v.frame.size.width;
     NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName,nil];
    
    
    
     NSLog(@"set label=%@",text);
    
    //not set a value to Css "Width", it is nil or "auto"
    if(initWidth<=0)
    {
        NSLog(@"set label size1");
        //create and init the label, do not set its frame size
        initWidth=2048;
        if(text!=nil && [text compare:@""]!=NSOrderedSame)
        {
            //set the init frame size to its first char's frame size
            NSString * firstChar=[text substringToIndex:1];
            CGSize size =CGSizeMake(initWidth,MAXFLOAT);
            CGSize  actualsize =[firstChar boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
            CGFloat w=0,h=0;
            if(css.width>0)w=css.width;else w=actualsize.width*[text length];
            if(css.height>0)h=css.height+css.border.width*2; else h=actualsize.height+css.border.width*2;
            [label setFrame:CGRectMake(label.frame.origin.x,label.frame.origin.y, w, h)];
            //if(w>origionSize.width || h!=origionSize.height)
            //    needRepaint=YES;
        }
    }
    //set a value, it is like "111px"
    else
    {
        NSLog(@"set label size2");
    CGSize size =CGSizeMake(initWidth,MAXFLOAT);
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    // ios7之前使用方法获取文本需要的size，7.0已弃用下面的方法。此方法要求font，与breakmode与之前设置的完全一致
    //    CGSize actualsize = [tstring sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    //   更新UILabel的frame
    CGFloat w=0,h=0;
    if(css.width>0)w=css.width;else w=actualsize.width;
    if(css.height>0)h=css.height+css.border.width*2; else h=actualsize.height+css.border.width*2;
        if(w<label.frame.size.width)w=label.frame.size.width;
    [label setFrame:CGRectMake(label.frame.origin.x,label.frame.origin.y, w, h)];

    //[label setNeedsDisplay];
    
        //repaint the whole screen view if the frame size of the label was changed to bigger
        BOOL needRepaint=NO;
    if(w>origionSize.width || h!=origionSize.height)
        needRepaint=YES;
        
        if(needRepaint)
        {
            NSLog(@"label frame size was changed....");
            if([parent isKindOfClass:[OLALinearLayout class]])
            {
                LinearLayout * container=(LinearLayout *)parent.v;
                [container resizeToFitMaxChild];
            }
            OLAView * containerParent=parent;
            while([containerParent.parent isKindOfClass:[OLALayout class]])
            {
                containerParent=containerParent.parent;
            }
            
            OLALayout *layout= (OLALayout *)containerParent;
            NSLog(@"repaint id=%@",layout.objId);
            NSLog(@"layout.description=%@",layout.description);
            //set min or max frame of subviews
            [(Layout *)layout.v repaint];
            //[(Layout *)layout.v setFrameMinSize];
            //reset auto fitted subviews to fit its parents
            //[(Layout *)layout.v repaint];
            
            
        }
        //reset the background image with alpha
        if(css.backgroundImageURL!=nil)
        {
            [super setBackgroundImageUrl:css.backgroundImageURL];
        }
    }
   
    
}

//adjust label  itself's true size by coculated by the WIDTH
-(void)adjustSelfSize:(CGFloat) width
{
    
    UILabelEx * label=(UILabelEx *)(self.v);
    CGFloat origionW=label.frame.size.width;
    CGFloat origionH=label.frame.size.height;
    CGSize size =CGSizeMake(width,MAXFLOAT);
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName,nil];
    
    CGSize  actualsize =[label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    CGFloat w=0,h=0;
    if(css.width>0)w=css.width;else w=actualsize.width;
    if(css.height>0)h=css.height+css.border.width*2; else h=actualsize.height+css.border.width*2;
    
    [label setFrame:CGRectMake(label.frame.origin.x,label.frame.origin.y, w, h)];
    [label setNeedsDisplay];
    
    //repaint the whole screen view if the frame size of the label was changed to bigger
    BOOL needRepaint=NO;
    
    if(w>origionW || h!=origionH)
        needRepaint=YES;
    
    if(needRepaint)
    {
        NSLog(@"label frame size was changed....");
        if([parent isKindOfClass:[OLALinearLayout class]])
        {
            LinearLayout * container=(LinearLayout *)parent.v;
            [container resizeToFitMaxChild];
        }
        OLAView * containerParent=parent;
        while([containerParent.parent isKindOfClass:[OLALayout class]])
        {
            containerParent=containerParent.parent;
        }
        
        OLALayout *layout= (OLALayout *)containerParent;
        //NSLog(@"repaint id=%@",layout.objId);
        //NSLog(@"layout.description=%@",layout.description);
        //set min or max frame of subviews
        //[(Layout *)layout.v repaint];
        //[(Layout *)layout.v setFrameMinSize];
        //reset auto fitted subviews to fit its parents
        //[(Layout *)layout.v repaint];
        
        
    }

    
    //reset the background image with alpha
    if(css.backgroundImageURL!=nil)
    {
        [super setBackgroundImageUrl:css.backgroundImageURL];
    }
}

//adjust label  itself's true size by coculated by the WIDTH, and its parent's size
-(void)adjustSize:(CGFloat) width
{
    [self adjustSelfSize:width];
    //adjust parent's frame size
    if([parent isKindOfClass:[OLALinearLayout class]])
    {
        NSLog(@"label repaint...");
        LinearLayout * container=(LinearLayout *)parent.v;
        [container resizeToFitMaxChild];
    }



}

@end
