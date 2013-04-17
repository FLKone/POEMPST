//
//  ViewController.h
//  POEMPST
//
//  Created by FLK on 31/03/13.
//

#import <UIKit/UIKit.h>
@class URLTextField;
@interface ViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *menuView;
@property (nonatomic, strong) IBOutlet UIImageView *menuImageView;
@property (nonatomic, strong) IBOutlet UIButton *loadFromURLBtn;
@property (nonatomic, strong) IBOutlet URLTextField *urlField;
@property (nonatomic, strong) IBOutlet UIButton *skillPointsView;
@property (nonatomic, strong) IBOutlet URLTextField *finalUrlField;

@property (nonatomic, strong) IBOutlet UIImageView *activeClassImageView;
@property (nonatomic, strong) IBOutlet UILabel *currentDextLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentStrLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentIntelLabel;

@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;

@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;

-(IBAction) loadURL:(id) sender;
-(IBAction) resetAS:(id) sender;
-(IBAction) settingMenu:(id) sender;

@end
