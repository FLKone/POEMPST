//
//  SkillLinkView.m
//  POEMPST
//
//  Created by Shasta on 06/04/13.
//  Copyright (c) 2013 FLKone. All rights reserved.
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

@implementation SkillLinkView

@synthesize startPoint, endPoint;

- (id)initWithFrame:(CGRect)frame andStartNode:(SkillNode *)n1 andEndNode:(SkillNode *)n2 andFullSize:(CGSize)gSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
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
        //myPath.lineCapStyle=kCGLineCapRound;
        //myPath.miterLimit=0;
        myPath.lineWidth=2;
        
        float radius;
        /*
        if (n1.id == 50636) {
            brushPattern=[UIColor redColor];
            radius = 15;
        }
        else if (n1.id == 1338) {
            brushPattern=[UIColor blueColor];
            radius = 10;
        }
        else
         )*/
        
        //NSLog(@"skill %d - %d | %@ - %@", n1.id, n2.id, n1.name, n2.name);
        
        brushPattern=[UIColor brownColor];
        
        //self.layer.borderColor = [UIColor whiteColor].CGColor;
        //self.layer.borderWidth = 1.0f;
        
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
            
            if (tmpSize.height > r.size.height) {
                
                float offsetH = tmpSize.height - r.size.height + StrokeWidth/2;
                
                if (startPoint.y > okP.y) {
                    r.size.height += offsetH;
                }
                else if (startPoint.y == okP.y)
                {
                    //self.layer.borderColor = [UIColor whiteColor].CGColor;
                    //self.layer.borderWidth = 1.0f;
                                              
                    if (clockwise) {
                        NSLog(@"cw");
                        
                        okP.y += offsetH;
                        r.origin.y -= offsetH;
                        r.size.height += offsetH;
                        
                    }
                    else
                    {
                        NSLog(@"!cw");
                        r.size.height += (offsetH + 5);
                    }
                }
                else
                {
                    okP.y += offsetH;
                    r.origin.y -= offsetH;
                    r.size.height += offsetH;
                }
            }
            else if (tmpSize.width > r.size.width)
            {
                float offsetW = tmpSize.width - r.size.width + StrokeWidth/2;
                
                if (startPoint.x > okP.x) {
                    r.size.width += offsetW;
                }
                else if (startPoint.x == okP.x)
                {
                    //ras
                    NSLog(@"gid2 %d", n1.nodeGroup.id);                    
                }
                else
                {
                    okP.x += offsetW;
                    r.origin.x -= offsetW;
                    r.size.width += offsetW;
                }
                
            }
            

            //else
             //   NSLog(@"OK Size");
            /*
            if (r.size.height >= r.size.width) {
             
                if (r.size.width < (orbitRadii[n1.orbit]/Zoom/MiniScale + StrokeWidth)) {
                    NSLog(@"trop petit Width diff %f", (orbitRadii[n1.orbit]/Zoom/MiniScale + StrokeWidth) - r.size.width);
                    
                    float offset = ((orbitRadii[n1.orbit]/Zoom/MiniScale + StrokeWidth) - r.size.width);
                    
                    //r.origin.x -= offset/2;
                    //r.size.width += offset;
                    
                    //okP = CGPointMake(okP.x + offset/2, okP.y);
                }
            }
            else
            {
                if (r.size.height < (orbitRadii[n1.orbit]/Zoom/MiniScale + StrokeWidth)) {
                    NSLog(@"trop petit height %f", (orbitRadii[n1.orbit]/Zoom/MiniScale + StrokeWidth) - r.size.height);
                    
                    float offset = ((orbitRadii[n1.orbit]/Zoom/MiniScale + StrokeWidth) - r.size.height);
                    
                    //r.origin.y -= offset/2;
                    //r.size.height += offset;
                    
                    //okP = CGPointMake(okP.x, okP.y + offset/2);
                    
                   // if (okP.y < orbitRadii[n1.orbit]/Zoom/MiniScale) {
                    //    float offset2 = orbitRadii[n1.orbit]/Zoom/MiniScale - okP.y;
                   //     okP.y += offset2;
                   //     r.size.height += offset2;
                   // }
                }
            }
            
            */
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
            /*
            NSLog(@"startP      %@", NSStringFromCGPoint(startP));
            NSLog(@"endP        %@", NSStringFromCGPoint(endP));
            NSLog(@"tmpP        %@", NSStringFromCGPoint(tmpP));
            NSLog(@"diff        %@", NSStringFromCGPoint(diff));

            NSLog(@"r           %@", NSStringFromCGRect(r));
            NSLog(@"myPath r    %@", NSStringFromCGRect([myPath bounds]));
            NSLog(@"startPoint  %@", NSStringFromCGPoint(startPoint));
            NSLog(@"endPoint    %@", NSStringFromCGPoint(endPoint));

            NSLog(@"okP         %@", NSStringFromCGPoint(okP));
            NSLog(@"radius      %f", orbitRadii[n1.orbit]/Zoom/MiniScale);
            NSLog(@"staAngle    %f", RadiansToDegrees((n1.Arc - DegreesToRadians(90.0f))));
            NSLog(@"endAngle    %f", RadiansToDegrees((n2.Arc - DegreesToRadians(90.0f))));
            
            NSLog(@"===================");
            NSLog(@"===================");            
            */
            
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