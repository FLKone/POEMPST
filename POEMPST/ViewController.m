//
//  ViewController.m
//  POEMPST
//
//  Created by FLK on 31/03/13.
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

@synthesize  loadFromURLBtn, urlField, skillPointsView, progressView, loadingView, activityView, loadingLabel, finalUrlField, activeClassImageView, currentDextLabel, currentStrLabel, currentIntelLabel;

-(void)errorLoading:(NSNotification *)notif {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSLog(@"notif %@", notif);
    
        [self.loadFromURLBtn setHidden:NO];
        [self.activityView setHidden:YES];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This is not a valid PoE link" message:@"Could be an old link no longer valid, or a new one which is not yet supported by the application.\nYou can try to clear the cache, if the problem persist, contact me." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Clear app's cache", nil];
        [alertView show];
    });
}

-(void)changeSkillCount:(NSNotification *)notif {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"changeSkillCount");

        int i = (MAXSKILLS - [notif.object intValue] + 1);
        
        if (i <= 1) {
            [skillPointsView setTitle:[NSString stringWithFormat:@"%d Point Left   ↻", i] forState:UIControlStateNormal];
        } 
        else
            [skillPointsView setTitle:[NSString stringWithFormat:@"%d Points Left   ↻", i] forState:UIControlStateNormal];
        
        
        NSArray *f = self.containerView.activeSkills;
        int characterClassID = self.containerView.characterClassID;
        NSString *rootID = self.containerView.rootID;

        //ENCODE TEST
        int val = 2;
        char* b2 = (char*) &val;
        
        NSMutableString *hex = [NSMutableString string];
        
        [hex appendFormat:@"%02x", b2[3]];                                      //0
        [hex appendFormat:@"%02x", b2[2]];                                      //1
        [hex appendFormat:@"%02x", b2[1]];                                      //2
        [hex appendFormat:@"%02x", b2[0]];                                      //3
        [hex appendFormat:@"%02x", (unsigned char)(characterClassID)];     //4
        [hex appendFormat:@"%02x", (unsigned char)0];                           //5
        int kk;
        for (kk=0; kk < [f count]; kk++) {
            if ([[f objectAtIndex:kk] intValue] == [rootID intValue]) {
                //NSLog(@"ROOT");
            }
            else
            {
                //                    NSLog(@"==");
                int val2 = (int)[[f objectAtIndex:kk] intValue];
                char* b3 = (char*) &val2;
                //                    NSLog(@"%02x", b3[1]);
                //                    NSLog(@"%02x", b3[0]);
                NSString *tmp1 = [NSString stringWithFormat:@"%02x", b3[1]];
                tmp1 = [tmp1 stringByReplacingOccurrencesOfString:@"ffffff" withString:@""];
                [hex appendString:tmp1];
                
                NSString *tmp = [NSString stringWithFormat:@"%02x", b3[0]];
                tmp = [tmp stringByReplacingOccurrencesOfString:@"ffffff" withString:@""];
                [hex appendString:tmp];
            }
        }
        
        //TO DATA
        NSString *command = [NSString stringWithString:hex];
        
        command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSMutableData *commandToSend= [[NSMutableData alloc] init];
        unsigned char whole_byte;
        char byte_chars[3] = {'\0','\0','\0'};
        int zz;
        for (zz=0; zz < [command length]/2; zz++) {
            byte_chars[0] = [command characterAtIndex:zz*2];
            byte_chars[1] = [command characterAtIndex:zz*2+1];
            whole_byte = strtol(byte_chars, NULL, 16);
            [commandToSend appendBytes:&whole_byte length:1];
        }
        //NSLog(@"commandToSend %@", commandToSend);
        
        
        //NSLog(@"rebuildstring %@", [commandToSend base64EncodedString]);

        NSString *s = [commandToSend base64EncodedString];
        //[[[[commandToSend base64EncodedString] stringByReplacingOccurrencesOfString:siteUrl withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@"+"] stringByReplacingOccurrencesOfString:@"_" withString:@"/"];

        s = [s stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        s = [s stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        s = [s stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, s.length)];
        s = [s stringByReplacingOccurrencesOfString:@"\r" withString:@"" options:0 range:NSMakeRange(0, s.length)];

        [self.finalUrlField setText:[NSString stringWithFormat:@"http://www.pathofexile.com/passive-skill-tree/%@", s]];
        
        //ENCODE TEST

        switch (characterClassID) {
            case 1:
                [self.activeClassImageView setImage:[UIImage imageNamed:@"marauder-large.png"]];
                break;
            case 2:
                [self.activeClassImageView setImage:[UIImage imageNamed:@"ranger-large.png"]];
                break;
            case 3:
                [self.activeClassImageView setImage:[UIImage imageNamed:@"witch-large.png"]];
                break;
            case 4:
                [self.activeClassImageView setImage:[UIImage imageNamed:@"duelist-large.png"]];
                break;
            case 5:
                [self.activeClassImageView setImage:[UIImage imageNamed:@"templar-large.png"]];
                break;
            case 6:
                [self.activeClassImageView setImage:[UIImage imageNamed:@"shadow-large.png"]];
                break;
            default:
                break;
        }

        int da = 0;
        int sa = 0;
        int ia = 0;
        for (NSNumber *skillID in f) {
            if ([skillID intValue] == [rootID intValue]) {
                //NSLog(@"ROOT");
            }
            else
            {
                da += ((SkillNode *)[self.containerView.skillNodes objectForKey:skillID]).da;
                sa += ((SkillNode *)[self.containerView.skillNodes objectForKey:skillID]).sa;
                ia += ((SkillNode *)[self.containerView.skillNodes objectForKey:skillID]).ia;
            }
        }
        
        //base  self.characterData
        
        NSDictionary *baseAttr = [self.containerView.characterData objectForKey:[NSString stringWithFormat:@"%d", characterClassID]];
        da += [[baseAttr objectForKey:@"base_dex"] intValue];
        sa += [[baseAttr objectForKey:@"base_str"] intValue];
        ia += [[baseAttr objectForKey:@"base_int"] intValue];
        
        [self.currentDextLabel setText:[NSString stringWithFormat:@"%d", da]];
        [self.currentIntelLabel setText:[NSString stringWithFormat:@"%d", ia]];
        [self.currentStrLabel setText:[NSString stringWithFormat:@"%d", sa]];
        
        if (![_menuView isHidden]) {
            [_menuView setHidden:YES];
            [self.loadFromURLBtn setHidden:NO];
            [self.activityView setHidden:YES];
            self.progressView.progress = 0;
        }
    });
}

