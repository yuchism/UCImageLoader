//
//  UIImageHTTPLoader.m
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 19..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import "UCImageHTTPLoader.h"

@interface UCImageHTTPLoader()
{
    NSURLConnection *mConn;
    NSString *mUrlString;
    NSMutableData *mData;
    
    UCImageHTTPCompleteBlock mCompleteBlock;
    UCImageHTTPCancelBlock mCancelBlock;
    BOOL mExecuting;
    BOOL mFinished;
}

@property(nonatomic,readonly) BOOL isExecuting;
@property(nonatomic,readonly) BOOL isFinished;
@property(nonatomic,copy) UCImageHTTPCompleteBlock completeBlock;
@property(nonatomic,copy) UCImageHTTPCancelBlock cancelBlock;
@end

@implementation UCImageHTTPLoader
@synthesize status = mStatus;
@synthesize error = mError;
@synthesize isExecuting = mExecuting;
@synthesize isFinished = mFinished;
@synthesize completeBlock = mCompleteBlock;
@synthesize cancelBlock = mCancelBlock;

+ (void) makeImageRequestThread
{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"imageRequestThread"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *) imageRequestThread
{
    static NSThread *_imageRequestThread = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _imageRequestThread = [[NSThread alloc] initWithTarget:self
                                                        selector:@selector(makeImageRequestThread)
                                                          object:nil];
        [_imageRequestThread start];
    });
    
    return _imageRequestThread;
}

- (id) initWithURLString:(NSString *)urlString complete:(UCImageHTTPCompleteBlock)completeBlock cancel:(UCImageHTTPCancelBlock)cancelBlock
{
    self = [super init];
    if(self)
    {
        mUrlString = [urlString retain];
        mExecuting = NO;
        mFinished = NO;
        
        self.status = UCImageHTTPLoaderInit;
        self.completeBlock = completeBlock;
        self.cancelBlock = cancelBlock;
    }
    return self;
}

- (BOOL) isConcurrent
{
    return YES;
}

- (void) start
{
    if ([self isCancelled])
    {
        self.status = UCImageHTTPLoaderCancel;
        return;
    }
    
    self.status = UCImageHTTPLoaderProgress;
    [self performSelector:@selector(_startConnection) onThread:[[self class] imageRequestThread] withObject:nil waitUntilDone:NO];
}

- (void) _startConnection
{
    NSURL *url = [[[NSURL alloc] initWithString:mUrlString] autorelease];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    mConn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    [mConn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [mConn start];
}

- (void) cancel
{
    [super cancel];
    
    if(mConn)
    {
        [mConn cancel];
    }
    self.status = UCImageHTTPLoaderCancel;
    
    if(mCancelBlock)
    {
        mCancelBlock();
    }
}
- (void) setStatus:(UCImageHTTPLoaderStatus)status
{
    mStatus = status;
    
    if(status == UCImageHTTPLoaderComplete || status == UCImageHTTPLoaderCompleteWithError || status == UCImageHTTPLoaderCancel)
    {
        [self willChangeValueForKey: @"isExecuting"];
        mExecuting = NO;
        [self didChangeValueForKey: @"isExecuting"];
        [self willChangeValueForKey: @"isFinished"];
        mFinished = YES;
        [self didChangeValueForKey: @"isFinished"];
    }
    
    else if(status == UCImageHTTPLoaderProgress)
    {
        [self willChangeValueForKey:@"isExecuting"];
        mExecuting = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

#pragma mark nsurlconnection delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(error)
    {
        self.status = UCImageHTTPLoaderCompleteWithError;
        if(mCompleteBlock)
        {
            mCompleteBlock(nil,error,[NSURL URLWithString:mUrlString]);
        }
    }
}

#pragma mark nsurlconnection delegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    if([self isCancelled])
    {
        mCancelBlock();
    }
    else
    {
        self.status = UCImageHTTPLoaderComplete;
        if(mCompleteBlock)
        {
            mCompleteBlock(mData,nil,[NSURL URLWithString:mUrlString]);
        }
    }
}
#pragma mark nsurlconnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(!mData)
    {
        mData = [[NSMutableData alloc] initWithData:data];
    } else
    {
        [mData appendData:data];
    }
}

- (NSString *) urlString
{
    return mUrlString;
}

- (void) dealloc
{
    [mUrlString release];
    [mData release];
    [mConn release];
    [mCompleteBlock release];
    [mCancelBlock release];
    [super dealloc];
}

@end
