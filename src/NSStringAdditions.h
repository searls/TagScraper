//  Created by Justin Searls on 5/15/09.

#import <Foundation/Foundation.h>


@interface NSString (TagScraper)

- (BOOL)isEmptyIgnoringWhitespace;

// These two are very important and simultaneously nowhere near complete.
// Their names are also bad.
// There is virtually nothing good about these methods.
- (NSString*)stringByReplacingXMLElementEntities;
- (NSString*)stringByUnescapingXMLElementEntities;


- (NSString*)stringByRemovingCharactersInString:(NSString*)chars removeWhitespace:(BOOL)whitespace;
- (NSString*)stringByRemovingCharactersInSet:(NSCharacterSet*)charSet options:(unsigned) mask;

/**
 * Here's the use case. You have a bunch of characters/tokens within a big string that need to be swapped
 * out for different characters/tokens in a pairwise fashion. (say, specific html entities). So you just
 * pass them in here, like so: @"firstToken", @"firstToken's Replacement",@"secondToken", etc.
 *
 */
- (NSString*)stringByReplacingEachStringWithTheNext:(NSString *)token, ... NS_REQUIRES_NIL_TERMINATION;

@end
