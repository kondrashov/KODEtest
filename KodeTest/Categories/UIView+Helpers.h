//
//  UIView+Helpers.h
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 Artem Kondrashov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helpers)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;

- (void)frameRoundToInt;
- (UIView *)findFirstResponder;

@end
