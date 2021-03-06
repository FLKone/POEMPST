//
//  SkillTreeView.m
//  POEMPST
//
//  Created by FLK on 06/04/13.
//

#import "SkillTreeView.h"

@implementation SkillTreeView

@synthesize skillLinksView;
@synthesize skillNodes, skillLinks, assets, nodeGroups, skillFaceGroups;
@synthesize fullY, fullX, characterClassID, arrayCharName;
@synthesize iconActiveSkills, iconInactiveSkills, activeSkills;
@synthesize dicoNodeBackgrounds, dicoNodeBackgroundsActive, snImages, touchLayer, spritesUnitedActive, spritesUnitedInactive, arrayFaceNames, graph, rootID, characterData;
@synthesize currentDextLabel, currentStrLabel, currentIntelLabel;
@synthesize skillPicker = _skillPicker;
@synthesize skillPickerPopover = _skillPickerPopover;

- (void)loadClass:(NSNotification *)sender {
    self.isFromURL = NO;
    
    //NSLog(@"loadClass %@", sender);
    self.characterClassID = ((UIButton*)sender.object).tag/BTNID;
    self.activeSkills = [NSMutableArray array];
    
    for (NSNumber *skillID in self.skillNodes) {
        
        SkillNode *sn = [self.skillNodes objectForKey:skillID];
        
        if ([arrayCharName indexOfObject:sn.name] == (self.characterClassID - 1)) {
            self.rootID = [NSString stringWithFormat:@"%d", sn.id];            
            [self.activeSkills addObject:[NSNumber numberWithInt:sn.id]];
            break;
        }
        
    }
    
    [self drawActiveLayer:self.skillLinks];
}

- (void)loadUrl:(NSNotification *)sender {
    self.isFromURL = YES;
    //NSLog(@"loadUrl %@", sender);
    
    if ([sender.object rangeOfString:@"http://www.pathofexile.com/passive-skill-tree/"].location == NSNotFound) {
        
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // LOAD URL
            //NSLog(@"dispatch_async loadURL");
            
            NSString *siteUrl = @"http://www.pathofexile.com/passive-skill-tree/";
            //NSString *loadUrl = @"http://www.pathofexile.com/passive-skill-tree/AAAAAgMADY0c3CL0VK5XK2sXbAttGX3Sf8aio8Hz";
            NSString *loadUrl = sender.object;//@"http://www.pathofexile.com/passive-skill-tree/AAAAAgUABVsWQClPPAVG12aeeuZ9U4KbgziFfYuMnYCf39R83QXhc-dq7SDvfPfB-tI=";
            
            NSString *s = [[[loadUrl stringByReplacingOccurrencesOfString:siteUrl withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@"+"] stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
            
            NSLog(@"s %@", s);
            
            /*
            NSString *stringValue = s;
             Byte inputData[[stringValue lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];//prepare a Byte[]
            [[stringValue dataUsingEncoding:NSUTF8StringEncoding] getBytes:inputData];//get the pointer of the data
            size_t inputDataSize = (size_t)[stringValue length];
            size_t outputDataSize = EstimateBas64DecodedDataSize(inputDataSize);//calculate the decoded data size
            Byte outputData[outputDataSize];//prepare a Byte[] for the decoded data
            Base64DecodeData(inputData, inputDataSize, outputData, &outputDataSize);//decode the data
            */
            NSData *theData = [NSData dataFromBase64String:s];//[[NSData alloc] initWithBytes:outputData length:outputDataSize];//create a NSData object from the decoded data

           // NSLog(@"theData   %@", theData);
          //  NSLog(@"theString %@", s);

            NSLog(@"b4");

            DataString *ss = [[DataString alloc] init];
            [ss setDataString:theData];
            
            NSLog(@"a4");

            int o = [ss readInt:0]; //ver
            int u = [ss readInt8];  //char
            int a = 0;
            o > 0 && (a = [ss readInt8]);
            
            if (u == 0 || o > 5) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"errorLoading" object:@"URL" userInfo:nil];
                NSLog(@"ERROR URL");
                return;

            }
            
            NSLog(@"u %d | o %d", u, o);
            self.characterClassID = u;

            NSMutableArray *f = [NSMutableArray array]; //skills
            int returnInt = 0;
            while ([ss hasData] && returnInt != -1) {
                returnInt = [ss readInt16];
                //NSLog(@"return Int %d", returnInt);
                [f addObject:[NSNumber numberWithInteger:returnInt]];
            }
            
            if (returnInt == -1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"errorLoading" object:@"URL" userInfo:nil];
                return;
            }
            
            self.activeSkills = f;
            //NSLog(@"f %@", f);
            //-- LOAD URL
            
            
            //[self.skillLinksView setNeedsDisplay];
            
            for (NSNumber *skillID in self.skillNodes) {
                
                SkillNode *sn = [self.skillNodes objectForKey:skillID];
                
                if ([arrayCharName indexOfObject:sn.name] == (self.characterClassID - 1)) {
                    self.rootID = [NSString stringWithFormat:@"%d", sn.id];
                    [self.activeSkills addObject:[NSNumber numberWithInt:sn.id]];
                    break;
                }
                
            }
            
                       
            
            
            
            [self drawActiveLayer:self.skillLinks];
        });

        //[self drawActiveLayer:YES];
        //[self drawBackgroundLayer];
    }
}

