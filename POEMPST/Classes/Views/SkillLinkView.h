//
//  SkillLinkView.h
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
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

- (id)initWithFrame:(CGRect)frame andStartNode:(SkillNode *)n1 andEndNode:(SkillNode *)n2 andFullSize:(CGSize)gSize;

@end
