//
//  USImageLayoutView.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class USTimeline;

@interface USImageLayoutView : UIView

// 注意: 当多张图片的时候, imageSizeStr 传 nil
+ (CGFloat)heightWithImageCount:(NSUInteger)imageCount maxWidth:(CGFloat)maxWidth singleImgSizeStr:(NSString *)imgSizeStr;

- (void)setupWithTimelineModel:(USTimeline *)timelineModel;

@end
