//
//  ViewController.m
//  POEMPST
//
//  Created by Shasta on 31/03/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *containerView;

- (void)centerScrollViewContents;
//- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
//- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation ViewController

@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;


- (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@", [gestureRecognizer view]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    
    
    NSURL *clientURL = [[NSBundle mainBundle] URLForResource:@"passive-skill-tree" withExtension:@"html"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:clientURL];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // tempiVAR
        int characterClassID = 0;
        NSArray *arrayFaceNames = [NSArray arrayWithObjects:@"centermarauder", @"centerranger", @"centerwitch", @"centerduelist", @"centertemplar", @"centershadow", nil];
        NSArray *arrayCharName = [NSArray arrayWithObjects:@"MARAUDER", @"RANGER", @"WITCH", @"DUELIST", @"TEMPLAR", @"SIX", nil];
        NSDictionary *dicoNodeBackgrounds =         [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PSSkillFrame", @"NotableFrameUnallocated", @"KeystoneFrameUnallocated", nil]
                                                                                forKeys:[NSArray arrayWithObjects:@"normal", @"notable", @"keystone", nil]];
        NSDictionary *dicoNodeBackgroundsActive =         [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PSSkillFrameActive", @"NotableFrameAllocated", @"KeystoneFrameAllocated", nil]
                                                                                      forKeys:[NSArray arrayWithObjects:@"normal", @"notable", @"keystone", nil]];
        //-- tempiVAR
        
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *regex = @"var passiveSkillTreeData(.*)";
        
        NSString *JSData = [[responseString stringByMatching:regex] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        
        NSRange r = NSMakeRange(27, JSData.length - 27 - 1);
        JSData = [JSData substringWithRange: r];
        NSDictionary* json = [JSData objectFromJSONString];

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
        
        NSLog(@"%d", u);
        characterClassID = u;
        
        
        NSMutableArray *f = [NSMutableArray array]; //skills
        while ([ss hasData]) {
            [f addObject:[NSNumber numberWithInteger:[ss readInt16]]];
        }
        
        NSLog(@"%@", f);
        //-- URL
        
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
            
            NSLog(@"%@ = %@", filename, key);
            
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
        NSMutableDictionary *skillNodes = [NSMutableDictionary dictionary];
        NSMutableArray *skillFaceGroups = [NSMutableArray array];
        
        for (NSDictionary *node in [json valueForKey:@"nodes"]) {

            SkillNode *skillNode = [[SkillNode alloc] initWithDictionary:node];
            [skillNodes setValue:skillNode forKey:[node valueForKey:@"id"]];
            
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
                
                [[skillNodes objectForKey:key2] setNodeGroup:ng];
                                
                //NSLog(@"key2 %@", key2);
            }
        }
        //-- Groups

        //NSLog(@"%@", skillNodes);
        
        float min_x = [[json objectForKey:@"min_x"] floatValue];
        float min_y = [[json objectForKey:@"min_y"] floatValue];
        float max_x = [[json objectForKey:@"max_x"] floatValue];
        float max_y = [[json objectForKey:@"max_y"] floatValue];
        
        //[self performSelectorOnMainThread:@selector(myMethod:) withObject:anObj waitUntilDone:YES];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            float fullX, fullY;
            //fullX = (float)(abs(min_x) + abs(max_x));
            fullX = (float)(MAX(abs(min_x),abs(max_x))*2.1);
            fullY = (float)(MAX(abs(min_y),abs(max_y))*2.1);
            //fullY = (float)(abs(minY) + abs(maxY));
            
            // Set up the container view to hold your custom view hierarchy
            CGSize containerSize = CGSizeMake(fullX, fullY);
            
            self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
            UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[((Asset *)[assets objectForKey:@"Background1"]) UIImage]];
            self.containerView.backgroundColor = backgroundColor;
            
            [self.scrollView addSubview:self.containerView];

            // BACKGROUNDS LAYER
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
                
                CGSize targetSize = CGSizeMake(object.size.width*2.61f, object.size.height*2.61f); //2.65;

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
                imageView.center = CGPointMake(ng.position.x + fullX/2, ng.position.y + fullY/2);
                [self.containerView addSubview:imageView];

            }
            //-- BACKGROUNDS LAYER

            
            // SKILLS LAYER
            float icontype;
            NSMutableDictionary *spritesUnited = [NSMutableDictionary dictionary];


//            [iv setUserInteractionEnabled:YES];
            
            for (NSString *key in skillNodes) {
                

                
                SkillNode *sn = [skillNodes objectForKey:key];

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
                    [self.containerView addSubview:imageView];
                    
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
                
                [self.containerView addSubview:imageView];
                
                //NSLog(@"%@ = %f %f %f %f", key, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
                
            }
            
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
            
            for (NSString *key in skillNodes) {
                
                SkillNode *sn = [skillNodes objectForKey:key];

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
                    [self.containerView addSubview:imageView];
                }
                else if (sn.isKeystone) {
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:2]];
                    imageView.center = CGPointMake(sn.Position.x + fullX/2, sn.Position.y + fullY/2);
                    imageView.tag = sn.id * SkillOverlayID;
                    [self.containerView addSubview:imageView];
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:0]];
                    imageView.center = CGPointMake(sn.Position.x + fullX/2, sn.Position.y + fullY/2);
                    imageView.tag = sn.id * SkillOverlayID;
                    [self.containerView addSubview:imageView];
                }
                
            }
            //-- SKILLS LAYER
            
            
           // NSLog(@"ACTIVE");
            // ACTIVE SKILLS
            NSMutableDictionary *spritesUnitedActive = [NSMutableDictionary dictionary];

            for (NSString *key in skillNodes) {
                SkillNode *sn = [skillNodes objectForKey:key];

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
                
                UIImageView *skillView = (UIImageView *)[self.containerView viewWithTag:(sn.id * SkillSpriteID)];
                //NSLog(@"SVi %@", NSStringFromCGRect(skillView.frame));
                //NSLog(@"UIi %@", NSStringFromCGSize(((UIImage *)[[spritesUnitedActive objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] objectForKey:[sn icon]]).size));
                
                [skillView setImage:[[spritesUnitedActive objectForKey:[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] allKeys] objectAtIndex:0]] objectForKey:[sn icon]]];
                
            }
            
            
            
            
            for (NSNumber *skillID in f) {
                //NSLog(@"%@", skillID);
                UIImageView *skillView = (UIImageView *)[self.containerView viewWithTag:([skillID intValue] * SkillOverlayID)];
                
                SkillNode *sn = [skillNodes objectForKey:skillID];

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
            
            
            
            
            
            
            
            
            // Tell the scroll view the size of the contents
            self.scrollView.contentSize = containerSize;
            
            // Set up the minimum & maximum zoom scales
            CGRect scrollViewFrame = self.scrollView.frame;
            CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
            CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
                        
            self.scrollView.minimumZoomScale = minScale;
            self.scrollView.maximumZoomScale = 0.3835f;
            self.scrollView.zoomScale = minScale;
            
            [self centerScrollViewContents];
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
    

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return true;
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
