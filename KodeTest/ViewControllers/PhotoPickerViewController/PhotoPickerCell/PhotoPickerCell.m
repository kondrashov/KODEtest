//
//  PhotoPickerCell.m
//  KodeTest
//
//  Created by Artem Kondrashov on 03.08.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "PhotoPickerCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface PhotoPickerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pickerImage;
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;

@end

@implementation PhotoPickerCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupUI];
    [self createGestures];
}

#pragma mark - Class methods

+ (NSString *)cellReuseId
{
    return @"PhotoPickerCell";
}

#pragma mark - Methods

- (void)setupUI
{
    self.pickerImage.layer.borderWidth = 1;
    self.pickerImage.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)createGestures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPickerButton:)];
    [self addGestureRecognizer:tap];
}

- (void)configureCellWithImageUrl:(NSString *)imageURL indexPath:(NSIndexPath *)indexPath isChecked:(BOOL)isChecked delegate:(id<PhotoPickerCellDelegate>)delegate
{
    self.pickerImage.image = nil;
    [self.pickerImage setImageWithURL:[NSURL URLWithString:imageURL]];
    self.indexPath = indexPath;
    self.pickerButton.selected = isChecked;
    self.pickerButton.alpha = self.pickerButton.selected ? 1 : 0.5;
    self.delegate = delegate;
}

#pragma mark - Action

- (IBAction)pressPickerButton:(id)sender
{
    if(!self.pickerImage.image && sender)
        return;
    
    self.pickerButton.selected = !self.pickerButton.selected;
    self.pickerButton.alpha = self.pickerButton.selected ? 1 : 0.5;
    
    if([self.delegate respondsToSelector:@selector(checkPhotoWithIndexPath:)])
        [self.delegate checkPhotoWithIndexPath:self.indexPath];
}

@end
