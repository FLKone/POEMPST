//
//  SkillLinksView.m
//  POEMPST
//
//  Created by FLK on 06/04/13.
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
        tmpView.tag = [self.skillLinks indexOfObject:link] + SkillLinkID;
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

-(void)reset {
    
    NSArray *viewArr = [self subviews];
    
    for (id item in viewArr)
    {
        if ([item isKindOfClass:[SkillLinkView class]])
        {
            SkillLinkView *blankItem = (SkillLinkView *)item;
            
            // this works
            [blankItem removeFromSuperview];
            
        }
        else
        {
            //
        }
    }
}

-(void)disableLinks:(NSArray *)linkToDisable {
    //NSLog(@"disableLinks");

    for (NSNumber *linkIDX in linkToDisable) {
        //NSLog(@"linkIDX %@", linkIDX);
        SkillLinkView *linkView = (SkillLinkView *)[self viewWithTag:([linkIDX intValue] + SkillLinkID)];
        if ([linkView respondsToSelector:@selector(disable)]) {
            //NSLog(@"linkView OK db %d %@", [linkIDX intValue] + SkillLinkID, [self viewWithTag:([linkIDX intValue] + SkillLinkID)]);

            [linkView disable];
        }
        else
        {
            SkillLinkView *tmpView = [[SkillLinkView alloc] initWithFrame:CGRectZero
                                                             andStartNode:[self.skillNodes objectForKey:[[self.skillLinks objectAtIndex:[linkIDX intValue]] objectAtIndex:0]]
                                                               andEndNode:[self.skillNodes objectForKey:[[self.skillLinks objectAtIndex:[linkIDX intValue]] objectAtIndex:1]]
                                                              andFullSize:self.frame.size];
            tmpView.tag = ([linkIDX intValue] + SkillLinkID);
            [self addSubview:tmpView];
            [tmpView disable];
            
            //NSLog(@"linkView db %d %@", [linkIDX intValue] + SkillLinkID, [self viewWithTag:([linkIDX intValue] + SkillLinkID)]);
        }
    }
}

-(void)activateLinks:(NSArray *)linkToActivate {
    //NSLog(@"activateLinks");

    for (NSNumber *linkIDX in linkToActivate) {
        //NSLog(@"linkIDX %@", linkIDX);
        SkillLinkView *linkView = (SkillLinkView *)[self viewWithTag:([linkIDX intValue] + SkillLinkID)];
        if ([linkView respondsToSelector:@selector(activate)]) {
            //NSLog(@"linkView OK ac %d %@", [linkIDX intValue] + SkillLinkID, [self viewWithTag:([linkIDX intValue] + SkillLinkID)]);
            runOnMainQueueWithoutDeadlocking(^{

                [linkView activate];
            });
        }
        else
        {
            SkillLinkView *tmpView = [[SkillLinkView alloc] initWithFrame:CGRectZero
                                                             andStartNode:[self.skillNodes objectForKey:[[self.skillLinks objectAtIndex:[linkIDX intValue]] objectAtIndex:0]]
                                                               andEndNode:[self.skillNodes objectForKey:[[self.skillLinks objectAtIndex:[linkIDX intValue]] objectAtIndex:1]]
                                                              andFullSize:self.frame.size];
            tmpView.tag = ([linkIDX intValue] + SkillLinkID);
            runOnMainQueueWithoutDeadlocking(^{

                [self addSubview:tmpView];
            
                [tmpView activate];
            });
            //NSLog(@"linkView ac %d %@", [linkIDX intValue] + SkillLinkID, [self viewWithTag:([linkIDX intValue] + SkillLinkID)]);
        }
    
    }
}

-(void)highlightLinks:(NSArray *)linkToHighlight{
    //NSLog(@"highlightLinks");

    for (NSNumber *linkIDX in linkToHighlight) {

        SkillLinkView *linkView = (SkillLinkView *)[self viewWithTag:([linkIDX intValue] + SkillLinkID)];
        if ([linkView respondsToSelector:@selector(highlight)]) {
            //NSLog(@"linkView OK hl %d %@", [linkIDX intValue] + SkillLinkID, [self viewWithTag:([linkIDX intValue] + SkillLinkID)]);
            runOnMainQueueWithoutDeadlocking(^{
                [linkView highlight];
            });
        }
        else
        {
            
            SkillLinkView *tmpView = [[SkillLinkView alloc] initWithFrame:CGRectZero
                                                             andStartNode:[self.skillNodes objectForKey:[[self.skillLinks objectAtIndex:[linkIDX intValue]] objectAtIndex:0]]
                                                               andEndNode:[self.skillNodes objectForKey:[[self.skillLinks objectAtIndex:[linkIDX intValue]] objectAtIndex:1]]
                                                              andFullSize:self.frame.size];
            tmpView.tag = ([linkIDX intValue] + SkillLinkID);
            runOnMainQueueWithoutDeadlocking(^{                
                [self addSubview:tmpView];
                [tmpView highlight];
            });
            
            //NSLog(@"linkView hl %d %@", [linkIDX intValue] + SkillLinkID, [self viewWithTag:([linkIDX intValue] + SkillLinkID)]);
        }
    }
}
/*
-(void) setNeedsDisplay {
    [self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    [super setNeedsDisplay];
}
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect");
}
*/

void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
@end
