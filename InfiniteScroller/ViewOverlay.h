//
//  vcTweetOverlay.h
//  MichaelColon
//
//  Created by Michael Colon on 1/4/13.
//  Copyright (c) 2013 Michael Colon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewOverlay : UIViewController {
  
  UILabel *message;
  
}


@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) IBOutlet UIScrollView *forawardView;

@end
