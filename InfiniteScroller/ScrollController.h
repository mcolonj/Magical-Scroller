//
//  TwitterContentController.h
//  MichaelColon
//
//  Created by Michael Colon on 1/2/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import "ContentController.h"
#import "View.h"
#import "ViewOverlay.h"


@interface ScrollController : ContentController <UIScrollViewDelegate> {
  
  UIScrollView *scrollView;
  UIPageControl *pageControl;
  NSMutableArray *viewControllers;
  NSMutableArray *messages;
  UIView *parentView;
  ViewOverlay *overlay;
  UIView *overlayView;
  NSTimer *timer;
  
  
  // To be used when scrolls originate from the UIPageControl
  BOOL pageControlUsed;
  int messageIndex;
  
  
  
}


@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) IBOutlet UIView *parentView;
@property (nonatomic, retain) IBOutlet UIView *overlayView;

-(id)init;
- (IBAction)changePage:(id)sender;
-(void) loadMessages;



@end
