//
//  ZKUser.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/23.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKUser : DBObject

@property (nonatomic, copy) NSString *avatarStr;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *isAuth;
@property (nonatomic, copy) NSString *sex;

@end
