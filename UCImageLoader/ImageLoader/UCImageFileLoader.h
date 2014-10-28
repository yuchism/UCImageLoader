//
//  UCImageFIleLoader.h
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 15..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CacheDir [NSTemporaryDirectory() stringByAppendingPathComponent:@"UCImageLoader"]


@interface UCImageFileLoader : NSObject

+ (UCImageFileLoader *) sharedInstance;

- (BOOL) isExist:(NSString *)fileName;
- (void) saveData:(NSData*)data fileName:(NSString*)fileName;
- (NSData *) loadImage:(NSString *)fileName;

@end
