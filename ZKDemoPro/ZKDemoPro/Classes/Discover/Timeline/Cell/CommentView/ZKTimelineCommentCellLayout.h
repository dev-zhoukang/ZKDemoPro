//
//  ZKTimelineCommentCellLayout.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/28.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKComment.h"

@interface ZKTimelineCommentCellLayout : NSObject

@property (nonatomic, assign, readonly) CGFloat totalHeight;
@property (nonatomic, assign, readonly) YYTextLayout *textLayout;

- (instancetype)initWithComment:(ZKComment *)comment;

@end

// === 

extern NSString *const kLinkNameKey_from;
extern NSString *const kLinkNameKey_to;
extern const CGFloat kCommentLineSpacing;
