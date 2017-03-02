//
//  USLogger.h
//  HappyIn
//
//  Created by marujun on 16/5/23.
//  Copyright © 2016年 MaRuJun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LOG_LEVEL_ERROR    = 1,
    LOG_LEVEL_WARNING  = 2,
    LOG_LEVEL_INFO     = 3,
    LOG_LEVEL_DEBUG    = 4
} LogLevel;

#define DEBUG_ENV       [USLogger isDebug_env]

#define WLOG(fmt,...)   [USLogger logWithLevel:LOG_LEVEL_WARNING file:__FILE__ line:__LINE__ format:(fmt), ##__VA_ARGS__]
#define ELOG(fmt,...)   [USLogger logWithLevel:LOG_LEVEL_ERROR   file:__FILE__ line:__LINE__ format:(fmt), ##__VA_ARGS__]
#define FLOG(fmt,...)   [USLogger logWithLevel:LOG_LEVEL_INFO    file:__FILE__ line:__LINE__ format:(fmt), ##__VA_ARGS__]
#define DLOG(fmt,...)   [USLogger logWithLevel:LOG_LEVEL_DEBUG   file:__FILE__ line:__LINE__ format:(fmt), ##__VA_ARGS__]

//#ifdef DEBUG
//#define NSLog(fmt,...)  DLOG(fmt,## __VA_ARGS__)
//#else
//#define NSLog(fmt,...)
//#endif

@interface USLogger : NSObject

/*!
 @method
 @param level 日志级别
 @brief 设置日志级别
 */
+ (void)setLogLevel:(LogLevel)level;


/*!
 @method
 @param level  日志级别
 @param file   文件名  可使用宏：__FILE__
 @param line   行数   可使用宏：__LINE__
 @brief 打印日志
 */
+ (void)logWithLevel:(LogLevel)level file:(const char *)file line:(int)line format:(NSString *)format, ...;

/*!
 @method
 @brief 是否为debug环境
 */
+ (BOOL)isDebug_env;

@end
