//
//  View.h
//  MichaelColon
//
//  Created by Michael Colon on 1/4/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View : UIViewController {
  UILabel *message;
  int pageNumber;
}

- (id)initWithPageNumber:(int)page;

@property (nonatomic, retain) IBOutlet UILabel *message;

@end
