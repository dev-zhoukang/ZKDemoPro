//
//  ZKCommonItemCell.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKCommonItemCell.h"

@implementation ZKCommonItemCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentify = @"ZKCommonItemCell";
    ZKCommonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[ZKCommonItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    return cell;
}

@end
