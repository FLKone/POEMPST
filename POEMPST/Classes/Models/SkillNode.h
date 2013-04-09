//
//  SkillNode.h
//  POEMPST
//
//  Created by Shasta on 01/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NodeGroup;

@interface SkillNode : NSObject

/*
 "id": 50360,
 "icon": "Art/2DArt/SkillIcons/passives/mana.png",
 "ks": false,
 "not": false,
 "dn": "Mana",
 "m": false,
 "spc": [], -- NOT USED
 "sd": ["8% increased maximum Mana"],
 "g": 138,
 "o": 2,
 "oidx": 10,
 "sa": 0,
 "da": 0,
 "ia": 0,
 "out": []
 */

@property int id; //id
@property (nonatomic, strong) NSString *icon; //icon
@property BOOL isKeystone; //ks
@property BOOL isNotable; //not
@property (nonatomic, strong) NSString *name; //dn
@property BOOL isMastery; //m
//spc -- NOT USED
@property (nonatomic, strong) NSMutableDictionary *attributes; //sd
@property int g; //g
@property int orbit; //o
@property int orbitIndex; //oidx
@property int sa; //sa
@property int da; //da
@property int ia; //ia
@property (nonatomic, strong) NSArray *linksID; //out

@property (nonatomic, strong) NodeGroup *nodeGroup;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(CGPoint)Position;
-(double)Arc;

@end
