//  Created by Justin Searls on 4/25/09.

#import "Tag.h"
#import "NSStringAdditions.h"

@implementation Tag

@synthesize children = _children, willBeStyled = _willBeStyled, 
            text = _text, name = _name, attributeDict = _attributeDict;

#pragma mark -
#pragma mark NSObject

- (id)initWithName:(NSString*)aName {
	return [self initWithName:aName text:nil attributes:nil willBeStyled:NO];
}

- (id)initWithName:(NSString*)aName text:(NSString*)someText {
	return [self initWithName:aName text:someText attributes:nil willBeStyled:NO];
}

- (id)initWithName:(NSString*)aName text:(NSString*)someText attributes:(NSMutableDictionary*)attributes {
	return [self initWithName:aName text:someText attributes:nil willBeStyled:NO];
}

- (id)initWithName:(NSString*)aName text:(NSString*)someText attributes:(NSMutableDictionary*)attributes willBeStyled:(BOOL)isStyled {
	if (self = [super init]) {
		self.name = aName;
		self.text = someText;
		self.attributeDict = attributes;
		self.willBeStyled = isStyled;
	}
	return self;
}

- (void)dealloc {
	[_name release];
	[_text release];
	[_attributeDict release];
	[_children release];
	[super dealloc];
}

#pragma mark -
#pragma mark Tag

- (void)addChildTag:(Tag*)tag {
	if(!_children) {
		_children = [[NSMutableArray alloc] init];
	}
	[_children addObject:tag];
}

- (void)addText:(NSString*)someText {
	if(_text == nil) {
		self.text = someText;
	} else {
		self.text = [_text stringByAppendingString:someText];
	}
}

#pragma mark Chid Retrieval

- (NSArray*)childrenWithoutText {
	NSMutableArray *childrenWithoutText = [[[NSMutableArray alloc] init] autorelease];;
  
	for (int i=0; i<[_children count]; i++) {
		Tag *tag = [_children objectAtIndex:i];
		if(![tag.name isEqualToString:@"comment"]
		   && ![tag.name isEqualToString:@"text"]) {
			[childrenWithoutText addObject:tag];
		}
	}
	return childrenWithoutText;
}

- (NSArray*)childrenWithTagName:(NSString*)aName {
	NSMutableArray *childrenWithTagName = [[[NSMutableArray alloc] init] autorelease];;
	
	for (int i=0; i<[_children count]; i++) {
		Tag *tag = [_children objectAtIndex:i];
		if([tag.name isEqualToString:aName]) {
			[childrenWithTagName addObject:tag];
		}
	}
	return childrenWithTagName;
}

- (Tag*)childWithTagName:(NSString*)aName atIndex:(NSUInteger)index {
	NSArray *tags = [self childrenWithTagName:aName];
	if(tags.count > index) {
		return [tags objectAtIndex:index];
	} else {
		/*
     @throw [NSException exceptionWithName:@"TagDoesNotExist" 
     reason:[NSString stringWithFormat:@"Child Tag named %@ at index %d didn't exist",aName,index] 
		 userInfo:nil];*/
		return nil;
	}
}

- (Tag*)firstChildWithTagName:(NSString*)aName {
	for (int i=0; i<[_children count]; i++) {
		Tag *tag = [_children objectAtIndex:i];
		if([tag.name isEqualToString:aName]) {
			return tag;
		}
	}
	/*@throw [NSException exceptionWithName:@"TagDoesNotExist" 
   reason:[NSString stringWithFormat:@"Child Tag named %@ didn't exist",aName] 
   userInfo:nil];*/
	return nil;
  
}

- (Tag*)lastChildWithTagName:(NSString*)aName {
	Tag *lastChild = nil;
	for (int i=0; i<[_children count]; i++) {
		Tag *tag = [_children objectAtIndex:i];
		if([tag.name isEqualToString:aName]) {
			lastChild = tag;
		}
	}
	
	if(!lastChild) {
		/*@throw [NSException exceptionWithName:@"TagDoesNotExist" 
     reason:[NSString stringWithFormat:@"Child Tag named %@ didn't exist",aName] 
		 userInfo:nil];		*/
		return nil;
	} else {		
		return lastChild;
	}
}

#pragma mark Attributes 

- (NSString*) valueForAttribute:(NSString*)aName escapeHtmlEntities:(BOOL)shouldEscape {
	if(shouldEscape) {
		return [[_attributeDict valueForKey:aName] stringByReplacingXMLElementEntities];		
	} else {
		return [_attributeDict valueForKey:aName];
	}
}

- (NSString*) valueForAttribute:(NSString*)aName {
	return [self valueForAttribute:aName escapeHtmlEntities:YES];
}

- (void)addAttributeWithName:(NSString*)attrName value:(NSString*)attrValue {
	if(!_attributeDict) {
		_attributeDict = [[NSMutableDictionary alloc] init];
	}
	[_attributeDict setValue:attrValue forKey:attrName];	
}

- (void)setAttributeWithName:(NSString*)attrName value:(NSString*)attrValue onChildrenWithTagName:(NSString*)tagName {
	if([_name isEqualToString:tagName]) {
		[self addAttributeWithName:attrName value:attrValue];
	}
	
	for (Tag *child in _children) {
		[child setAttributeWithName:attrName value:attrValue onChildrenWithTagName:tagName];
	}
}

#pragma mark Text Retrievers 

//Private
- (NSString*)recurseUpToDepth:(NSUInteger)depth escapeHtmlEntities:(BOOL)shouldEscape addSpaceBetweenTags:(BOOL)addSpace { 
	if([_name isEqualToString:@"comment"]) {
		return @"";
	}
	
	NSMutableString *sb = [NSMutableString string];
	if(_text) {
		[sb appendString:_text];	
	}
	if(depth > 0 || depth == -1) {
		for (Tag* child in _children) {
      NSString *childText = [child recurseUpToDepth:depth-1 escapeHtmlEntities:shouldEscape addSpaceBetweenTags:addSpace];
			[sb appendString:childText];
      
      //Add a space if there's not one between the tags.
      if(addSpace && ![childText isEmptyIgnoringWhitespace] 
         && [childText characterAtIndex:childText.length-1] != ' ') 
        [sb appendString:@" "];
		}
	} 
	
	if(shouldEscape) {
		return [sb stringByReplacingXMLElementEntities];	
	} else {
		return sb;
	}
}

//Public
- (NSString*)retrieveTextUpToDepth:(NSUInteger)depth escapeHtmlEntities:(BOOL)shouldEscape addSpaceBetweenTags:(BOOL)addSpace {
  NSString *results = [self recurseUpToDepth:depth escapeHtmlEntities:shouldEscape addSpaceBetweenTags:addSpace];
  
  //Current addSpace impl will always add one extra space at the very end. lop it off.
  if(addSpace) {
    return [results substringToIndex:[results length]-1];
  } else {
    return results;
  }  
}

- (NSString*)retrieveTextUpToDepth:(NSUInteger)depth escapeHtmlEntities:(BOOL)shouldEscape {
	return [self retrieveTextUpToDepth:depth escapeHtmlEntities:shouldEscape addSpaceBetweenTags:YES];
}

- (NSString*)retrieveTextUpToDepth:(NSUInteger)depth {
  return [self retrieveTextUpToDepth:depth escapeHtmlEntities:YES addSpaceBetweenTags:YES];
}

- (NSString*)retrieveText {
  return [self retrieveTextUpToDepth:-1 escapeHtmlEntities:YES addSpaceBetweenTags:YES];
}

@end






