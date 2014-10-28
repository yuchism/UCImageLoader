//
//  UIImageHTTPLoader.h
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 19..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef enum {
    UCImageHTTPLoaderInit = 1,
    UCImageHTTPLoaderProgress,
    UCImageHTTPLoaderComplete,
    UCImageHTTPLoaderCompleteWithError,
    UCImageHTTPLoaderCancel,
} UCImageHTTPLoaderStatus;

typedef void (^UCImageHTTPCompleteBlock)(NSData *data, NSError *error, NSURL *imageURL);
typedef void (^UCImageHTTPCancelBlock)();


@interface UCImageHTTPLoader : NSOperation <NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    UCImageHTTPLoaderStatus mStatus;
    NSError *mError;

}

- (id)initWithURLString:(NSString *)urlString
               complete:(UCImageHTTPCompleteBlock)completeBlock
                 cancel:(UCImageHTTPCancelBlock)cancelBlock;
- (NSString *) urlString;

@property(nonatomic,assign) UCImageHTTPLoaderStatus status;
@property(nonatomic,retain) NSError *error;
@end
