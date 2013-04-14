//
//  CustomPopoverBackgroundView.h
//  POEMPST
//
//  Created by Shasta on 14/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPopoverBackgroundView : UIPopoverBackgroundView
{
    UIImageView *_borderImageView;
    UIImageView *_arrowView;
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}
@end
