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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,460)];
    view.backgroundColor = [UIColor blackColor];
    message = [[UILabel alloc] initWithFrame:view.frame];
    message.numberOfLines = 6;
    message.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:message];
    
    self.view = view;
    
  }
  return self;
  
  
}

//-(void) loadView {
//
//}

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


@end
