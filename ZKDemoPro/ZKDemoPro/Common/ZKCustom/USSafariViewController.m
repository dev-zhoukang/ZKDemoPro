//
//  USSafariViewController.m
//  MCFriends
//
//  Created by ZK on 14-5-16.
//  Copyright (c) 2014年 ZK. All rights reserved.
//

#import "USSafariViewController.h"
#import "WebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

@interface USSafariViewController () <WKNavigationDelegate>
{
    id _bridge;
    
    NSString *_shareUrl;
    NSString *_shareTitle;
    NSString *_shareIcon;
}

@property (weak, nonatomic) WKWebView *wkWebView;
@property (weak, nonatomic) UIWebView *uiWebView;
@property (weak, nonatomic) CALayer *progresslayer;

@property (nonatomic, copy) WVJBResponseCallback shareCallback;
@property (nonatomic, copy) NSString *shareID;

@end

@implementation USSafariViewController

+ (instancetype)initWithUrl:(NSString *)url
{
    return [self initWithTitle:@"" url:url];
}

+ (instancetype)initWithTitle:(NSString *)title url:(NSString *)url
{
    USSafariViewController *safariVC = [USSafariViewController new];
    safariVC.url = url;
    safariVC.title = title;
    return safariVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    [self setNavigationBackButtonDefault];
    
    if (!_url || !_url.length) {
        return;
    }
    
    //加载本地文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_url]) {
        [self startLoadURL:[NSURL fileURLWithPath:_url]];
        return;
    }
    
    if (![_url hasPrefix:@"http"]) {
        _url = [NSString stringWithFormat:@"http://%@",_url];
    }
    NSURL *urlObj = [NSURL URLWithString:_url];
    
#ifdef DEBUG
#else
    if (![urlObj.host hasSuffix:AppHostSuffix]) {
        [self startLoadURL:urlObj];
        return;
    }
#endif
    
    [self setupWebViewJavascriptBridge];
    
    [self startLoadURL:urlObj];
}

- (void)navigationBackButtonAction:(UIButton *)sender
{
    if (self.wkWebView && [self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        [super navigationBackButtonAction:sender];
    }
}

- (void)setupViews
{
    if (NSClassFromString(@"WKWebView")) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:webView atIndex:0];
        [webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(topInset, 0, 0, 0)];
        
        webView.navigationDelegate = self;
        
        //添加属性监听
        [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        //进度条
        UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, topInset-2.5, SCREEN_WIDTH, 2.5)];
        progress.backgroundColor = [UIColor clearColor];
        [self.view addSubview:progress];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 2.5);
        layer.backgroundColor = HexColor(0x4f8e30).CGColor;
        [progress.layer addSublayer:layer];
        
        self.wkWebView = webView;
        self.progresslayer = layer;
    }
    else {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view insertSubview:webView atIndex:0];
        [webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(topInset, 0, 0, 0)];
        
        self.uiWebView = webView;
    }
}

- (void)startLoadURL:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    if (self.wkWebView) {
        [self.wkWebView loadRequest:request];
    }
    else {
        [self.uiWebView loadRequest:request];
        [self.uiWebView setScalesPageToFit:true];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 2.5);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 2.5);
            });
        }
    }
    else if ([keyPath isEqualToString:@"title"]) {
        if (!self.title || !self.title.length) {
            self.title = self.wkWebView.title;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)setupWebViewJavascriptBridge
{
    @weakify(self)
    //只有官方链接才提供桥接功能
    if (self.wkWebView) {
        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    } else {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.uiWebView];
    }
    
    [_bridge setWebViewDelegate:self];
    
//    [_bridge registerHandler:@"UserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
//        responseCallback(_loginUser?[_loginUser dictionary]:@{});
//    }];
    [_bridge registerHandler:@"DeviceInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback([UIDevice BIData]);
    }];
    [_bridge registerHandler:@"PushView" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIViewController *viewController = [[weak_self class] viewControllerWithInfo:data];
        if (viewController) {
            [weak_self.navigationController pushViewController:viewController animated:YES];
            responseCallback?responseCallback(@{@"success":@(YES)}):nil;
        } else {
            responseCallback?responseCallback(@{@"success":@(NO)}):nil;
        }
    }];
    [_bridge registerHandler:@"PopView" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weak_self.navigationController popViewControllerAnimated:true];
        responseCallback?responseCallback(@{@"success":@(YES)}):nil;
    }];
    [_bridge registerHandler:@"CallInterface" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [NetManager postRequestToUrl:data[@"url"] params:data[@"params"] complete:^(BOOL successed, HttpResponse *response) {
                responseCallback?responseCallback(@{@"success":@(successed),@"result":(response.payload?:@{})}):nil;
            }];
        }
    }];
//    [_bridge registerHandler:@"SetUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
//        if (data && [data isKindOfClass:[NSDictionary class]] && _loginUser) {
//            [_loginUser setValuesForKeysWithDictionary:data];
//            [_loginUser synchronize];
//            
//            responseCallback?responseCallback(@{@"success":@(YES),@"info":[_loginUser dictionary]}):nil;
//        }
//        else{
//            responseCallback?responseCallback(@{@"success":@(NO)}):nil;
//        }
//    }];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    DLOG(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    DLOG(@"webViewDidFinishLoad");
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.title || !self.title.length) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}


/**
 通过指定信息获取某个 ViewController
 
 Example:
    info:
    {
        "class": "USInstallmentsViewController",
        "payload": {
            "hospital": {
                "class": "DBHospital",
                "value": {
                    "ID": "1314",
                    "name":"神奇医院",
                    "address": "北京市朝阳区国家会议中心",
                    "contact": "010-23451234",
                    "installments": [
                         {
                             "ID": "121",
                             "number": 3,
                             "rate": 1085
                         }
                     ]
                }
            },
            "loanAmount": {
                "value": 8866
            }
        }
    }
*/
+ (UIViewController *)viewControllerWithInfo:(id)info
{
    Class class;
    NSDictionary *payload;
    if (info && [info isKindOfClass:[NSString class]]) {
        class = NSClassFromString(info);
    }
    else if (info && [info isKindOfClass:[NSDictionary class]]) {
        class = NSClassFromString(info[@"class"]);
        payload = info[@"payload"];
    }
    
    if (!class) return nil;
    
    UIViewController *viewController;
    if([[NSBundle mainBundle] pathForResource:NSStringFromClass(class) ofType:@"nib"] != nil) {
        viewController = [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
    } else {
        viewController = [[class alloc] init];
    }
    
    [payload enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        objc_property_t property = class_getProperty(class, [key UTF8String]);
        if (property) {
            Class iclass = NSClassFromString(obj[@"class"]);
            id value = obj[@"value"];
            if (class) {
                DBObject *item = [[iclass alloc] init];
                if ([item isKindOfClass:[DBObject class]]) {
                    [item populateWithObject:value];
                }
                else if ([value isKindOfClass:[NSDictionary class]]) {
                    [value enumerateKeysAndObjectsUsingBlock:^(id key2, id obj2, BOOL * stop) {
                        [item setValue:obj2 forKey:key2];
                    }];
                }
                value = item;
            }
            [viewController setValue:value forKey:key];
        }
    }];
    return viewController;
}

@end
