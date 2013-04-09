//
//  SkillTreeView.m
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "SkillTreeView.h"

@implementation SkillTreeView

@synthesize skillLinksView;
@synthesize skillNodes, skillLinks, assets, nodeGroups, skillFaceGroups;
@synthesize fullY, fullX, characterClassID, arrayCharName;
@synthesize iconActiveSkills, iconInactiveSkills;

- (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@", [gestureRecognizer view]);
}

- (void)button1:(id)sender {
    NSLog(@"button1");
    [self drawBackgroundLayer];
}

- (void)button2:(id)sender {
    NSLog(@"button2");
    [self drawLinksLayer];
}

- (void)button3:(id)sender {
    NSLog(@"button2");
    [self drawLinksLayer];
}

- (id)initWithFrame:(CGRect)frame andJSON:(NSDictionary *)json
{
    NSLog(@"initWithFrameandJSON");

    
    
    self = [super initWithFrame:frame];
    if (self) {
        NSDate *then = [NSDate date]; 
        
        // iVAR
        self.characterClassID = 0;
        self.arrayCharName = [NSArray arrayWithObjects:@"MARAUDER", @"RANGER", @"WITCH", @"DUELIST", @"TEMPLAR", @"SIX", nil];

        //-- iVAR

        
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
        self.characterClassID = u;
        
        
        NSMutableArray *f = [NSMutableArray array]; //skills
        while ([ss hasData]) {
            [f addObject:[NSNumber numberWithInteger:[ss readInt16]]];
        }
        
        //NSLog(@"%@", f);
        //-- LOAD URL
        
        NSDate *thenLOADURL = [NSDate date];
        
        // Skill Sprites
        iconActiveSkills = [[SkillIcons alloc] init];
        iconInactiveSkills = [[SkillIcons alloc] init];
        
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
            
            //NSLog(@"key %@", key);
            
            NSDictionary *jobj = [[[json valueForKey:@"skillSprites"] objectForKey:key] objectAtIndex:3];
            NSString *filename = [jobj objectForKey:@"filename"];
            
            
            [iconInactiveSkills.images setValue:@"" forKey:filename];
            
            for (NSString *key2 in [jobj objectForKey:@"coords"]) {
                
                NSDictionary *jobj2 = [[jobj objectForKey:@"coords"] objectForKey:key2];
                
                NSDictionary *skill = [NSDictionary dictionaryWithObject:NSStringFromCGRect(CGRectMake([[jobj2 objectForKey:@"x"] floatValue], [[jobj2 objectForKey:@"y"] floatValue], [[jobj2 objectForKey:@"w"] floatValue], [[jobj2 objectForKey:@"h"] floatValue])) forKey:filename];
                
                //NSLog(@"filename %@", filename);

                //NSLog(@"jobs2 %@", [[jobj objectForKey:@"coords"] objectForKey:key2]);
                //NSLog(@"key2 %@ - skillPositions %@", key2, skill);
                
                if ([iconInactiveSkills.skillPositions objectForKey:key2]) {
                    [[iconInactiveSkills.skillPositions objectForKey:key2] setObject:skill forKey:key];
                }
                else
                    [iconInactiveSkills.skillPositions setObject:[NSMutableDictionary dictionaryWithObject:skill forKey:key] forKey:key2];
                
            }
            
        }
        
        [iconActiveSkills OpenOrDownloadImages];
        [iconInactiveSkills OpenOrDownloadImages];
        
        
        //NSLog(@"iconInactiveSkills %@", iconInactiveSkills);
        
        //-- Skill Sprites
        
        // Assets
        assets = [NSMutableDictionary dictionary];
        
        for (NSString *key in [json objectForKey:@"assets"]) {
            
            //NSLog(@"lastkey %@", [[[[json objectForKey:@"assets"] objectForKey:key] allKeys] lastObject]);
            
            Asset *asset = [[Asset alloc] init];
            [asset setName:key];
            [asset setUrlPath:[[[json objectForKey:@"assets"] objectForKey:key] objectForKey:[[[[json objectForKey:@"assets"] objectForKey:key] allKeys] lastObject]]];
            [asset OpenOrDownloadImages];
            
            [assets setObject:asset forKey:key];
        }
        //-- Assets
        
        // Nodes
        self.skillNodes = [NSMutableDictionary dictionary];
        skillFaceGroups = [NSMutableArray array];
        
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
        nodeGroups = [NSMutableDictionary dictionary];
        
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
            //if (sn.g != 49) { continue; }
            
            //if (sn.id != 62213) {
            //    continue;
            //}
            
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
                
                
            }
        }
        //-- LINKS
        //NSLog(@"skillLinks a4 %@", skillLinks);
        
        NSDate *thenPARSE = [NSDate date];
        
        float min_x = [[json objectForKey:@"min_x"] floatValue];
        float min_y = [[json objectForKey:@"min_y"] floatValue];
        float max_x = [[json objectForKey:@"max_x"] floatValue];
        float max_y = [[json objectForKey:@"max_y"] floatValue];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 800, 100)];
        [[button1 titleLabel] setFont:[UIFont fontWithName:@"Times New Roman" size:100]];
        [button1 setTitle:@"START" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
/*
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(810, 10, 800, 100)];
        [[button2 titleLabel] setFont:[UIFont fontWithName:@"Times New Roman" size:100]];
        [button2 setTitle:@"LINKS" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(button2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        
        UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(810, 10, 800, 100)];
        [[button3 titleLabel] setFont:[UIFont fontWithName:@"Times New Roman" size:100]];
        [button3 setTitle:@"SKILLS" forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(button3:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button3];
        */
        
        //[self performSelectorOnMainThread:@selector(myMethod:) withObject:anObj waitUntilDone:YES];

        fullX = (float)(MAX(abs(min_x),abs(max_x))*2.15);
        fullY = (float)(MAX(abs(min_y),abs(max_y))*2.15);
        
        //UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[((Asset *)[assets objectForKey:@"Background1"]) UIImage]];
        //self.backgroundColor = backgroundColor;


  /*
     
        

        thenSKILLBACK = [NSDate date];
        //-- SKILLS LAYER
*/

        
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
                
                icontype = sn.isMastery ? 2.61f/Zoom/MiniScale : (sn.isKeystone ? 2.61f/Zoom/MiniScale : (sn.isNotable ? 2.61f/Zoom/MiniScale : 2.1f/Zoom/MiniScale));
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
        NSLog(@"Time elapsed thenLOADURL        : %f", [thenLOADURL timeIntervalSinceDate:then]);
        NSLog(@"Time elapsed thenPARSE          : %f", [thenPARSE timeIntervalSinceDate:thenLOADURL]);
    //    NSLog(@"Time elapsed thenBGLAYER        : %f", [thenBGLAYER timeIntervalSinceDate:thenPARSE]);
  //      NSLog(@"Time elapsed thenSKILLFORE      : %f", [thenSKILLFORE timeIntervalSinceDate:thenBGLAYER]);
//        NSLog(@"Time elapsed thenSKILLBACK      : %f", [thenSKILLBACK timeIntervalSinceDate:thenSKILLFORE]);
        NSLog(@"Time elapsed TOTAL              : %f", [last timeIntervalSinceDate:then]);
        
        
    }
    return self;
}

