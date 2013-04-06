//
//  SkillTreeView.m
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "SkillTreeView.h"

@implementation SkillTreeView

@synthesize skillNodes, skillLinks;
@synthesize fullY, fullX;

- (id)initWithFrame:(CGRect)frame andJSON:(NSDictionary *)json
{
    NSLog(@"initWithFrameandJSON");

    
    self = [super initWithFrame:frame];
    if (self) {
        NSDate *then = [NSDate date]; 

        
        // tempiVAR
        int characterClassID = 0;
        NSArray *arrayFaceNames = [NSArray arrayWithObjects:@"centermarauder", @"centerranger", @"centerwitch", @"centerduelist", @"centertemplar", @"centershadow", nil];
        NSArray *arrayCharName = [NSArray arrayWithObjects:@"MARAUDER", @"RANGER", @"WITCH", @"DUELIST", @"TEMPLAR", @"SIX", nil];
        NSDictionary *dicoNodeBackgrounds =         [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PSSkillFrame", @"NotableFrameUnallocated", @"KeystoneFrameUnallocated", nil]
                                                                                forKeys:[NSArray arrayWithObjects:@"normal", @"notable", @"keystone", nil]];
        NSDictionary *dicoNodeBackgroundsActive =         [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PSSkillFrameActive", @"NotableFrameAllocated", @"KeystoneFrameAllocated", nil]
                                                                                      forKeys:[NSArray arrayWithObjects:@"normal", @"notable", @"keystone", nil]];
        //-- tempiVAR

        
        // LOAD URL
        NSString *siteUrl = @"http://www.pathofexile.com/passive-skill-tree/";
        NSString *loadUrl = @"http://www.pathofexile.com/passive-skill-tree/AAAAAgUABVsWQClPPAVG12aeeuZ9U4KbgziFfYuMnYCf39R83QXhc-dq7SDvfPfB-tI=";
        
        NSString *s = [[[loadUrl stringByReplacingOccurrencesOfString:siteUrl withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@"+"] stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
        
        NSString *stringValue = s;
        Byte inputData[[stringValue lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];//prepare a Byte[]
        [[stringValue dataUsingEncoding:NSUTF8StringEncoding] getBytes:inputData];//get the pointer of the data
        size_t inputDataSize = (size_t)[stringValue length];
        size_t outputDataSize = EstimateBas64DecodedDataSize(inputDataSize);//calculate the decoded data size
        Byte outputData[outputDataSize];//prepare a Byte[] for the decoded data
        Base64DecodeData(inputData, inputDataSize, outputData, &outputDataSize);//decode the data
        NSData *theData = [[NSData alloc] initWithBytes:outputData length:outputDataSize];//create a NSData object from the decoded data
        
        DataString *ss = [[DataString alloc] init];
        [ss setDataString:theData];
        int o = [ss readInt:0]; //ver
        int u = [ss readInt8];  //char
        int a = 0;
        o > 0 && (a = [ss readInt8]);
        
        //NSLog(@"%d", u);
        characterClassID = u;
        
        
        NSMutableArray *f = [NSMutableArray array]; //skills
        while ([ss hasData]) {
            [f addObject:[NSNumber numberWithInteger:[ss readInt16]]];
        }
        
        //NSLog(@"%@", f);
        //-- LOAD URL
        
        NSDate *then0 = [NSDate date];
        
        // Skill Sprites
        SkillIcons *iconActiveSkills = [[SkillIcons alloc] init];
        SkillIcons *iconInactiveSkills = [[SkillIcons alloc] init];
        
        for (NSString *key in [json objectForKey:@"skillSprites"]) {
            
            if ([key rangeOfString:@"Inactive"].location != NSNotFound) {
                continue;
            }
            
            NSDictionary *jobj = [[[json valueForKey:@"skillSprites"] objectForKey:key] objectAtIndex:3];
            NSString *filename = [jobj objectForKey:@"filename"];
            
            [iconActiveSkills.images setValue:@"" forKey:filename];
            
            //NSLog(@"%@ = %@", filename, key);
            
            for (NSString *key2 in [jobj objectForKey:@"coords"]) {
                
                NSDictionary *jobj2 = [[jobj objectForKey:@"coords"] objectForKey:key2];
                
                NSDictionary *skill = [NSDictionary dictionaryWithObject:NSStringFromCGRect(CGRectMake([[jobj2 objectForKey:@"x"] floatValue], [[jobj2 objectForKey:@"y"] floatValue], [[jobj2 objectForKey:@"w"] floatValue], [[jobj2 objectForKey:@"h"] floatValue])) forKey:filename];
                
                [iconActiveSkills.skillPositions setObject:skill forKey:key2];
                
            }
            
        }
        
        for (NSString *key in [json objectForKey:@"skillSprites"]) {
            
            if ([key rangeOfString:@"Active"].location != NSNotFound) {
                continue;
            }
            
            NSDictionary *jobj = [[[json valueForKey:@"skillSprites"] objectForKey:key] objectAtIndex:3];
            NSString *filename = [jobj objectForKey:@"filename"];
            
            [iconInactiveSkills.images setValue:@"" forKey:filename];
            
            for (NSString *key2 in [jobj objectForKey:@"coords"]) {
                
                NSDictionary *jobj2 = [[jobj objectForKey:@"coords"] objectForKey:key2];
                
                NSDictionary *skill = [NSDictionary dictionaryWithObject:NSStringFromCGRect(CGRectMake([[jobj2 objectForKey:@"x"] floatValue], [[jobj2 objectForKey:@"y"] floatValue], [[jobj2 objectForKey:@"w"] floatValue], [[jobj2 objectForKey:@"h"] floatValue])) forKey:filename];
                
                [iconInactiveSkills.skillPositions setObject:skill forKey:key2];
                
            }
            
        }
        
        [iconActiveSkills OpenOrDownloadImages];
        [iconInactiveSkills OpenOrDownloadImages];
        //-- Skill Sprites
        
        // Assets
        NSMutableDictionary *assets = [NSMutableDictionary dictionary];
        
        for (NSString *key in [json objectForKey:@"assets"]) {
            
            Asset *asset = [[Asset alloc] init];
            [asset setName:key];
            [asset setUrlPath:[[[json objectForKey:@"assets"] objectForKey:key] objectForKey:@"0.3835"]];
            [asset OpenOrDownloadImages];
            
            [assets setObject:asset forKey:key];
        }
        //-- Assets
        
        // Nodes
        self.skillNodes = [NSMutableDictionary dictionary];
        NSMutableArray *skillFaceGroups = [NSMutableArray array];
        
        for (NSDictionary *node in [json valueForKey:@"nodes"]) {
            
            SkillNode *skillNode = [[SkillNode alloc] initWithDictionary:node];
            [self.skillNodes setValue:skillNode forKey:[node valueForKey:@"id"]];
            
            // START NODES
            if ([arrayCharName indexOfObject:[node valueForKey:@"dn"]] != NSNotFound) {
                [skillFaceGroups addObject:[node valueForKey:@"g"]];
            }
            
        }
        //-- Nodes
        
        // Groups
        NSMutableDictionary *nodeGroups = [NSMutableDictionary dictionary];
        
        for (NSString *key in [json valueForKey:@"groups"]) {
            
            NSDictionary *group = [[json valueForKey:@"groups"] objectForKey:key];
            NodeGroup *nodeGroup = [[NodeGroup alloc] initWithDictionary:group andId:[key intValue]];
            [nodeGroups setValue:nodeGroup forKey:key];
        }
        
        for (NSString *key in nodeGroups) {
            //NSLog(@"===== key %@", key);
            NodeGroup *ng = [nodeGroups objectForKey:key];
            
            
            
            for (NSString *key2 in ng.nodes) {
                
                [[self.skillNodes objectForKey:key2] setNodeGroup:ng];
                
                //NSLog(@"key2 %@", key2);
            }
        }
        //-- Groups
        
        //LINKS
        self.skillLinks = [NSMutableArray array];
        
        for (NSString *key in self.skillNodes) {
            
            SkillNode *sn = [self.skillNodes objectForKey:key];
            //NSLog(@"id %d", sn.id);
            for (NSNumber *i in sn.linksID) {
                
                NSIndexSet *indexSet = [self.skillLinks indexesOfObjectsPassingTest:
                                        ^ BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                            
                                            //NSLog(@"obj %@", obj);
                                            
                                            if (([obj objectAtIndex:0] == i && [[obj objectAtIndex:1] intValue] == sn.id) ||
                                                ([obj objectAtIndex:1] == i && [[obj objectAtIndex:0] intValue] == sn.id)) {
                                                return YES;
                                            }
                                            else
                                                return NO;
                                            
                                            //NSLog(@"IOO %@ %d", obj, idx);
                                            
                                            //return YES;
                                            /*
                                             if ([[obj name] rangeOfString:theName options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                             return YES;
                                             } else
                                             return NO;
                                             */
                                        } ];
                
                if (indexSet.count > 0) {
                    NSLog(@"%d - %@ - %d", sn.id, i, indexSet.count);
                }
                
                [self.skillLinks addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:sn.id], i, nil]];
                
                //NSLog(@"skillLinks a4 %@", skillLinks);
            }
        }
        //-- LINKS
        
        NSDate *then1 = [NSDate date];
        
        float min_x = [[json objectForKey:@"min_x"] floatValue];
        float min_y = [[json objectForKey:@"min_y"] floatValue];
        float max_x = [[json objectForKey:@"max_x"] floatValue];
        float max_y = [[json objectForKey:@"max_y"] floatValue];
        
        //[self performSelectorOnMainThread:@selector(myMethod:) withObject:anObj waitUntilDone:YES];
        
        fullX = (float)(MAX(abs(min_x),abs(max_x))*2.1);
        fullY = (float)(MAX(abs(min_y),abs(max_y))*2.1);
        
        UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[((Asset *)[assets objectForKey:@"Background1"]) UIImage]];
        self.backgroundColor = backgroundColor;

        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *diskDataLayerBackgroundCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data/Layers/background.png"];

        UIImage *layerBackgroundIMAGE;
        
        // BACKGROUNDS LAYER
        if (![fileManager fileExistsAtPath:diskDataLayerBackgroundCachePath])
        {
            UIView *layerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fullX/Zoom/MiniScale, fullY/Zoom/MiniScale)];
            layerBackground.backgroundColor = [UIColor clearColor];
            
            NSMutableArray *ngImages = [NSMutableArray arrayWithObjects:  [((Asset *)[assets objectForKey:@"PSGroupBackground1"]) UIImage],
                                        [((Asset *)[assets objectForKey:@"PSGroupBackground2"]) UIImage],
                                        [((Asset *)[assets objectForKey:@"PSGroupBackground3"]) UIImage], nil];
            
            // BACKGROUND 3 transformation
            UIImage *PSG2 = [ngImages objectAtIndex:2];
            UIImage *PSG2r = [PSG2 rotate:UIImageOrientationDownMirrored];
            CGSize newSize = CGSizeMake(PSG2.size.width, PSG2.size.height*2);
            UIGraphicsBeginImageContext( newSize );
            [PSG2 drawInRect:CGRectMake(0,0,PSG2.size.width,PSG2.size.height)];
            [PSG2r drawInRect:CGRectMake(0,PSG2.size.height,PSG2.size.width,PSG2.size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [ngImages replaceObjectAtIndex:2 withObject:newImage];
            
            int i;
            for (i = 0; i < [ngImages count]; i++) {
                UIImage *object = [ngImages objectAtIndex:i];
                
                CGSize targetSize = CGSizeMake(object.size.width/MiniScale, object.size.height/MiniScale); //2.65;
                
                UIGraphicsBeginImageContext(targetSize); // this will crop
                
                CGRect newSize = CGRectZero;
                //thumbnailRect.origin = thumbnailPoint;
                newSize.size.width  = targetSize.width;
                newSize.size.height = targetSize.height;
                
                [object drawInRect:newSize];
                
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                //pop the context to get back to the default
                UIGraphicsEndImageContext();
                
                [ngImages replaceObjectAtIndex:i withObject:newImage];
                
                
            }
            //-- BACKGROUND 3 transformation
            
            for (NSString *key in nodeGroups) {
                
                NodeGroup *ng = [nodeGroups objectForKey:key];
                
                // START NODES
                if ([skillFaceGroups indexOfObject:[NSNumber numberWithInt:ng.id]] != NSNotFound) {
                    continue;
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.intValue <= 3"];
                NSArray *filteredArray = [ng.occupiedOrbites.allKeys filteredArrayUsingPredicate:predicate];
                int cgrp = filteredArray.count;
                if (cgrp == 0) continue;
                
                NSNumber *maxr = [filteredArray valueForKeyPath:@"@max.intValue"];
                int maxri = [maxr intValue];
                if (maxri == 0) continue;
                
                maxri = maxri > 3 ? 2 : maxri - 1;
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[ngImages objectAtIndex:maxri]];
                imageView.center = CGPointMake((ng.position.x + fullX/2)/Zoom/MiniScale, (ng.position.y + fullY/2)/Zoom/MiniScale);
                [layerBackground addSubview:imageView];
                
            }
            
            layerBackgroundIMAGE = [layerBackground capture];
            //[UIImageJPEGRepresentation(layerBackgroundIMAGE, 0.8) writeToFile:diskDataLayerBackgroundCachePath atomically:YES];
            [UIImagePNGRepresentation(layerBackgroundIMAGE) writeToFile:diskDataLayerBackgroundCachePath atomically:YES];
            
        }
        else
        {
            layerBackgroundIMAGE = [UIImage imageWithContentsOfFile:diskDataLayerBackgroundCachePath];
        }
        
        [self addSubview:[[UIImageView alloc] initWithImage:layerBackgroundIMAGE]];
        //-- BACKGROUNDS LAYER
        NSDate *then2 = [NSDate date];

        
        /*
        
        // SKILLS LAYER
        float icontype;
        NSMutableDictionary *spritesUnited = [NSMutableDictionary dictionary];
        
        
        //            [iv setUserInteractionEnabled:YES];
        
        for (NSString *key in self.skillNodes) {
            
            
            
            SkillNode *sn = [self.skillNodes objectForKey:key];
            
            // START NODES
            if ([arrayCharName indexOfObject:sn.name] != NSNotFound) {
                
                UIImage *faceImg;
                
                if ([arrayCharName indexOfObject:sn.name] == (characterClassID - 1)) {
                    faceImg = [((Asset *)[assets objectForKey:[arrayFaceNames objectAtIndex:[arrayCharName indexOfObject:sn.name]]]) UIImage];
                }
                else
                    faceImg = [((Asset *)[assets objectForKey:@"PSStartNodeBackgroundInactive"]) UIImage];
                
                
                CGSize targetSize = CGSizeMake(faceImg.size.width * 2.61f,  faceImg.size.height * 2.61f);
                
                UIGraphicsBeginImageContext(targetSize); // this will crop
                
                CGRect newSize = CGRectZero;
                //thumbnailRect.origin = thumbnailPoint;
                newSize.size.width  = targetSize.width;
                newSize.size.height = targetSize.height;
                
                [faceImg drawInRect:newSize];
                
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
                imageView.center = CGPointMake(sn.Position.x + fullX/2, sn.Position.y + fullY/2);
                [self addSubview:imageView];
                
                continue;
                //[skillFaceGroups addObject:[node valueForKey:@"g"]];
            }
            
            if ([spritesUnited objectForKey:[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] && [[spritesUnited objectForKey:[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] objectForKey:[sn icon]]) {
                
            }
            else
            {
                
                icontype = sn.isMastery ? 2.61f : (sn.isKeystone ? 2.61f : (sn.isNotable ? 2.61f : 2.1f));
                //icontype = 2.61f;
                CGRect rect = CGRectFromString([[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] allValues] objectAtIndex:0]);
                
                UIImage *sprite = [iconInactiveSkills.images objectForKey:[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]];
                
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
                
                if ([spritesUnited objectForKey:[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]]) {
                    [[spritesUnited objectForKey:[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] setObject:newImage forKey:[sn icon]];
                }
                else {
                    [spritesUnited setObject:[NSMutableDictionary dictionaryWithObject:newImage forKey:[sn icon]]
                                      forKey:[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]];
                }
                
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[[spritesUnited objectForKey:[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] objectForKey:[sn icon]]];
            imageView.center = CGPointMake(sn.Position.x + fullX/2, sn.Position.y + fullY/2);
            imageView.tag = sn.id * SkillSpriteID;
            
            if (!sn.isMastery) {
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
                singleTap.numberOfTapsRequired = 1;
                singleTap.numberOfTouchesRequired = 1;
                [imageView setUserInteractionEnabled:YES];
                [imageView addGestureRecognizer:singleTap];
                
                CALayer * l = [imageView layer];
                [l setMasksToBounds:YES];
                [l setCornerRadius:30.0];
                
            }
            
            [self addSubview:imageView];
            
            //NSLog(@"%@ = %f %f %f %f", key, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
            
        }
        */
        NSDate *then3 = [NSDate date];

        /*
        NSMutableArray *snImages = [NSMutableArray arrayWithObjects:
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"normal"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"normal"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"keystone"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"notable"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"keystone"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"notable"]]) UIImage], nil];
        
        int j;
        for (j = 0; j < [snImages count]; j++) {
            UIImage *object = [snImages objectAtIndex:j];
            
            
            icontype = 2.61f;
            CGSize targetSize = CGSizeMake(object.size.width * icontype, object.size.height * icontype);
            
            UIGraphicsBeginImageContext(targetSize); // this will crop
            
            CGRect newSize = CGRectZero;
            //thumbnailRect.origin = thumbnailPoint;
            newSize.size.width  = targetSize.width;
            newSize.size.height = targetSize.height;
            
            [object drawInRect:newSize];
            
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            //pop the context to get back to the default
            UIGraphicsEndImageContext();
            
            [snImages replaceObjectAtIndex:j withObject:newImage];
            
        }
        
        for (NSString *key in self.skillNodes) {
            
            SkillNode *sn = [self.skillNodes objectForKey:key];
            
            // START NODES
            if ([skillFaceGroups indexOfObject:[NSNumber numberWithInt:sn.g]] != NSNotFound && [arrayCharName indexOfObject:sn.name] != NSNotFound) {
                continue;
            }
            
            if (sn.isMastery) {
                continue;
            }
            
            if (sn.isNotable) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:3]];
                imageView.center = CGPointMake(sn.Position.x + fullX/2, sn.Position.y + fullY/2);
                imageView.tag = sn.id * SkillOverlayID;
                [self addSubview:imageView];
            }
            else if (sn.isKeystone) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:2]];
                imageView.center = CGPointMake(sn.Position.x + fullX/2, sn.Position.y + fullY/2);
                imageView.tag = sn.id * SkillOverlayID;
                [self addSubview:imageView];
            }
            else {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:0]];
                imageView.center = CGPointMake(sn.Position.x + fullX/2, sn.Position.y + fullY/2);
                imageView.tag = sn.id * SkillOverlayID;
                [self addSubview:imageView];
            }
            
        }
         */
        //-- SKILLS LAYER
         NSDate *then3final = [NSDate date];

        
        // ACTIVE SKILLS
        /*
        NSMutableDictionary *spritesUnitedActive = [NSMutableDictionary dictionary];
        
        for (NSString *key in self.skillNodes) {
            SkillNode *sn = [self.skillNodes objectForKey:key];
            
            if ([f indexOfObject:[NSNumber numberWithInt:sn.id]] == NSNotFound) {
                continue;
            }
            //NSLog(@"%d = %@", sn.id, [f objectAtIndex:[f indexOfObject:[NSNumber numberWithInt:sn.id]]]);
            
            if ([spritesUnitedActive objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] && [[spritesUnitedActive objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] objectForKey:[sn icon]]) {
                
            }
            else
            {
                
                icontype = sn.isMastery ? 2.61f : (sn.isKeystone ? 2.61f : (sn.isNotable ? 2.61f : 2.1f));
                //icontype = 2.61f;
                CGRect rect = CGRectFromString([[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allValues] objectAtIndex:0]);
                
                UIImage *sprite = [iconActiveSkills.images objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]];
                
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
                
                if ([spritesUnitedActive objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]]) {
                    [[spritesUnitedActive objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] setObject:newImage forKey:[sn icon]];
                }
                else {
                    [spritesUnitedActive setObject:[NSMutableDictionary dictionaryWithObject:newImage forKey:[sn icon]]
                                            forKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]];
                }
                
            }
            
            UIImageView *skillView = (UIImageView *)[self viewWithTag:(sn.id * SkillSpriteID)];
            //NSLog(@"SVi %@", NSStringFromCGRect(skillView.frame));
            //NSLog(@"UIi %@", NSStringFromCGSize(((UIImage *)[[spritesUnitedActive objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] objectForKey:[sn icon]]).size));
            
            [skillView setImage:[[spritesUnitedActive objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] objectForKey:[sn icon]]];
            
        }
        
        
       
        
        
        
        for (NSNumber *skillID in f) {
            //NSLog(@"%@", skillID);
            UIImageView *skillView = (UIImageView *)[self viewWithTag:([skillID intValue] * SkillOverlayID)];
            
            SkillNode *sn = [self.skillNodes objectForKey:skillID];
            
            CGRect bounds;
            
            bounds.origin = CGPointZero;
            
            UIImage *newImage;
            
            if (sn.isNotable) {
                newImage = [snImages objectAtIndex:5];
            }
            else if (sn.isKeystone) {
                newImage = [snImages objectAtIndex:4];
            }
            else {
                newImage = [snImages objectAtIndex:1];
            }
            
            bounds.size = newImage.size;
            
            skillView.bounds = bounds;
            skillView.image = newImage;
            
        }
        */
        //-- ACTIVE SKILLS
        
        
        
        
        NSLog(@"FINISH INIT");
        NSDate *last = [NSDate date];
        NSLog(@"Time elapsed then0		: %f", [then0 timeIntervalSinceDate:then]);
        NSLog(@"Time elapsed then1		: %f", [then1 timeIntervalSinceDate:then0]);
        NSLog(@"Time elapsed then2		: %f", [then2 timeIntervalSinceDate:then1]);
        NSLog(@"Time elapsed then3		: %f", [then3 timeIntervalSinceDate:then2]);
        NSLog(@"Time elapsed then3final : %f", [then3final timeIntervalSinceDate:then3]);
        NSLog(@"Time elapsed TOTAL		: %f", [last timeIntervalSinceDate:then]);
        
        
    }
    return self;
}
 /*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // CONNECTIONS
   
    for (NSArray *link in self.skillLinks) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path setLineWidth:20.0];
        
        path.lineCapStyle=kCGLineCapRound;
        path.miterLimit=0;
        path.lineWidth=10;
        UIColor *brushPattern = [UIColor redColor];
        
        
        [path moveToPoint:CGPointMake([[self.skillNodes objectForKey:[link objectAtIndex:0]] Position].x + fullX/2, [[self.skillNodes objectForKey:[link objectAtIndex:0]] Position].y + fullY/2)];
        [path addLineToPoint:CGPointMake([[self.skillNodes objectForKey:[link objectAtIndex:1]] Position].x + fullX/2, [[self.skillNodes objectForKey:[link objectAtIndex:1]] Position].y + fullY/2)];
        
        [brushPattern setStroke];
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        
    }
  
  //-- CONNECTIONS
 
 // Drawing code
 //[myPath stroke];
}
   */
@end
