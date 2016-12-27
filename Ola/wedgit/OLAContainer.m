//
//  OLAContainer.m
//  Ola
//
//  Created by Terrence Xing on 3/23/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAContainer.h"

#import "OLAView.h"
#import "OLALayout.h"
#import "OLAProperties.h"
#import "OLAButton.h"
#import "OLATable.h"
#import "OLALuaContext.h"
#import "OLAUIFactory.h"
#import "UILabelEx.h"
#import "OLALabel.h"
#import "OLALinearLayout.h"
#import "LinearLayout.h"


@implementation OLAContainer

- (id) initWithParent:(OLAView *) viewParent  withXMLElement:(XMLElement *) xmlRoot andUIFactory:(OLAUIFactory *)uiFactory
{
    return [super initWithParent:viewParent withXMLElement:xmlRoot andUIFactory:uiFactory];
    //return self;
}
//	- void addView(View child)
//	{
//		((ViewGroup)v).addView(child);
//		//child.requestLayout();
//	}
//	void addView(OLAView * child)
//	{
//		((ViewGroup)v).addView(child.getView());
//		//child.getView().requestLayout();
//	}

- (void) parseChildren:(OLAContainer *) rootView withXMLElement:(XMLElement *) rootEle
{
    NSLog(@"start to parse children...");
    for (XMLElement * n in rootEle.children)
    {
        
        //if (n != null && n.getXMLElementType() == XMLElement.ELEMENT_XMLElement)
        {
            NSString * name=n.tagName;
            NSLog(@"view=%@,text=%@",name,n.textContent.value);
            if([name caseInsensitiveCompare:@"DIV"]==NSOrderedSame)
            {
                NSString * layoutName=[n.attributes objectForKey:@"layout"];
                /*
                if([layoutName caseInsensitiveCompare:@"FrameLayout"]
                   || ([layoutName caseInsensitiveCompare:@"LinearLayout"])
                   || ([layoutName caseInsensitiveCompare:@"RelativeLayout"])
                   || ([layoutName caseInsensitiveCompare:@"WebView"])
                   )
                 */
                {
                    OLALayout * layout= [ui createLayout:rootView withXMLElement:n];//Layout.createLayout(rootView,self.context,n);
                    [rootView addSubview:layout];
                }
            }
            else
            {
                OLAView * view=[ui createView:rootView withXMLElement:n];//UIFactory.createView(rootView, context,   n);
                [rootView addSubview:view];
                
            }
            
            
        }
    }
}


- (void) addSubview:(OLAView *) child
{
    //implemented by sub class
}

- (void) addOlaView :(OLAView *) child
{
    
    if(child.parent==nil)
    {
        child.parent=self;
        //rebuild the properties of the view.
        //be rebuilt by the setParent method
        //((IWedgit)child).parseCSS();
    }
   // [self addSubview:child];

    
    Layout *layout = (Layout *)v;
    CGFloat  origionalW=layout.frame.size.width;
    CGFloat origionalH=layout.frame.size.height;
    
    [self addSubview:child];
    //adjust the Label's acture size, and the layout will be shrinked
    if([child isKindOfClass:[OLALabel class]])
    {
        OLALabel *label =(OLALabel *)child;
        [label adjustSelfSize:v.frame.size.width];
    }
    //repaint the layout with its origional size
    //[v setFrame:size];
    
    
    [self repaint];
    
    //check to see if it needes to repaint parent container view or not
    BOOL needRepaint=NO;
    /*
     if([layout isKindOfClass:[LinearLayout class]])
     {
     LinearLayout *ll=(LinearLayout *)layout;
     
     if(ll.orientation==horizontal &&  (strncmp(ll.layoutParams->align, "center",6)==0 || strncmp(ll.layoutParams->align, "right",5)==0))
     {
     needRepaint=YES;
     }
     else
     {
     needRepaint=YES;
     }
     }
     else
     */
    //NSLog(@"Container[addView] -- Info -- object=%@",objId);
    //NSLog(@"Container[addView] -- Info -- origionalW=%f,origionalH=%f",origionalW,origionalH);
    //NSLog(@"Container[addView] -- Info -- frame.width=%f,frame.height=%f",layout.frame.size.width,layout.frame.size.height);
    if(origionalW<layout.frame.size.width || origionalH<layout.frame.size.height)
    {
        //the origional view's size is larger than the size of after added a child
        //so it is need to repaint the parent
        needRepaint=YES;
    }
    if(needRepaint)
    {
        OLAView * containerParent=parent;
        while([containerParent.parent isKindOfClass:[OLALayout class]])
        {
            containerParent=containerParent.parent;
        }
        OLALayout *layout1= (OLALayout *)containerParent;
        [layout1  setFrameMinSize];
        [layout1 repaint];
        //set min or max frame of subviews
        //[(Layout *)layout1.v setFrameMinSize];
        //[(Layout *)layout1.v repaint];
    }

    
    
    
    //child.getView().requestLayout();
}
/*
 - void removeView(OLAView * child) {
 if (child==null) return;
 ((ViewGroup) v).removeView(child.getView());
 
 }
 */
/**
 * add a child by Lua id, self method will be used by the lua script
 * @param id
 */
- (void) addView:(NSString *) objLuaId
{
    //CGRect size=self.v.frame;
    //lua.getGlobal(id);
    OLAView * obj=[[OLALuaContext getInstance]  getObject:objLuaId];
    [self addOlaView:obj];
    
}

-(void) removeOlaView:(OLAView *) view
{
    [view.v removeFromSuperview];
}

/**
 * remove a child view from the current container by the child's lua id
 * @param id
 */
- (void) removeView:(NSString *) objId
{
    id obj=[[OLALuaContext getInstance]  remove:objId];
    //v remove//removeView((OLAView *)obj);
    [self removeOlaView:obj];
}

- (void) removeAllViews
{
    for(UIView * view in [v subviews])
    {
        [view removeFromSuperview];
    }
}


- (void) repaint
{
    
}
- (void) setFrameMinSize
{
    
}

@end
