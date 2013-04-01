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

    static int minX = 0, minY = 0;
    static int maxX = 0, maxY = 0;
    
    NSURL *clientURL = [[NSBundle mainBundle] URLForResource:@"passive-skill-tree" withExtension:@"html"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:clientURL];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
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
            //NSLog(@"key %@", key);

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
        
        // Nodes
        NSMutableDictionary *skillNodes = [NSMutableDictionary dictionary];
        
        for (NSDictionary *node in [json valueForKey:@"nodes"]) {

            SkillNode *skillNode = [[SkillNode alloc] initWithDictionary:node];
            
            [skillNodes setValue:skillNode forKey:[node valueForKey:@"id"]];
        }
        //-- Nodes
        
        // Groups
        
        //-- Groups        
        

        
    //    NSLog(@"nodes %@", nodes);
/*
        for (NSNumber *key2 in nodes) {
            
            NSLog(@"key2 %@", key2);
            NSLog(@"key2 %@", [nodes objectForKey:key2]);

            
        }
  */
        //NSLog(@"27271 %@", [[nodes objectForKey:[NSNumber numberWithInt:27271]] valueForKey:@"dn"]);

        
        for (NSString *key in [json valueForKey:@"groups"]) {
            //NSLog(@"%@", key);
            
            NSArray *node = [[json valueForKey:@"groups"] objectForKey:key];
            
            //NSLog(@"%d", [[node valueForKey:@"x"] integerValue]);

            // MIN
            if (minX > [[node valueForKey:@"x"] integerValue]) {
                minX = [[node valueForKey:@"x"] integerValue];
            }

            
            if (minY > [[node valueForKey:@"y"] integerValue]) {
                minY = [[node valueForKey:@"y"] integerValue];
            }

            
            //MAX
            if (maxX < [[node valueForKey:@"x"] integerValue]) {
                maxX = [[node valueForKey:@"x"] integerValue];
            }
            
            if (maxY < [[node valueForKey:@"y"] integerValue]) {
                maxY = [[node valueForKey:@"y"] integerValue];
            }
            
        }

        NSLog(@"minX %d", minX);
        NSLog(@"minY %d", minY);
        
        NSLog(@"maxX %d", maxX);
        NSLog(@"maxY %d", maxY);
        
        NSLog(@"%f %f", (float)(abs(maxX) + abs(minX)), (float)(abs(minY) + abs(maxY)));
        
        //[self performSelectorOnMainThread:@selector(myMethod:) withObject:anObj waitUntilDone:YES];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            float fullX, fullY;
            fullX = (float)(MAX(abs(maxX),abs(minX))*2);
            fullY = (float)(MAX(abs(minY),abs(maxY))*2);
            //fullY = (float)(abs(minY) + abs(maxY));
            
            
            // Set up the container view to hold your custom view hierarchy
            CGSize containerSize = CGSizeMake(fullX, fullY);
            self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
            self.containerView.backgroundColor = [UIColor brownColor];
            [self.scrollView addSubview:self.containerView];

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
