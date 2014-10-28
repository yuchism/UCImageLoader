//
//  UCImageLoader.h
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 14..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UCImageLoader : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    
}

typedef void(^UCImageLoaderCompleteBlock)(UIImage *image, NSError *error, NSURL *url);
typedef void(^UCImageLoaderCancelBlock)();


+ (UCImageLoader *) sharedInstance;
- (void) loadImageWithURLString:(NSString *)urlString
                        withKey:(NSString* )key
                       complete:(UCImageLoaderCompleteBlock)completeBlock
                         cancel:(UCImageLoaderCancelBlock)cancelBlock;
- (void) cancelImageWithKey:(NSString *)key;

@end
