//
//  ViewController.m
//  yzloan
//
//  Created by 苏文彬 on 2018/12/18.
//  Copyright © 2018年 yinzhong. All rights reserved.
//

#import "ViewController.h"
#import "CustomNavigationView.h"
#import "WebViewJavascriptBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "NSUtil.h"
#import "YZWebViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) WKWebView *wkWebView;

@property(nonatomic,strong) NSString *currentURL;

@property(nonatomic,strong) CustomNavigationView *navigationView;
@property WebViewJavascriptBridge* bridge;

#define UIMainScreen [UIScreen mainScreen].bounds

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewdidload");
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewwillappear");
    if (_bridge) { return; }
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"window.app.getInfo()" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"JS Bridge called: %@", data);
        /* app当前版本号 */
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = infoDict[@"CFBundleShortVersionString"];
        
        NSString *uuid = [NSUtil getUUID];
        NSString *client = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        
        NSDictionary *dictCallBack = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"deviceId",client,@"client",currentVersion,@"versonName",@"",@"channel", nil];
        
        
        responseCallback(dictCallBack);
    }];
    
    [_bridge registerHandler:@"window.app.toThreeProduct()" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [self openThreeProduct:data];
    }];
    
//    NSString *urlString = @"http://192.168.101.3:8080";
    
    [self loadRequest];
    
//    [self loadExamplePage];
}

- (void)loadRequest
{
    NSString *urlString = @"http://app.yioucash.com/test/index.html";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadExamplePage {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadHTMLString:appHtml baseURL:baseURL];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)webView {
    if (!_webView) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        _webView = [[UIWebView alloc ]initWithFrame:CGRectMake(0, statusRect.size.height, self.view.bounds.size.width, self.view.bounds.size.height - statusRect.size.height)];
        [self.view addSubview:_webView];
    }
    return _webView;
}

//屏蔽了JS，需要打开
-(WKWebView *)wkWebView
{
    if(!_wkWebView){
//        CGFloat statusRectHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(UIMainScreen.origin.x,UIMainScreen.origin.y,UIMainScreen.size.width,UIMainScreen.size.height)];
//        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.navigationView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationView.bounds.size.height)];
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}


#pragma UIWebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSURL *url = [request URL];
//    NSString *requestString = [[request URL] absoluteString];
//    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:url];
//    NSEnumerator *enumerator = [cookies objectEnumerator];
//    NSHTTPCookie *cookie;
//    while (cookie = [enumerator nextObject]) {
//        NSLog(@"COOKIE{name: %@, value: %@,domain:%@}", [cookie name], [cookie value],[cookie domain]);
//    }
//    
//    NSArray *urlComps = [requestString componentsSeparatedByString:@"://"];
    
//    
//    return YES;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    _currentURL = webView.request.URL.absoluteString;
    NSLog(@"%@",_currentURL);
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


#pragma mark Private Method

//打开第三方页面
-(void)openThreeProduct:(id)data
{
    YZWebViewViewController *yzWebViewController = [[YZWebViewViewController alloc] initWithDict:data];
    [self presentViewController:yzWebViewController animated:YES completion:nil];
}


@end