-(void)unload {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"loadUrl"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"loadClass"];

    self.skillLinksView = nil;
    self.touchLayer = nil;
    
    self.skillNodes = nil;
    self.skillLinks = nil;
    self.assets = nil;
    self.nodeGroups = nil;
    self.skillFaceGroups = nil;
    self.arrayCharName = nil;
    self.iconActiveSkills = nil;
    self.iconInactiveSkills = nil;
    self.activeSkills = nil;
    
    self.characterData = nil;
    
    self.rootID = nil;
    self.dicoNodeBackgrounds = nil;
    self.dicoNodeBackgroundsActive = nil;
    self.snImages = nil;
    self.spritesUnitedActive = nil;
    self.spritesUnitedInactive = nil;
    self.arrayFaceNames = nil;
    self.graph = nil;
}

- (id)initWithFrame:(CGRect)frame andJSON:(NSDictionary *)json
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP1] userInfo:nil];

    //NSLog(@"initWithFrameandJSON");
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // iVAR
        self.characterClassID = 0;
        self.arrayCharName = [NSArray arrayWithObjects:@"MARAUDER", @"RANGER", @"WITCH", @"DUELIST", @"TEMPLAR", @"SIX", nil];
        self.dicoNodeBackgrounds =          [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PSSkillFrame", @"NotableFrameUnallocated", @"KeystoneFrameUnallocated", nil]
                                                                        forKeys:[NSArray arrayWithObjects:@"normal", @"notable", @"keystone", nil]];
        self.dicoNodeBackgroundsActive =    [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PSSkillFrameActive", @"NotableFrameAllocated", @"KeystoneFrameAllocated", nil]
                                                                        forKeys:[NSArray arrayWithObjects:@"normal", @"notable", @"keystone", nil]];
        self.arrayFaceNames = [NSArray arrayWithObjects:@"centermarauder", @"centerranger", @"centerwitch", @"centerduelist", @"centertemplar", @"centershadow", nil];
        self.spritesUnitedActive = [NSMutableDictionary dictionary];
        self.spritesUnitedInactive = [NSMutableDictionary dictionary];
        self.graph = [[PESGraph alloc] init];
        self.isFromURL = NO;
        
        self.currentDextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 21)];
        self.currentIntelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 21)];
        self.currentStrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 21)];
        [self.currentDextLabel setBackgroundColor:[UIColor clearColor]];
        [self.currentIntelLabel setBackgroundColor:[UIColor clearColor]];
        [self.currentStrLabel setBackgroundColor:[UIColor clearColor]];

        self.currentDextLabel.font = [UIFont fontWithName:@"Fontin-Regular" size:7.0];
        self.currentIntelLabel.font = [UIFont fontWithName:@"Fontin-Regular" size:7.0];
        self.currentStrLabel.font = [UIFont fontWithName:@"Fontin-Regular" size:7.0];

        [self.currentDextLabel setTextAlignment:NSTextAlignmentCenter];
        [self.currentIntelLabel setTextAlignment:NSTextAlignmentCenter];
        [self.currentStrLabel setTextAlignment:NSTextAlignmentCenter];
        //self.currentDextLabel.font = [UIFont systemFontOfSize:7.0];
        //self.currentIntelLabel.font = [UIFont systemFontOfSize:7.0];
        //self.currentStrLabel.font = [UIFont systemFontOfSize:7.0];
        [self.currentIntelLabel setTextColor:[UIColor colorWithRed:73/255.f green:159/255.f blue:210/255.f alpha:1.00]];
        [self.currentStrLabel setTextColor:[UIColor colorWithRed:205/255.f green:47/255.f blue:19/255.f alpha:1.00]];
        [self.currentDextLabel setTextColor:[UIColor colorWithRed:4/255.f green:195/255.f blue:4/255.f alpha:1.00]];
        //-- iVAR

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUrl:) name:@"loadUrl" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadClass:) name:@"loadClass" object:nil];
                
        //characterData
        self.characterData = [json objectForKey:@"characterData"];
        //-- characterData
        
        
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
            
            for (NSString *key2 in [jobj objectForKey:@"coords"]) {
                
                NSDictionary *jobj2 = [[jobj objectForKey:@"coords"] objectForKey:key2];
                
                NSDictionary *skill = [NSDictionary dictionaryWithObject:NSStringFromCGRect(CGRectMake([[jobj2 objectForKey:@"x"] floatValue], [[jobj2 objectForKey:@"y"] floatValue], [[jobj2 objectForKey:@"w"] floatValue], [[jobj2 objectForKey:@"h"] floatValue])) forKey:filename];
                
                if ([iconActiveSkills.skillPositions objectForKey:key2]) {
                    [[iconActiveSkills.skillPositions objectForKey:key2] setObject:skill forKey:key];
                }
                else
                    [iconActiveSkills.skillPositions setObject:[NSMutableDictionary dictionaryWithObject:skill forKey:key] forKey:key2];
                                
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
                
                if ([iconInactiveSkills.skillPositions objectForKey:key2]) {
                    [[iconInactiveSkills.skillPositions objectForKey:key2] setObject:skill forKey:key];
                }
                else
                    [iconInactiveSkills.skillPositions setObject:[NSMutableDictionary dictionaryWithObject:skill forKey:key] forKey:key2];
                
            }
            
        }
        
        [iconActiveSkills OpenOrDownloadImages];
        [iconInactiveSkills OpenOrDownloadImages];
        //-- Skill Sprites
        NSLog(@"00");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP2] userInfo:nil];

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
        NSLog(@"10");

        self.snImages = [NSMutableArray arrayWithObjects:
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"normal"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"normal"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"keystone"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgrounds objectForKey:@"notable"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"keystone"]]) UIImage],
                                    [((Asset *)[assets objectForKey:[dicoNodeBackgroundsActive objectForKey:@"notable"]]) UIImage], nil];
        
        
        
        int j;
        for (j = 0; j < [snImages count]; j++) {
            UIImage *object = [snImages objectAtIndex:j];
            
            
            float icontype = 2.61f/Zoom/MiniScale*2;
            CGSize targetSize = CGSizeMake(object.size.width * icontype, object.size.height * icontype);
            
            UIGraphicsBeginImageContext(targetSize); // this will crop
            
            CGRect newSize = CGRectZero;
            //thumbnailRect.origin = thumbnailPoint;
            newSize.size.width  = targetSize.width;
            newSize.size.height = targetSize.height;
            
            [object drawInRect:newSize];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            //pop the context to get back to the default
            UIGraphicsEndImageContext();
            
            [snImages replaceObjectAtIndex:j withObject:newImage];
            
        }
        
        //-- Assets

        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP3] userInfo:nil];

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
        NSLog(@"30");

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
        NSLog(@"40");

        //LINKS
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *diskLinksCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data/links.plist"];
        
        if (![fileManager fileExistsAtPath:diskLinksCachePath])
        {
            self.skillLinks = [NSMutableArray array];
            int i = 0;
            for (NSString *key in self.skillNodes) {
                //NSLog(@"400");
                
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
                        //
                    }
                    
                    //NSLog(@"%d - %@ - %d", sn.id, i, indexSet.count);
                    [self.skillLinks addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:sn.id], i, nil]];
                    
                    
                }
                
                i++;
            }
            
            [self.skillLinks writeToFile:diskLinksCachePath atomically:YES];
        }
        else
        {
            self.skillLinks = [NSArray arrayWithContentsOfFile:diskLinksCachePath];
        }
        
        //-- LINKS
        //NSLog(@"skillLinks a4 %@", skillLinks);
        NSLog(@"50");

        float min_x = [[json objectForKey:@"min_x"] floatValue];
        float min_y = [[json objectForKey:@"min_y"] floatValue];
        float max_x = [[json objectForKey:@"max_x"] floatValue];
        float max_y = [[json objectForKey:@"max_y"] floatValue];

        fullX = (float)(MAX(abs(min_x),abs(max_x))*2.15);
        fullY = (float)(MAX(abs(min_y),abs(max_y))*2.15);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP4] userInfo:nil];

    }
    
    [self drawBackgroundLayer];
    
    return self;
}

