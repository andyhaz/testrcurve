//
//  myDraw.m
//  testRCurve
//
//  Created by andrew hazlett on 8/27/16.
//  Copyright © 2016 andrew hazlett. All rights reserved.
//

#import "myDraw.h"
#import "myPoint.h"

@interface myDraw(){
    int locX,locY;
    short mouseClick,pointSelect;
    
    NSBezierPath *PathA,*PathB,*PathC;
}
@end

@implementation myDraw

@synthesize myMutaryOfPoints;


-(void)mouseDown:(NSEvent *)theEvent{
    if (!myMutaryOfPoints) myMutaryOfPoints = [[NSMutableArray alloc] init];
    if (!mouseClick) mouseClick = 1;
    if (pointSelect) pointSelect = 0;
    NSPoint tvarMousePointInWindow = [theEvent locationInWindow];
    NSPoint tvarMousePointInView   = [self convertPoint:tvarMousePointInWindow fromView:nil];
    myPoint * tvarMyPointObj       = [[myPoint alloc]initWithNSPoint:tvarMousePointInView];
    
    locX = [tvarMyPointObj x];
    locY = [tvarMyPointObj y];
    
    switch (mouseClick) {
        case 1:
            NSLog(@"first click");
            if (myMutaryOfPoints.count == 3) [myMutaryOfPoints removeAllObjects];
            [myMutaryOfPoints addObject:tvarMyPointObj];
            mouseClick ++;
            break;
        case 2:
            NSLog(@"secone click");
            [myMutaryOfPoints addObject:tvarMyPointObj];
            [myMutaryOfPoints addObject:tvarMyPointObj];
            //update with new middle
            myMutaryOfPoints = [self middleLocation:myMutaryOfPoints];
            
            mouseClick ++;//= 1;
            break;
        case 3:
          //  NSLog(@"click:%hhd",[PathA containsPoint:tvarMousePointInView]);
            if ([PathA containsPoint:tvarMousePointInView] == true) {
                NSLog(@"hit test A");
                pointSelect = 0;
            }
            if ([PathB containsPoint:tvarMousePointInView] == true) {
                NSLog(@"hit test B");
                pointSelect = 1;
            }
            if ([PathC containsPoint:tvarMousePointInView] == true) {
                NSLog(@"hit test C");
                pointSelect = 2;
            }
            break;
        default:
            break;
    }
    
}

-(void)mouseDragged:(NSEvent *)event{
  //  NSLog(@"mosue move");
    NSPoint tvarMousePointInWindow = [event locationInWindow];
    NSPoint tvarMousePointInView   = [self convertPoint:tvarMousePointInWindow fromView:nil];
    myPoint * tvarMyPointObj       = [[myPoint alloc]initWithNSPoint:tvarMousePointInView];

    [myMutaryOfPoints replaceObjectAtIndex:pointSelect withObject:tvarMyPointObj];

 
    [self setNeedsDisplay:YES];
}

-(void)mouseUp:(NSEvent *)theEvent{
    [self setNeedsDisplay:YES];
}

/*- (NSView *) hitTest: (NSPoint) aPoint {
    NSLog(@"hittest true");
    return [self superview];
}*/

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (locY && locX) [self drawSquareBackgroundSolidColor];

    // Drawing code h
  /*  NSBezierPath *curve = [NSBezierPath bezierPath];

    [curve moveToPoint:NSMakePoint(startX,startY)];
    
    [curve curveToPoint:NSMakePoint(endPointx,endPointy)
                  controlPoint1:NSMakePoint(point1x,point1y)
                  controlPoint2:NSMakePoint(point2x,point2y)];
    
    [curve setLineWidth:5.0];
    [[NSColor redColor] set];
    [curve stroke];
    
    [[NSColor whiteColor] set];
    [curve fill];*/
}

