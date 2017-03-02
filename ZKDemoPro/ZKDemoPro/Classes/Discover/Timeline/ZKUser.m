//
//  ZKUser.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/23.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKUser.h"

@implementation ZKUser

+ (NSDictionary *)propertyMapper {
    return @{
             @"avatarStr": @"avatar",
             @"nickName": @"nickname",
             @"isAuth": @"is_auth",
             };
}

@end
