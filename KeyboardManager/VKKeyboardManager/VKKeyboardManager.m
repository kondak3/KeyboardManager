//
//  VKKeyboardManager.m
//  KeyboardManager
//
//  Created by Kondaiah V on 8/21/18.
//  Copyright © 2018 Veeraboyina Kondaiah. All rights reserved.
//

#import "VKKeyboardManager.h"

#define tool_height 40
@interface VKKeyboardManager () {
    
    // variables...
    BOOL _initialize;
    // placeholder message lable...
    UILabel *_placeholder;
    // toolbar...
    UIToolbar *_toolBar;
    // textfiled for assign..
    UITextField *_textField;
    // textview for assign...
    UITextView *_textView;
	// disable...
	BOOL _disable;

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
	_disable = NO;
    
    // add only once...
    if (!_initialize) {
        
        _initialize = YES;
        [self create_toolbar];
        [self add_observers];
    }
}

// keyboard manager disable...
- (void)setDisable {
	_disable = YES;
}

#pragma mark -
- (void)create_toolbar {
	
    // done buttons...
    UIButton *_doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.frame = CGRectMake(0, 0, 50, tool_height);
    _doneBtn.backgroundColor = [UIColor clearColor];
    _doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor colorWithRed:30.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_doneBtn addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];

	
	UIView *_emptyView = [[UIView alloc] init];
	_emptyView.frame = CGRectMake(0, 0, 50, tool_height);
	_emptyView.backgroundColor = [UIColor clearColor];
	
	
    // place holder label...
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, tool_height)];
    _placeholder.textColor = [UIColor grayColor];
    _placeholder.textAlignment = NSTextAlignmentCenter;
    _placeholder.numberOfLines = 2;
    _placeholder.minimumScaleFactor = 8;
    _placeholder.font = [UIFont systemFontOfSize:12];
    _placeholder.backgroundColor = [UIColor clearColor];
	
	
    // tool bar creation...
	UIBarButtonItem *space_area = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				target:nil action:nil];
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	_toolBar.items = @[[[UIBarButtonItem alloc] initWithCustomView:_emptyView], space_area,
					   [[UIBarButtonItem alloc] initWithCustomView:_placeholder], space_area,
					   [[UIBarButtonItem alloc] initWithCustomView:_doneBtn]];
    [_toolBar sizeToFit];
}

- (void)add_toolbar {
	
	// keyboard disable...
	if (_disable == YES) {
		return;
	}
	[self frame_adjustment];

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
	// orientation notifications...
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(deviceOrientationDidChange:)
												 name: UIDeviceOrientationDidChangeNotification
											   object: nil];
}

- (void)dealloc {
    
    // dealloc all notifications...
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidEndEditingNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIDeviceOrientationDidChangeNotification
												  object:nil];
}

#pragma mark -
- (void)deviceOrientationDidChange:(NSNotification *)notification {
	[self dismissKeyboard];
}

- (void)frame_adjustment {
	
	if (_placeholder != nil) {
		
		// orientation checking...
		UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
			_placeholder.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 140), tool_height);
		} else {
			_placeholder.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 280), tool_height);
		}
		
		// adjustment menu...
		if (_toolBar.items.count >= 3) {
			
			NSMutableArray *temp_array = [_toolBar.items mutableCopy];
			[temp_array replaceObjectAtIndex:2 withObject:[[UIBarButtonItem alloc] initWithCustomView:_placeholder]];
			_toolBar.items = temp_array;
			[_toolBar sizeToFit];
		}
	}
}

#pragma mark -
- (void)keyboardWillShow:(NSNotification *)notification {
    
	// keyboard disable...
	if (_disable == YES) {
		return;
	}
	
	// getting textfield y-axis...
    UIWindow *_window = UIApplication.sharedApplication.keyWindow;
    CGRect fieldRect;
    if (_textField != nil) {
        fieldRect = [_window convertRect:_textField.bounds fromView:_textField];
    }
    else if (_textView != nil) {
        fieldRect = [_window convertRect:_textView.bounds fromView:_textView];
    }
    else {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
    float upperVal = -kbSize.height + height;

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
    
	// keyboard disable...
	if (_disable == YES) {
		return;
	}
	
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
        [_textView becomeFirstResponder];
    }
}

- (void)textView_textDidEndEditing:(NSNotification *)notification {
    
    // at end editing remove textview...
    _textView = nil;
}

@end
