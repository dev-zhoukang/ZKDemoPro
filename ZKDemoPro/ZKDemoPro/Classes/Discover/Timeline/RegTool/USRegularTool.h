//
//  USRegularTool.h
//  MCFriends
//
//  Created by ZK on 16/9/8.
//  Copyright © 2016年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USRegularTool : NSObject

+ (NSMutableAttributedString *)matchAttributedText:(NSMutableAttributedString *)attributedString;

/** 将 string 匹配正则, 高亮显示 highlightColor:可定制高亮文字颜色 不设置则默认仿微信蓝 */
+ (NSMutableAttributedString *)matchAttributedText:(NSMutableAttributedString *)attributedString
                                    highlightColor:(UIColor *)highlightColor;

/** 网址正则 如: www.hoolai.com */
+ (NSRegularExpression *)regularWebUrl;

/** 手机号码正则 如: 18613375661 */
+ (NSRegularExpression *)regularMobileNumber;

/** 座机正则 如: 76547623 */
+ (NSRegularExpression *)regularPhoneNumber;

/** 表情正则 如: [害羞] */
+ (NSRegularExpression *)regularEmotion;

//-------处理点击电话等高亮文字点击回调-------

/*! 处理点击手机号码 电话号码 网址链接的文字事件点击 */
+ (void)handleClickRegularTextWithInfo:(NSDictionary *)info;

/*! 单个处理点击事件 */
+ (void)handleWebUrl:(NSString *)webUrl;
+ (void)handleTelPhone:(NSString *)telString;

@end

#pragma mark - ConstString

extern NSString *const kWebUrlLink;  // 网址链接
extern NSString *const kTelNumber;   // 电话号码
extern NSString *const kMobileNumber;// 手机号码
