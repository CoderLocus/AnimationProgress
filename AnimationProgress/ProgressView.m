//
//  ProgressView.m
//  AnimationProgress
//
//  Created by 井庆林 on 16/4/5.
//  Copyright © 2016年 unfae. All rights reserved.
//

#import "ProgressView.h"


@implementation ProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.925 green:0.961 blue:0.941 alpha:1.000];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger width = self.frame.size.width;
    NSInteger height = self.frame.size.height;
    
    // 画进度
    CGFloat padding = 25;
    CGFloat linewidth = 8;
    CGFloat radius = (width - padding - linewidth) / 2;
    CGFloat centerX = width / 2;
    CGFloat centerY = height - [self p_calculateAWithAngleA:30 c:radius] + 2;
    
    UIColor *lineColor = [UIColor colorWithRed:0.776 green:0.820 blue:0.863 alpha:1.000];
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, linewidth);
    CGContextAddArc(context, centerX, centerY, radius, 150 * M_PI / 180, 390 * M_PI / 180, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.271 green:0.541 blue:0.988 alpha:1.000].CGColor);
    CGContextSetLineWidth(context, linewidth);
    CGFloat angle = 150;
    if (_progress != 0) {
        angle = [self p_calculateProgressAngle:_progress];
    }
    CGContextAddArc(context, centerX, centerY, radius, 150 * M_PI / 180, angle * M_PI / 180, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    // 画虚线
    CGFloat lineRadius = radius - 14;
    CGContextSetLineWidth(context, 1);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextAddArc(context, centerX, centerY, lineRadius, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPoint linePoints[2];
    CGFloat b = [self p_calculateBWithA:height - centerY c:lineRadius];
    linePoints[0] = CGPointMake(centerX - b, height - 1);
    linePoints[1] = CGPointMake(centerX + b, height - 1);
    CGContextAddLines(context, linePoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGFloat triangleRadius = radius - 8;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.271 green:0.541 blue:0.988 alpha:1.000].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.271 green:0.541 blue:0.988 alpha:1.000].CGColor);
    CGContextSetLineWidth(context, 1);
    
    CGFloat a = [self p_calculateAWithAngleA:angle - 180 c:triangleRadius];
    b = [self p_calculateBWithAngleA:angle - 180 c:triangleRadius];
    
    CGPoint trianglePoints[3];
    trianglePoints[0] = CGPointMake(centerX - b, centerY - a);
    CGFloat radical3 = [self p_calculateAWithAngleA:60 c:4];
    
    CGFloat tempRadius = triangleRadius - radical3;
    CGFloat tempA = [self p_calculateAWithAngleA:angle - 180 c:tempRadius];
    CGFloat tempB = [self p_calculateBWithAngleA:angle - 180 c:tempRadius];
    
    CGFloat triangleA = [self p_calculateAWithAngleA:angle - 270 c:2];
    CGFloat triangleB = [self p_calculateBWithAngleA:angle - 270 c:2];
    trianglePoints[1] = CGPointMake(centerX - tempB + triangleB, centerY - tempA + triangleA);
    trianglePoints[2] = CGPointMake(centerX - tempB - triangleB, centerY - tempA - triangleA);
    CGContextAddLines(context, trianglePoints, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // 画刻度
    [self p_drawScaleWithContext:context centerX:centerX centerY:centerY radius:radius progress:25];
    [self p_drawScaleWithContext:context centerX:centerX centerY:centerY radius:radius progress:50];
    [self p_drawScaleWithContext:context centerX:centerX centerY:centerY radius:radius progress:75];
    
}

- (void)p_drawScaleWithContext:(CGContextRef)context centerX:(CGFloat)centerX centerY:(CGFloat)centerY radius:(CGFloat)radius progress:(NSInteger)progress {
    CGFloat scaleRadius = radius + 8;
    CGFloat angle = [self p_calculateProgressAngle:progress];
    CGFloat a = [self p_calculateAWithAngleA:angle - 180 c:scaleRadius];
    CGFloat b = [self p_calculateBWithAngleA:angle - 180 c:scaleRadius];
    CGFloat x = centerX - b;
    CGFloat y = centerY - a;
    UIColor *textColor = [UIColor colorWithRed:0.663 green:0.698 blue:0.765 alpha:1.000];
    CGContextSetFillColorWithColor(context, textColor.CGColor);
    CGContextSetStrokeColorWithColor(context, textColor.CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextAddArc(context, x, y, 1, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    NSString *text = [NSString stringWithFormat:@"%ld", progress];
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    if (progress == 25) {
        x = x - 16;
        y = y - 6;
    } else if (progress == 50) {
        x = x - 6;
        y = y - 14;
    } else if (progress == 75) {
        x = x + 4;
        y = y - 6;
    }
    [text drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
}

- (CGFloat)p_calculateProgressAngle:(CGFloat)progress {
    return progress / 100.0 * (240) + 150;
}

- (CGFloat)p_calculateAWithAngleA:(CGFloat)angleA c:(CGFloat)c {
    return c * sin(angleA * M_PI / 180);
}

- (CGFloat)p_calculateBWithAngleA:(CGFloat)angleA c:(CGFloat)c {
    return c * cos(angleA * M_PI / 180);
}

- (CGFloat)p_calculateBWithA:(CGFloat)a c:(CGFloat)c {
    return sqrt(c * c - a * a);
}

- (CGFloat)p_calculateRadius:(CGFloat)angle {
    return angle * M_PI / 180;
}

- (void)setProgress:(NSInteger)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end
