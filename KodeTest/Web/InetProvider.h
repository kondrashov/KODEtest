//
//  InetProvider.h
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

#define BASE_URL @"https://api.instagram.com/"

@protocol InetProviderDelegate <NSObject>

@optional

- (void)getUserIdByNameSuccess:(id)json;
- (void)getUserIdByNameFailedWithError:(NSError *)error;

- (void)getUserPhotoSuccess:(id)json;
- (void)getUserPhotoFailedWithError:(NSError *)error;

@end

@interface InetProvider : NSObject

+ (void)getUserIdByName:(NSString *)userName delegate:(id<InetProviderDelegate>)delegate;
+ (void)getUserPhotoById:(NSString *)userId delegate:(id<InetProviderDelegate>)delegate;

@end