-(void)drawBackgroundLayer {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *diskDataLayerBackgroundCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data/Layers/background-v2.png"];
    
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
    
        //-- BACKGROUND
        
        // LINKS

        SkillLinksView *localskillLinksView = [[SkillLinksView alloc] initWithFrame:CGRectMake(0, 0, fullX/Zoom/MiniScale, fullY/Zoom/MiniScale)
                                                                           andLinks:skillLinks
                                                                          andSkills:skillNodes];
        [localskillLinksView load];
            
        [layerBackground addSubview:localskillLinksView];
        

        //-- LINKS
        
        layerBackgroundIMAGE = [layerBackground capture];
        [UIImagePNGRepresentation(layerBackgroundIMAGE) writeToFile:diskDataLayerBackgroundCachePath atomically:YES];
        
    }
    
    layerBackgroundIMAGE = [UIImage imageWithContentsOfFile:diskDataLayerBackgroundCachePath];
    
    [self insertSubview:[[UIImageView alloc] initWithImage:layerBackgroundIMAGE] atIndex:10];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP5] userInfo:nil];

    
    self.skillLinksView = [[SkillLinksView alloc] initWithFrame:CGRectMake(0, 0, fullX/Zoom/MiniScale, fullY/Zoom/MiniScale) andLinks:skillLinks andSkills:skillNodes];
    [self insertSubview:self.skillLinksView atIndex:10];


    
    NSString *diskDataLayerSkillsCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data/Layers/skills-v2.png"];
    UIImage *outputImage;
    
    if (![fileManager fileExistsAtPath:diskDataLayerSkillsCachePath])
    {

        // SKILLS LAYER
        CGFloat width = fullX/Zoom/MiniScale*2, height = fullY/Zoom/MiniScale*2;
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        
        //UIView *layerSkills = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fullX/Zoom/MiniScale, fullY/Zoom/MiniScale)];
        //layerSkills.backgroundColor = [UIColor clearColor];
        UIImage *newImage;
        
        float icontype;
        self.spritesUnitedInactive = [NSMutableDictionary dictionary];
        
        for (NSString *key in self.skillNodes) {
            
            SkillNode *sn = [self.skillNodes objectForKey:key];
            
            // START NODES
            if ([arrayCharName indexOfObject:sn.name] != NSNotFound) {
                
                UIImage *faceImg = [((Asset *)[assets objectForKey:@"PSStartNodeBackgroundInactive"]) UIImage];
                
                CGSize targetSize = CGSizeMake(faceImg.size.width/MiniScale*2,  faceImg.size.height/MiniScale*2);
                
                //UIGraphicsBeginImageContext(targetSize); // this will crop
                
                CGRect newSize = CGRectZero;
                //thumbnailRect.origin = thumbnailPoint;
                newSize.size.width  = targetSize.width;
                newSize.size.height = targetSize.height;
                newSize.origin.x = (sn.Position.x + fullX/2)/Zoom/MiniScale*2 - newSize.size.height / 2;
                newSize.origin.y = (sn.Position.y + fullY/2)/Zoom/MiniScale*2 - newSize.size.height / 2;
                
                [faceImg drawInRect:newSize];
                
                //newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
                //imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                //[layerSkills addSubview:imageView];
                
                continue;
            }
            
            NSString *iconkey = sn.isMastery ? @"mastery" : (sn.isKeystone ? @"keystoneInactive" : (sn.isNotable ? @"notableInactive" : @"normalInactive"));
            NSString *spriteSheetName = [[[[iconInactiveSkills.skillPositions objectForKey:[sn icon]] objectForKey:iconkey] allKeys] objectAtIndex:0];
            
            if ([self.spritesUnitedInactive objectForKey:spriteSheetName] && [[spritesUnitedInactive objectForKey:spriteSheetName] objectForKey:[sn icon]] && [[[self.spritesUnitedInactive objectForKey:spriteSheetName] objectForKey:[sn icon]] objectForKey:iconkey]) {
                //NSLog(@"OK DEJA");
                //NSLog(@"D iconkey %@", iconkey);
                
            }
            else
            {
                //continue;
                icontype = sn.isMastery ? 2.61f/Zoom/MiniScale : (sn.isKeystone ? 2.61f/Zoom/MiniScale : (sn.isNotable ? 2.61f/Zoom/MiniScale : 2.61f/Zoom/MiniScale));
                icontype = icontype*2;
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
                
                if ([self.spritesUnitedInactive objectForKey:spriteSheetName]) {
                    if ([[self.spritesUnitedInactive objectForKey:spriteSheetName] objectForKey:[sn icon]]) {
                        [[[self.spritesUnitedInactive objectForKey:spriteSheetName] objectForKey:[sn icon]] setObject:newImage forKey:iconkey];
                    }
                    else
                    {
                        [[self.spritesUnitedInactive objectForKey:spriteSheetName] setObject:[NSMutableDictionary dictionaryWithObject:newImage forKey:iconkey] forKey:[sn icon]];
                    }
                }
                else {
                    [self.spritesUnitedInactive setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObject:newImage forKey:iconkey] forKey:[sn icon]]
                                                   forKey:spriteSheetName];
                }
                
                
                
            }
            
            UIImage *tmpI = [[[self.spritesUnitedInactive objectForKey:spriteSheetName] objectForKey:[sn icon]] objectForKey:iconkey];
            [tmpI drawInRect:
             CGRectMake((sn.Position.x + fullX/2)/Zoom/MiniScale*2 - tmpI.size.width / 2, (sn.Position.y + fullY/2)/Zoom/MiniScale*2 - tmpI.size.height / 2, tmpI.size.width, tmpI.size.height)];
            
            //UIImageView *imageView = [[UIImageView alloc] initWithImage:[[[self.spritesUnitedInactive objectForKey:spriteSheetName] objectForKey:[sn icon]] objectForKey:iconkey]];
            //imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
            
            //[layerSkills addSubview:imageView];
            
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP6] userInfo:nil];
        
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
                //UIImage *OverlayTmp = [[UIImage alloc] initWithCGImage:[[self.snImages objectAtIndex:3] CGImage]
                //                                                 scale:2
                //                                           orientation:UIImageOrientationUp];
                
                UIImage *tmpI = [self.snImages objectAtIndex:3];
                [tmpI drawInRect:CGRectMake((sn.Position.x + fullX/2)/Zoom/MiniScale*2 - tmpI.size.width / 2,
                                            (sn.Position.y + fullY/2)/Zoom/MiniScale*2 - tmpI.size.height / 2,
                                            tmpI.size.width,
                                            tmpI.size.height)];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:OverlayTmp];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:3]];
                //imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                //imageView.tag = sn.id * SkillOverlayID;
                //[layerSkills addSubview:imageView];
            }
            else if (sn.isKeystone) {
                //UIImage *OverlayTmp = [[UIImage alloc] initWithCGImage:[[self.snImages objectAtIndex:2] CGImage]
                //                                                 scale:2
                //                                           orientation:UIImageOrientationUp];
                
                UIImage *tmpI = [self.snImages objectAtIndex:2];
                [tmpI drawInRect:CGRectMake((sn.Position.x + fullX/2)/Zoom/MiniScale*2 - tmpI.size.width / 2,
                                            (sn.Position.y + fullY/2)/Zoom/MiniScale*2 - tmpI.size.height / 2,
                                            tmpI.size.width,
                                            tmpI.size.height)];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:OverlayTmp];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:2]];
                //imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                //imageView.tag = sn.id * SkillOverlayID;
                //[layerSkills addSubview:imageView];
            }
            else {
                //UIImage *OverlayTmp = [[UIImage alloc] initWithCGImage:[[self.snImages objectAtIndex:0] CGImage]
                //                                                 scale:2
                //                                           orientation:UIImageOrientationUp];
                
                UIImage *tmpI = [self.snImages objectAtIndex:0];
                [tmpI drawInRect:CGRectMake((sn.Position.x + fullX/2)/Zoom/MiniScale*2 - tmpI.size.width / 2,
                                            (sn.Position.y + fullY/2)/Zoom/MiniScale*2 - tmpI.size.height / 2,
                                            tmpI.size.width,
                                            tmpI.size.height)];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:OverlayTmp];
                
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:[snImages objectAtIndex:0]];
                //imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                //imageView.tag = sn.id * SkillOverlayID;
                //[layerSkills addSubview:imageView];
            }
            
        }
        
        UIGraphicsPopContext();
        outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [UIImagePNGRepresentation(outputImage) writeToFile:diskDataLayerSkillsCachePath atomically:NO];

        
    }
    
    
    outputImage = [UIImage imageWithContentsOfFile:diskDataLayerSkillsCachePath];

    UIImageView *tmpUIV = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithCGImage:[outputImage CGImage]
                                                                                        scale:2
                                                                                  orientation:UIImageOrientationUp]];
    [self insertSubview:tmpUIV atIndex:10];
    
    //[self insertSubview:layerSkills atIndex:10];

    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP7] userInfo:nil];

    [self drawTouchLayer];
}

