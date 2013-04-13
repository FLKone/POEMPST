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

@synthesize menuImageView = _menuImageView;
@synthesize menuView = _menuView;
@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;

@synthesize  loadFromURLBtn, urlField, skillPointsView;


-(void)changeSkillCount:(NSNotification *)notif {
    
    int i = (MAXSKILLS - [notif.object intValue] + 1);
    
    if (i <= 1) {
        [skillPointsView setTitle:[NSString stringWithFormat:@"%d Point Left", i] forState:UIControlStateNormal];
    }
    else
        [skillPointsView setTitle:[NSString stringWithFormat:@"%d Points Left", i] forState:UIControlStateNormal];
}

-(void)selectClass:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadClass" object:sender userInfo:nil];
    [_menuView setHidden:YES];

}

-(IBAction)loadURL:(id) sender {
    
    if ([self.urlField.text rangeOfString:@"http://www.pathofexile.com/passive-skill-tree/AAAAA"].location == NSNotFound) {
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUrl" object:self.urlField.text userInfo:nil];
        [_menuView setHidden:YES];
    }

}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];

    // MAIN MENU
    CGRect baseFrame = CGRectMake(0, 0, 110, 135); //base img = 105
    UIButton *marauderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    marauderBtn.frame = baseFrame;
    marauderBtn.tag = MARAUDERBTNID;
    [marauderBtn setImage:[UIImage imageNamed:@"marauder-large.png"] forState:UIControlStateNormal];
    [marauderBtn setTitle:@"Marauder" forState:UIControlStateNormal];
    marauderBtn.titleLabel.font = [UIFont fontWithName:@"Fontin-SmallCaps" size:15.0];
    [marauderBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [marauderBtn setTitleColor:[UIColor colorWithRed:163/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [marauderBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    [marauderBtn setTitleEdgeInsets:UIEdgeInsetsMake(108, -110, 0, 0)];
    [marauderBtn addTarget:self action:@selector(selectClass:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rangerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rangerBtn.frame = baseFrame;
    rangerBtn.tag = RANGERBTNID;
    [rangerBtn setImage:[UIImage imageNamed:@"ranger-large.png"] forState:UIControlStateNormal];
    [rangerBtn setTitle:@"Ranger" forState:UIControlStateNormal];
    rangerBtn.titleLabel.font = [UIFont fontWithName:@"Fontin-SmallCaps" size:15.0];
    [rangerBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [rangerBtn setTitleColor:[UIColor colorWithRed:163/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [rangerBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    [rangerBtn setTitleEdgeInsets:UIEdgeInsetsMake(108, -110, 0, 0)];
    [rangerBtn addTarget:self action:@selector(selectClass:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *witchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    witchBtn.frame = baseFrame;
    witchBtn.tag = WITCHBTNID;
    [witchBtn setImage:[UIImage imageNamed:@"witch-large.png"] forState:UIControlStateNormal];
    [witchBtn setTitle:@"Witch" forState:UIControlStateNormal];
    witchBtn.titleLabel.font = [UIFont fontWithName:@"Fontin-SmallCaps" size:15.0];
    [witchBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [witchBtn setTitleColor:[UIColor colorWithRed:163/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [witchBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    [witchBtn setTitleEdgeInsets:UIEdgeInsetsMake(108, -110, 0, 0)];
    [witchBtn addTarget:self action:@selector(selectClass:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *duelistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    duelistBtn.frame = baseFrame;
    duelistBtn.tag = DUELISTBTNID;
    [duelistBtn setImage:[UIImage imageNamed:@"duelist-large.png"] forState:UIControlStateNormal];
    [duelistBtn setTitle:@"Duelist" forState:UIControlStateNormal];
    duelistBtn.titleLabel.font = [UIFont fontWithName:@"Fontin-SmallCaps" size:15.0];
    [duelistBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [duelistBtn setTitleColor:[UIColor colorWithRed:163/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [duelistBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    [duelistBtn setTitleEdgeInsets:UIEdgeInsetsMake(108, -110, 0, 0)];
    [duelistBtn addTarget:self action:@selector(selectClass:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *templarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    templarBtn.frame = baseFrame;
    templarBtn.tag = TEMPLARBTNID;
    [templarBtn setImage:[UIImage imageNamed:@"templar-large.png"] forState:UIControlStateNormal];
    [templarBtn setTitle:@"Templar" forState:UIControlStateNormal];
    templarBtn.titleLabel.font = [UIFont fontWithName:@"Fontin-SmallCaps" size:15.0];
    [templarBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [templarBtn setTitleColor:[UIColor colorWithRed:163/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [templarBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    [templarBtn setTitleEdgeInsets:UIEdgeInsetsMake(108, -110, 0, 0)];
    [templarBtn addTarget:self action:@selector(selectClass:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *sixBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sixBtn.frame = baseFrame;
    sixBtn.tag = SIXBTNID;
    [sixBtn setImage:[UIImage imageNamed:@"shadow-large.png"] forState:UIControlStateNormal];
    [sixBtn setTitle:@"Shadow" forState:UIControlStateNormal];
    sixBtn.titleLabel.font = [UIFont fontWithName:@"Fontin-SmallCaps" size:15.0];
    [sixBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [sixBtn setTitleColor:[UIColor colorWithRed:163/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [sixBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    [sixBtn setTitleEdgeInsets:UIEdgeInsetsMake(108, -110, 0, 0)];
    [sixBtn addTarget:self action:@selector(selectClass:) forControlEvents:UIControlEventTouchUpInside];

    [self.menuView addSubview:marauderBtn];
    [self.menuView addSubview:rangerBtn];
    [self.menuView addSubview:witchBtn];
    [self.menuView addSubview:duelistBtn];
    [self.menuView addSubview:templarBtn];
    [self.menuView addSubview:sixBtn];

    //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    //urlField.leftView = paddingView;
    //urlField.leftViewMode = UITextFieldViewModeAlways;
    
    urlField.layer.cornerRadius=2.0f;
    urlField.layer.masksToBounds=YES;
    urlField.layer.borderColor=[[UIColor colorWithRed:129/255.f green:102/255.f blue:59/255.f alpha:1.00] CGColor];
    urlField.font = [UIFont fontWithName:@"Fontin-Regular" size:13.0];
    //   urlField.layer.borderColor=[[UIColor colorWithRed:223/255.f green:207/255.f blue:59/255.f alpha:1.00] CGColor];
    urlField.layer.borderWidth= 1.0f;
    
    [loadFromURLBtn setTitleColor:[UIColor colorWithRed:163/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [loadFromURLBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    [loadFromURLBtn.titleLabel setFont:[UIFont fontWithName:@"Fontin-Regular" size:18.0]];

    // skill points
    [skillPointsView.titleLabel setFont:[UIFont fontWithName:@"Fontin-Bold" size:12.0]];
    
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        [self setupMenuPortrait];
    } else {
        [self setupMenuLandscape];
    }
    //-- MAIN MENU
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkillCount:) name:@"changeSkillCount" object:nil];

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
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                self.containerView = [[SkillTreeView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 30.0f), .size=containerSize} andJSON:(NSDictionary *)json];
                
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                    
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
              //  });

                
           // });

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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {

    if((interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self setupMenuLandscape];
    } else  if((interfaceOrientation == UIDeviceOrientationPortrait) || (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
        [self setupMenuPortrait];
    }
}

-(void)setupMenuLandscape {
    float offsetY = 520;
    float offsetX = 155;
    
    UIButton *marauderBtn = (UIButton*)[self.menuView viewWithTag:MARAUDERBTNID];
    marauderBtn.frame = CGRectMake(0 + offsetX, offsetY, marauderBtn.frame.size.width, marauderBtn.frame.size.height);
    
    UIButton *rangerBtn = (UIButton*)[self.menuView viewWithTag:RANGERBTNID];
    rangerBtn.frame = CGRectMake(120 + offsetX, offsetY, rangerBtn.frame.size.width, rangerBtn.frame.size.height);
    
    UIButton *witchBtn = (UIButton*)[self.menuView viewWithTag:WITCHBTNID];
    witchBtn.frame = CGRectMake(240 + offsetX, offsetY, witchBtn.frame.size.width, witchBtn.frame.size.height);
    
    UIButton *duelistBtn = (UIButton*)[self.menuView viewWithTag:DUELISTBTNID];
    duelistBtn.frame = CGRectMake(360 + offsetX, offsetY, duelistBtn.frame.size.width, duelistBtn.frame.size.height);
    
    UIButton *templarBtn = (UIButton*)[self.menuView viewWithTag:TEMPLARBTNID];
    templarBtn.frame = CGRectMake(480 + offsetX, offsetY, templarBtn.frame.size.width, templarBtn.frame.size.height);
    
    UIButton *sixBtn = (UIButton*)[self.menuView viewWithTag:SIXBTNID];
    sixBtn.frame = CGRectMake(600 + offsetX, offsetY, sixBtn.frame.size.width, sixBtn.frame.size.height);
    
    self.urlField.frame =  CGRectMake(157, 670, self.urlField.frame.size.width, self.urlField.frame.size.height);
    self.loadFromURLBtn.frame =  CGRectMake(783, 670, 70, self.loadFromURLBtn.frame.size.height);
}

-(void)setupMenuPortrait {
    float offsetY = 520;
    float offsetX = 209;
    
    UIButton *marauderBtn = (UIButton*)[self.menuView viewWithTag:MARAUDERBTNID];
    marauderBtn.frame = CGRectMake(0 + offsetX, offsetY, marauderBtn.frame.size.width, marauderBtn.frame.size.height);
    
    UIButton *rangerBtn = (UIButton*)[self.menuView viewWithTag:RANGERBTNID];
    rangerBtn.frame = CGRectMake(120 + offsetX, offsetY, rangerBtn.frame.size.width, rangerBtn.frame.size.height);
    
    UIButton *witchBtn = (UIButton*)[self.menuView viewWithTag:WITCHBTNID];
    witchBtn.frame = CGRectMake(240 + offsetX, offsetY, witchBtn.frame.size.width, witchBtn.frame.size.height);
    
    offsetY += 130;
    
    UIButton *duelistBtn = (UIButton*)[self.menuView viewWithTag:DUELISTBTNID];
    duelistBtn.frame = CGRectMake(0 + offsetX, offsetY, duelistBtn.frame.size.width, duelistBtn.frame.size.height);
    
    UIButton *templarBtn = (UIButton*)[self.menuView viewWithTag:TEMPLARBTNID];
    templarBtn.frame = CGRectMake(120 + offsetX, offsetY, templarBtn.frame.size.width, templarBtn.frame.size.height);
    
    UIButton *sixBtn = (UIButton*)[self.menuView viewWithTag:SIXBTNID];
    sixBtn.frame = CGRectMake(240 + offsetX, offsetY, sixBtn.frame.size.width, sixBtn.frame.size.height);
    
    
    self.urlField.frame =  CGRectMake(75, 850, 618, self.urlField.frame.size.height);
    self.loadFromURLBtn.frame =  CGRectMake(75, 890, 618, self.loadFromURLBtn.frame.size.height);
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
