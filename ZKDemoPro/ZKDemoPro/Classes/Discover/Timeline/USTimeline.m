//
//  USTimeline.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "USTimeline.h"

@implementation USTimeline

+ (NSDictionary *)propertyMapper {
    return @{
             @"contentText": @"content",
             @"imageUrls": @"file_name",
             @"sendTime": @"send_time",
             @"fromUser": @"user_info",
             @"imgSize": @"img_size",
             };
}

+ (NSDictionary *)propertyGenericClass {
    return @{
             @"fromUser": [USUser class]
             };
}

- (void)populateValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"comment"]) {
        if (![value isKindOfClass:[NSArray class]]) return;
        NSMutableArray <USComment *> *tempArray = [[NSMutableArray alloc] init];
        for (NSArray *itemArray in value) {
            USComment *comment = [USComment new];
            [comment populateWithObject:itemArray.firstObject];
            [tempArray addObject:comment];
        }
        [super populateValue:tempArray forKey:@"comments"];
    }
    else {
        [super populateValue:value forKey:key];
    }
}

@end
