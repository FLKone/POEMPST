//
//  UIView+Image.m
//  POEMPST
//
//  Created by FLK on 06/04/13.
//

#import "UIView+Image.h"

@implementation UIView (Image)

-(UIImage *) capture
{
    if (scale == 1.0f) {
        UIGraphicsBeginImageContext(self.bounds.size);
    }
    else
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);

    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;   
}

@end
