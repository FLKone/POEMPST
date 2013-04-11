//
//  SkillTreeView.h
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SkillLinksView;
@class SkillIcons;
@class PESGraph;

@interface SkillTreeView : UIView

@property (strong, nonatomic) SkillLinksView *skillLinksView;
@property (strong, nonatomic) UIView *touchLayer;

@property (strong, nonatomic) NSMutableDictionary *skillNodes;
@property (strong, nonatomic) NSMutableArray *skillLinks;
@property (strong, nonatomic) NSMutableDictionary *assets;
@property (strong, nonatomic) NSMutableDictionary *nodeGroups;
@property (strong, nonatomic) NSMutableArray *skillFaceGroups;
@property (strong, nonatomic) NSArray *arrayCharName;
@property (strong, nonatomic) SkillIcons *iconActiveSkills;
@property (strong, nonatomic) SkillIcons *iconInactiveSkills;
@property (strong, nonatomic) NSMutableArray *activeSkills;

@property int characterClassID;
@property (strong, nonatomic) NSString *rootID;
@property (strong, nonatomic) NSDictionary *dicoNodeBackgrounds;
@property (strong, nonatomic) NSDictionary *dicoNodeBackgroundsActive;
@property (strong, nonatomic) NSMutableArray *snImages;
@property (strong, nonatomic) NSMutableDictionary *spritesUnitedActive; //cached active images
@property (strong, nonatomic) NSArray *arrayFaceNames;
@property (strong, nonatomic) PESGraph *graph;

@property float fullX;
@property float fullY;

- (id)initWithFrame:(CGRect)frame andJSON:(NSDictionary *)json;

- (void)addActiveSkill:(NSNumber *)skillID;
- (void)removeActiveSkill:(NSNumber *)skillID;

@end
