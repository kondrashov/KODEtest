//
//  PhotoCollectionViewController.m
//  KodeTest
//
//  Created by Artem Kondrashov on 03.08.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "PhotoCollectionViewController.h"

@interface PhotoCollectionViewController ()

@end

@implementation PhotoCollectionViewController

- (id)initWithImageUrlsArray:(NSArray *)imgUrlsArray
{
    self = [super init];
    if (self)
    {
        self.imgUrlsArray = [NSArray arrayWithArray:imgUrlsArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
