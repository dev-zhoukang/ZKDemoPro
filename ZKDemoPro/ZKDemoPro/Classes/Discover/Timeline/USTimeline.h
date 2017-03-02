//
//  USTimeline.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USUser.h"
#import "USComment.h"

@interface USTimeline : DBObject

@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, copy) NSString *imageUrls;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, strong) USUser *fromUser;
@property (nonatomic, copy) NSString *imgSize;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) NSArray <USComment *> *comments;

@end
