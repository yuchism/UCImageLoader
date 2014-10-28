//
//  UIImageView+UCImageLoaderAdditions.m
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 21..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import "UIImageView+UCImageLoaderAdditions.h"

@implementation UIImageView(UCImageLoaderAdditions)

- (void) setImageURLString:(NSString *)urlString
{
    __block id sself = self;
    NSString *key = [NSString stringWithFormat:@"%p",self];
    
    [[UCImageLoader sharedInstance] loadImageWithURLString:urlString withKey:key complete:^(UIImage *image, NSError *error, NSURL *url) {
        [sself setImage:image];
        [sself setNeedsLayout];
    } cancel:^{

    }];
}



@end
