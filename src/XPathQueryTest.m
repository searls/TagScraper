//  Copyright 2009 Justin Searls. All rights reserved.

#import "XPathQueryTest.h"


@implementation XPathQueryTest

@synthesize sampleOne = _sampleOne;

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application


#else               // all code under test must be linked into the Unit Test bundle

- (void) setUp {
  NSString * filePath = [[NSBundle bundleForClass:[self class] ] pathForResource:@"sample-1" ofType:@"html"];
  STAssertNotNil(filePath,@"Verify that sample-1.html has been added to the TagScraperTests target bundle.");
  
  self.sampleOne = [NSData dataWithContentsOfFile:filePath];  
}

- (void) testSimpleXpathQuery {
  NSArray *results = [XPathQuery performXPathQuery:@"//p" onDocument:_sampleOne isHTML:YES returnTags:YES];
  STAssertTrue([results count] > 0,@"Verify that sample-1.html has at least one <p> tag in it.");
  Tag *tag = [results objectAtIndex:0];
  NSString *contents = [tag retrieveTextUpToDepth:1];
  STAssertEqualObjects(contents, @"I'm some particularly dull-looking HTML.", nil);
}

- (void) testSimpleXpathQueryWithDictionary {
  NSArray *results = [XPathQuery performXPathQuery:@"//p" onDocument:_sampleOne isHTML:YES returnTags:YES];
  STAssertTrue([results count] > 0,@"Verify that sample-1.html has at least one <p> tag in it.");
  Tag *tag = [results objectAtIndex:0];
  NSString *contents = [tag retrieveTextUpToDepth:1];
  STAssertEqualObjects(contents, @"I'm some particularly dull-looking HTML.", nil);
}

- (void) testAttributeEquivalence {
  Tag *tag = [XPathQuery firstResultForXPathQuery:@"//table[@id=\"tableOfUtmostRelevance\"]" onDocument:_sampleOne];  
  STAssertNotNil(tag,@"Verify that a table with the ID 'tableOfUtmostRelevance' exists.");
}

- (void) testXPathTraversal {
  NSArray *results = [XPathQuery performXPathQuery:@"//table[2]/tr[last()-1]/td" onDocument:_sampleOne];
  STAssertTrue([results count] == 1,@"There should be one td on the second-to-last tr of the second table.");  
  Tag *td = [results objectAtIndex:0];
  
  //Dive only deep enough to get the text we want.
  NSString * contents = [td retrieveTextUpToDepth:1];
  STAssertEqualObjects(contents, @"Important Data!", nil);
  
  //Dive one more down and get text we don't want
  contents = [td retrieveTextUpToDepth:2];
  //Note that whitespace gets the axe by default
  STAssertEqualObjects(contents, @"Important Data! Cruft you don't need or want", nil);  

  //Dive all the way down and get text we REALLY don't want
  contents = [td retrieveText];
  //Note that whitespace gets the axe by default
  STAssertEqualObjects(contents, @"Important Data! Cruft you don't need or really want", nil);  
}

#endif

@end