-(void)drawTouchLayer {
    
    self.touchLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fullX/Zoom/MiniScale, fullY/Zoom/MiniScale)];
    
    for (NSNumber *skillID in self.skillNodes) {
        
        SkillNode *sn = [self.skillNodes objectForKey:skillID];
        
        if ([skillFaceGroups indexOfObject:[NSNumber numberWithInt:sn.g]] != NSNotFound && [arrayCharName indexOfObject:sn.name] != NSNotFound) {
            continue;
        }
        
        if (sn.isMastery) {
            continue;
        }
        
        NSString *iconkey = sn.isMastery ? @"mastery" : (sn.isKeystone ? @"keystoneActive" : (sn.isNotable ? @"notableActive" : @"normalActive"));
        CGRect rect = CGRectFromString([[[[iconActiveSkills.skillPositions objectForKey:[sn icon]] objectForKey:iconkey] allValues] objectAtIndex:0]);
        
        float TouchLayerScale = 1;
        TouchLayerScale = (rect.size.width > 35 ? TouchLayerScaleDown : TouchLayerScaleUp);
        
        rect.size.width = rect.size.width*TouchLayerScale;
        rect.size.height = rect.size.height*TouchLayerScale;
        
        SkillTouchView *touchView = [[SkillTouchView alloc] initWithFrame:rect];
        touchView.scaleTouch = TouchLayerScale;
        touchView.clipsToBounds = YES;
        touchView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
        touchView.tag = sn.id;
        
        //touchView.layer.borderColor = [UIColor redColor].CGColor;
        //touchView.layer.borderWidth = 1.0f;
        
        if (!sn.isMastery) {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSkillButtonTapped:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [touchView setUserInteractionEnabled:YES];
            [touchView addGestureRecognizer:singleTap];
        }
        
        [self.touchLayer addSubview:touchView];
        
    }
    

    
    [self insertSubview:self.touchLayer atIndex:10];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP8] userInfo:nil];


}

