//
//  SkillLinkView.m
//  POEMPST
//
//  Created by FLK on 06/04/13.
//

#import "SkillLinkView.h"

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
};

float ceilfabs(float dec)
{
    return ceilf(abs(dec));
};

@implementation SkillLinkView

@synthesize startPoint, endPoint, isActivated, isHighlighted;

- (id)initWithFrame:(CGRect)frame andStartNode:(SkillNode *)n1 andEndNode:(SkillNode *)n2 andFullSize:(CGSize)gSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.isActivated = NO;
        self.isHighlighted = NO;
        CGPoint startP = CGPointMake(([n1 Position].x + gSize.width*Zoom*MiniScale/2)/Zoom/MiniScale,
                             ([n1 Position].y + gSize.height*Zoom*MiniScale/2)/Zoom/MiniScale);
        
        CGPoint endP = CGPointMake(([n2 Position].x + gSize.width*Zoom*MiniScale/2)/Zoom/MiniScale,
                             ([n2 Position].y + gSize.height*Zoom*MiniScale/2)/Zoom/MiniScale);
        
        CGRect r = CGRectMake(MIN(startP.x, endP.x) - StrokeWidth / 2,
                              MIN(startP.y, endP.y) - StrokeWidth / 2,
                              fabs(startP.x - endP.x) + StrokeWidth,
                              fabs(startP.y - endP.y) + StrokeWidth);
        

        self.node1 = n1;
        self.node2 = n2;
        
        if (startP.x < endP.x && startP.y < endP.y) {
            self.startPoint = CGPointMake(StrokeWidth / 2, StrokeWidth / 2);
            self.endPoint = CGPointMake(endP.x - startP.x + StrokeWidth / 2, endP.y - startP.y + StrokeWidth / 2);
        }
        else if (startP.x > endP.x && startP.y > endP.y)
        {
            self.startPoint = CGPointMake(startP.x - endP.x + StrokeWidth / 2, startP.y - endP.y + StrokeWidth / 2);
            self.endPoint = CGPointMake(StrokeWidth / 2, StrokeWidth / 2);
        }
        else if (startP.x < endP.x && startP.y > endP.y)
        {
            self.startPoint = CGPointMake(StrokeWidth / 2, startP.y - endP.y + StrokeWidth / 2);
            self.endPoint = CGPointMake(endP.x - startP.x + StrokeWidth / 2, StrokeWidth / 2);
        }
        else if (startP.x > endP.x && startP.y < endP.y)
        {
            self.startPoint = CGPointMake(startP.x - endP.x + StrokeWidth / 2, StrokeWidth / 2);
            self.endPoint = CGPointMake(StrokeWidth / 2, endP.y - startP.y + StrokeWidth / 2);
        }
        else if (startP.x == endP.x && startP.y < endP.y) {
            self.startPoint = CGPointMake(StrokeWidth / 2, StrokeWidth / 2);
            self.endPoint = CGPointMake(endP.x - startP.x + StrokeWidth / 2, endP.y - startP.y + StrokeWidth / 2);
        }
        else if (startP.x == endP.x && startP.y > endP.y) {
            self.startPoint = CGPointMake(startP.x - endP.x + StrokeWidth / 2, startP.y - endP.y + StrokeWidth / 2);
            self.endPoint = CGPointMake(StrokeWidth / 2, StrokeWidth / 2);
        }
        else if (startP.x < endP.x && startP.y == endP.y) {
            self.startPoint = CGPointMake(StrokeWidth / 2, startP.y - endP.y + StrokeWidth / 2);
            self.endPoint = CGPointMake(endP.x - startP.x + StrokeWidth / 2, StrokeWidth / 2);
        }
        else if (startP.x > endP.x && startP.y == endP.y) {
            self.startPoint = CGPointMake(startP.x - endP.x + StrokeWidth / 2, StrokeWidth / 2);
            self.endPoint = CGPointMake(StrokeWidth / 2, endP.y - startP.y + StrokeWidth / 2);
        }
        
        self.clipsToBounds = NO;
        self.backgroundColor=[UIColor clearColor];
        myPath=[[UIBezierPath alloc]init];
        myPath.lineWidth=2;
                
        brushPattern=[UIColor colorWithRed:66/255.f green:58/255.f blue:32/255.f alpha:1.00];
        

        
        if (n1.nodeGroup == n2.nodeGroup && n1.orbit == n2.orbit) {
            CGPoint tmpP = CGPointMake((n1.nodeGroup.position.x + gSize.width*Zoom*MiniScale/2)/Zoom/MiniScale, (n1.nodeGroup.position.y + gSize.height*Zoom*MiniScale/2)/Zoom/MiniScale);
            CGPoint diff = CGPointMake((tmpP.x - startP.x), (tmpP.y - startP.y));
            CGPoint okP = CGPointMake(self.startPoint.x + diff.x, self.startPoint.y + diff.y);
            
            UIBezierPath *tmpPath=[[UIBezierPath alloc]init];
            bool clockwise = NO;
            
            if ((n1.Arc - n2.Arc > 0 && n1.Arc - n2.Arc <= M_PI) || n1.Arc - n2.Arc < -M_PI)
            {
                [tmpPath addArcWithCenter:CGPointMake(okP.x,
                                                     okP.y) radius:orbitRadii[n1.orbit]/Zoom/MiniScale startAngle:(n1.Arc - DegreesToRadians(90.0f)) endAngle:(n2.Arc - DegreesToRadians(90.0f)) clockwise:NO];
            }
            else
            {
                [tmpPath addArcWithCenter:CGPointMake(okP.x,
                                                     okP.y) radius:orbitRadii[n1.orbit]/Zoom/MiniScale startAngle:(n1.Arc - DegreesToRadians(90.0f)) endAngle:(n2.Arc - DegreesToRadians(90.0f)) clockwise:YES];
                
                clockwise = YES;
            }

            CGSize tmpSize = [tmpPath bounds].size;
                    
            if (ceilfabs(tmpSize.height - r.size.height + StrokeWidth) > 0) {

                float offsetH = tmpSize.height - r.size.height + StrokeWidth/2;

                
                if (startPoint.y > okP.y) {
                    offsetH += StrokeWidth/2/2;

                    r.size.height += offsetH;
                }
                else if (startPoint.y == okP.y)
                {
                    if (clockwise) {
                        okP.y += offsetH;
                        r.origin.y -= offsetH;
                        r.size.height += offsetH;
                        
                    }
                    else
                    {
                        r.size.height += (offsetH + 5);
                    }
                }
                else
                {
                    offsetH += StrokeWidth/2;
                    
                    okP.y += offsetH;
                    r.origin.y -= offsetH;
                    r.size.height += offsetH;
                }
                

                
            }
            else if (ceilfabs(tmpSize.width - r.size.width + StrokeWidth) > 0)
            {
                float offsetW = tmpSize.width - r.size.width + StrokeWidth/2;
                
                if (startPoint.x > okP.x) {
                    offsetW += StrokeWidth/2;
                    r.size.width += offsetW;
                }
                else if (startPoint.x == okP.x)
                {
                    //ras
                   // NSLog(@"gid2 %d", n1.nodeGroup.id);
                }
                else
                {
                    
                    offsetW += StrokeWidth/2;
                    
                    okP.x += offsetW;
                    r.origin.x -= offsetW;
                    r.size.width += offsetW;
                }
                
               // NSLog(@"tmprf1       %@", NSStringFromCGSize(r.size));
                
            }
            else
            {

                
            }

            if ((n1.Arc - n2.Arc > 0 && n1.Arc - n2.Arc <= M_PI) || n1.Arc - n2.Arc < -M_PI)
            {
                [myPath addArcWithCenter:CGPointMake(okP.x,
                                                     okP.y) radius:orbitRadii[n1.orbit]/Zoom/MiniScale startAngle:(n1.Arc - DegreesToRadians(90.0f)) endAngle:(n2.Arc - DegreesToRadians(90.0f)) clockwise:NO];
                
            }
            else
            {
                [myPath addArcWithCenter:CGPointMake(okP.x,
                                                     okP.y) radius:orbitRadii[n1.orbit]/Zoom/MiniScale startAngle:(n1.Arc - DegreesToRadians(90.0f)) endAngle:(n2.Arc - DegreesToRadians(90.0f)) clockwise:YES];
            }

        }
        else
        {
            [myPath moveToPoint:startPoint];
            [myPath addLineToPoint:endPoint];
            
            //self.frame = r;
            
        }

        self.frame = r;

    }
    return self;
}

- (void)disable {
    //NSLog(@"disable %d > %d", self.node1.id, self.node2.id);
    self.isActivated = NO;
    self.isHighlighted = NO;
    
    myPath.lineWidth=2;
    brushPattern=[UIColor colorWithRed:66/255.f green:58/255.f blue:32/255.f alpha:1.00];
    [self setNeedsDisplay];
}

- (void)activate {
    self.isHighlighted = NO;
    self.isActivated = YES;
    
    brushPattern=[UIColor colorWithRed:173/255.f green:151/255.f blue:107/255.f alpha:1.00];
    myPath.lineWidth=3;
    [self setNeedsDisplay];
}

- (void)highlight {
    //brushPattern=[UIColor colorWithRed:173/255.f green:151/255.f blue:107/255.f alpha:1.00];

    self.isActivated = NO;
    self.isHighlighted = YES;
    
    brushPattern=[UIColor colorWithRed:135/255.f green:108/255.f blue:63/255.f alpha:1.00];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [brushPattern setStroke];
    [myPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    //[self sizeToFit];
}


@end
