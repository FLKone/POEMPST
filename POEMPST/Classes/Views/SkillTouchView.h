//
//  SkillTouchView.h
//  POEMPST
//
//  Created by FLK on 11/04/13.
//

#import <UIKit/UIKit.h>

@interface SkillTouchView : UIView

@property (strong, nonatomic) UIImageView *skillImage;
@property (strong, nonatomic) UIImageView *overlayImage;

@property BOOL isActivated;
@property BOOL isHighlighted;
@property float scaleTouch;

@property (strong, nonatomic) NSMutableArray *linksIDs;
@property (strong, nonatomic) NSMutableArray *linksHighIDs;

- (void)activate:(BOOL)isFirstLoad;
- (void)highlight:(BOOL)isFirstLoad;


- (void)desactivate;
- (void)lowlight;
@end