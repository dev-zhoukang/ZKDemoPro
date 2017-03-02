//
//  ZKTimelineCommentCell.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/28.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKTimelineCommentCellLayout;

@interface ZKTimelineCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)updateWithLayout:(ZKTimelineCommentCellLayout *)layout;

@end
