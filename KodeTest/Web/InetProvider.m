//
//  InetProvider.m
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "InetProvider.h"
#import "AFNetworking.h"

#define BASE_URL @"https://api.instagram.com/"

@implementation InetProvider

+ (void)getUserIdByName:(NSString *)userName delegate:(id<InetProviderDelegate>)delegate
{
    NSString *url = [NSString stringWithFormat:@"%@v1/users/search?q=%@&count=1&access_token=%@", BASE_URL ,[userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        
        if([delegate respondsToSelector:@selector(getUserIdByNameSuccess:)])
            [delegate getUserIdByNameSuccess:responseObject];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
        
        if([delegate respondsToSelector:@selector(getUserIdByNameFailedWithError:)])
            [delegate getUserIdByNameFailedWithError:error];
    }];
}

+ (void)getUserPhotoById:(NSString *)userId delegate:(id<InetProviderDelegate>)delegate
{
    NSString *url = [NSString stringWithFormat:@"%@v1/users/%@/media/recent?access_token=%@", BASE_URL ,userId, [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         if([delegate respondsToSelector:@selector(getUserPhotoSuccess:)])
             [delegate getUserPhotoSuccess:responseObject];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         if([delegate respondsToSelector:@selector(getUserPhotoFailedWithError:)])
             [delegate getUserPhotoFailedWithError:error];
     }];
    
}



@end
