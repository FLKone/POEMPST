//
//  ViewController.h
//  POEMPST
//
//  Created by Shasta on 31/03/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class URLTextField;
@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *menuView;
@property (nonatomic, strong) IBOutlet UIImageView *menuImageView;
@property (nonatomic, strong) IBOutlet UIButton *loadFromURLBtn;
@property (nonatomic, strong) IBOutlet URLTextField *urlField;
@property (nonatomic, strong) IBOutlet UIButton *skillPointsView;

-(IBAction) loadURL:(id) sender;

@end
