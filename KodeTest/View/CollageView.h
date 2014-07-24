//
//  CollageView.h
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollageViewDelegate <NSObject>

- (void)collageLoadFinished;

@end

@interface CollageView : UIView

@property (weak, nonatomic) id<CollageViewDelegate> delegate;

- (void)configureWithImgUrlsArray:(NSArray *)imgUrlsArray;

@end