-(void)selectClass:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadClass" object:sender userInfo:nil];
    [_menuView setHidden:YES];
    self.progressView.progress = 0;

}

-(IBAction)loadURL:(id) sender {

    if ([self.urlField.text rangeOfString:@"http://www.pathofexile.com/passive-skill-tree/"].location == NSNotFound) {
    }
    else {
            [self.loadFromURLBtn setHidden:YES];
            [self.activityView setHidden:NO];
                
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUrl" object:self.urlField.text userInfo:nil];
    }

}

-(void)changeProgress:(NSNotification *)notif {
    NSLog(@"Progress %f", [notif.object floatValue]);
    dispatch_async(dispatch_get_main_queue(), ^{

        self.progressView.progress = [notif.object floatValue];
    });
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
    urlField.canPaste = YES;
    
    loadingLabel.font = [UIFont fontWithName:@"Fontin-SmallCaps" size:18.0];
    
    [loadFromURLBtn setTitleColor:[UIColor colorWithRed:163/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [loadFromURLBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    [loadFromURLBtn.titleLabel setFont:[UIFont fontWithName:@"Fontin-Regular" size:18.0]];

    // skill points
    [skillPointsView.titleLabel setFont:[UIFont fontWithName:@"Fontin-Bold" size:12.0]];
    
    [self.activityView setHidden:YES];

    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Copy with BBCode" action:@selector(copyBBCode:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
    
    finalUrlField.font = [UIFont fontWithName:@"Fontin-Regular" size:13.0];
    finalUrlField.canCopyBBcode = YES;
    
    self.currentDextLabel.font = [UIFont fontWithName:@"Fontin-Regular" size:10.0];
    self.currentIntelLabel.font = [UIFont fontWithName:@"Fontin-Regular" size:10.0];
    self.currentStrLabel.font = [UIFont fontWithName:@"Fontin-Regular" size:10.0];
    [self.currentIntelLabel setTextColor:[UIColor colorWithRed:73/255.f green:159/255.f blue:210/255.f alpha:1.00]];
    [self.currentStrLabel setTextColor:[UIColor colorWithRed:205/255.f green:47/255.f blue:19/255.f alpha:1.00]];
    [self.currentDextLabel setTextColor:[UIColor colorWithRed:4/255.f green:195/255.f blue:4/255.f alpha:1.00]];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
        [self setupMenuPortrait];
    } else {
        [self setupMenuLandscape];
    }
    
    
    //-- MAIN MENU
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkillCount:) name:@"changeSkillCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgress:) name:@"changeProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoading:) name:@"errorLoading" object:nil];

    [self setup];
}

