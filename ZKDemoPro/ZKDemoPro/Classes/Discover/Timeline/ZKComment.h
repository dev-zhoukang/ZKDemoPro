//
//  ZKComment.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/27.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKComment : DBObject

@property (nonatomic, copy) NSString *avatarStr;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *fromNick;
@property (nonatomic, copy) NSString *fromUid;
@property (nonatomic, copy) NSString *toNick;
@property (nonatomic, copy) NSString *toUid;
@property (nonatomic, copy) NSString *did; // 动态 ID
@property (nonatomic, copy) NSString *cid; // 评论 ID

@end
