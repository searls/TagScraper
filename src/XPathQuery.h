//
//  XPathQuery.m
//
//  This class was adapted from code originally created by Matt Gallagher on 4/08/08.
//  For reference, see Matt Gallagher's blog post describing this technique:
//  http://cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html
//
//  The class was later expanded by Justin Searls.
//

#define XPATH_STRING_ENCODING NSISOLatin1StringEncoding

@class Tag;

@interface XPathQuery : NSObject

/* This method should be somewhat straightforward (not to say it'll fit all uses / encodings, etc.),
 *  however, the "returnTags" parameter is probably going to appear cryptic.
 *
 *  If you send returnTags:YES, returns an NSArray of Tag objects, each acting as the root of a tree to other Tag objects in the document
 *
 *  If you send returnTags:NO, returns an NSArray of NSDictionary objects will be returned, with these keys
 *   nodeName — an NSString containing the name of the node
 *   nodeContent — an NSString containing the textual content of the node
 *   nodeAttributeArray — an NSArray of NSDictionary where each dictionary has two keys: attributeName (NSString) and nodeContent (NSString)
 *   nodeChildArray — an NSArray of child nodes (same structure as this node)
 ***************************************************/
+ (NSArray*) performXPathQuery:(NSString*)xpath onDocument:(NSData*)document isHTML:(BOOL)html returnTags:(BOOL)useTags;
+ (NSArray*) performXPathQuery:(NSString*)xpath onDocument:(NSData*)document isHTML:(BOOL)html; //returnTags:YES
+ (NSArray*) performXPathQuery:(NSString*)xpath onDocument:(NSData*)document; //isHTML:YES //returnTags:YES

//Convenience method for when one result is expected
+ (Tag*) firstResultForXPathQuery:(NSString*)xpath onDocument:(NSData*)document; //isHTML:YES //returnTags:YES

@end