-(NSMutableArray*)middleLocation:(NSMutableArray*)midAry{
    //formale (x1 + x2)/2 (y1+ y2)/2
    int x1,x2,y1,y2;
    int midx,midy;
    
    if (midAry) {
        x1 = [[midAry objectAtIndex:0] x];
        y1 = [[midAry objectAtIndex:0] y];
       
        x2 = [[midAry objectAtIndex:1] x];
        y2 = [[midAry objectAtIndex:1] y];
        
        midx = (x1+x2)/2;
        midy = (y1+y2)/2;
        
        NSPoint tvarMousePointInView   = [self convertPoint:NSMakePoint(midx, midy+40) fromView:nil];
        myPoint * tvarMyPointObj       = [[myPoint alloc]initWithNSPoint:tvarMousePointInView];
        
        [midAry replaceObjectAtIndex:1 withObject:tvarMyPointObj];
        
        return midAry;
    }
    return nil;
}

-(void)drawCurve{
    NSBezierPath *curve = [NSBezierPath bezierPath];
    
    int locX1 = (int)[myMutaryOfPoints[0] x];
    int locY1 = (int)[myMutaryOfPoints[0] y];
    
    int locX2 = (int)[myMutaryOfPoints[1] x];
    int locY2 = (int)[myMutaryOfPoints[1] y];
    
    int locX3 = (int)[myMutaryOfPoints[2] x];
    int locY3 = (int)[myMutaryOfPoints[2] y];
    
    [curve moveToPoint:NSMakePoint(locX1,locY1)];
    
    [curve curveToPoint:NSMakePoint(locX3,locY3)
          controlPoint1:NSMakePoint(locX2,locY2)
          controlPoint2:NSMakePoint(locX2,locY2)];
    
    [curve setLineWidth:5.0];
    [[NSColor redColor] set];
    [curve stroke];
    
    [[NSColor whiteColor] set];
    [curve fill];
}


-(void)drawLine {
        int locX1 = (int)[myMutaryOfPoints[0] x];
        int locY1 = (int)[myMutaryOfPoints[0] y];
        
        int locX2 = (int)[myMutaryOfPoints[1] x];
        int locY2 = (int)[myMutaryOfPoints[1] y];
    
        int locX3 = (int)[myMutaryOfPoints[2] x];
        int locY3 = (int)[myMutaryOfPoints[2] y];
    
        NSBezierPath *Path = [NSBezierPath bezierPath];
        [Path moveToPoint:NSMakePoint(locX1, locY1)];
        [Path lineToPoint:NSMakePoint(locX2, locY2)];
        [Path lineToPoint:NSMakePoint(locX3, locY3)];
        [Path setLineWidth:3.0];
        [[NSColor blueColor] set];
        [Path stroke];
}


-(void)drawSquareBackgroundSolidColor {
    //  NSLog(@"myMutaryOfPoints:%@",myMutaryOfPoints);

    if ([myMutaryOfPoints count] > 0) {
     //NSLog(@"not null A:%@",[myMutaryOfPoints objectAtIndex:0]);
        int locX1 = (int)[myMutaryOfPoints[0] x];
        int locY1 = (int)[myMutaryOfPoints[0] y];
        PathA = [NSBezierPath bezierPathWithRect:NSMakeRect(locX1,locY1, 10, 10)];
        //  [[NSColor whiteColor] set];
        //  [Path fill];
        [[NSColor blackColor] set];
        [PathA setLineWidth:1.0];
        [PathA stroke];
    }
    
    if ([myMutaryOfPoints count] > 1) {
     //NSLog(@"not null B:%@",[myMutaryOfPoints objectAtIndex:1]);
        int locX2 = (int)[myMutaryOfPoints[1] x];
        int locY2 = (int)[myMutaryOfPoints[1] y];
        PathB = [NSBezierPath bezierPathWithRect:NSMakeRect(locX2,locY2, 10, 10)];
        //  [[NSColor whiteColor] set];
        //  [Path fill];
        [[NSColor blackColor] set];
        [PathB setLineWidth:2.0];
        [PathB stroke];
        
        [self drawLine];
        
        int locX3 = (int)[myMutaryOfPoints[2] x];
        int locY3 = (int)[myMutaryOfPoints[2] y];
        PathC = [NSBezierPath bezierPathWithRect:NSMakeRect(locX3,locY3, 10, 10)];
        //  [[NSColor whiteColor] set];
        //  [Path fill];
        [[NSColor blackColor] set];
        [PathC setLineWidth:1.0];
        [PathC stroke];
        [self drawLine];
        [self drawCurve];
    }
      //NSLog(@"myMutaryOfPoints X:%d y:%d",locX,locY);
}
@end
