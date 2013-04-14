//
//  URLTextField.h
//  POEMPST
//
//  Created by FLK on 12/04/13.
//

#import <UIKit/UIKit.h>

@interface URLTextField : UILabel

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) BOOL canPaste;
@property (nonatomic, assign) BOOL canCopyBBcode;
- (void)resizeHeightToFitText;

@end
