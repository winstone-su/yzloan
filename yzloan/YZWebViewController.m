//
//  YZWebViewViewController.m
//  yzloanNew
//
//  Created by 苏文彬 on 2018/12/22.
//  Copyright © 2018年 yinzhong. All rights reserved.
//

#import "YZWebViewController.h"
#import "CustomNavigationView.h"
#import "CustomNavigationView.h"
@interface YZWebViewViewController ()


@property(nonatomic,strong) NSDictionary *dataDict;

@property(nonatomic,strong) CustomNavigationView *customerNavigationView;

@end

@implementation YZWebViewViewController

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.dataDict = dict;
    return self;
}

//-(CustomNavigationView *)customerNavigationView
//{
//    if(!_customerNavigationView){
//        _customerNavigationView = [[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
//    }
//
//    return _customerNavigationView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.customerNavigationView];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.customerNavigationView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.customerNavigationView.bounds.size.height)];
    
    NSString *title = [self.dataDict objectForKey:@"productName"];
    
    if([title isEqualToString:@""]){
        self.customerNavigationView.titleLabel.text = @"活动页面";
    }else{
        self.customerNavigationView.titleLabel.text = title;
    }
    
//    [self.view addSubview:self.webView];
    NSString *urlString = [self.dataDict objectForKey:@"productUrl"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //获取导航栏的rect
//    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    [self.view addSubview:self.wkWebView];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate  = self;
    [self.wkWebView loadRequest:request];
}

- (WKWebView *)wkWebView
{
    if(!_wkWebView){
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.customerNavigationView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.customerNavigationView.bounds.size.height)];
    }
    
    return _wkWebView;
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CustomNavigationView *)customerNavigationView
{
    if(!_customerNavigationView){
        _customerNavigationView = [[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        _customerNavigationView.titleLabel.text = @"活动页面";
        [_customerNavigationView.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _customerNavigationView;
}

-(void)backButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString  *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
//    if([title isEqualToString:@""]){
//        title = @"活动页面";
//    }
//    self.customerNavigationView.titleLabel.text= title;
}


/**
webView中弹出警告框时调用, 只能有一个按钮

@param webView webView
@param message 提示信息
@param frame 可用于区分哪个窗口调用的
@param completionHandler 警告框消失的时候调用, 回调给JS
*/
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

/** 对应js的confirm方法
 webView中弹出选择框时调用, 两个按钮
 
 @param webView webView description
 @param message 提示信息
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 确认框消失的时候调用, 回调给JS, 参数为选择结果: YES or NO
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"同意" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不同意" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/** 对应js的prompt方法
 webView中弹出输入框时调用, 两个按钮 和 一个输入框
 
 @param webView webView description
 @param prompt 提示信息
 @param defaultText 默认提示文本
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 输入框消失的时候调用, 回调给JS, 参数为输入的内容
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入";
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *tf = [alert.textFields firstObject];
        
        completionHandler(tf.text);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(defaultText);
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //  在发送请求之前，决定是否跳转
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = navigationAction.request.URL.absoluteString;
    if([urlString hasPrefix:@"itms-services://"]){
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil ];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 是否接收响应
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    // 在收到响应后，决定是否跳转和发送请求之前那个允许配套使用
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling ,nil);
}


@end
