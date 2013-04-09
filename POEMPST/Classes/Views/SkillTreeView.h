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

@interface SkillTreeView : UIView

@property (strong, nonatomic) SkillLinksView *skillLinksView;

@property (strong, nonatomic) NSMutableDictionary *skillNodes;
@property (strong, nonatomic) NSMutableArray *skillLinks;
@property (strong, nonatomic) NSMutableDictionary *assets;
@property (strong, nonatomic) NSMutableDictionary *nodeGroups;
@property (strong, nonatomic) NSMutableArray *skillFaceGroups;
@property (strong, nonatomic) NSArray *arrayCharName;
@property (strong, nonatomic) SkillIcons *iconActiveSkills;
@property (strong, nonatomic) SkillIcons *iconInactiveSkills;

@property int characterClassID;


@property float fullX;
@property float fullY;

- (id)initWithFrame:(CGRect)frame andJSON:(NSDictionary *)json;

@end
