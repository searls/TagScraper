//
//  TSDemoAppDelegate.h
//  TSDemo
//
//  Created by Juice on 8/8/09.
//  Copyright Justin Searls 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagScraper.h"

@class TSDemoViewController;

@interface TSDemoAppDelegate : NSObject <UIApplicationDelegate> {  
  UIWindow *window;
  TSDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TSDemoViewController *viewController;

@end