-(void)setup {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"loadingView hidden");
        self.progressView.progress = 0;
        self.loadingView.alpha = 0.9;
        self.loadingView.hidden = NO;
    });
    
    
    // DIRECTORIES
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *diskDataCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:diskDataCachePath])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:diskDataCachePath
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
    
	NSString *diskDataAssetsCachePath = [diskDataCachePath stringByAppendingPathComponent:@"Assets"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:diskDataAssetsCachePath])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:diskDataAssetsCachePath
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
    
	NSString *diskDataLayerCachePath = [diskDataCachePath stringByAppendingPathComponent:@"Layers"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:diskDataLayerCachePath])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:diskDataLayerCachePath
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
    // DIRECTORIES
    
    //NSURL *clientURL = [[NSBundle mainBundle] URLForResource:@"passive-skill-tree-v2" withExtension:@"html"];
    
    NSURL *clientURL;
	if ([[NSFileManager defaultManager] fileExistsAtPath:[diskDataCachePath stringByAppendingPathComponent:@"tree.html"]])
	{
        clientURL = [NSURL fileURLWithPath:[diskDataCachePath stringByAppendingPathComponent:@"tree.html"]
                               isDirectory:NO];
    }
    else
    {
        
        clientURL = [NSURL URLWithString:@"http://www.pathofexile.com/passive-skill-tree/"];
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:clientURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProgress" object:[NSNumber numberWithFloat:LOADSTEP11] userInfo:nil];

            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *diskDataCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data"];
            
            NSError *error;
            BOOL succeed = [responseString writeToFile:[diskDataCachePath stringByAppendingPathComponent:@"tree.html"]
                                            atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (!succeed){
                // Handle error here
            }
            
            
            NSString *regex = @"var passiveSkillTreeData(.*)";
            
            NSString *JSData = [[responseString stringByMatching:regex] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
            
            NSRange rangeToSearch = NSMakeRange(0, [JSData length]);
            NSRange rangeOfSecondToLastSpace = [JSData rangeOfString:@"," options:NSBackwardsSearch range:rangeToSearch];
            
            
            NSRange r = NSMakeRange(27, rangeOfSecondToLastSpace.location - 27);
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
            NSLog(@"before async");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSLog(@"in async");
                self.containerView = nil;
                self.containerView = [[SkillTreeView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 30.0f), .size=containerSize} andJSON:(NSDictionary *)json];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"in async MAIN");
                    
                    [self.scrollView addSubview:self.containerView];
                    
                    // Tell the scroll view the size of the contents
                    self.scrollView.contentSize = containerSize;
                    
                    // 3
                    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
                    doubleTapRecognizer.numberOfTapsRequired = 2;
                    doubleTapRecognizer.numberOfTouchesRequired = 1;
                    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
                    
                    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
                    twoFingerTapRecognizer.numberOfTapsRequired = 1;
                    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
                    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
                    
                    
                    // Set up the minimum & maximum zoom scales
                    CGRect scrollViewFrame = self.scrollView.frame;
                    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
                    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
                    CGFloat minScale = MIN(scaleWidth, scaleHeight);
                    
                    UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background1.png"]];
                    self.scrollView.backgroundColor = backgroundColor;
                    
                    self.scrollView.minimumZoomScale = minScale;
                    self.scrollView.maximumZoomScale = MaxZoom;//0.3835f;
                    self.scrollView.zoomScale = minScale;
                    
                    self.scrollView.autoresizesSubviews = NO;
                    
                    [self centerScrollViewContents];
                    
                    NSLog(@"END in async MAIN");
                    
                    BOOL hide = YES;
                    
                    [UIView animateWithDuration:0.5
                                          delay:0.0
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^
                     {
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         if (hide)
                             self.loadingView.alpha=0;
                         else
                         {
                             self.loadingView.hidden= NO;
                             self.loadingView.alpha=1;
                         }
                     }
                                     completion:^(BOOL b)
                     {
                         if (hide)
                             self.loadingView.hidden= YES;
                     }
                     ];
                    
                });
                
                
            });
            
            
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

    NSLog(@"will %f %f", self.scrollView.contentOffset.x, self.scrollView.contentOffset.y);
    
    if((interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self setupMenuLandscape];
        
        if (self.scrollView.contentOffset.x != 0 && self.scrollView.contentOffset.y != 0 ) {
            CGPoint newOffset;
            newOffset.x = self.scrollView.contentOffset.x - 128;// (1024-768)/2;
            newOffset.y = self.scrollView.contentOffset.y + 128;// - 768/2;
            
            self.scrollView.contentOffset = newOffset;
        }
        

        
    } else  if((interfaceOrientation == UIDeviceOrientationPortrait) || (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
        [self setupMenuPortrait];
        
        if (self.scrollView.contentOffset.x != 0 && self.scrollView.contentOffset.y != 0 ) {

            CGPoint newOffset;
            newOffset.x = self.scrollView.contentOffset.x + 128;// (1024-768)/2;
            newOffset.y = self.scrollView.contentOffset.y - 128;// - 768/2;
            
            self.scrollView.contentOffset = newOffset;
        }
    }
    
    [self centerScrollViewContents];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self centerScrollViewContents];
    
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
    self.activityView.frame  =  CGRectMake(808, 675, self.activityView.frame.size.width, self.activityView.frame.size.height);
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
    self.activityView.frame  =  CGRectMake(376, 895, self.activityView.frame.size.width, self.activityView.frame.size.height);

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

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.containerView];
    
    // 2
    CGFloat newZoomScale = self.scrollView.maximumZoomScale;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

