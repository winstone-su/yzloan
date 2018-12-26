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
    
    [self.view addSubview:self.webView];
    NSString *urlString = [self.dataDict objectForKey:@"productUrl"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //获取导航栏的rect
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
//    [self.view addSubview:self.wkWebView];
//    self.wkWebView.UIDelegate = self;
//    self.wkWebView.navigationDelegate  = self;
//    [self.wkWebView loadRequest:request];
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
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

@end
