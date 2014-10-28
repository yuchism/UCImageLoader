//
//  UCCircularArray.h
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 14..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCCircularArray : NSMutableArray

- (id) initWithCount:(NSInteger)count;
- (NSObject *) inqueue : (NSObject*)object;
- (NSObject *) dequeue;
- (BOOL) isEmpty;


@end