-(IBAction) resetAS:(id) sender{
    NSLog(@"resetAS");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Reset Tree ?"
                                                        delegate:self cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Yes !"
                                               otherButtonTitles:@"Back to main menu",
                             nil,
                             nil];
    actionSheet.tag = 1;
    // use the same style as the nav bar
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [actionSheet showFromRect:self.skillPointsView.frame inView:self.view animated:YES];
    }
    
    //else
    //    [self.topicActionSheet showInView:[[[xxx sharedAppDelegate] rootController] view]];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex %d", buttonIndex);
    
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            //reset tree
            int cID = [self.containerView characterClassID];
            
            [self.containerView.skillLinksView reset];
            self.containerView.activeSkills = nil;
            
            for (id item in [self.containerView.touchLayer subviews])
            {
                if ([item isKindOfClass:[SkillTouchView class]])
                {
                    SkillTouchView *blankItem = (SkillTouchView *)item;
                    
                    // this works
                    [blankItem desactivate];
                    
                }
                else
                {
                    //
                }
            }
            
            switch (cID) {
                case 1:
                    [(UIButton *)[self.view viewWithTag:MARAUDERBTNID] sendActionsForControlEvents: UIControlEventTouchUpInside];
                    break;
                case 2:
                    [(UIButton *)[self.view viewWithTag:RANGERBTNID] sendActionsForControlEvents: UIControlEventTouchUpInside];
                    break;
                case 3:
                    [(UIButton *)[self.view viewWithTag:WITCHBTNID] sendActionsForControlEvents: UIControlEventTouchUpInside];
                    break;
                case 4:
                    [(UIButton *)[self.view viewWithTag:DUELISTBTNID] sendActionsForControlEvents: UIControlEventTouchUpInside];
                    break;
                case 5:
                    [(UIButton *)[self.view viewWithTag:TEMPLARBTNID] sendActionsForControlEvents: UIControlEventTouchUpInside];
                    break;
                case 6:
                    [(UIButton *)[self.view viewWithTag:SIXBTNID] sendActionsForControlEvents: UIControlEventTouchUpInside];
                    break;
                default:
                    break;
            }
        }
        else if (buttonIndex == 1) {
            //reset + main menu
            [self.containerView.skillLinksView reset];
            self.containerView.activeSkills = nil;
            [[self.containerView.touchLayer viewWithTag:ACTIVEFACEID] removeFromSuperview];
            
            for (id item in [self.containerView.touchLayer subviews])
            {
                if ([item isKindOfClass:[SkillTouchView class]])
                {
                    SkillTouchView *blankItem = (SkillTouchView *)item;
                    
                    // this works
                    [blankItem desactivate];
                    
                }
                else
                {
                    //
                }
            }
            
            [_menuView setHidden:NO];
        }

    }
    else if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *DataCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data"];
            
            if ([fileManager fileExistsAtPath:DataCachePath])
            {
                [fileManager removeItemAtPath:DataCachePath error:NULL];
            }
            
            [self.containerView removeFromSuperview];
            self.containerView = nil;
            
            [self setup];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex %d", buttonIndex);
    if (buttonIndex == 0) {
        //OK
    }
    else if (buttonIndex == 1) {
        //CLEAR CACHE
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *DataCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Data"];
        
        if ([fileManager fileExistsAtPath:DataCachePath])
        {
            [fileManager removeItemAtPath:DataCachePath error:NULL];
        }
        
        [self.containerView removeFromSuperview];
        self.containerView = nil;

        [self setup];

    }
}

-(IBAction) settingMenu:(UIButton *) sender {
    NSLog(@"SM");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Settings"
                                                             delegate:self cancelButtonTitle:@"Hide"
                                               destructiveButtonTitle:@"Clear app's cache"
                                                    otherButtonTitles:[NSString stringWithFormat:@"Version: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]],
                                  nil,
                                  nil];
    actionSheet.tag = 2;

    // use the same style as the nav bar
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [actionSheet showFromRect:sender.frame inView:self.view animated:YES];
    }
}


@end