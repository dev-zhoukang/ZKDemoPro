//  Created by ZK on 16/7/19.
//  Copyright © 2016年 ZK. All rights reserved.

#import "SDWebImageManager+ZK.h"

@implementation SDWebImageManager (ZK)
+ (void)downloadWithURL:(NSURL *)url
{
    [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
}
@end
