//
//  VKKeyboardManager.h
//  KeyboardManager
//
//  Created by Kondaiah V on 8/21/18.
//  Copyright © 2018 Veeraboyina Kondaiah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// interface...
@interface VKKeyboardManager : NSObject

// default gap between keyboard and textfiled/textview...
@property (nonatomic, assign) float keyboard_gap;

// instance...
+ (VKKeyboardManager *)shared;

// enable keyboard manager...
- (void)setEnable;

@end
