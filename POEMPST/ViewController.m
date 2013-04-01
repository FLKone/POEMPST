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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSURL *clientURL = [[NSBundle mainBundle] URLForResource:@"passive-skill-tree" withExtension:@"html"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:clientURL];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *regex = @"var passiveSkillTreeData(.*)";
        
        NSString *JSData = [[responseString stringByMatching:regex] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        
        NSRange r = NSMakeRange(27, JSData.length - 27 - 1);
        JSData = [JSData substringWithRange: r];
        NSDictionary* json = [JSData objectFromJSONString];

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
        
        for (NSDictionary *node in [json valueForKey:@"nodes"]) {

            SkillNode *skillNode = [[SkillNode alloc] initWithDictionary:node];
            [skillNodes setValue:skillNode forKey:[node valueForKey:@"id"]];
        }
        //-- Nodes
        
        // Groups
        NSMutableDictionary *nodeGroups = [NSMutableDictionary dictionary];
        
        for (NSString *key in [json valueForKey:@"groups"]) {
            
            NSDictionary *group = [[json valueForKey:@"groups"] objectForKey:key];
            NodeGroup *nodeGroup = [[NodeGroup alloc] initWithDictionary:group andId:[key intValue]];
            [nodeGroups setValue:nodeGroup forKey:key];
        }
        //-- Groups

        float min_x = [[json objectForKey:@"min_x"] floatValue];
        float min_y = [[json objectForKey:@"min_y"] floatValue];
        float max_x = [[json objectForKey:@"max_x"] floatValue];
        float max_y = [[json objectForKey:@"max_y"] floatValue];
        
        //[self performSelectorOnMainThread:@selector(myMethod:) withObject:anObj waitUntilDone:YES];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            float fullX, fullY;
            fullX = (float)(MAX(abs(min_x),abs(max_x))*2.1);
            fullY = (float)(MAX(abs(min_y),abs(max_y))*2.1);
            //fullY = (float)(abs(minY) + abs(maxY));
            
            
            // Set up the container view to hold your custom view hierarchy
            CGSize containerSize = CGSizeMake(fullX, fullY);
            
            self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
            UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[((Asset *)[assets objectForKey:@"Background1"]) UIImage]];
            self.containerView.backgroundColor = backgroundColor;
            
            [self.scrollView addSubview:self.containerView];

            //BACKGROUND LAYER
            
            
            
            
            //-- BACKGROUND LAYER
            /*
            for (NSNumber *key in [json valueForKey:@"groups"]) {
                
                NSArray *node = [[json valueForKey:@"groups"] objectForKey:key];
                
                //NSLog(@"%d", [[node valueForKey:@"x"] integerValue]);
                float centerX, centerY;
                centerX = [[node valueForKey:@"x"] floatValue] + fullX/2;
                centerY = [[node valueForKey:@"y"] floatValue] + fullY/2;
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(centerX, centerY, 100.0f, 50.0f)];

                //[label setText:[[nodes objectForKey:[NSNumber numberWithInt:27271]] valueForKey:@"dn"]];
                //NSLog(@"text %@ %d %@", key, [key integerValue], [nodes objectForKey:[NSNumber numberWithInt:[key integerValue]]]);
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KeystoneFrameAllocated.png"]];

                //imageView.center = CGPointMake(centerX, centerY);
                [self.containerView addSubview:label];

                
            }
            */
            // Tell the scroll view the size of the contents
            self.scrollView.contentSize = containerSize;
            
            // Set up the minimum & maximum zoom scales
            CGRect scrollViewFrame = self.scrollView.frame;
            CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
            CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
            
            self.scrollView.minimumZoomScale = minScale;
            self.scrollView.maximumZoomScale = 1.0f;
            self.scrollView.zoomScale = 1.0f;
            
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
