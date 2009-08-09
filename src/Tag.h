//  Created by Justin Searls on 4/25/09.

#import <Foundation/Foundation.h>


@interface Tag : NSObject {
	NSString *_name;
	NSMutableDictionary *_attributeDict;
	NSString *_text;
	
  //This is a Three20 reference.
	BOOL _willBeStyled;
	
	NSMutableArray *_children;
  
  BOOL _childTextFound; //Used as a scratchpad for recursion
}

@property (nonatomic, retain) NSMutableArray *children;
@property BOOL willBeStyled; 
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableDictionary *attributeDict;

- (id)initWithName:(NSString*)aName;
- (id)initWithName:(NSString*)aName text:(NSString*)someText;
- (id)initWithName:(NSString*)aName text:(NSString*)someText attributes:(NSMutableDictionary*)attributes;
/** Designated initializer **/
- (id)initWithName:(NSString*)aName text:(NSString*)someText attributes:(NSMutableDictionary*)attributes willBeStyled:(BOOL)isStyled;

/** Mutators **/
- (void)addChildTag:(Tag*)tag;
- (void)addText:(NSString*)someText;
- (void)addAttributeWithName:(NSString*)attrName value:(NSString*)attrValue;
- (void)setAttributeWithName:(NSString*)attrName value:(NSString*)attrValue onChildrenWithTagName:(NSString*)tagName;

/** Child retrievers **/
- (NSArray*)childrenWithoutText; //Returns the child array but cuts text, comment elements
- (NSArray*)childrenWithTagName:(NSString*)name;
- (Tag*)childWithTagName:(NSString*)name atIndex:(NSUInteger)index;
- (Tag*)firstChildWithTagName:(NSString*)name;
- (Tag*)lastChildWithTagName:(NSString*)name;

/** Attr retrievers **/
- (NSString*) valueForAttribute:(NSString*)aName; //escapeHtmlEntities:YES
- (NSString*) valueForAttribute:(NSString*)aName escapeHtmlEntities:(BOOL)shouldEscape;

/** Text retrievers, concatenating children TEXT elements **/
/* TODO: All whitespace is already stripped within each tag. Elegant solution to this..? */
/* Note: maxDepth of '-1' will just keep on recursing until you run out of tags. */
- (NSString*)retrieveTextUpToDepth:(NSUInteger)depth escapeHtmlEntities:(BOOL)shouldEscape addSpaceBetweenTags:(BOOL)addSpace;
- (NSString*)retrieveTextUpToDepth:(NSUInteger)maxDepth escapeHtmlEntities:(BOOL)shouldEscape; //addSpaceBetweenTags:YES
- (NSString*)retrieveTextUpToDepth:(NSUInteger)maxDepth; //escapeHtmlEntities:YES //addSpaceBetweenTags:YES
- (NSString*)retrieveText;//UpToDepth:-1 //escapeHtmlEntities:YES  //addSpaceBetweenTags:YES

@end






