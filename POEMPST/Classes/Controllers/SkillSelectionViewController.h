//
//  SkillSelectionViewController.h
//  POEMPST
//
//  Created by FLK on 14/04/13.
//

#import <UIKit/UIKit.h>

@class SkillNode;

@protocol SkillSelectionDelegate <NSObject>
@required
-(void)selectedSkill:(SkillNode *)node;
-(void)cancelSkill;
@end

@interface SkillSelectionViewController : UIViewController

@property (nonatomic, weak) id<SkillSelectionDelegate> delegate;

@property (nonatomic, strong) IBOutlet SkillNode *node;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UIButton *validateBtn;
@property (nonatomic, strong) IBOutlet UIButton *cancelBtn;

@property BOOL canAdd;
@property BOOL canRemove;

-(IBAction)selectSkill;
-(IBAction)cancelSkill;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andNode:(SkillNode *)aNode;
@end
