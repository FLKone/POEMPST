//
//  SkillNode.m
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "SkillNode.h"

@implementation SkillNode

-(id)initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];
    if (self) {
        
        self.id = [[dictionary objectForKey:@"id"] integerValue]; //id
        self.icon = [dictionary objectForKey:@"icon"]; //icon
        self.isKeystone = [[dictionary objectForKey:@"ks"] boolValue]; //ks
        self.isNotable = [[dictionary objectForKey:@"not"] boolValue]; //not
        self.name = [dictionary objectForKey:@"dn"]; //dn
        self.isMastery = [[dictionary objectForKey:@"m"] boolValue]; //m
        //spc -- NOT USED
        self.attributes = [dictionary objectForKey:@"sd"]; //sd
        self.g = [[dictionary objectForKey:@"g"] integerValue]; //g
        self.orbit = [[dictionary objectForKey:@"o"] integerValue]; //o
        self.orbitIndex = [[dictionary objectForKey:@"oidx"] integerValue]; //oidx
        self.sa = [[dictionary objectForKey:@"sa"] integerValue]; //sa
        self.da = [[dictionary objectForKey:@"da"] integerValue]; //da
        self.ia = [[dictionary objectForKey:@"ia"] integerValue]; //ia
        //out -- TODO
        
    }
    return self;
}

- (NSString *)description {

    return [NSString stringWithFormat:@"\r%d\r%@\r%d\r%d\r%@\r%d\r%@\r%d\r%d\r%d\r%d\r%d\r%d", self.id, self.icon, self.isKeystone, self.isNotable, self.name, self.isMastery, [self.attributes description], self.g, self.orbit, self.orbitIndex, self.sa, self.da, self.ia];
}

-(CGPoint)Position {

    return CGPointMake(0, 0);
}

-(double)Arc {
    return 0.0f;
}

@end
