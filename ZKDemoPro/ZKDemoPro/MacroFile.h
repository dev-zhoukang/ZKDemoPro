//
//  MacroFile.h
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#ifndef MacroFile_h
#define MacroFile_h

#define IS_IPAD              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA            ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT        [[UIScreen mainScreen] bounds].size.height
#define SCREEN_MAX_LENGTH    (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH    (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IS_IPHONE_4          (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5          (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6          (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P         (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define ScreenScale         [UIScreen mainScreen].scale
#define userDefaults        [NSUserDefaults standardUserDefaults]
#define KeyWindow           [[[UIApplication sharedApplication] delegate] window]
#define WindowZoomScale     (SCREEN_WIDTH/320.f)
#define UniversalZoomScale  (MIN(1.8, WindowZoomScale))  //适配iPad

#define _applicationContext [ApplicationContext sharedContext]

FOUNDATION_EXPORT NSString *NSDocumentPath();
FOUNDATION_EXPORT NSString *NSResourcePath();
FOUNDATION_EXPORT UIImage *UIImageNamed(NSString *imageName);

FOUNDATION_EXPORT UIColor *HexColor(unsigned int hexValue);
FOUNDATION_EXPORT UIColor *RGBCOLOR(CGFloat read, CGFloat green, CGFloat blue);
FOUNDATION_EXPORT UIColor *RGBACOLOR(CGFloat read, CGFloat green, CGFloat blue, CGFloat alpha);

FOUNDATION_EXPORT BOOL SystemVersionEqualTo(NSString *version);
FOUNDATION_EXPORT BOOL SystemVersionGreaterThan(NSString *version);
FOUNDATION_EXPORT BOOL SystemVersionGreaterThanOrEqualTo(NSString *version);
FOUNDATION_EXPORT BOOL SystemVersionLessThan(NSString *version);
FOUNDATION_EXPORT BOOL SystemVersionLessThanOrEqualTo(NSString *version);

FOUNDATION_EXPORT CGFloat MainScale();

#define XcodeBundleVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define ZKColor(r,g,b,a)        [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define ZKRandomColor           ZKColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1)

#define _loginUser          [AuthData loginUser]
#define _applicationContext [ApplicationContext sharedContext]

#ifdef DEBUG
#define USTakeTimeCountBegin       NSDate *takeTimeCountDate = [NSDate date];
#define USTakeTimeCountEnd(flag)   DLOG(@"%@耗时 %.4f 秒",flag,[[NSDate date] timeIntervalSinceDate:takeTimeCountDate]);
#else
#define USTakeTimeCountBegin       ((void)0);
#define USTakeTimeCountEnd(flag)   ((void)0);
#endif

/**
 * Fixes colors in Storyboard and XIB files that are using the wrong colorspace
 *
 * find . \( -name "*.xib" -or -name "*.storyboard" \) -print0 | xargs -0 sed -i '' -e 's/colorSpace="custom" customColorSpace="sRGB"/colorSpace="calibratedRGB"/g'
 */

//获取随机数
#define Random(from, to) (int)(from + (arc4random() % (to - from + 1))) //+1,result is [from to]; else is [from, to)!!!!!!!
#define ARC4RANDOM_MAX (0x100000000 * 20)

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

// 去除方法调用警告
#define ZKPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0);

//微信
#define kAppID_WeiXin                          @".."

//高德
#define kAppKey_Gaode                          @".."

//友盟SDK
#define kAppKey_YouMeng                        @".."

//用户反馈
#define kAppKey_ALFeed                         @".."

//Bugly
#define kAppId_Bugly                           @".."


//到app store 评分
#define AppInfoURL     @".."
#define AppHtmlURL     @".."

FOUNDATION_EXPORT CGFloat AutoFitFontSize(CGFloat basePointSize);
FOUNDATION_EXPORT CGFloat AutoFitCellRowHeight(CGFloat baseRowHeight, NSInteger textLineNumber);

//Cell默认字体和行间距
#define CELL_ROW_HEIGHT                    AutoFitCellRowHeight(45, 1)
#define CELL_TEXT_FONT                     [UIFont systemFontOfSize:AutoFitFontSize(13)]

//页面默认背景色
#define VIEW_BG_COLOR                      HexColor(0xF2F2F5)

//缩略图宽高的最大像素值
#define ThumbMaxPixelSize                  2000.f

//缩略图转化为JPG图片时的压缩质量
#define ThumbCompressionQuality            0.8

//通用色调的色值
#define KG_TINT_COLOR                       HexColor(0x4f8e30)       /* 深绿色 */
#define KG_TINT_HIGHLIGHT_COLOR             HexColor(0x467e2a)       /* 深绿色，高亮效果 */
#define KGray_TINT_COLOR                    HexColor(0x535353)       /* 深灰色 */
#define KGray_TINT_HIGHLIGHT_COLOR          HexColor(0x000000)       /* 深灰色，高亮效果 */
#define KY_TINT_COLOR                       HexColor(0xf9d942)       /* 浅黄色 */
#define KY_TINT_HIGHLIGHT_COLOR             HexColor(0xf3d33d)       /* 浅黄色，高亮效果 */
#define GlobalGreenColor       RGBCOLOR(31.f, 185.f, 34.f)
#define GlobalBGColor          RGBCOLOR(239.f, 239.f, 245.f)
#define GlobalChatBGColor      RGBCOLOR(230.f, 230.f, 230.f)
#define ThemColor              HexColor(0x096096)
#define GlobalColor            HexColor(0x1abc9c) // 全局墨绿色
#define GlobalColorHL          HexColor(0x17a085) // 深绿

#define NetManager                          [HttpManager defaultManager]

typedef NS_ENUM(NSInteger, GENDER) {
    GENDER_WOMEN = 0,
    GENDER_MAN,
    GENDER_NONE
};

#endif /* MacroFile_h */
