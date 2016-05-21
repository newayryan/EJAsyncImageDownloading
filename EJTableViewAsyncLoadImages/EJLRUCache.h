//
//  EJRLUCache.h
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/18/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EJLRUCache : NSObject

- (instancetype)initWithCount:(NSUInteger)count andCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;
- (void)cacheObject:(id)obj forKey:(id)key;
- (id)cachedObjectWithKey:(id)key;
- (void)removeAllObjects;
- (id)removeObjectForKey:(id)key;

@end
