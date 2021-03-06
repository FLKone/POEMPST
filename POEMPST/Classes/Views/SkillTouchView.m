//
//  SkillTouchView.m
//  POEMPST
//
//  Created by FLK on 11/04/13.
//

#import "SkillTouchView.h"

@implementation SkillTouchView

@synthesize skillImage, overlayImage;
@synthesize isActivated, isHighlighted, linksIDs, linksHighIDs;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isActivated = NO;
        self.isHighlighted = NO;
        self.linksIDs = [NSMutableArray array];
        self.linksHighIDs = [NSMutableArray array];
        //self.layer.borderColor = [UIColor greenColor].CGColor;
        //self.layer.borderWidth = 1;
        //self.layer.cornerRadius = 12;
        self.layer.masksToBounds = NO;
        self.clipsToBounds = NO;
    }
    return self;
}


- (BOOL)isActivable {
    return YES;
}

- (BOOL)isHighlightable {
    return YES;
}

- (void)activate:(BOOL)isFirstLoad {
    
    if (!self.isHighlighted) {
        return;
    }
    
    if (!self.isActivated) {
        
        //NSLog(@"1 Add %d isFirstLoad %d", self.tag, isFirstLoad);

        if (self.isActivable) {
            
            SkillTreeView *localTreeView = (SkillTreeView *)[[self superview] superview];

            UIImage *newImage;

            SkillNode *sn = [localTreeView.skillNodes objectForKey:[NSNumber numberWithInt:self.tag]];
            //NSLog(@"sn %@", sn);
            
            // SKILL SPRITE
            NSString *iconkey = sn.isMastery ? @"mastery" : (sn.isKeystone ? @"keystoneActive" : (sn.isNotable ? @"notableActive" : @"normalActive"));
            NSString *spriteSheetName = [[[[localTreeView.iconActiveSkills.skillPositions objectForKey:[sn icon]] objectForKey:iconkey] allKeys] objectAtIndex:0];
            CGRect rect = CGRectFromString([[[[localTreeView.iconActiveSkills.skillPositions objectForKey:[sn icon]] objectForKey:iconkey] allValues] objectAtIndex:0]);


            if ([localTreeView.spritesUnitedActive objectForKey:spriteSheetName] && [[localTreeView.spritesUnitedActive objectForKey:spriteSheetName] objectForKey:[sn icon]] && [[[localTreeView.spritesUnitedActive objectForKey:spriteSheetName] objectForKey:[sn icon]] objectForKey:iconkey]) {

            }
            else
            {

                float icontype = sn.isMastery ? 2.61f/Zoom/MiniScale : (sn.isKeystone ? 2.61f/Zoom/MiniScale : (sn.isNotable ? 2.61f/Zoom/MiniScale : 2.61f/Zoom/MiniScale));

                icontype = icontype*2;
                UIImage *sprite = [localTreeView.iconActiveSkills.images objectForKey:spriteSheetName];

                CGImageRef cgIcon = CGImageCreateWithImageInRect(sprite.CGImage, rect);

                UIImage *icon = [UIImage imageWithCGImage:cgIcon];
                CGImageRelease(cgIcon);

                CGSize targetSize = CGSizeMake(icon.size.width * icontype,  icon.size.height * icontype); //2.8 MASTERY

                UIGraphicsBeginImageContext(targetSize); // this will crop

                CGRect newSize = CGRectZero;
                //thumbnailRect.origin = thumbnailPoint;
                newSize.size.width  = targetSize.width;
                newSize.size.height = targetSize.height;

                [icon drawInRect:newSize];

                newImage = UIGraphicsGetImageFromCurrentImageContext();

                //pop the context to get back to the default
                UIGraphicsEndImageContext();

                if ([localTreeView.spritesUnitedActive objectForKey:spriteSheetName]) {
                    if ([[localTreeView.spritesUnitedActive objectForKey:spriteSheetName] objectForKey:[sn icon]]) {
                        [[[localTreeView.spritesUnitedActive objectForKey:spriteSheetName] objectForKey:[sn icon]] setObject:newImage forKey:iconkey];
                    }
                    else
                    {
                        [[localTreeView.spritesUnitedActive objectForKey:spriteSheetName] setObject:[NSMutableDictionary dictionaryWithObject:newImage forKey:iconkey] forKey:[sn icon]];
                    }
                }
                else {
                    [localTreeView.spritesUnitedActive setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObject:newImage forKey:iconkey] forKey:[sn icon]]
                    forKey:spriteSheetName];
                }

            }
            
            UIImage *OverlayTmp = [[UIImage alloc] initWithCGImage:[[[[localTreeView.spritesUnitedActive objectForKey:spriteSheetName] objectForKey:[sn icon]] objectForKey:iconkey] CGImage]
                                                             scale:2
                                                       orientation:UIImageOrientationUp];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:OverlayTmp];
            
            
            //UIImageView *imageView = [[UIImageView alloc] initWithImage:[[[localTreeView.spritesUnitedActive objectForKey:spriteSheetName] objectForKey:[sn icon]] objectForKey:iconkey]];
            imageView.clipsToBounds = NO;
            imageView.center = CGPointMake(rect.size.width*self.scaleTouch/2, rect.size.height*self.scaleTouch/2);
            self.skillImage = imageView;
            [self addSubview:self.skillImage];
            //- SKILL SPRITE
            
            // SKILL OVERLAY
            if (sn.isNotable) {
                UIImage *OverlayTmp = [[UIImage alloc] initWithCGImage:[[localTreeView.snImages objectAtIndex:5] CGImage]
                                                                 scale:2
                                                           orientation:UIImageOrientationUp];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:OverlayTmp];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:3]];
                imageView.center = CGPointMake(rect.size.width*self.scaleTouch/2, rect.size.height*self.scaleTouch/2);
                imageView.tag = sn.id * SkillOverlayID;
                self.overlayImage = imageView;
                [self addSubview:self.overlayImage];
            }
            else if (sn.isKeystone) {
                UIImage *OverlayTmp = [[UIImage alloc] initWithCGImage:[[localTreeView.snImages objectAtIndex:4] CGImage]
                                                                 scale:2
                                                           orientation:UIImageOrientationUp];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:OverlayTmp];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:2]];
                imageView.center = CGPointMake(rect.size.width*self.scaleTouch/2, rect.size.height*self.scaleTouch/2);
                imageView.tag = sn.id * SkillOverlayID;
                self.overlayImage = imageView;
                [self addSubview:self.overlayImage];
            }
            else {
                UIImage *OverlayTmp = [[UIImage alloc] initWithCGImage:[[localTreeView.snImages objectAtIndex:1] CGImage]
                                                                 scale:2
                                                           orientation:UIImageOrientationUp];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:OverlayTmp];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:0]];
                imageView.center = CGPointMake(rect.size.width*self.scaleTouch/2, rect.size.height*self.scaleTouch/2);
                imageView.tag = sn.id * SkillOverlayID;
                self.overlayImage = imageView;
                [self addSubview:self.overlayImage];
            }
            
            /*
            if (sn.isNotable) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[localTreeView.snImages objectAtIndex:5]];
                imageView.clipsToBounds = NO;                
                imageView.center = CGPointMake(rect.size.width*self.scaleTouch/2, rect.size.height*self.scaleTouch/2);
                self.overlayImage = imageView;
                [self addSubview:self.overlayImage];
            }
            else if (sn.isKeystone) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[localTreeView.snImages objectAtIndex:4]];
                imageView.clipsToBounds = NO;
                imageView.center = CGPointMake(rect.size.width*self.scaleTouch/2, rect.size.height*self.scaleTouch/2);
                self.overlayImage = imageView;
                [self addSubview:self.overlayImage];
            }
            else {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[localTreeView.snImages objectAtIndex:1]];
                imageView.clipsToBounds = NO;
                imageView.center = CGPointMake(rect.size.width*self.scaleTouch/2, rect.size.height*self.scaleTouch/2);
                self.overlayImage = imageView;
                [self addSubview:self.overlayImage];
            }
             */
            //-- SKILL OVERLAY
            
            self.isActivated = YES;
            //self.layer.borderColor = [UIColor greenColor].CGColor;
        }
    }
}

- (void)highlight:(BOOL)isFirstLoad {

    if (self.isActivated) {
        return;
    }
    
    if (!self.isHighlighted) {
        
        //NSLog(@"highlight %d", self.tag);
        
        if (self.isHighlightable) {
            
            self.isHighlighted = YES;
            //self.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
}

- (void)desactivate {
    
    [self.overlayImage removeFromSuperview];
    [self.skillImage removeFromSuperview];
    self.overlayImage = nil;
    self.skillImage = nil;
    
    self.isActivated = NO;
    self.isHighlighted = NO;
    
    self.linksIDs = [NSMutableArray array];
    self.linksHighIDs = [NSMutableArray array];
    
    //self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)lowlight {
    if (self.isActivated) {
        return;
    }
    
    if (self.isHighlighted) {
        //self.layer.borderColor = [UIColor redColor].CGColor;
        self.isHighlighted = NO;
    }
}

@end