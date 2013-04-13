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
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;   
}

@end
