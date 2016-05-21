//
//  EJDataManager.h
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/14/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completionBlock)(BOOL success, NSArray *data, NSError *error);

@interface EJDataManager : NSObject

+ (instancetype)sharedDataManager;
- (void)loadDataWithCompletionBlock:(completionBlock) block;
@end