-(void)drawBackgroundLayer {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *diskDataLayerBackgroundCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data/Layers/background.png"];
    
    UIImage *layerBackgroundIMAGE;
    
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
    
    
    [self insertSubview:[[UIImageView alloc] initWithImage:layerBackgroundIMAGE] atIndex:10];
    //[self addSubview:[[UIImageView alloc] initWithImage:layerBackgroundIMAGE]];
    
    [self drawLinksLayer];
}

-(void)drawLinksLayer {
    self.skillLinksView = [[SkillLinksView alloc] initWithFrame:CGRectMake(0, 0, fullX/Zoom/MiniScale, fullY/Zoom/MiniScale) andLinks:skillLinks andSkills:skillNodes];
    [self insertSubview:self.skillLinksView atIndex:10];

    //[self addSubview:self.skillLinksView];
    [self.skillLinksView load];
    
    [self drawSkillsLayer];
}

-(void)drawSkillsLayer {
    
    NSArray *arrayFaceNames = [NSArray arrayWithObjects:@"centermarauder", @"centerranger", @"centerwitch", @"centerduelist", @"centertemplar", @"centershadow", nil];
    NSDictionary *dicoNodeBackgrounds =         [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PSSkillFrame", @"NotableFrameUnallocated", @"KeystoneFrameUnallocated", nil]
                                                                            forKeys:[NSArray arrayWithObjects:@"normal", @"notable", @"keystone", nil]];
    NSDictionary *dicoNodeBackgroundsActive =         [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PSSkillFrameActive", @"NotableFrameAllocated", @"KeystoneFrameAllocated", nil]
                                                                                  forKeys:[NSArray arrayWithObjects:@"normal", @"notable", @"keystone", nil]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    
    // SKILLS LAYER
    float icontype;
    NSMutableDictionary *spritesUnited = [NSMutableDictionary dictionary];
    NSMutableArray *snImages = [NSMutableArray arrayWithObjects:
                                [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"normal"]]) UIImage],
                                [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"normal"]]) UIImage],
                                [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"keystone"]]) UIImage],
                                [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"notable"]]) UIImage],
                                [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"keystone"]]) UIImage],
                                [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"notable"]]) UIImage], nil];
    
    NSDate *thenSKILLFORE;
    NSDate *thenSKILLBACK;
    UIImage *newImage;
    
    NSString *diskDataLayerSkillsCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data/Layers/skills.png"];
    
    UIImage *layerSkillsIMAGE;
    
    if (![fileManager fileExistsAtPath:diskDataLayerSkillsCachePath])
    {
        UIView *layerSkills = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fullX/Zoom/MiniScale, fullY/Zoom/MiniScale)];
        layerSkills.backgroundColor = [UIColor clearColor];
        
        for (NSString *key in self.skillNodes) {
            
            
            
            SkillNode *sn = [self.skillNodes objectForKey:key];
            
            // START NODES
            if ([arrayCharName indexOfObject:sn.name] != NSNotFound) {
                
                UIImage *faceImg;
                
                if ([arrayCharName indexOfObject:sn.name] == (self.characterClassID - 1)) {
                    faceImg = [((Asset *)[assets objectForKey:[arrayFaceNames objectAtIndex:[arrayCharName indexOfObject:sn.name]]]) UIImage];
                }
                else
                    faceImg = [((Asset *)[assets objectForKey:@"PSStartNodeBackgroundInactive"]) UIImage];
                
                
                CGSize targetSize = CGSizeMake(faceImg.size.width/MiniScale,  faceImg.size.height/MiniScale);
                
                UIGraphicsBeginImageContext(targetSize); // this will crop
                
                CGRect newSize = CGRectZero;
                //thumbnailRect.origin = thumbnailPoint;
                newSize.size.width  = targetSize.width;
                newSize.size.height = targetSize.height;
                
                [faceImg drawInRect:newSize];
                
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
                imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                [layerSkills addSubview:imageView];
                
                continue;
                //[skillFaceGroups addObject:[node valueForKey:@"g"]];
            }
            
            //continue;
            
            NSString *iconkey = sn.isMastery ? @"mastery" : (sn.isKeystone ? @"keystoneInactive" : (sn.isNotable ? @"notableInactive" : @"normalInactive"));
            NSString *spriteSheetName = [[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] objectForKey:iconkey] allKeys] objectAtIndex:0];

            if ([spritesUnited objectForKey:spriteSheetName] && [[spritesUnited objectForKey:spriteSheetName] objectForKey:[sn icon]] && [[[spritesUnited objectForKey:spriteSheetName] objectForKey:[sn icon]] objectForKey:iconkey]) {
                //NSLog(@"OK DEJA");
                //NSLog(@"D iconkey %@", iconkey);
                
            }
            else
            {
                
                icontype = sn.isMastery ? 2.61f/Zoom/MiniScale : (sn.isKeystone ? 2.61f/Zoom/MiniScale : (sn.isNotable ? 2.61f/Zoom/MiniScale : 2.61f/Zoom/MiniScale));
                
                //icontype = 2.61f;
                CGRect rect = CGRectFromString([[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] objectForKey:iconkey] allValues] objectAtIndex:0]);
                
                
                //NSLog(@"spriteSheetName %@", spriteSheetName);
                //NSLog(@"rect %@", NSStringFromCGRect(rect));
                
                UIImage *sprite = [iconInactiveSkills.images objectForKey:spriteSheetName];
                
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
                
                if ([spritesUnited objectForKey:spriteSheetName]) {
                    if ([[spritesUnited objectForKey:spriteSheetName] objectForKey:[sn icon]]) {
                        [[[spritesUnited objectForKey:spriteSheetName] objectForKey:[sn icon]] setObject:newImage forKey:iconkey];
                    }
                    else
                    {
                        [[spritesUnited objectForKey:spriteSheetName] setObject:[NSMutableDictionary dictionaryWithObject:newImage forKey:iconkey] forKey:[sn icon]];
                    }
                }
                else {
                    [spritesUnited setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObject:newImage forKey:iconkey] forKey:[sn icon]]
                                      forKey:spriteSheetName];
                }
                

              
            }
           
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[[[spritesUnited objectForKey:spriteSheetName] objectForKey:[sn icon]] objectForKey:iconkey]];
            imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
            imageView.tag = sn.id * SkillSpriteID;

            if (!sn.isMastery) {
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
                singleTap.numberOfTapsRequired = 1;
                singleTap.numberOfTouchesRequired = 1;
                [imageView setUserInteractionEnabled:YES];
                [imageView addGestureRecognizer:singleTap];
                
                CALayer * l = [imageView layer];
                [l setMasksToBounds:YES];
                //[l setCornerRadius:30.0];
                
            }
            
            [layerSkills addSubview:imageView];
            
            //NSLog(@"%@ = %f %f %f %f", key, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
            
        }
    
    
        thenSKILLFORE = [NSDate date];
        
        
        
        int j;
        for (j = 0; j < [snImages count]; j++) {
            UIImage *object = [snImages objectAtIndex:j];
            
            
            icontype = 2.61f/Zoom/MiniScale;
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
                imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                imageView.tag = sn.id * SkillOverlayID;
                [layerSkills addSubview:imageView];
            }
            else if (sn.isKeystone) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:2]];
                imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                imageView.tag = sn.id * SkillOverlayID;
                [layerSkills addSubview:imageView];
            }
            else {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:0]];
                imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                imageView.tag = sn.id * SkillOverlayID;
                [layerSkills addSubview:imageView];
            }
            
        }
        
        layerSkillsIMAGE = [layerSkills capture];
        //[UIImageJPEGRepresentation(layerBackgroundIMAGE, 0.8) writeToFile:diskDataLayerBackgroundCachePath atomically:YES];
        [UIImagePNGRepresentation(layerSkillsIMAGE) writeToFile:diskDataLayerSkillsCachePath atomically:YES];
        
    }
    else
    {
        layerSkillsIMAGE = [UIImage imageWithContentsOfFile:diskDataLayerSkillsCachePath];
    }
    
    [self insertSubview:[[UIImageView alloc] initWithImage:layerSkillsIMAGE] atIndex:10];

    //[self addSubview:[[UIImageView alloc] initWithImage:layerSkillsIMAGE]];
}

@end
