//
//  UCCircularArray.m
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 14..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import "UCCircularArray.h"

#define kDefaultMaxCount 10


@interface UCCircularArray()
{
    NSInteger mMaxCount;
}

@end

@implementation UCCircularArray

- (id) init
{
    return [self initWithCount:kDefaultMaxCount];
}

- (id) initWithCount:(NSInteger)count
{
    self = [super init];
    if(self)
    {
        mMaxCount = count;
    }
    return self;
}

- (NSObject *) dequeue
{
    NSObject *obj = nil;
    
    @synchronized(self){
        if(![self isEmpty])
        {
            obj = [[[self firstObject] retain] autorelease];
            [self removeObjectAtIndex:0];
        }
    }
    return obj;
}

- (BOOL) isEmpty
{
    return ([self count] == 0) ? YES : NO;
}

- (NSObject *) inqueue : (NSObject*) operation
{
    NSObject *object = nil;
    
    @synchronized(self){
        if([self count] == mMaxCount)
        {
            object = [self dequeue];
        }
        [self addObject:operation];
    }
    
    return object;
}

@end
