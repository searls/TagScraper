//
//  TSDemoAppDelegate.m
//  TSDemo
//
//  Created by Juice on 8/8/09.
//  Copyright Justin Searls 2009. All rights reserved.
//

#import "TSDemoAppDelegate.h"
#import "TSDemoViewController.h"

@implementation TSDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  
  //Test 1
  Tag *someTag = [[[Tag alloc] initWithName:@"My Name!"] autorelease];
  NSLog(someTag.name);
  
  //Test 2
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample-1" ofType:@"html"];
  NSData *sample1data = [NSData dataWithContentsOfFile:filePath];
  NSArray *results = [XPathQuery performQueryWithXPath:@"//p" onDocument:sample1data shouldTreatAsHTML:YES returningAsTags:YES];
  Tag *tag = [results objectAtIndex:0];
  NSLog([tag retrieveTextUpToDepth:1]);
  
  
  // Override point for customization after app launch    
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];
}


- (void)dealloc {
  [viewController release];
  [window release];
  [super dealloc];
}


@end
