//
//  TwitterContentController.m
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

@synthesize scrollView, pageControl, viewControllers, parentView;
@synthesize overlayView = overlayView;


-(id) init {
  
  self = [super init];
  if ( self ) {
    
  }
  return self;
  
}

- (void)awakeFromNib
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
  
  pageControl.numberOfPages = kNumberOfPages;
  pageControl.currentPage = 0;
  
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


- (UIView *)view
{
  return self.scrollView;
}

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

-(void)updateTweets {
  

}

-(void) loadOverlay {
  
  int scrollTo = 1;
  int page = pageControl.currentPage;

  View *currentView = [viewControllers objectAtIndex:pageControl.currentPage];
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

-(void) removeOverlay {

  
  
  
  overlay.view.hidden = YES;
  
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
  // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
  // which a scroll event generated from the user hitting the page control triggers updates from
  // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
  if (pageControlUsed)
  {
    // do nothing - the scroll was initiated from the page control, not the user dragging
    return;
  }
	
  // Switch the indicator when more than 50% of the previous/next page is visible
  CGFloat pageWidth = scrollView.frame.size.width;
  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  
  pageControl.currentPage = page;
  
  
  // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];
  
  
  

  
  // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  //NSLog(@"begin scrolling");
  [self removeOverlay];
  pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  [self loadOverlay];

  //NSLog(@"decelerated");
  pageControlUsed = NO;
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView  {
  //NSLog(@"scrollview did end scrolling");
  //if ( pageControl.currentPage != 1 )
  //  NSLog(@"do magic %i", pageControl.currentPage);
}

- (IBAction)changePage:(id)sender
{
  //NSLog(@"change page");
  int page = pageControl.currentPage;
	
  // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];
  
	// update the scroll view to the appropriate page
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:YES];
  
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
  pageControlUsed = YES;
}

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
