//
//  NodeGroup.h
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NodeGroup : NSObject

/*
"1": {
    "x": 4683.29,
    "y": 3634.69,
    "oo": {
        "0": true,
        "6": true,
        "8": true,
        "9": true
    },
    "n": [27271]
}
*/

@property int id; //id
@property CGPoint position; //x, y
@property (nonatomic, strong) NSMutableDictionary *occupiedOrbites; //oo
@property (nonatomic, strong) NSMutableDictionary *nodes; //n

-(id)initWithDictionary:(NSDictionary *)dictionary andId:(int)id;

@end