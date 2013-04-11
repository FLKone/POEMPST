//
//  SkillTouchView.h
//  POEMPST
//
//  Created by Shasta on 11/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillTouchView : UIView

@property (strong, nonatomic) UIImageView *skillImage;
@property (strong, nonatomic) UIImageView *overlayImage;

@property BOOL isActivated;
@property BOOL isHighlighted;

@property (strong, nonatomic) NSMutableArray *linksIDs;
@property (strong, nonatomic) NSMutableArray *linksHighIDs;

- (void)activate:(BOOL)isFirstLoad;
- (void)highlight:(BOOL)isFirstLoad;

- (void)desactivate;
- (void)lowlight;
@end