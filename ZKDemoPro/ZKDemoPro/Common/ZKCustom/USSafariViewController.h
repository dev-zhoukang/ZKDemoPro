//
//  USSafariViewController.h
//  MCFriends
//
//  Created by ZK on 14-5-16.
//  Copyright (c) 2014年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USSafariViewController : ZKViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSString *url;

+ (instancetype)initWithUrl:(NSString *)url;
+ (instancetype)initWithTitle:(NSString *)title url:(NSString *)url;

@end
