//
//  UIImageView+AsyncDownloading.m
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/17/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import "UIImageView+AsyncDownloading.h"
#import <objc/runtime.h>

static char *const kUrlStrKey = "urlStrKey";

@implementation UIImageView (AsyncDownloading)

+ (EJLRUCache *)sharedLRUCache {
  static EJLRUCache *sharedLRUCache = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    sharedLRUCache = [[EJLRUCache alloc] initWithCount:100 andCapacity:0];
  });
  return sharedLRUCache;
}

+ (NSCache *)defaultImageCache {
  static NSCache *defaultCache = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    defaultCache = [NSCache new];
    
    // Should NSCache handle low memory warning?
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
      [defaultCache removeAllObjects];
    }];
  });
  return defaultCache;
}


- (void)setUrl:(NSURL *)url {
  [self setImageURL:url withCompletionBlock:nil];
}

- (NSURL*)url {
  return [NSURL URLWithString:[self urlStr]];
}

- (void)setUrlStr:(NSString *)urlStr {
  objc_setAssociatedObject(self, kUrlStrKey, urlStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)urlStr {
  return objc_getAssociatedObject(self, kUrlStrKey);
}

// TODO: Test reuse table view cell and same imageView instance download another image
- (void)setImageURL:(NSURL*)imageURL withCompletionBlock:(completionBlock)block {
  
  // save the urlStr
  [self setUrlStr:[imageURL absoluteString]];
  // check the cache
//  UIImage *image = [[UIImageView defaultImageCache] objectForKey:imageURL];
  UIImage *image = [[UIImageView sharedLRUCache] cachedObjectWithKey:imageURL];
  if (image) {
    self.image = image;
    if (block) {
      block(YES, image, nil);
    }
    return;
  }
  
  __weak  typeof(self) weakSelf = self;
  NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:imageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (!error) {
      UIImage *downloadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
//      [[UIImageView defaultImageCache] setObject:downloadImage forKey:imageURL];
      [[UIImageView sharedLRUCache] cacheObject:downloadImage forKey:imageURL];
      dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) self = weakSelf;
        // imageView could be reused to download other image, so need to verify the url
        if ([[imageURL absoluteString] isEqualToString:self.urlStr]) {
          self.image = downloadImage;
          if (block) {
            block(YES, downloadImage, nil);
          }
        }
      });
    } else {
      if (block) {
        block(NO, nil, error);
      }
    }
  }];
  
  [task resume];
}

@end
