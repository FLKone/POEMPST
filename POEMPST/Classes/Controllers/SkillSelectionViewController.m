//
//  SkillSelectionViewController.m
//  POEMPST
//
//  Created by Shasta on 14/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "SkillSelectionViewController.h"





@interface SkillSelectionViewController ()

@end

@implementation SkillSelectionViewController

@synthesize node;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize validateBtn;
@synthesize cancelBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andNode:(SkillNode *)aNode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.node = aNode;
      
//        NSLog(@"name = %@", [aNode name]);
  //      NSLog(@"name = %@", [aNode description]);
    }
    return self;
}

-(IBAction)selectSkill {
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate selectedSkill:self.node];
    }
}


-(IBAction)cancelSkill {
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate cancelSkill];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:@"Fontin-Bold" size:15.0];
    self.descriptionLabel.font = [UIFont fontWithName:@"Fontin-Regular" size:13.0];
    
    self.validateBtn.layer.cornerRadius=5.0f;
    self.validateBtn.layer.masksToBounds=YES;
    self.validateBtn.layer.borderColor=[[UIColor colorWithRed:162/255.f green:141/255.f blue:109/255.f alpha:1.00] CGColor];
    [self.validateBtn titleLabel].font = [UIFont fontWithName:@"Fontin-SmallCaps" size:18.0];
    [self.validateBtn setTitleColor:[UIColor colorWithRed:162/255.f green:141/255.f blue:109/255.f alpha:1.00] forState:UIControlStateNormal];
    [self.validateBtn setTitleColor:[UIColor colorWithRed:107/255.f green:93/255.f blue:72/255.f alpha:1.00] forState:UIControlStateHighlighted];
    self.validateBtn.layer.borderWidth= 2.0f;
    
    self.cancelBtn.layer.cornerRadius=5.0f;
    self.cancelBtn.layer.masksToBounds=YES;
    self.cancelBtn.layer.borderColor=[[UIColor colorWithRed:79/255.f green:69/255.f blue:53/255.f alpha:1.00] CGColor];
    [self.cancelBtn titleLabel].font = [UIFont fontWithName:@"Fontin-SmallCaps" size:18.0];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:79/255.f green:69/255.f blue:53/255.f alpha:1.00] forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:53/255.f green:46/255.f blue:36/255.f alpha:1.00] forState:UIControlStateHighlighted];
    self.cancelBtn.layer.borderWidth= 2.0f;
    
    
    [self.titleLabel setText:[self.node name]];
//    NSLog(@"descriptionLabel %@", [[self.node attributes] componentsJoinedByString:@"\n"]);
    NSString *desc = [[self.node attributes] componentsJoinedByString:@"\n∙ "];
    [self.descriptionLabel setText:[NSString stringWithFormat:@"∙ %@", desc]];
    
    CGSize maximumLabelSize = CGSizeMake(230, FLT_MAX);
    CGSize expectedLabelSize = [desc sizeWithFont:self.descriptionLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.descriptionLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = self.descriptionLabel.frame;
    float baseH = newFrame.size.height;

    newFrame.size.height = expectedLabelSize.height;
    self.descriptionLabel.frame = newFrame;
    
    
    
    self.contentSizeForViewInPopover = CGSizeMake(250, 125 + newFrame.size.height - baseH);

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
