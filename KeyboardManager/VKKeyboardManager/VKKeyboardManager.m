//
//  VKKeyboardManager.m
//  KeyboardManager
//
//  Created by Kondaiah V on 8/21/18.
//  Copyright © 2018 Veeraboyina Kondaiah. All rights reserved.
//

#import "VKKeyboardManager.h"

#define tool_height 35
@interface VKKeyboardManager () {
    
    // variables...
    BOOL _initialize;
    // placeholder message lable...
    UILabel *_placeholder;
    // toolbar...
    UIToolbar *_toolBar;
    // done button for keyboard resign...
    UIButton *_doneBtn;
    // textfiled for assign..
    UITextField *_textField;
    // textview for assign...
    UITextView *_textView;
}
@end

@implementation VKKeyboardManager

// instance...
+ (VKKeyboardManager *)shared {
    
    static id _instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// keyboard manager enable...
- (void)setEnable {
    
    // default gap...
    if (_keyboard_gap == 0) {
        _keyboard_gap = 5.0;
    }
    
    // add only once...
    if (!_initialize) {
        
        _initialize = YES;
        [self create_toolbar];
        [self add_observers];
    }
}

#pragma mark -
- (void)create_toolbar {
    
    // parent view creations...
    UIView *parent_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 40), tool_height)];
    parent_view.backgroundColor = [UIColor clearColor];

    // done buttons...
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.frame = CGRectMake((parent_view.frame.size.width - 50), 0, 50, tool_height);
    _doneBtn.backgroundColor = [UIColor clearColor];
    _doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor colorWithRed:30.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_doneBtn addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [parent_view addSubview:_doneBtn];

    // place holder label...
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(115/2, 0, (parent_view.frame.size.width - 115), tool_height)];
    _placeholder.textColor = [UIColor grayColor];
    _placeholder.textAlignment = NSTextAlignmentCenter;
    _placeholder.numberOfLines = 2;
    _placeholder.minimumScaleFactor = 8;
    _placeholder.font = [UIFont systemFontOfSize:12];
    _placeholder.backgroundColor = [UIColor clearColor];
    [parent_view addSubview:_placeholder];
    
    // tool bar creation...
    UIBarButtonItem *button_items = [[UIBarButtonItem alloc] initWithCustomView:parent_view];
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    _toolBar.items = @[button_items];
    [_toolBar sizeToFit];
}


- (void)add_toolbar {
    
    // tool bar width....
    float final_width = ([UIScreen mainScreen].bounds.size.width - 40);
    _doneBtn.frame = CGRectMake((final_width - 50), 0, 50, tool_height);
    _placeholder.frame = CGRectMake(115/2, 0, (final_width - 115), tool_height);
    
    // assign tool bar to textfiled/textview...
    if (_textField != nil) {
        
        _placeholder.text = _textField.placeholder;
        _textField.inputAccessoryView = _toolBar;
    } else {
        
        _placeholder.text = @"";
        _textView.inputAccessoryView = _toolBar;
    }
}

- (UIViewController *)getController:(UIView *)childView {
    
    // getting parent ctrl...
    UIResponder *responder = childView;
    do {
        
        // move to next responder...
        responder = [responder nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            
            // getting final controller...
            return (UIViewController *)responder;
        }
    } while( responder != nil);
    return nil;
}

- (UIViewController *)getController {
    
    // getting textfiled/textview view control...
    if (_textField != nil)
        return [self getController:_textField];
    else
        return [self getController:_textView];
}

- (void)add_observers {
    
    // textfiled notifications...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textField_textDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textField_textDidEndEditing:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:nil];
    // textview notifications...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textView_textDidBeginEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textView_textDidEndEditing:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:nil];
    
    // keyboard notifications...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc {
    
    // dealloc all notifications...
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
}

#pragma mark -
- (void)keyboardWillShow:(NSNotification *)notification {
    
    // getting textfield y-axis...
    UIWindow *_window = UIApplication.sharedApplication.keyWindow;
    CGRect fieldRect;
    if (_textField != nil) {
        fieldRect = [_window convertRect:_textField.bounds fromView:_textField];
    }
    else if (_textView != nil) {
        fieldRect = [_window convertRect:_textField.bounds fromView:_textField];
    }
    else {
        return;
    }
    
    // default height...
    if (_keyboard_gap <= 5.0 || _keyboard_gap >= 101.0) {
        _keyboard_gap = 5.0;
    }
    float yValue = fieldRect.size.height + fieldRect.origin.y + _keyboard_gap;
    
    // screen height calculations...
    CGRect screenSize = [UIScreen mainScreen].bounds;
    float height = screenSize.size.height - yValue;
    if (height < 0) {
        height = 0;
    }
    
    // if we didn't get view controller...
    UIViewController *viewCtrl = [self getController];
    if (viewCtrl == nil) {
        return;
    }
    
    // Keyboard height....
    NSDictionary *userInfo = notification.userInfo;
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    float upperVal = -kbSize.height+height;
    
    // getting view controller "self" view
    UIView *mainView = viewCtrl.view;
    if (height < kbSize.height) {
        
        // view move to up...
        [UIView animateWithDuration:0.5 animations:^{
            mainView.frame = CGRectMake(0, upperVal, mainView.frame.size.width, mainView.frame.size.height);
        }];
    }
    else {
        
        // view move to down...
        [UIView animateWithDuration:0.5 animations:^{
            mainView.frame = CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    // if we didn't get view controller...
    UIViewController *viewCtrl = [self getController];
    if (viewCtrl == nil) {
        return;
    }
    
    // getting view controller "self" view
    UIView *mainView = viewCtrl.view;
    
    // view move to down...
    [UIView animateWithDuration:0.5 animations:^{
        mainView.frame = CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height);
    }];
}

- (void)dismissKeyboard {
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
}

#pragma mark -
- (void)textField_textDidBeginEditing:(NSNotification *)notification {
    
    // getting textfield which one user editing...
    if ([notification.object isKindOfClass:[UITextField class]]) {
        
        _textField = (UITextField *)notification.object;
        [self add_toolbar];
    }
}

- (void)textField_textDidEndEditing:(NSNotification *)notification {

    // at end editing remove textfiled...
    _textField = nil;
}

- (void)textView_textDidBeginEditing:(NSNotification *)notification {
    
    // getting textview which one user editing...
    if ([notification.object isKindOfClass:[UITextView class]]) {
        
        _textView = (UITextView *)notification.object;
        [self add_toolbar];
    }
}

- (void)textView_textDidEndEditing:(NSNotification *)notification {
    
    // at end editing remove textview...
    _textView = nil;
}

@end
