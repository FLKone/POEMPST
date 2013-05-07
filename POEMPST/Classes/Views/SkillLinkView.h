//
//  SkillLinkView.h
//  POEMPST
//
//  Created by FLK on 06/04/13.
//

#import <UIKit/UIKit.h>
@class SkillNode;

@interface SkillLinkView : UIView {
    
    UIBezierPath *myPath;
    UIColor *brushPattern;
}

@property (nonatomic, strong) SkillNode *node1;
@property (nonatomic, strong) SkillNode *node2;

@property CGPoint startPoint;
@property CGPoint endPoint;
@property CGPoint centerPoint;

@property BOOL isActivated;
@property BOOL isHighlighted;

- (id)initWithFrame:(CGRect)frame andStartNode:(SkillNode *)n1 andEndNode:(SkillNode *)n2 andFullSize:(CGSize)gSize andState:(SkillState)state;

- (void)disable;
- (void)activate;
- (void)highlight;

@end
