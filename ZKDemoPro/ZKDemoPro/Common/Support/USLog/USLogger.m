//
//  USLogger.m
//  HappyIn
//
//  Created by marujun on 16/5/23.
//  Copyright © 2016年 MaRuJun. All rights reserved.
//

#import "USLogger.h"
#include <execinfo.h>

@interface USLogger ()

@property (nonatomic, assign) BOOL debug;  //是否是debug模式，如果是debug模式则默认打印DEBUG级别日志，并且setLogLevel方法将失效
@property (nonatomic, assign) NSInteger logLevel;  //日志级别，默认LOG_LEVEL_DEBUG
@property (nonatomic, strong) NSDateFormatter *dateFormatter;  //日期格式化工具

@end

@implementation USLogger

+ (instancetype)defaultManager
{
    static dispatch_once_t pred = 0;
    __strong static id defaultMCLogManager = nil;
    dispatch_once( &pred, ^{
        defaultMCLogManager = [[self alloc] init];
    });
    return defaultMCLogManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _debug = true;
        _logLevel = LOG_LEVEL_DEBUG;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    return self;
}

+ (BOOL)isDebug_env
{
    return [[self defaultManager] debug];
}

+ (void)setLogLevel:(LogLevel)level
{
    if (![[self defaultManager] debug]) return;
    
    [[self defaultManager] setLogLevel:level];
}

+ (void)logWithLevel:(LogLevel)level file:(const char *)file line:(int)line format:(NSString *)format, ...
{
    if (![[self defaultManager] debug]) {
        va_list blargs;
        va_start(blargs, format);
        va_end(blargs);
        
        return;
    }

    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSString *levelString = @"VERBOBE";
    switch (level) {
        case LOG_LEVEL_DEBUG:
            levelString = @"DEBUG";
            break;
        case LOG_LEVEL_INFO:
            levelString = @"INFO";
            break;
        case LOG_LEVEL_WARNING:
            levelString = @"WARNING";
            break;
        case LOG_LEVEL_ERROR:
            levelString = @"ERROR";
            break;
    }
    
    NSString *log_str = nil;
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    
    if (isatty(STDOUT_FILENO)) {
        NSString *date_str = [[[self defaultManager] dateFormatter] stringFromDate:[NSDate date]];
        
        log_str = [NSString stringWithFormat:(@"%@ [%@][%@][%d] %@"), date_str, levelString, fileName, line, string];
    }
    
    if (!log_str) log_str = [NSString stringWithFormat:@"[%@][%@][%d] %@",levelString,fileName,line,string];
    
    if (isatty(STDOUT_FILENO)) {
        printf("%s\n", [log_str UTF8String]);
    }
    else {
        NSLog(@"%@",log_str); //使用系统的Log输出到device log 方便查看
    }
}

void InstallSignalHandler(void) {
    signal(SIGHUP, SignalHandler);
    signal(SIGINT, SignalHandler);
    signal(SIGQUIT, SignalHandler);
    
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

void InstallUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

static NSString * UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";

- (void)handleSignalException:(NSException *)exception
{
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    SignalExceptionHandler(exception);
    
    kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
}

NSString *CurrentFormatDateString() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

NSString *SignalNameWithNumber(int signal) {
    switch (signal) {
        case SIGHUP:
            return @"SIGHUP";
        case SIGINT:
            return @"SIGINT";
        case SIGQUIT:
            return @"SIGQUIT";
        case SIGABRT:
            return @"SIGABRT";
        case SIGILL:
            return @"SIGILL";
        case SIGSEGV:
            return @"SIGSEGV";
        case SIGFPE:
            return @"SIGFPE";
        case SIGBUS:
            return @"SIGBUS";
        case SIGPIPE:
            return @"SIGPIPE";
    }
    return @"UNKNOWN";
}

void SaveCrashException(NSString* crashString) {
    //每次启动【崩溃日志】只记录一次，NSSetUncaughtExceptionHandlerh会优先执行
    static BOOL hasSaved = NO;
    if (hasSaved) return;
    hasSaved = YES;
    
    //将crash日志保存到Document目录下
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *logFilePath = [documentPath stringByAppendingPathComponent:@"UncaughtException.log"];
    
    //把错误日志写到文件中
    if (![[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
        [crashString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    else {
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [outFile seekToEndOfFile];
        [outFile writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
        [outFile closeFile];
    }
}

//截取signal信息
void SignalHandler(int signal) {
    NSException *exception = [NSException exceptionWithName:@"UncaughtExceptionHandlerSignalExceptionName"
                                                     reason: SignalNameWithNumber(signal)
                                                   userInfo:@{UncaughtExceptionHandlerSignalKey: @(signal)}];
    
    [[USLogger defaultManager] performSelectorOnMainThread:@selector(handleSignalException:) withObject:exception waitUntilDone:YES];
}

void UncaughtExceptionHandler(NSException* exception) {
    //未捕获的Objective-C异常日志
    NSArray* symbols = [ exception callStackSymbols ]; // 异常发生时的调用栈
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; //将调用栈拼成输出日志的字符串
    for ( NSString* item in symbols ) {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *crashString = [NSString stringWithFormat:@"<- %@ -> Version: %@ [ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n\r\n",
                             CurrentFormatDateString(), version, [exception name], [exception reason], strSymbols];
    SaveCrashException(crashString);
}

void SignalExceptionHandler(NSException* exception) {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableString* strSymbols = [[ NSMutableString alloc ] init ]; //将调用栈拼成输出日志的字符串
    int i;
    for ( i = 6; i < frames; i++) {
        [ strSymbols appendString: [NSString stringWithUTF8String:strs[i]] ];
        [ strSymbols appendString: @"\r\n" ];
    }
    free(strs);
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *crashString = [NSString stringWithFormat:@"<- %@ -> Version: %@ [ %@ ]\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n\r\n",
                             CurrentFormatDateString(), version, [exception reason], strSymbols];
    SaveCrashException(crashString);
}

@end
