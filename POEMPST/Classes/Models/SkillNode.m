//
//  SkillNode.m
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "SkillNode.h"
#include <math.h>
#include <stdio.h>

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

    return [NSString stringWithFormat:@"id = %d\r%@\r%d\r%d\r%@\r%d\r%@\r%d\r%d\r%d\r%d\r%d\r%d\r%@", self.id, self.icon, self.isKeystone, self.isNotable, self.name, self.isMastery, [self.attributes description], self.g, self.orbit, self.orbitIndex, self.sa, self.da, self.ia, [self.nodeGroup description]];
}

-(CGPoint)Position {

    double d = orbitRadii[self.orbit];
    double b = ( 2 * M_PI * self.orbitIndex / skillsPerOrbit[self.orbit]);
    
    return CGPointMake((self.nodeGroup.position.x - ( d * sin(-b) ) ), (self.nodeGroup.position.y - ( d * cos(-b) ) ));
}

-(double)Arc {
    return ( 2 * M_PI * self.orbitIndex / skillsPerOrbit[self.orbit]);
}

@end
