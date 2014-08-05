//
//  PhotoPickerViewController.m
//  KodeTest
//
//  Created by Artem Kondrashov on 03.08.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "CollageViewController.h"

#define TOP_BORDER_INSET        10

@interface PhotoPickerViewController ()
{
    BOOL isCheckAll;
}

@property (strong, nonatomic) NSMutableArray *checkedStatesArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *checkAllButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

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
    layout.sectionInset = UIEdgeInsetsMake(TOP_BORDER_INSET, 0, self.footerView.height + TOP_BORDER_INSET, 0);
}

- (void)checkAllPhoto
{
    isCheckAll = !isCheckAll;
    [self.checkedStatesArray removeAllObjects];
    
    for(int i = 0; i < self.imgUrlsArray.count; i++)
        [self.checkedStatesArray addObject:@(isCheckAll)];

    [self.collectionView reloadData];
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

#pragma mark - Actions

- (IBAction)pressCheckAllButton:(id)sender
{
    [self checkAllPhoto];
    NSString *title = isCheckAll ? @"Убрать выделение" : @"Выбрать все";

    [UIView performWithoutAnimation:^{
        [self.checkAllButton setTitle:title forState:UIControlStateNormal];
        [self.checkAllButton sizeToFit];
    }];
}

- (IBAction)pressDoneButton:(id)sender
{
    NSMutableArray *resultArray = [NSMutableArray array];;
    for(int i = 0; i < self.imgUrlsArray.count; i++)
    {
        if([self.checkedStatesArray[i] boolValue] == YES)
           [resultArray addObject:self.imgUrlsArray[i]];
    }
    
    if(resultArray.count)
    {
        CollageViewController *collageViewController = [[CollageViewController alloc] initWithImageUrlsArray:resultArray];
        [self.navigationController pushViewController:collageViewController animated:YES];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Вы не выбрали ни одного фото" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
}

@end
