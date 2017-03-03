//
//  USTimeline.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKTimeline.h"

@implementation ZKTimeline

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"contentText": @"content",
             @"imageUrls": @"file_name",
             @"sendTime": @"send_time",
             @"imgSize": @"img_size",
             @"fromUser": @"user_info"
             };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    
    NSMutableArray <ZKComment *> *tempArray = [[NSMutableArray alloc] init];
    for (NSArray *itemArray in dic[@"comment"]) {
        ZKComment *comment = [ZKComment modelWithDictionary:itemArray.firstObject];
        [tempArray addObject:comment];
    }
    _comments = tempArray.copy;
    return true;
}

@end
