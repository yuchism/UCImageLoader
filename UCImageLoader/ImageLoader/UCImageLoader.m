//
//  UCImageLoader.m
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 14..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import "UCImageLoader.h"
#import "UCImageHTTPLoader.h"
#import "UCImageFileLoader.h"
#import "UCImageMemoryLoader.h"

#define kUCImageLoaderMaxMemoryCapacity 1024*1024*5
#define kUCImageLoaderMaxConcurrentOperationCount 10


@interface UCImageLoader()
{
    NSOperationQueue *queue;
}
@end

@implementation UCImageLoader

+ (UCImageLoader *) sharedInstance
{
    static dispatch_once_t once;
    static UCImageLoader *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];;
    });
    return instance;
}

- (id)init
{
    return [self initWithMemoryCapacity:kUCImageLoaderMaxMemoryCapacity];
}

- (id) initWithMemoryCapacity:(long long)memoryBytes
{
    self = [super init];
    if(self)
    {
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:kUCImageLoaderMaxConcurrentOperationCount];

    }
    return self;
}


- (void) cancelImageWithKey:(NSString *)key
{
    NSArray *operaions = [queue operations];
    for (UCImageHTTPLoader *loader in operaions)
    {
        if ([loader.name isEqual:key] && ![loader isCancelled])
        {
            [loader cancel];
        }
    }
}

- (void) loadImageWithURLString:(NSString *)urlString withKey:(NSString* )key complete:(UCImageLoaderCompleteBlock)completeBlock cancel:(UCImageLoaderCancelBlock)cancelBlock
{
    NSString *fileName = [self getFileNameFromURLString:urlString];

    UCImageFileLoader *fileLoader = [UCImageFileLoader sharedInstance];
    
    if([fileLoader isExist:fileName])
    {
        NSData *data = [fileLoader loadImage:fileName];
        if(data)
        {
            UIImage *image = [UIImage imageWithData:data];
            NSURL *url = [NSURL URLWithString:urlString];
            completeBlock(image,nil,url);
        }
    }
    else
    {
        UCImageHTTPLoader *httpLoader = [[[UCImageHTTPLoader alloc] initWithURLString:urlString complete:^(NSData *data, NSError *error, NSURL *imageURL) {
            
            if(error)
            {
                completeBlock(nil,error,imageURL);
            }
            else
            {
                NSString *fileName = [[UCImageLoader sharedInstance] getFileNameFromURLString:[imageURL absoluteString]];
                [fileLoader saveData:data fileName:fileName];
                UIImage *image = [UIImage imageWithData:data];
                completeBlock(image,nil,imageURL);
            }
            
        } cancel:^{
            cancelBlock();
        }] autorelease];

        httpLoader.name = key;

        @synchronized(queue)
        {
            [self cancelImageWithKey:key];
            [queue addOperation:httpLoader];
        }
    }
}




- (NSString *) getFileNameFromURLString : (NSString *) URLString
{
    NSString *fileName = [URLString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return fileName;
}


- (void)dealloc
{
    [super dealloc];
}



@end
