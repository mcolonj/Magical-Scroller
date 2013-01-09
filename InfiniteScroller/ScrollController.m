//
//  ScrollController.m
//  MichaelColon
//
//  Created by Michael Colon on 1/2/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//


#import "ScrollController.h"
#import "View.h"
#import "ViewOverlay.h"

static NSUInteger kNumberOfPages = 3;


@interface ContentController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end

@implementation ScrollController

@synthesize scrollView, viewControllers, parentView;
@synthesize overlayView = overlayView;


-(id) init {
  
  self = [super init];
  if ( self ) {
    
  }
  return self;
  
}

/**************************************************************
 
 -(void) loadView: will place three UIViews within a UIScrollView
 
 +-------------------------------------------------------------+
 |                                                             |
 |  ScrollView                                                 |
 |                             **                              |
 |                         active view                         |
 |   ______________     _______________    _________________   |
 |  |              |   |               |  |                 |  |
 |  |              |   |               |  |                 |  |
 |  |              |   |               |  |                 |  |
 |  |              |   |               |  |                 |  |
 |  |    view0     |   |     view1     |  |      view2      |  |
 |  |              |   |               |  |                 |  |
 |  |              |   |               |  |                 |  |
 |  |______________|   |_______________|  |_________________|  |
 |                                                             |
 |                                                             |
 |  Also, an overlay view is placed over the scrollview as a   |
 |  sibling subview to the UIWindow.                           |
 |                                                             |
 |                                                             |
 |                                                             |
 |                    +----------------+                       |
 |                    |                |                       |
 |                    |    overlay     |                       |
 |                    |      view      |                       |
 |                    |                |                       |
 |                    |                |                       |
 |                    +----------------+                       |
 |                                                             |
 +-------------------------------------------------------------+
 
***************************************************************/

- (void)loadView
{
  if (messages == nil )
    [self loadMessages];

  NSMutableArray *controllers = [[NSMutableArray alloc] init];
  for (unsigned i = 0; i < kNumberOfPages+1; i++)
  {
		[controllers addObject:[NSNull null]];
  }
  self.viewControllers = controllers;
  
  
  // a page is the width of the scroll view
  scrollView.pagingEnabled = YES;
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.scrollsToTop = NO;
  scrollView.delegate = self;
  
  numberOfPages = kNumberOfPages;
  currentPage = 0;
  
  // pages are created on demand
  // load the visible page
  // load the page on either side to avoid flashes when the user starts scrolling
  //
  [self loadScrollViewWithPage:0];
  [self loadScrollViewWithPage:1];
  
  overlay = [[ViewOverlay alloc] init];
  overlay.view.hidden = YES;
  [parentView addSubview:overlay.view];
  
}

// returns scrollview
- (UIView *)view
{
  return self.scrollView;
}


// load scroll view with page
- (void)loadScrollViewWithPage:(int)page
{
  
  if (page < 0)
    return;
  if (page >= kNumberOfPages)
    return;
  
  // replace the placeholder if necessary
  View *controller = [viewControllers objectAtIndex:page];
  if ((NSNull *)controller == [NSNull null])
  {
    controller = [[View alloc] initWithPageNumber:page];
    [viewControllers replaceObjectAtIndex:page withObject:controller];
  }
  
  // add the controller's view to the scroll view
  if (controller.view.superview == nil)
  {
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    controller.view.frame = frame;
    [scrollView addSubview:controller.view];
    
  }
  
  NSDictionary *dict = [messages objectAtIndex:messageIndex+page];
  controller.message.text = [dict valueForKey:@"text"];

  
}

// load the overlay view, scroll the scrollview to center view, unload overlay view
/*
-(void) loadView: will place three UIViews within a UIScrollView

 step 1
+-------------------------------------------------------------+
|                                                             |
|  ScrollView - scrolled                                      |
|                                                             |
|                                                             |
|                                                             |
|         **                                                  |
|     active view                                             |
|   ______________     _______________    _________________   |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |    view0     |   |     view1     |  |      view2      |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |______________|   |_______________|  |_________________|  |
|                                                             |
|                                                             |
+-------------------------------------------------------------+

 step 2
+-------------------------------------------------------------+
|                                                             |
|                                                             |
|  load overlay and fill with data from view0                 |
|                                                             |
|       **                                                    |
|                                                             |
|   ______________     _______________    _________________   |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |   overlay    |   |     view1     |  |      view2      |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |______________|   |_______________|  |_________________|  |
|                                                             |
|                                                             |
+-------------------------------------------------------------+

 step 3
+-------------------------------------------------------------+
|                                                             |
|                                                             |
|                                                             |
| Scroll the scroll view to center view. Load overlay data    |
|  onto view1. Unload overlay.                                |
|                                                             |
|                            **                               |
|                        active view                          |
|                                                             |
|   ______________     _______________    _________________   |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |    view0     |   |     view1     |  |      view2      |  |
|  |              |   |               |  |                 |  |
|  |              |   |               |  |                 |  |
|  |______________|   |_______________|  |_________________|  |
|                                                             |
|  Also, an overlay view is placed over the scrollview as a   |
|  sibling subview to the UIWindow.                           |
|                                                             |
|                                                             |
|                                                             |
|                    +----------------+                       |
|                    |                |                       |
|                    |    overlay     |                       |
|                    |      view      |                       |
|                    |                |                       |
|                    |                |                       |
|                    +----------------+                       |
|                                                             |
+-------------------------------------------------------------+

***************************************************************/

-(void) loadOverlay {
  
  int scrollTo = 1;
  int page = currentPage;

  View *currentView = [viewControllers objectAtIndex:currentPage];
  overlay.message.text = currentView.message.text;
  
  overlay.view.hidden = NO;
  
  if ( page == 0 )
    messageIndex--;
  else if ( page == 2 )
    messageIndex++;
  
  if (messageIndex < 0 ) {
    messageIndex = 0;
    scrollTo = 0;
  } else if (messageIndex > [messages count] - 3) {
    messageIndex = [messages count] - 3;
    scrollTo = kNumberOfPages;
  }
  
  // update the scroll view to the appropriate page
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * scrollTo;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:NO];
  
  overlay.view.hidden = YES;
  
}


// remove overlay view
-(void) removeOverlay {
  
  overlay.view.hidden = YES;
  
}

// load each page with data on scroll.
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	
  // Switch the indicator when more than 50% of the previous/next page is visible
  CGFloat pageWidth = scrollView.frame.size.width;
  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  
  currentPage = page;
  
  
  // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  //override if necessary
}

// load scroll view at end of deceleration. Fired once for each scroll.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  //load overlay view.
  [self loadOverlay];

}

// sends end of scrolling event.
- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView  {
  //NSLog(@"scrollview did end scrolling");
}


// load views with mock data.
-(void) loadMessages {
  
  messages = [[NSMutableArray alloc] initWithCapacity:100];
  for ( int i = 0; i<100; i++)
  {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *text = [NSString stringWithFormat:@"page: %i", i];
    [dict setValue:text forKey:@"text"];
    [messages addObject:dict];
  }

  messageIndex = 0;
}




@end
