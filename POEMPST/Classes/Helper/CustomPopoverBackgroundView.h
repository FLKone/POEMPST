//
//  CustomPopoverBackgroundView.h
//  POEMPST
//
//  Created by FLK on 14/04/13.
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
