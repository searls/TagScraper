//  Created by Justin Searls on 4/25/09.

#import "Tag.h"
#import "NSStringAdditions.h"

@interface Tag()
- (NSString*)recurseUpToDepth:(NSUInteger)depth escapeHtmlEntities:(BOOL)shouldEscape addSpaceBetweenTags:(BOOL)addSpace;
+ (NSString*)printTags:(NSArray*)tags removeTextAndComments:(BOOL)cullText;
@end

@implementation Tag

@synthesize children = _children,
text = _text, name = _name, attributeDict = _attributeDict;

#pragma mark -
#pragma mark NSObject

- (id)initWithName:(NSString*)aName {
	return [self initWithName:aName text:nil attributes:nil];
}

- (id)initWithName:(NSString*)aName text:(NSString*)someText {
	return [self initWithName:aName text:someText attributes:nil];
}

- (id)initWithName:(NSString*)aName text:(NSString*)someText attributes:(NSMutableDictionary*)attributes {
	if (self = [super init]) {
		self.name = aName;
		self.text = someText;
		_attributeDict = [[NSMutableDictionary alloc] initWithDictionary:attributes];
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

#pragma mark Conversion (To XML/HTML)

//Private
+ (NSString*)printTags:(NSArray*)tags removeTextAndComments:(BOOL)cullText {
	NSMutableString *sb = [[[NSMutableString alloc] init] autorelease];
	for (Tag *tag in tags) {
		if(!tag.text && (tag.children == nil || tag.children.count ==0)) {
			//Tag is independent, no children and should self-terminate			    
			[sb appendFormat:@" <%@",tag.name];
			for (NSString *key in [tag.attributeDict allKeys]) {
				[sb appendFormat:@" %@=\"%@\"",key,[tag valueForAttribute:key]];
			}
			[sb appendString:@" /> "];			
		} else {
			//Write the tag and terminate it separately.
			if(cullText && ![tag.name isEqualToString:@"comment"] && ![tag.name isEqualToString:@"text"]) {
        
				[sb appendFormat:@" <%@",tag.name];
				for (NSString *key in [tag.attributeDict allKeys]) {
					[sb appendFormat:@" %@=\"%@\"",key,[tag valueForAttribute:key]];
				}
				[sb appendString:@">"];			
			}
      
			//Append the text of the tag
			if(tag.text) {
				//Ugly, but ran into issues with not escaping < and > in posts
				[sb appendString:[tag.text stringByReplacingXMLElementEntities]];
			}			      
			
			//Draw children
			if(tag.children != nil && tag.children.count > 0) {
				[sb appendString:[Tag printTags:tag.children removeTextAndComments:cullText]];
			}
			
      if(cullText && ![tag.name isEqualToString:@"comment"] && ![tag.name isEqualToString:@"text"]) {
        //Close tag if it's to be styled
        [sb appendFormat:@"</%@> ",tag.name];								
      }
		}		
	}
	return sb;
}

//Public
- (NSString*)toHTML {
  return [Tag printTags:[NSArray arrayWithObject:self] removeTextAndComments:YES];
}

@end