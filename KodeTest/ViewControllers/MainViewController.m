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
#import "InetProvider.h"

@interface MainViewController () <InetProviderDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *token;

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createObservers];
    [self createGetures];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Methods

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
    [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:TOKEN_KEY];
    [InetProvider getUserIdByName:self.txtUsername.text delegate:self];
}

#pragma mark - Actions

- (IBAction)pressGetCollageBtn:(id)sender
{
    if(!self.txtUsername.text.length)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Пожалуйста, введите имя пользователя" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if(!self.token)
    {
        AuthViewController *authViewController = [[AuthViewController alloc] init];
        [self presentViewController:authViewController animated:YES completion:nil];
    }
    else
    {
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
        [[[UIAlertView alloc] initWithTitle:nil message:@"Такого пользователя не существует" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)getUserIdByNameFailedWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Сервер не отвечает либо такого пользователя не существует" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)getUserPhotoSuccess:(id)json
{
    NSArray *jsonData = [json objectForKey:@"data"];

    if(jsonData.count)
    {
        NSMutableArray *imageUrlsArray = [NSMutableArray array];
        
        for(NSDictionary *dict in jsonData)
            [imageUrlsArray addObject:dict[@"images"][@"low_resolution"][@"url"]];
        
        CollageViewController *collageViewController = [[CollageViewController alloc] initWithImageUrlsArray:imageUrlsArray];
        [self.navigationController pushViewController:collageViewController animated:YES];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"У этого пользователя нет фотографий" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)getUserPhotoFailedWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Пользователь закрыл доступ к своим фото" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
