//
//  View.m
//  MichaelColon
//
//  Created by Michael Colon on 1/4/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import "View.h"

@interface View ()

@end

@implementation View

@synthesize message;

- (id)initWithPageNumber:(int)page {
  
  self = [super init];
  if (self) {
    
    pageNumber = page;
    
    
    
  }
  return self;
  
  
}

-(void) loadView {

  UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  view.backgroundColor = [UIColor blackColor];
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  view.autoresizesSubviews = YES;
  view.contentMode = UIViewContentModeScaleAspectFill;
  
  message = [[UILabel alloc] initWithFrame:view.frame];
  message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  message.contentMode = UIViewContentModeScaleAspectFill;
  message.numberOfLines = 6;
  message.lineBreakMode = NSLineBreakByWordWrapping;
  [view addSubview:message];
  
  self.view = view;
  
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}



@end
