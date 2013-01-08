//
//  vcmessageOverlay.m
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  //NSLog(@"touches");
  self.view.hidden = YES;
  [self.forawardView touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
}


@end