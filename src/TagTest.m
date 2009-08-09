//  Created by Juice on 8/8/09.

#import "TagTest.h"
#import "TagScraper.h"

@implementation TagTest

@synthesize sampleOne = _sampleOne;

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

#else                           // all code under test must be linked into the Unit Test bundle

- (void) setUp {
  NSString * filePath = [[NSBundle bundleForClass:[self class] ] pathForResource:@"sample-1" ofType:@"html"];
  STAssertNotNil(filePath,@"Verify that sample-1.html has been added to the TagScraperTests target bundle.");
  
  self.sampleOne = [NSData dataWithContentsOfFile:filePath];  
}

- (void)testPrintingTags {
  Tag *html = [XPathQuery firstResultForXPathQuery:@"//html" onDocument:_sampleOne];
  STAssertNotNil(html, @"Element named 'html' should be present in the HTML file.");
  STAssertEqualObjects([html toHTML],@" <html> <head>BLERG!</head>  <body> <p>I'm some particularly dull-looking HTML.</p>  <table id=\"tableOfUtmostRelevance\"> <tr> <th>Header</th> </tr>  <tr> <td> <span atr=\"Garbage\">Worthless commentUseful data</span> </td> </tr>  <tr> <td> <span atr=\"Garbage\">Worthless commentUseful data</span> </td> </tr> </table>  <table>Excuse the mess, my HTML vendor thinks obfuscating HTML will keep him in business  <tr> <td /> </tr>  <tr> <td /> </tr>  <tr> <td /> </tr>  <tr> <td /> </tr>  <tr> <td /> </tr>  <tr> <td /> </tr>  <tr> <td>Important Data! <span>Cruft you don't need and a comment or <b>really</b> want</span> </td> </tr>  <tr /> </table> </body> </html> ",nil);
}

#endif


@end

