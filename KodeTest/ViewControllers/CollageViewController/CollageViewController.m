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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CollageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self createCollage];
}

#pragma mark - Methods

- (void)setupUI
{
    self.title = @"Коллаж";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.btnPrint.titleLabel.font = [UIFont fontWithName:@"Appetite New" size:14];
}

- (void)createCollage
{
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

#pragma mark - Actions

- (IBAction)pressPrint:(id)sender
{
    UIImage *collageImage = [self.collageView getCollageImage];
    
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
