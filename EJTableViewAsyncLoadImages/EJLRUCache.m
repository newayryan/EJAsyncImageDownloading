//
//  EJRLUCache.m
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/18/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import "EJLRUCache.h"

@interface EJLRUCache ()
@property (nonatomic) NSMutableDictionary *cacheDictionary;
@property (nonatomic) NSMutableArray *cacheKeys;
@end

@implementation EJLRUCache {
  NSUInteger _count;
  NSUInteger _capacity;
}

- (instancetype)initWithCount:(NSUInteger)count andCapacity:(NSUInteger)capacity {
  if (self = [super init]) {
    _count = count;
    _capacity = capacity;
    _cacheDictionary = [NSMutableDictionary dictionary];
    _cacheKeys = [NSMutableArray array];
  }
  return self;
}

- (instancetype)init {
  return [self initWithCount:0 andCapacity:0];
}

#pragma mark - Public Interface

- (void)cacheObject:(id)obj forKey:(id)key {
  id object = self.cacheDictionary[key];
  if (object) {
    [self.cacheKeys removeObject:key];
  } else {
    if (self.cacheDictionary.count > _count) {
      id key = self.cacheKeys.lastObject;
      [self.cacheKeys removeObject:key];
      [self.cacheDictionary removeObjectForKey:key];
    }
  }
  [self.cacheKeys insertObject:key atIndex:0];
  [self.cacheDictionary setObject:obj forKey:key];
}

- (id)cachedObjectWithKey:(id)key {
  id object = self.cacheDictionary[key];
  if (object) {
    [self.cacheKeys removeObject:key];
    [self.cacheKeys insertObject:key atIndex:0];
  }
  return object;
}

- (void)removeAllObjects {
  [self.cacheDictionary removeAllObjects];
  [self.cacheKeys removeAllObjects];
  _capacity = 0;
  _count = 0;
}

- (id)removeObjectForKey:(id)key {
  id object = [self.cacheDictionary objectForKey:key];
  [self.cacheDictionary removeObjectForKey:key];
  [self.cacheKeys removeObject:key];
  return object;
}

@end
