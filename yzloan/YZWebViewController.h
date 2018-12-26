//
//  YZWebViewViewController.h
//  yzloanNew
//
//  Created by 苏文彬 on 2018/12/22.
//  Copyright © 2018年 yinzhong. All rights reserved.
//

#import "ViewController.h"

@interface YZWebViewViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

-(id)initWithDict:(NSDictionary *)dict;

@end
