//
//  PhotoPickerViewController.m
//  KodeTest
//
//  Created by Artem Kondrashov on 03.08.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "PhotoPickerViewController.h"

#define TOP_BORDER_INSET        10
#define BOTTOM_BORDER_INSET     10

@interface PhotoPickerViewController ()

@property (strong, nonatomic) NSMutableArray *checkedStatesArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PhotoPickerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
    [self prepareCheckedArray];
}

#pragma mark - Methods

- (void)setupUI
{
    self.title = @"Выберите лучшие фото";
    self.navigationController.navigationBar.hidden = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:[PhotoPickerCell cellReuseId] bundle:nil] forCellWithReuseIdentifier:[PhotoPickerCell cellReuseId]];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(TOP_BORDER_INSET, 0, BOTTOM_BORDER_INSET, 0);    
}

- (void)prepareCheckedArray
{
    if(!self.checkedStatesArray)
        self.checkedStatesArray = [NSMutableArray array];
    else
        [self.checkedStatesArray removeAllObjects];
    
    for(int i = 0; i < self.imgUrlsArray.count; i++)
        [self.checkedStatesArray addObject:@(NO)];
}

#pragma mark - CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgUrlsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoPickerCell cellReuseId] forIndexPath:indexPath];

    [cell configureCellWithImageUrl:self.imgUrlsArray[indexPath.row ]
                       indexPath:indexPath
                        isChecked:[self.checkedStatesArray[indexPath.row] boolValue]
                        delegate:self];
    return cell;
}

#pragma - PhotoPickerCell delegate

- (void)checkPhotoWithIndexPath:(NSIndexPath *)indexPath
{
    BOOL curentValue = [self.checkedStatesArray[indexPath.row] boolValue];
    [self.checkedStatesArray replaceObjectAtIndex:indexPath.row withObject:@(!curentValue)];
}


@end
