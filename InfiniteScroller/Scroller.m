//
//  Scroller.m
//  MichaelColon
//
//  Created by Michael Colon on 1/4/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import "Scroller.h"

static NSUInteger kNumberOfPages = 3;

@interface Scroller ()

@end

@implementation Scroller

@synthesize viewControllers, scrollView, overlayView;

-(id) init {
  
  if ( (self = [super init]) ) {
    
  }
  return self;
  
}

-(void) loadView {

  [super loadView];
  
  CGRect frame = [[UIScreen mainScreen] bounds];
  
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.backgroundColor = [UIColor yellowColor];
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  view.autoresizesSubviews = YES;
  view.contentMode = UIViewContentModeScaleAspectFill;

  scrollView = [[UIScrollView alloc] initWithFrame:frame];
  scrollView.backgroundColor = [UIColor blackColor];
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  scrollView.autoresizesSubviews = YES;
  scrollView.contentMode = UIViewContentModeScaleAspectFill;
  
  [view addSubview:scrollView];
  
  self.view = view;
  
  [self setupViews];
  NSLog(@"loadView");
  
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//  
//  NSLog(@"did rotate %@", NSStringFromCGRect(scrollView.bounds));
//}
//
//-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//  NSLog(@"will rotate fired");
//}

-(void) viewWillLayoutSubviews {
  
  // minimal setup when rotating
  //reset scrollview contentsize, reload the left page and visible page.
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
  
  [self loadScrollViewWithPage:0];
  [self loadScrollViewWithPage:1];
  [self loadScrollViewWithPage:2];

  [self moveScrollViewTo:1 animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
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

- (void)setupViews
{
  
  if (messages == nil )
    [self loadMessages];
  
  NSMutableArray *controllers = [[NSMutableArray alloc] init];
  for (unsigned i = 0; i < kNumberOfPages+1; i++)
  {
		[controllers addObject:[NSNull null]];
  }
  self.viewControllers = controllers;
  
  [self sizeScrollView];
  scrollView.pagingEnabled = YES;

  scrollView.delegate = self;
  
  //numberOfPages = kNumberOfPages;
  currentPage = 0;
  
  // pages are created on demand
  // load the visible page
  // load the page on either side to avoid flashes when the user starts scrolling
  //
  [self loadScrollViewWithPage:0];
  [self loadScrollViewWithPage:1];
  
  
  // init overlay view
  overlay = [[ViewOverlay alloc] init];
  overlay.view.autoresizesSubviews = YES;
  overlay.view.hidden = YES;
  [self.view addSubview:overlay.view];
  
}

-(BOOL) isValidPage:(int) page {
  
  if (page < 0 || page >= kNumberOfPages)
    return NO;
  
  return YES;
}

-(void) sizeScrollView {
  
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
  
}

-(CGRect) frameForPage:(int)page {
  
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  
  return frame;
  
}

-(void) moveScrollViewTo:(int)page animated:(BOOL)animated {
  
  // update the scroll view to the appropriate page
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:animated];
  
}

-(View*) viewControllerForPage:(int)page {
  
  View *controller = [viewControllers objectAtIndex:page];
  if ((NSNull *)controller == [NSNull null])
  {
    controller = [[View alloc] initWithPageNumber:page];
    controller.view.autoresizesSubviews = YES;
    controller.view.contentMode = UIViewContentModeScaleAspectFill;
    [viewControllers replaceObjectAtIndex:page withObject:controller];
  }
  
  return controller;
  
}

// load scroll view with page
- (void)loadScrollViewWithPage:(int)page
{
  // check page is valid
  if ( ! [self isValidPage:page] ) return;

  //get view for page
  View* controller = [self viewControllerForPage:page];
  
  //set controller view frame for page
  controller.view.frame = [self frameForPage:page];
  
  // add the controller's view to the scroll view
  if (controller.view.superview == nil)
    [scrollView addSubview:controller.view];
  
  NSDictionary *dict = [messages objectAtIndex:messageIndex+page];
  controller.message.text = [dict valueForKey:@"text"];
  
}

// load the overlay view, scroll the scrollview to center view, unload overlay view
/*
 
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
  
  [self moveScrollViewTo:scrollTo animated:NO];
  
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
