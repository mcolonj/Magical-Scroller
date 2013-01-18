//
//  Scroller.h
//  MichaelColon
//
//  Created by Michael Colon on 1/4/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollController.h"

@interface Scroller : UIViewController <UIScrollViewDelegate> {
  
  //ScrollController *scrollController;
  
  NSMutableArray *viewControllers;
  NSMutableArray *messages;
  UIView *overlayView;
  UIScrollView *scrollView;
  ViewOverlay *overlay;
  
  int messageIndex;
  int currentPage;
  //int numberOfPages;
  BOOL justLoaded;
}

//@property (nonatomic, retain) IBOutlet ScrollController *scrollController;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) IBOutlet UIView *overlayView;


-(id)init;
@end
