//
//  SkillLinksView.h
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillLinksView : UIView

@property (strong, nonatomic) NSMutableDictionary *skillNodes;
@property (strong, nonatomic) NSMutableArray *skillLinks;

- (id)initWithFrame:(CGRect)frame andLinks:(NSMutableArray *)links andSkills:(NSMutableDictionary *)nodes;
- (void)load;
-(void)disableLinks:(NSArray *)linkToDisable;
- (void)activateLinks:(NSArray *)linkToActivate;
- (void)highlightLinks:(NSArray *)linkToActivate;

@end