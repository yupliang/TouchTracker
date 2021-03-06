//
//  QQZDrawView.m
//  TouchTracker
//
//  Created by Qiqiuzhe on 2021/1/9.
//  Copyright © 2021 Qiqiuzhe. All rights reserved.
//

#import "QQZDrawView.h"

@implementation QQZDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishedLines = [NSMutableArray new];
        self.lineInProgress = [NSMutableDictionary new];
        self.circles = [NSMutableArray new];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = TRUE;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delaysTouchesBegan = TRUE;
        [tap requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
    }
    return self;
}

- (void)longPress:(UILongPressGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.lineInProgress removeAllObjects];
        }
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

- (void)moveLine:(UIPanGestureRecognizer *)gr {
    if (!self.selectedLine) {
        return;
    }
    if (gr.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gr translationInView:self];
        
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];
    }
}

- (void)tap:(UIGestureRecognizer *)gr {
    NSLog(@"%s", __func__);
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    if (self.selectedLine) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        [menu showMenuFromView:self rect:CGRectMake(point.x, point.y, 2, 2)];
//        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
//        [menu setMenuVisible:YES animated:YES];
    } else {
        [[UIMenuController sharedMenuController] setMenuVisible:false animated:false];
    }
    [self setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)deleteLine:(id)sender {
    [self.finishedLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
}

- (void)doubleTap:(UIGestureRecognizer *)gr {
    NSLog(@"%s", __func__);
    [self.finishedLines removeAllObjects];
    [self.lineInProgress removeAllObjects];
    [self.circles removeAllObjects];
    [self setNeedsDisplay];
}

- (void)strokeLine:(QQZLine *)line {
    UIBezierPath *bp = [[UIBezierPath alloc] init];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)strokeCircle:(QQZCircle *)circle {
    CGFloat distance = [self distanceBetweenTwoPoint:circle.point2 point2:circle.point1];
    circle.color = [UIColor colorWithRed:1 green:distance/1000 blue:1 alpha:1];
    UIBezierPath *bp = [[UIBezierPath alloc] init];
    bp.lineWidth = 10;
    [bp addArcWithCenter:CGPointMake((circle.point1.x+circle.point2.x)/2, (circle.point1.y+circle.point2.y)/2) radius:sqrtf(powf(distance/2, 2)/2) startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [bp stroke];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (QQZLine *line in self.finishedLines) {
        [line.color set];
        [self strokeLine:line];
    }
    [[UIColor redColor] set];
    for (NSValue *key in self.lineInProgress) {
        [self strokeLine:self.lineInProgress[key]];
    }
    for (QQZCircle *circle in self.circles) {
        [circle.color set];
        [self strokeCircle:circle];
    }
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    if (touches.count == 2) {
        int i=0;
        QQZCircle *circle = [QQZCircle new];
        for (UITouch *t in touches) {
            i++;
            if (i == 1) {
                circle.point1 = [t locationInView:self];
            } else if (i == 2) {
                circle.point2 = [t locationInView:self];
            }
        }
        [self.circles addObject:circle];
    }
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        QQZLine *line = [QQZLine new];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.lineInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        QQZLine *line = self.lineInProgress[key];
        line.end = location;
    }

    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        QQZLine *line = self.lineInProgress[key];
        line.end = location;
        CGFloat angle = [self angleBetweenLinesWithLine1Start:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) Line1End:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds)) Line2Start:line.begin Line2End:line.end];
        line.color = [UIColor colorWithRed:angle/M_PI green:angle/M_PI blue:angle/M_PI alpha:1];
        
        [self.finishedLines addObject:line];
        [self.lineInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    for (UITouch *t in touches) {
        [self.lineInProgress removeObjectForKey:[NSValue valueWithNonretainedObject:t]];
    }
    [self setNeedsDisplay];
}

- (CGFloat)angleBetweenLinesWithLine1Start:(CGPoint)line1Start

                                  Line1End:(CGPoint)line1End

                                Line2Start:(CGPoint)line2Start

                                  Line2End:(CGPoint)line2End{

    CGFloat a = line1End.x - line1Start.x;

    CGFloat b = line1End.y - line1Start.y;

    CGFloat c = line2End.x - line2Start.x;

    CGFloat d = line2End.y - line2Start.y;

    return acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
}

//计算两点距离
-(float)distanceBetweenTwoPoint:(CGPoint)point1 point2:(CGPoint)point2
{
    
    return sqrtf(powf(point1.x - point2.x, 2) + powf(point1.y - point2.y, 2));
}

- (QQZLine *)lineAtPoint:(CGPoint)p {
    for (QQZLine *line in self.finishedLines) {
        CGPoint start = line.begin;
        CGPoint end = line.end;
        
        for (float t = 0.0; t<=1.0; t+=0.05) {
            float x = start.x + t*(end.x-start.x);
            float y = start.y + t*(end.y-start.y);
            if (hypot(x-p.x, y-p.y) < 20) {
                return line;
            }
        }
    }
    return nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return FALSE;
}

@end
