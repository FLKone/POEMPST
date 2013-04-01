//
//  NodeGroup.m
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "NodeGroup.h"

@implementation NodeGroup

-(id)initWithDictionary:(NSDictionary *)dictionary andId:(int)nodeid {
    
    self = [super init];
    if (self) {
        self.id = nodeid; //id
        self.position = CGPointMake([[dictionary objectForKey:@"x"] floatValue], [[dictionary objectForKey:@"y"] floatValue]); //x, y
        self.occupiedOrbites = [dictionary objectForKey:@"oo"]; //oo
        self.nodes = [dictionary objectForKey:@"n"];; //n
    }
    return self;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"\r%d\r%f\r%f\r%@\r%@", self.id, self.position.x, self.position.y, [self.occupiedOrbites description], [self.nodes description]];
}


@end