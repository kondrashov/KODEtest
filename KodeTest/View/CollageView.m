//
//  CollageView.m
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "CollageView.h"
#import "UIImageView+AFNetworking.h"

#define MAX_IMAGE_COUNT     12

@interface CollageView ()
{
    NSInteger maxImageCount;
    NSInteger imageLoadedCount;
}

@property (strong, nonatomic) NSMutableArray *imgViewsArray;

@end

@implementation CollageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.clipsToBounds = YES;
        self.alpha = 0;
        imageLoadedCount = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutImageViews];
}

- (void)layoutImageViews
{
    CGFloat imgWidth = self.frame.size.width / 3;
    CGFloat x = 0;
    CGFloat y = 0;
    
    for(UIImageView *imgView in self.imgViewsArray)
    {
        imgView.frame = CGRectMake(x, y, imgWidth, imgWidth);
        x += imgWidth;
        
        if(x >= self.frame.size.width)
        {
            x = 0;
            y += imgWidth;
        }
    }
}

- (void)configureWithImgUrlsArray:(NSArray *)imgUrlsArray
{
    self.imgViewsArray = [NSMutableArray array];
    maxImageCount = (MAX_IMAGE_COUNT < imgUrlsArray.count) ? MAX_IMAGE_COUNT : imgUrlsArray.count;

    for(int i = 0; i < maxImageCount; i++)
    {
        NSString *url = imgUrlsArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.imgViewsArray addObject:imageView];
        [self addSubview:imageView];
        __weak UIImageView *weakImageView = imageView;
        [imageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakImageView.image = image;
            imageLoadedCount++;
            
            if(imageLoadedCount == maxImageCount)
            {
                if([self.delegate respondsToSelector:@selector(collageLoadFinished)])
                    [self.delegate collageLoadFinished];
                
                [UIView animateWithDuration:0.5 animations:^{
                    self.alpha = 1;
                }];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
    }
}

- (UIImage *) imageFromView: (UIView *) view
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    if (scale > 1) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext: context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end
