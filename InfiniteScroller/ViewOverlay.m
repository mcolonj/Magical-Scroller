//
//  ViewOverlay.m
//  MichaelColon
//
//  Created by Michael Colon on 1/4/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import "ViewOverlay.h"

@interface ViewOverlay ()

@end

@implementation ViewOverlay

@synthesize message;
- (id)init
{
    self = [super init];
    if (self) {
      
      
      UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
      view.backgroundColor = [UIColor blackColor];
      view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      view.autoresizesSubviews = YES;
      view.contentMode = UIViewAutoresizingFlexibleWidth;
      
      message = [[UILabel alloc] initWithFrame:view.frame];
      message.numberOfLines = 6;
      message.autoresizesSubviews  = YES ;
      message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      message.contentMode = UIViewContentModeScaleAspectFill;
      message.lineBreakMode = NSLineBreakByWordWrapping;
      [view addSubview:message];
      
      self.view = view;
    }
    return self;
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
