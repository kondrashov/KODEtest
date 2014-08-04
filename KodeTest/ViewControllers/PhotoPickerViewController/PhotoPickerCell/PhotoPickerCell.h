//
//  PhotoPickerCell.h
//  KodeTest
//
//  Created by Artem Kondrashov on 03.08.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoPickerCellDelegate <NSObject>

- (void)checkPhotoWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface PhotoPickerCell : UICollectionViewCell

@property (weak, nonatomic) id<PhotoPickerCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

+ (NSString *)cellReuseId;

- (void)configureCellWithImageUrl:(NSString *)imageURL
                        indexPath:(NSIndexPath *)indexPath
                        isChecked:(BOOL)isChecked
                         delegate:(id<PhotoPickerCellDelegate>)delegate;

@end
