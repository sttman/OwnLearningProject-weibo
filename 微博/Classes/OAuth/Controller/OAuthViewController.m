//
//  OAuthViewController.m
//  微博
//
//  Created by mac on 15-7-30.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "OAuthViewController.h"
#import "HttpTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "MBProgressHUD+NJ.h"
#import "UIWindow+Extension.h"
// 账号信息
NSString * const AppKey = @"3547256664";
NSString * const RedirectURI = @"http://www.baidu.com";
NSString * const AppSecret = @"44e4dcdbac50786297240248276639fe";
@interface OAuthViewController () <UIWebViewDelegate>

@end

@implementation OAuthViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.创建一个webView
    UIWebView * webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    // 2.用webView加载登入界面(新浪提供)
    // 请求地址：https://api.weibo.com/oauth2/authorize
    /* 请求参数：
     client_id	true	string	申请应用时分配的AppKey。
     redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
     */
    NSString * urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",AppKey,RedirectURI];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
#pragma mark - webView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessage:@"正在加载..."];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUD];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 1.获取url
    NSString * url = request.URL.absoluteString;
    
    // 2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {// 是回调地址
        // 截取code=后面的参数值
        NSUInteger fromIndex = range.location + range.length;
        NSString * code = [url substringFromIndex:fromIndex];
        
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载回调地址
        return NO;
    }
    
    return YES;
}
/**
 *  利用code（授权成功后的request token）换取一个accessToken
 *
 *  @param code 授权成功后的request token
 */
- (void)accessTokenWithCode:(NSString *)code{
    /*
     URL：https://api.weibo.com/oauth2/access_token
     
     请求参数：
     client_id：申请应用时分配的AppKey
     client_secret：申请应用时分配的AppSecret
     grant_type：使用authorization_code
     redirect_uri：授权成功后的回调地址
     code：授权成功后返回的code
     */
    // 1.请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = AppKey;
    params[@"client_secret"] = AppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = RedirectURI;
    params[@"code"] = code;
    
    // 3.发送请求
    [HttpTool post:@"https://api.weibo.com/oauth2/access_token" params:params success:^(id json){
        [MBProgressHUD hideHUD];
        
        // 将返回的账号字典数据，存进沙盒
        Account * account = [Account accountWithDict:json];
        
        // 存储账号信息
        [AccountTool saveAccount:account];
        
        // 切换窗口的根控制器
        [UIWindow switchRootViewController];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUD];
    }];
//    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
//
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUD];
//        NSLog(@"请求失败-%@", error);
//    }];
}
@end
