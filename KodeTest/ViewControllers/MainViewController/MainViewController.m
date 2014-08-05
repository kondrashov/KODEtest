//
//  MainViewController.m
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "MainViewController.h"
#import "AuthViewController.h"
#import "CollageViewController.h"
#import "PhotoPickerViewController.h"
#import "InetProvider.h"

@interface MainViewController () <InetProviderDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *token;

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self createObservers];
    [self createGetures];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Methods

- (void)setupUI
{
    [self updateUI];
    self.title = @"";
    self.getCollageButton.titleLabel.font = [UIFont fontWithName:@"Appetite New" size:18];
    [self.getCollageButton sizeToFit];
    
    self.containerView.x = IS_RETINA ? 19.5 : 19;
    self.containerView.y = IS_IPHONE_5 ? 216 : 172;
    [self performSelector:@selector(showInputField) withObject:nil afterDelay:0.5];
}

- (void)showInputField
{
    [UIView animateWithDuration:1 animations:^{
        self.containerView.y = IS_IPHONE_5 ? 100 : 60;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
             self.txtUsername.alpha = 1;
             self.getCollageButton.alpha = 1;
         }];
    }];
}

- (void)updateUI
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)updateFrame
{
    self.getCollageButton.centerX = self.txtUsername.center.x;
    self.getCollageButton.y = self.txtUsername.y + self.txtUsername.height + 20;
}

- (void)createObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenReceivedNotification:) name:TOKEN_RECEIVED_NOTIFICATION object:nil];
}

- (void)createGetures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Notifications handlers

- (void)tokenReceivedNotification:(NSNotification *)note
{
    self.token = note.object;

    if(self.token.length)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:TOKEN_KEY];
        [InetProvider getUserIdByName:self.txtUsername.text delegate:self];
        [SVProgressHUD showWithStatus:@"Загрузка фото..." maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Токен пуст" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

#pragma mark - Actions

- (IBAction)pressGetCollageBtn:(id)sender
{
    if(!self.txtUsername.text.length)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Пожалуйста, введите имя пользователя" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    [self.txtUsername resignFirstResponder];
    if(!self.token)
    {
        AuthViewController *authViewController = [[AuthViewController alloc] init];
        [self.navigationController pushViewController:authViewController animated:YES];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Загрузка фото..." maskType:SVProgressHUDMaskTypeBlack];
        [InetProvider getUserIdByName:self.txtUsername.text delegate:self];
    }
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - InetProvider delegate

- (void)getUserIdByNameSuccess:(id)json
{
    NSArray *jsonData = [json objectForKey:@"data"];

    if(jsonData.count)
    {
        NSString *userId = [[jsonData objectAtIndex:0] objectForKey:@"id"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USERID_KEY];
        [InetProvider getUserPhotoById:userId delegate:self];
    }
    else
    {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:nil message:@"Такого пользователя не существует" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)getUserIdByNameFailedWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [[[UIAlertView alloc] initWithTitle:nil message:@"Сервер не отвечает либо такого пользователя не существует" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)getUserPhotoSuccess:(id)json
{
    [SVProgressHUD dismiss];
    
    NSArray *jsonData = [json objectForKey:@"data"];
    if(jsonData.count)
    {
        NSMutableArray *imageUrlsArray = [NSMutableArray array];
        NSMutableArray *imageInfoArray = [NSMutableArray array];

        for(NSDictionary *dict in jsonData)
        {
            NSDictionary *infoDict = @{@"like_count": dict[@"likes"][@"count"],
                                       @"image_url" : dict[@"images"][@"low_resolution"][@"url"]};
            [imageInfoArray addObject:infoDict];
        }
        
        // Sorting photo by likes count
        
        [imageInfoArray sortUsingComparator:^NSComparisonResult(NSDictionary * dict1, NSDictionary *dict2) {
            if([dict1[@"like_count"] longValue] > [dict2[@"like_count"] longValue])
                return NSOrderedAscending;
            else if ([dict1[@"like_count"] longValue] < [dict2[@"like_count"] longValue])
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
        
        for(NSDictionary *dict in imageInfoArray)
            [imageUrlsArray addObject:dict[@"image_url"]];
        
        PhotoPickerViewController *pickerViewController = [[PhotoPickerViewController alloc] initWithImageUrlsArray:imageUrlsArray];
        
         [SVProgressHUD dismiss];
        [self.navigationController pushViewController:pickerViewController animated:YES];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"У этого пользователя нет фотографий" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)getUserPhotoFailedWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [[[UIAlertView alloc] initWithTitle:nil message:@"Пользователь закрыл доступ к своим фото" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
