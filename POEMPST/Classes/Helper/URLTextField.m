//
//  URLTextField.m
//  POEMPST
//
//  Created by FLK on 12/04/13.
//

#import "URLTextField.h"

@implementation URLTextField

@synthesize canPaste;
@synthesize canCopyBBcode, insets;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        //NSLog(@"dsds iwc %@", self);
        self.canCopyBBcode = NO;
        self.canPaste = NO;
    }
    return self;
}


- (void)drawTextInRect:(CGRect)rect
{
    self.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (void)resizeHeightToFitText
{
    CGRect frame = [self bounds];

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, frame.size.height);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
   // NSLog(@"action %@", NSStringFromSelector(action));

    if(action == @selector(paste:) && self.canPaste) {
       // NSLog(@"canPaste");
        return YES;
    }
    else if(action == @selector(copyBBCode:) && self.canCopyBBcode) {
       // NSLog(@"canCopy");
        
        return YES;
    }
    else if(action == @selector(copy:)) {
        //NSLog(@"canCopy");
        
        return YES;
    }
    else
        return NO;
    /*
    else {
    //    NSLog(@"Other");

        return [super canPerformAction:action withSender:sender];
    }
     */
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


- (void)copyBBCode:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:[NSString stringWithFormat:@"[url=\%@\"]Passive skill tree build[/url]", self.text]];
    self.highlighted = NO;
    [self resignFirstResponder];
}

- (void)copy:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:self.text];
    self.highlighted = NO;
    [self resignFirstResponder];
}

//
- (void)paste:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    if ([board.string rangeOfString:@"http://www.pathofexile.com/passive-skill-tree/"].location == NSNotFound || ![NSURL URLWithString:board.string]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This is not a valid PoE link" message:board.string delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([[NSURL URLWithString:board.string] pathComponents].count != 3) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This is not a valid PoE link" message:board.string delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:board.string];
        
        NSLog(@"url = %@", url);
        
        [self setText:@""];
        [self setText:[board.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [self resizeHeightToFitText];
    }
    
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
