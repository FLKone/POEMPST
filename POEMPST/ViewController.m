//
//  ViewController.m
//  POEMPST
//
//  Created by Shasta on 31/03/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) SkillTreeView *containerView;

- (void)centerScrollViewContents;
//- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
//- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation ViewController

@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    NSURL *clientURL = [[NSBundle mainBundle] URLForResource:@"passive-skill-tree-v2" withExtension:@"html"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:clientURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSString *regex = @"var passiveSkillTreeData(.*)";
            
            NSString *JSData = [[responseString stringByMatching:regex] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
            
            NSRange r = NSMakeRange(27, JSData.length - 27 - 1);
            JSData = [JSData substringWithRange: r];
            NSDictionary *json = [JSData objectFromJSONString];
            
            float min_x = [[json objectForKey:@"min_x"] floatValue];
            float min_y = [[json objectForKey:@"min_y"] floatValue];
            float max_x = [[json objectForKey:@"max_x"] floatValue];
            float max_y = [[json objectForKey:@"max_y"] floatValue];

            float fullX, fullY;
            fullX = (float)(MAX(abs(min_x),abs(max_x))*2.15)/Zoom/MiniScale;
            fullY = (float)(MAX(abs(min_y),abs(max_y))*2.15)/Zoom/MiniScale;
            
            //NSLog(@"%f %f", fullX, fullY);
            
            // Set up the container view to hold your custom view hierarchy
            CGSize containerSize = CGSizeMake(fullX, fullY);
            self.containerView = [[SkillTreeView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize} andJSON:(NSDictionary *)json];
            [self.scrollView addSubview:self.containerView];
            
            // Tell the scroll view the size of the contents
            self.scrollView.contentSize = containerSize;
            
            // Set up the minimum & maximum zoom scales
            CGRect scrollViewFrame = self.scrollView.frame;
            CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
            CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
            
            UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background1.png"]];
            self.scrollView.backgroundColor = backgroundColor;
            
            self.scrollView.minimumZoomScale = minScale;
            self.scrollView.maximumZoomScale = 1;//0.3835f;
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
