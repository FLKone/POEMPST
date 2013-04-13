//
//  URLTextField.m
//  POEMPST
//
//  Created by FLK on 12/04/13.
//

#import "URLTextField.h"

@implementation URLTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action == @selector(paste:)) {
        return YES;
    }
    else if(action == @selector(copy:)) {
        return YES;
    }
    else {
        return [super canPerformAction:action withSender:sender];
    }
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (BOOL)becomeFirstResponder {

    if([super becomeFirstResponder]) {
        self.highlighted = YES;
        return YES;
    }
    return NO;
}


- (void)copy:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:self.text];
    self.highlighted = NO;
    [self resignFirstResponder];
}


- (void)paste:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    if ([board.string rangeOfString:@"http://www.pathofexile.com/passive-skill-tree/AAAAA"].location == NSNotFound) {
        NSLog(@"pwet");
    }
    else
        [self setText:board.string];
    
    [self resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if([self isFirstResponder]) {
        self.highlighted = NO;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
        [menu update];
        [self resignFirstResponder];
    }
    else if([self becomeFirstResponder]) {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

@end
