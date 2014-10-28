//
//  UCImageFIleLoader.m
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 15..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import "UCImageFileLoader.h"

@implementation UCImageFileLoader

+ (UCImageFileLoader *) sharedInstance
{
    static dispatch_once_t once;
    static UCImageFileLoader *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];;
    });
    return instance;
}



- (id) init
{
    self = [super init];
    if(self)
    {
        NSLog(@"%@",CacheDir);
        
        NSFileManager *fm  = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:CacheDir])
        {
            [fm createDirectoryAtPath:CacheDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

- (BOOL) isExist:(NSString *)fileName
{
    NSString *filePath = [CacheDir stringByAppendingPathComponent:fileName];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    return isExist;
}

- (NSData *)loadImage:(NSString *)fileName
{
    NSFileManager *fm  = [NSFileManager defaultManager];
    NSString *filePath = [CacheDir stringByAppendingPathComponent:fileName];
    if([fm fileExistsAtPath:filePath]){
        
        return [NSData dataWithContentsOfFile:filePath];
    }
    else
    {
        return nil;
    }
    
}

- (void) saveData:(NSData *)data fileName:(NSString *)fileName
{
    NSFileManager *fm  = [NSFileManager defaultManager];
    NSString *filePath = [CacheDir stringByAppendingPathComponent:fileName];
    if(![fm fileExistsAtPath:filePath]){
        [fm createFileAtPath:filePath contents:data attributes:nil];
    }
    else
    {
        [self removeDataWithFileName:fileName];
        [fm createFileAtPath:filePath contents:data attributes:nil];
    }
}

- (void) removeDataWithFileName:(NSString *)fileName
{
    NSFileManager *fm  = [NSFileManager defaultManager];
    NSString *filePath = [CacheDir stringByAppendingPathComponent:fileName];
    if([fm fileExistsAtPath:filePath])
    {
        [fm removeItemAtPath:filePath error:nil];
    }
}

@end
