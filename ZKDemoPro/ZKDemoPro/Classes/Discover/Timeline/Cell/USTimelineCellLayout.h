//
//  USTimelineCellLayout.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USTimeline.h"

@interface USTimelineCellLayout : NSObject

@property (nonatomic, strong, readonly) USTimeline *timelineModel;
@property (nonatomic, strong, readonly) YYTextLayout *textLayout;

@property (nonatomic, assign, readonly) CGFloat totalHeight;
@property (nonatomic, assign, readonly) CGFloat nickTopMargin;
@property (nonatomic, assign, readonly) CGFloat nickHeight;
@property (nonatomic, assign, readonly) CGFloat contentTextHeight;

@property (nonatomic, assign, readonly) CGFloat contentImageTopBottomMargin;
@property (nonatomic, assign, readonly) CGFloat contentImageHeight;
@property (nonatomic, assign, readonly) CGFloat optionBarViewHeight;
@property (nonatomic, assign, readonly) CGFloat commentViewHeight;

- (instancetype)initWithTimelineModel:(USTimeline *)model;

@end
