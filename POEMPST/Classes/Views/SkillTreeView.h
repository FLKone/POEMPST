//
//  SkillTreeView.h
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillTreeView : UIView

@property (strong, nonatomic) NSMutableDictionary *skillNodes;
@property (strong, nonatomic) NSMutableArray *skillLinks;

@property float fullX;
@property float fullY;

- (id)initWithFrame:(CGRect)frame andJSON:(NSDictionary *)json;

@end
