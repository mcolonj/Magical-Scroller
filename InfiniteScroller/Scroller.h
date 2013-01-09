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
  
  ScrollController *scrollController;
  
}

@property (nonatomic, retain) IBOutlet ScrollController *scrollController;

-(id)init;
@end
