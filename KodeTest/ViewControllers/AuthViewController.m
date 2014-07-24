//
//  AuthViewController.m
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation AuthViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.webView = [UIWebView new];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;

        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.color = [UIColor blackColor];
        self.activityIndicator.hidesWhenStopped = YES;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    self.webView.frame = self.view.bounds;
    self.activityIndicator.center = self.webView.center;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    NSString *scopeStr = @"scope=likes+comments+relationships";
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&display=touch&%@&redirect_uri=%@&response_type=token", INSTAGRAM_CLIENT_ID, scopeStr, INSTAGRAM_REDIRECT_URI];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *responseString = request.URL.absoluteString;
    
    if([responseString rangeOfString:@"access_token="].location != NSNotFound)
    {
        NSString *token = [[responseString componentsSeparatedByString:@"access_token="] objectAtIndex:1];
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_RECEIVED_NOTIFICATION object:token];
        }];
        return NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
}

@end
