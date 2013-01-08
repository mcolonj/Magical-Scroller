//
//  vcTwitter.m
//  MichaelColon
//
//  Created by Michael Colon on 1/4/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import "Scroller.h"

@interface Scroller ()

@end

@implementation Scroller

@synthesize scrollController;

-(void) loadView {

  
  [super loadView];

  scrollController = [[ScrollController alloc] init];
  self.scrollController = scrollController;
  
  CGRect frame = [[UIScreen mainScreen] bounds];
  
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.backgroundColor = [UIColor whiteColor];

  
  UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
  [view addSubview:pageControl];
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
  scrollView.backgroundColor = [UIColor blackColor];
  
  [view addSubview:scrollView];
  scrollController.scrollView = scrollView;
  scrollController.parentView = view;
  scrollController.pageControl = pageControl;
  
  self.view = view;
  [scrollController awakeFromNib];
  
  
}


- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void) viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
