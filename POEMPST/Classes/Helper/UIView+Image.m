//
//  UIView+Image.m
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
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
