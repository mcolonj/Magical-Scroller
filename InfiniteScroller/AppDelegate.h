//
//  AppDelegate.h
//  InfiniteScroller
//
//  Created by Michael Colon on 1/8/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scroller.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Scroller *viewController;
@end
