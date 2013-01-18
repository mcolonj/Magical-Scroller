//
//  Scroller.h
//  MichaelColon
//
//  Created by Michael Colon on 1/4/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewOverlay.h"
#import "View.h"


@interface Scroller : UIViewController <UIScrollViewDelegate> {
  
  //ScrollController *scrollController;
  
  NSMutableArray *viewControllers;
  NSMutableArray *messages;
  UIView *overlayView;
  UIScrollView *scrollView;
  ViewOverlay *overlay;
  
  int messageIndex;
  int currentPage;
  BOOL justLoaded;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) IBOutlet UIView *overlayView;


-(id)init;
@end
