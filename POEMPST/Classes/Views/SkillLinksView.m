//
//  SkillLinksView.m
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
//

#import "SkillLinksView.h"

@implementation SkillLinksView

@synthesize skillNodes, skillLinks;

- (id)initWithFrame:(CGRect)frame andLinks:(NSMutableArray *)links andSkills:(NSMutableDictionary *)nodes
{
    //NSLog(@"initWithFrameandLinksandSkills");

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.skillLinks = links;
        self.skillNodes = nodes;
    }
    return self;
}

-(void)load {
    
    // CONNECTIONS
    
    for (NSArray *link in self.skillLinks) {
        
        SkillLinkView *tmpView = [[SkillLinkView alloc] initWithFrame:CGRectZero
                                                         andStartNode:[self.skillNodes objectForKey:[link objectAtIndex:0]]
                                                           andEndNode:[self.skillNodes objectForKey:[link objectAtIndex:1]]
                                                          andFullSize:self.frame.size];
        tmpView.tag = [self.skillLinks indexOfObject:link]*SkillLinkID;
        //tmpView.clipsToBounds = NO;
        
        //SkillLinkView *tmpView = [[SkillLinkView alloc] initWithFrame:CGRectZero
        //                                               andStartPoint:CGPointMake(([[self.skillNodes objectForKey:[link objectAtIndex:0]] Position].x + self.frame.size.width*Zoom*MiniScale/2)/Zoom/MiniScale,
        //                                                                      ([[self.skillNodes objectForKey:[link objectAtIndex:0]] Position].y + self.frame.size.height*Zoom*MiniScale/2)/Zoom/MiniScale)
        //                                                andEndPoint:CGPointMake(([[self.skillNodes objectForKey:[link objectAtIndex:1]] Position].x + self.frame.size.width*Zoom*MiniScale/2)/Zoom/MiniScale,
        //                                                                    ([[self.skillNodes objectForKey:[link objectAtIndex:1]] Position].y + self.frame.size.height*Zoom*MiniScale/2)/Zoom/MiniScale)];
        
        //NSLog(@"link %@", link);
        //tmpView.backgroundColor = [UIColor redColor];
        [self addSubview:tmpView];

             

        //break;
    }
    
    /*
    for (NSArray *link in self.skillLinks) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path setLineWidth:20.0];
        
        path.lineCapStyle=kCGLineCapRound;
        path.miterLimit=0;
        path.lineWidth=10;
        UIColor *brushPattern = [UIColor redColor];
        
        
        [path moveToPoint:CGPointMake(([[self.skillNodes objectForKey:[link objectAtIndex:0]] Position].x + self.frame.size.width*Zoom*MiniScale/2)/Zoom/MiniScale, ([[self.skillNodes objectForKey:[link objectAtIndex:0]] Position].y + self.frame.size.height*Zoom*MiniScale/2)/Zoom/MiniScale)];
        [path addLineToPoint:CGPointMake(([[self.skillNodes objectForKey:[link objectAtIndex:1]] Position].x + self.frame.size.width*Zoom*MiniScale/2)/Zoom/MiniScale, ([[self.skillNodes objectForKey:[link objectAtIndex:1]] Position].y + self.frame.size.height*Zoom*MiniScale/2)/Zoom/MiniScale)];
        //        [path addLineToPoint:CGPointMake([[self.skillNodes objectForKey:[link objectAtIndex:1]] Position].x + fullX/2, [[self.skillNodes objectForKey:[link objectAtIndex:1]] Position].y + fullY/2)];
        
        [brushPattern setStroke];
        [path stroke];
        //[path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];

    }
     */
}

-(void)disableLinks:(NSArray *)linkToDisable {
    for (NSNumber *linkIDX in linkToDisable) {
        //NSLog(@"linkIDX %@", linkIDX);
        SkillLinkView *linkView = (SkillLinkView *)[self viewWithTag:([linkIDX intValue] * SkillLinkID)];
        [linkView disable];
    }
}

-(void)activateLinks:(NSArray *)linkToActivate {
    for (NSNumber *linkIDX in linkToActivate) {
        //NSLog(@"linkIDX %@", linkIDX);
        SkillLinkView *linkView = (SkillLinkView *)[self viewWithTag:([linkIDX intValue] * SkillLinkID)];
        [linkView activate];
    }
}

-(void)highlightLinks:(NSArray *)linkToHighlight{
    for (NSNumber *linkIDX in linkToHighlight) {
        //NSLog(@"linkIDX %@", linkIDX);
        SkillLinkView *linkView = (SkillLinkView *)[self viewWithTag:([linkIDX intValue] * SkillLinkID)];
        [linkView highlight];
    }
}

-(void) setNeedsDisplay {
    [self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    [super setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect");
}
*/

@end
