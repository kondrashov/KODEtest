//
//  UIView+Helpers.m
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 Artem Kondrashov. All rights reserved.
//

#import "UIView+Helpers.h"

@implementation UIView (Helpers)

- (CGFloat) height
{
    return self.frame.size.height;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (CGFloat) x
{
    return self.frame.origin.x;
}

- (CGFloat) y
{
    return self.frame.origin.y;
}

- (CGFloat) centerY
{
    return self.center.y;
}

- (CGFloat) centerX
{
    return self.center.x;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)x
{
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void)setCenterY:(CGFloat)y
{
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (void) setHeight:(CGFloat) newHeight
{
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (void) setWidth:(CGFloat) newWidth
{
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (void) setX:(CGFloat) newX
{
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

- (void) setY:(CGFloat) newY
{
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder])
        return self;
    
    for (UIView * subView in self.subviews)
    {
        UIView * fr = [subView findFirstResponder];
        if (fr != nil)
            return fr;
    }
    return nil;
}

- (void)frameRoundToInt
{
    self.frame = CGRectMake((int)(self.frame.origin.x + 0.5),
                            (int)(self.frame.origin.y + 0.5),
                            (int)(self.frame.size.width + 0.5),
                            (int)(self.frame.size.height +0.5));
}

@end