-(void)drawActiveLayer:(NSArray *)forLinks {
    BOOL isFirstLoad = NO;
    NSLog(@"drawActiveLayer isFirstLoad %d", isFirstLoad);

    //ACTIVATE START NODE
    if ([self.touchLayer viewWithTag:ACTIVEFACEID]) {
        //
    }
    else {
        for (NSString *key in self.skillNodes) {
            
            SkillNode *sn = [self.skillNodes objectForKey:key];
            
            if ([arrayCharName indexOfObject:sn.name] != NSNotFound) {
                
                
                UIImage *faceImg;
                UIImage *newImage;
                
                if ([arrayCharName indexOfObject:sn.name] == (self.characterClassID - 1)) {
                    
                    
                    //[self.activeSkills addObject:[NSNumber numberWithInt:sn.id]];
                    //NSLog(@"ID START %d", sn.id);
                    
                    faceImg = [((Asset *)[assets objectForKey:[arrayFaceNames objectAtIndex:[arrayCharName indexOfObject:sn.name]]]) UIImage];
                    

                    CGSize targetSize = CGSizeMake(faceImg.size.width/MiniScale*2,  faceImg.size.height/MiniScale*2);
                    
                    UIGraphicsBeginImageContext(targetSize); // this will crop
                    
                    CGRect newSize = CGRectZero;
                    //thumbnailRect.origin = thumbnailPoint;
                    newSize.size.width  = targetSize.width;
                    newSize.size.height = targetSize.height;
                    
                    [faceImg drawInRect:newSize];
                    
                    newImage = UIGraphicsGetImageFromCurrentImageContext();
                    
                    UIImage *newImageTmp = [[UIImage alloc] initWithCGImage:[newImage CGImage]
                                                                     scale:2
                                                               orientation:UIImageOrientationUp];
                                           
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:newImageTmp];
                    
                    imageView.center = CGPointMake((sn.Position.x + fullX/2)/Zoom/MiniScale, (sn.Position.y + fullY/2)/Zoom/MiniScale);
                    imageView.tag = ACTIVEFACEID;
                   // NSLog(@"frame %f %f", self.superview.bounds.size.width, self.superview.bounds.size.height);
                    
                    CGRect intFrame = CGRectMake(imageView.center.x - 11         , imageView.center.y - 35   , 22, 21);
                    CGRect dexFrame = CGRectMake(imageView.center.x - 11 + 22    , imageView.center.y + 1.5   , 22, 21);
                    CGRect strFrame = CGRectMake(imageView.center.x - 11 - 21    , imageView.center.y + 1.5   , 22, 21);
                    
                    self.currentDextLabel.frame     = dexFrame;
                    self.currentIntelLabel.frame    = intFrame;
                    self.currentStrLabel.frame      = strFrame;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!self.isFromURL) {
                            CGPoint newOffset;
                            newOffset.x = (sn.Position.x + fullX/2)/Zoom/MiniScale*MaxZoom - self.superview.frame.size.width/2;
                            newOffset.y = (sn.Position.y + fullY/2)/Zoom/MiniScale*MaxZoom - self.superview.frame.size.height/2;
                            
                            ((UIScrollView *)[self superview]).zoomScale = MaxZoom;
                            ((UIScrollView *)[self superview]).contentOffset = newOffset;
                        }
                        else
                        {
                            ((UIScrollView *)[self superview]).zoomScale = ((UIScrollView *)[self superview]).minimumZoomScale;
                        }
                        
                        //((UIScrollView *)[self superview]).zoomScale = ((UIScrollView *)[self superview]).minimumZoomScale;

                        [self.touchLayer insertSubview:currentIntelLabel atIndex:0];
                        [self.touchLayer insertSubview:currentStrLabel atIndex:0];
                        [self.touchLayer insertSubview:currentDextLabel atIndex:0];
                        [self.touchLayer insertSubview:imageView atIndex:0];
                    });
                    
                    
                    break;
                }
            }
        }
    }

    //-- ACTIVATE START NODE

    //LINKS
    NSMutableArray *skillLinkToActivate = [NSMutableArray array];
    NSMutableArray *skillLinkToHighlight = [NSMutableArray array];
    
    //NSLog(@"forLinks %@", forLinks);
    
    for (NSArray *link in forLinks) {
     
        
        if ([self.activeSkills indexOfObject:[link objectAtIndex:0]] == NSNotFound && [self.activeSkills indexOfObject:[link objectAtIndex:1]] == NSNotFound) {
            continue;
        }
        
        if ([self.activeSkills indexOfObject:[link objectAtIndex:0]] != NSNotFound && [self.activeSkills indexOfObject:[link objectAtIndex:1]] != NSNotFound) {
            //NSLog(@"IDX AC: %@", [NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]);
            [skillLinkToActivate addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] andWeight:[NSNumber numberWithInt:1]]
                               fromNode:[PESGraphNode nodeWithIdentifier:[NSString stringWithFormat:@"%@", [link objectAtIndex:0]]]
                                 toNode:[PESGraphNode nodeWithIdentifier:[NSString stringWithFormat:@"%@", [link objectAtIndex:1]]]];
            
            //NSLog(@"tags to AC = %d | %d", [[link objectAtIndex:0] intValue], [[link objectAtIndex:1] intValue]);
            
            SkillTouchView *tmpView = (SkillTouchView *)[self.touchLayer viewWithTag:[[link objectAtIndex:0] intValue]];
            SkillTouchView *tmpView2 = (SkillTouchView *)[self.touchLayer viewWithTag:[[link objectAtIndex:1] intValue]];

            dispatch_async(dispatch_get_main_queue(), ^{
                [tmpView2 highlight:isFirstLoad];
                [tmpView2 activate:isFirstLoad];
                
                [tmpView highlight:isFirstLoad];
                [tmpView activate:isFirstLoad];
            });
            
            if([tmpView.linksIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] == NSNotFound)
                [tmpView.linksIDs addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            if([tmpView2.linksIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] == NSNotFound)
                [tmpView2.linksIDs addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];

            if([tmpView.linksHighIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                [tmpView.linksHighIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            if([tmpView2.linksHighIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                [tmpView2.linksHighIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
        }
        
        if ([self.activeSkills indexOfObject:[link objectAtIndex:0]] != NSNotFound ^ [self.activeSkills indexOfObject:[link objectAtIndex:1]] != NSNotFound) {
            [skillLinkToHighlight addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            //NSLog(@"IDX HL: %@", [NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]);
            
            //[graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]]
            //                                             andWeight:[NSNumber numberWithInt:1]]
            //                   fromNode:[PESGraphNode nodeWithIdentifier:[NSString stringWithFormat:@"%@", [link objectAtIndex:0]]]
            //                     toNode:[PESGraphNode nodeWithIdentifier:[NSString stringWithFormat:@"%@", [link objectAtIndex:1]]]];

            if ([self.activeSkills indexOfObject:[link objectAtIndex:0]] != NSNotFound) {
                
                SkillTouchView *tmpView = (SkillTouchView *)[self.touchLayer viewWithTag:[[link objectAtIndex:0] intValue]];


                SkillTouchView *tmpView2 = (SkillTouchView *)[self.touchLayer viewWithTag:[[link objectAtIndex:1] intValue]];


                dispatch_async(dispatch_get_main_queue(), ^{
                    [tmpView2 highlight:isFirstLoad];
                    
                    [tmpView highlight:isFirstLoad];
                    [tmpView activate:isFirstLoad];
                });

                
                
                if([tmpView.linksHighIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] == NSNotFound)
                    [tmpView.linksHighIDs addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
                if([tmpView2.linksHighIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] == NSNotFound)
                    [tmpView2.linksHighIDs addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
                
                if([tmpView.linksIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                    [tmpView.linksIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
                if([tmpView2.linksIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                    [tmpView2.linksIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            }

            if ([self.activeSkills indexOfObject:[link objectAtIndex:1]] != NSNotFound) {
                SkillTouchView *tmpView = (SkillTouchView *)[self.touchLayer viewWithTag:[[link objectAtIndex:1] intValue]];

                
                SkillTouchView *tmpView2 = (SkillTouchView *)[self.touchLayer viewWithTag:[[link objectAtIndex:0] intValue]];

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tmpView2 highlight:isFirstLoad];
                    
                    [tmpView highlight:isFirstLoad];
                    [tmpView activate:isFirstLoad];
                });
                
                if([tmpView.linksHighIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] == NSNotFound)
                    [tmpView.linksHighIDs addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
                if([tmpView2.linksHighIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] == NSNotFound)
                    [tmpView2.linksHighIDs addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
                
                if([tmpView.linksIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                    [tmpView.linksIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
                if([tmpView2.linksIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                    [tmpView2.linksIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            }

        }

    }

    [self.skillLinksView activateLinks:skillLinkToActivate];
    [self.skillLinksView highlightLinks:skillLinkToHighlight];
    //-- LINKS
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkillCount" object:[NSNumber numberWithInt:self.activeSkills.count] userInfo:nil];
}

- (void)addActiveSkill:(NSNumber *)skillID {
    
    if ([self.activeSkills indexOfObject:skillID] == NSNotFound) {
        [self.activeSkills addObject:skillID];
        
        NSMutableArray *skillLinksToDisable = [NSMutableArray array];

        for (NSArray *link in self.skillLinks) {
            if ([[link objectAtIndex:0] integerValue] == [skillID integerValue] || [[link objectAtIndex:1] integerValue] == [skillID integerValue]) {
                [skillLinksToDisable addObject:link];
                
            }
        }
        [self drawActiveLayer:skillLinksToDisable];
    }
}

- (BOOL)removeActiveSkill:(NSNumber *)skillID {
    // CHECK IF IT CAN BE REMOVED
    SkillTouchView *tmpView = (SkillTouchView *)[self.touchLayer viewWithTag:[skillID intValue]];
    BOOL canBeRemoved = YES;

    
    //PESGraph *cgraph = graph;
    
    NSArray *connectedLinks = tmpView.linksIDs;
    
    for (NSNumber *linkIDX in connectedLinks) {
        NSArray *tmpLink = [self.skillLinks objectAtIndex:[linkIDX intValue]];
        
        NSLog(@"remove %@ > %@ | stringKey %@", [tmpLink objectAtIndex:0], [tmpLink objectAtIndex:1], [NSString stringWithFormat:@"%@", [tmpLink objectAtIndex:0]]);


        
        [graph removeBiDirectionalEdgeFromNode:[graph.nodes valueForKey:[NSString stringWithFormat:@"%@", [tmpLink objectAtIndex:0]]] toNode:[graph.nodes valueForKey:[NSString stringWithFormat:@"%@", [tmpLink objectAtIndex:1]]]];

        
    }
    
    for (NSNumber *linkIDX in connectedLinks) {
        NSArray *tmpLink = [self.skillLinks objectAtIndex:[linkIDX intValue]];
        
        if ([[tmpLink objectAtIndex:0] intValue] != [skillID intValue] && [[tmpLink objectAtIndex:0] intValue] != [self.rootID intValue]) {
            PESGraphRoute *route = [graph shortestRouteFromNode:[graph.nodes valueForKey:self.rootID]
                                                          toNode:[graph.nodes valueForKey:[NSString stringWithFormat:@"%@", [tmpLink objectAtIndex:0]]]];
            
            NSLog(@"route %@ >%@ c:%d l:%f", [tmpLink objectAtIndex:0], self.rootID, [route count], [route length]);

            if ([route length] == 0) {
                canBeRemoved = NO;
                //break;
            }
        }

        if ([[tmpLink objectAtIndex:1] intValue] != [skillID intValue] && [[tmpLink objectAtIndex:1] intValue] != [self.rootID intValue]) {
            PESGraphRoute *route2 = [graph shortestRouteFromNode:[graph.nodes valueForKey:self.rootID]
                                                          toNode:[graph.nodes valueForKey:[NSString stringWithFormat:@"%@", [tmpLink objectAtIndex:1]]]];
            
            NSLog(@"route2 %@ >%@ c:%d l:%f", [tmpLink objectAtIndex:1], self.rootID, [route2 count], [route2 length]);
            
            if ([route2 length] == 0) {
                canBeRemoved = NO;
                //break;
            }
            
        }
        
    }
    
    if (canBeRemoved) {
        NSLog(@"canBeRemoved");
    }
    else {
        for (NSNumber *linkIDX in connectedLinks) {
            NSArray *tmpLink = [self.skillLinks objectAtIndex:[linkIDX intValue]];
            
            [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:[linkIDX intValue]]]
                                                         andWeight:[NSNumber numberWithInt:1]]
                               fromNode:[graph.nodes valueForKey:[NSString stringWithFormat:@"%@", [tmpLink objectAtIndex:0]]]
                                 toNode:[graph.nodes valueForKey:[NSString stringWithFormat:@"%@", [tmpLink objectAtIndex:1]]]];
            
            
            
        }
        
        return NO;
    }
    //return;
    /*
    for (NSNumber *linkIDX in connectedLinks) {
        NSArray *tmpLink = [self.skillLinks objectAtIndex:[linkIDX intValue]];
        NSLog(@"%@", tmpLink);

        if ([[tmpLink objectAtIndex:0] intValue] == [skillID intValue]) {
            SkillTouchView *tmpView0 = (SkillTouchView *)[self.touchLayer viewWithTag:[[tmpLink objectAtIndex:1] intValue]];
            NSLog(@"tmpView0 %d %d", tmpView0.tag, tmpView0.linksIDs.count);
            if (tmpView0.linksIDs.count == 1) {
                canBeRemoved = NO;
                //break;
            }
        }
        
        if ([[tmpLink objectAtIndex:1] intValue] == [skillID intValue]) {
            SkillTouchView *tmpView1 = (SkillTouchView *)[self.touchLayer viewWithTag:[[tmpLink objectAtIndex:0] intValue]];
            NSLog(@"tmpView1 %d %d", tmpView1.tag, tmpView1.linksIDs.count);
            
            if (tmpView1.linksIDs.count == 1) {
                canBeRemoved = NO;
                //break;
            }
        }

    }
    if (!canBeRemoved) {
        return;
    }
    
    NSLog(@"OK ON REMOVE");
    return;
     */
    // CHECK IF IT CAN BE REMOVED
    
    
    [self.activeSkills removeObject:skillID];
    
    //DISABLE LINKS
    NSMutableArray *skillLinkIDXToDisable = [NSMutableArray array];
    NSMutableArray *skillLinksToDisable = [NSMutableArray array];

    //NSLog(@"removeActiveSkill skillID %@", skillID);
    
    for (NSArray *link in self.skillLinks) {

        //NSLog(@"link %@ %@", [link objectAtIndex:0], [link objectAtIndex:1]);
        
        if ([[link objectAtIndex:0] integerValue] == [skillID integerValue] || [[link objectAtIndex:1] integerValue] == [skillID integerValue]) {
            //NSLog(@"found");
            [skillLinkIDXToDisable addObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            [skillLinksToDisable addObject:link];
            SkillTouchView *tmpView2 = (SkillTouchView *)[self.touchLayer viewWithTag:[skillID intValue]];
            [tmpView2 desactivate];
            
            
            
            SkillTouchView *tmpView11 = (SkillTouchView *)[self.touchLayer viewWithTag:[[link objectAtIndex:1] intValue]];
            SkillTouchView *tmpView12 = (SkillTouchView *)[self.touchLayer viewWithTag:[[link objectAtIndex:0] intValue]];
            
            [tmpView11 lowlight];
            [tmpView12 lowlight];
            
            if([tmpView11.linksHighIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                [tmpView11.linksHighIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            
            if([tmpView11.linksIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                [tmpView11.linksIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            
            if([tmpView12.linksHighIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                [tmpView12.linksHighIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            
            if([tmpView12.linksIDs indexOfObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]] != NSNotFound)
                [tmpView12.linksIDs removeObject:[NSNumber numberWithInt:[self.skillLinks indexOfObject:link]]];
            
        }
    }
    //NSLog(@"skillLinkToDisable %@", skillLinkToDisable);

    [self.skillLinksView disableLinks:skillLinkIDXToDisable];
    //-- DISABLE LINKS
    
    
    [self drawActiveLayer:skillLinksToDisable];
    
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (_skillPickerPopover != nil) {
        _skillPickerPopover = nil;
    }
}

#pragma mark - IBActions
-(IBAction)chooseSkillButtonTapped:(UIGestureRecognizer *)gestureRecognizer
{
    [self cancelSkill:NO];
/*

  */  
    
    SkillNode *node = [self.skillNodes objectForKey:[NSNumber numberWithInt:[gestureRecognizer view].tag]];

   // NSLog(@"node tapped %@", node);
    
    //Create the ColorPickerViewController.
    _skillPicker = [[SkillSelectionViewController alloc] initWithNibName:@"SkillSelectionViewController" bundle:nil andNode:node];
    
    int nbLinks = ((SkillTouchView *)[self.touchLayer viewWithTag:node.id]).linksHighIDs.count + ((SkillTouchView *)[self.touchLayer viewWithTag:node.id]).linksIDs.count;
    
    if (nbLinks && self.activeSkills.count - 1 < MAXSKILLS && [self.activeSkills indexOfObject:[NSNumber numberWithInt:node.id]] == NSNotFound) {
        NSLog(@"ADD");
        [self addActiveSkill:[NSNumber numberWithInt:node.id]];
        _skillPicker.canCancel = YES;
        //_skillPicker.canAdd = YES;
    }
    else if (self.activeSkills && [self.activeSkills indexOfObject:[NSNumber numberWithInt:node.id]] != NSNotFound)
    {
        NSLog(@"REMOVE");
        BOOL canBeRemoved = [self removeActiveSkill:[NSNumber numberWithInt:node.id]];
        if (canBeRemoved) {
            _skillPicker.canCancel = YES;
        }
        else {
            _skillPicker.canRemove = NO;
        }
    }
    else
    {
        _skillPicker.reqNeeded = YES;
    }
    //Set this VC as the delegate.
    _skillPicker.delegate = self;
    
    if (_skillPickerPopover == nil) {
        NSLog(@"_skillPickerPopover == nil");
        //The color picker popover is not showing. Show it.
        _skillPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_skillPicker];
        _skillPickerPopover.popoverBackgroundViewClass = [CustomPopoverBackgroundView class];
        _skillPickerPopover.passthroughViews = [NSArray arrayWithObjects:self, nil];
        _skillPickerPopover.delegate = self;
        [_skillPickerPopover presentPopoverFromRect:CGRectMake((node.Position.x + fullX/2)/Zoom/MiniScale - 6, (node.Position.y + fullY/2)/Zoom/MiniScale - 6, 12, 12)
                                             inView:self.touchLayer
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
        
//        [_skillPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
//                                    permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        NSLog(@"_skillPickerPopover == nil ELSE");

        //The color picker popover is showing. Hide it.
        [_skillPickerPopover dismissPopoverAnimated:YES];
        _skillPickerPopover = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self cancelSkill:YES];
    
    NSLog(@"touchesBegan");
}


#pragma mark - SkillSelectionViewController method
-(void)selectedSkill:(SkillNode *)node {
    NSLog(@"selectedSkill");
    
    int nbLinks = ((SkillTouchView *)[self.touchLayer viewWithTag:node.id]).linksHighIDs.count + ((SkillTouchView *)[self.touchLayer viewWithTag:node.id]).linksIDs.count;
    
    if (nbLinks && self.activeSkills.count - 1 < MAXSKILLS && [self.activeSkills indexOfObject:[NSNumber numberWithInt:node.id]] == NSNotFound) {
        [self addActiveSkill:[NSNumber numberWithInt:node.id]];
        [self cancelSkill:NO];
        return;
    }
    else if (self.activeSkills && [self.activeSkills indexOfObject:[NSNumber numberWithInt:node.id]] != NSNotFound)
    {
        [self removeActiveSkill:[NSNumber numberWithInt:node.id]];
    }

    [self cancelSkill:NO];
}

-(void)cancelSkill:(BOOL)animated {
    if (_skillPickerPopover) {
        [_skillPickerPopover dismissPopoverAnimated:animated];
        _skillPickerPopover = nil;
    }
}

@end