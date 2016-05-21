//
//  UIImageView+AsyncDownloading.h
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/17/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EJLRUCache.h"

typedef void (^completionBlock)(BOOL success, UIImage *image, NSError *error);

@interface UIImageView (AsyncDownloading)

@property (nonatomic) NSString *urlStr;
@property (nonatomic) NSURL *url;

+ (NSCache *)defaultImageCache;
+ (EJLRUCache *)sharedLRUCache;
- (void)setImageURL:(NSURL*)imageURL withCompletionBlock:(completionBlock)block;

@end
