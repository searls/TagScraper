//  Created by Justin Searls on 5/15/09.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.
#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
//#import "application_headers" as required


@interface TagTest : SenTestCase {
  NSData *_sampleOne;
}

@property (nonatomic, retain) NSData *sampleOne;

#if USE_APPLICATION_UNIT_TEST

#else

- (void)testPrintingTags;

#endif

@end

