//
//  CollageViewController.m
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "CollageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CollageView.h"


@interface CollageViewController () <CollageViewDelegate>

@property (weak, nonatomic) IBOutlet CollageView *collageView;
@property (strong, nonatomic) NSArray *imgUrlsArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CollageViewController

#pragma mark - Lifecycle

- (id)initWithImageUrlsArray:(NSArray *)imgUrlsArray
{
    self = [super init];
    if (self)
    {
        self.title = @"Коллаж";
        self.imgUrlsArray = [NSArray arrayWithArray:imgUrlsArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.activityIndicator startAnimating];
    self.collageView.delegate = self;
    [self.collageView configureWithImgUrlsArray:self.imgUrlsArray];
}

#pragma mark - CollageView delegate

- (void)collageLoadFinished
{
    [self.activityIndicator stopAnimating];
    self.btnPrint.hidden = NO;
}

#pragma mark - Methods

- (UIImage *) imageFromView: (UIView *) view
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    if (scale > 1)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    else
        UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext: context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

#pragma mark - Actions

- (IBAction)pressPrint:(id)sender
{
    UIImage *collageImage = [self imageFromView:self.collageView];
    
    UIPrintInteractionController *printer = [UIPrintInteractionController sharedPrintController];
    printer.printingItem = collageImage;
    
    UIPrintInfo *info = [UIPrintInfo printInfo];
    info.orientation = UIPrintInfoOrientationLandscape;
    info.outputType = UIPrintInfoOutputPhoto;
    printer.printInfo = info;
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
        if (!completed && error)
            NSLog(@"FAILED! due to error in domain %@ with error code %ld: %@",
                  error.domain, (long)error.code, [error localizedDescription]);
    };
    
    [printer presentAnimated:YES completionHandler:completionHandler];
}

@end
