//
//  OLATextField.h
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAView.h"
#import "OLATextView.h"

@interface OLATextField : OLATextView<UITextFieldDelegate>
- (id) initWithParent:(OLAView *)parent withXMLElement:(XMLElement *) root;
-(void)setText:(NSString *) text;
- (NSString *) getText;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
@end
