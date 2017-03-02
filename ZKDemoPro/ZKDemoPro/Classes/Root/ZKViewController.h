//
//  ZKViewController.h
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Navigation.h"

@interface ZKNavigationBar : UINavigationBar

@end

// ===

@interface ZKViewController : UIViewController

@property (nonatomic, strong) ZKNavigationBar *navigationBar;
@property (nonatomic, strong) UINavigationItem *myNavigationItem;

@end

extern const CGFloat topInset; // 导航栏高度
