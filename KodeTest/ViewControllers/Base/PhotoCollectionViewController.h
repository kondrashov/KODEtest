//
//  PhotoCollectionViewController.h
//  KodeTest
//
//  Created by Artem Kondrashov on 03.08.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewController : UIViewController

@property (strong, nonatomic) NSArray *imgUrlsArray;

- (id)initWithImageUrlsArray:(NSArray *)imgUrlsArray;

@end
