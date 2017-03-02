//
//  USTimelineCommentCell.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/28.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class USTimelineCommentCellLayout;

@interface USTimelineCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)updateWithLayout:(USTimelineCommentCellLayout *)layout;

@end
