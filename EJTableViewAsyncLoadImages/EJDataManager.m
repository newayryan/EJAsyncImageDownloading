//
//  EJDataManager.m
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/14/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import "EJDataManager.h"
#import "EJCellData.h"

static NSString *const kTopPaidAppsURL = @"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=129/json";
static NSString *const kFullAppDetailsURL = @"https://itunes.apple.com/lookup?id=%@";

@interface EJDataManager()

@end

@implementation EJDataManager

+ (instancetype)sharedDataManager {
  static EJDataManager *manager = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    manager = [[EJDataManager alloc] init];
  });
  
  return manager;
}

- (void)loadDataWithCompletionBlock:(completionBlock) block {
  __weak typeof(self) weakSelf = self;
  NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:kTopPaidAppsURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if (!error) {
      NSError *jsonParsingError = nil;
      NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
      NSArray *data = [weakSelf createAppObjectsForRecords:jsonResults[@"feed"][@"entry"]];
      block(YES, data, error);
    } else {
      block(NO, nil, error);
    }
    
  }];
  
  [task resume];
}

- (NSArray*)createAppObjectsForRecords:(NSArray *)records {
  NSMutableArray *recordObjects = [NSMutableArray array];
  for (NSDictionary *data in records) {
    NSDictionary *imageDict = [data[@"im:image"] lastObject];
    
    EJCellData *cellData = [[EJCellData alloc] initWithTitle:data[@"title"][@"label"]
                                                withCategory:data[@"category"][@"attributes"][@"label"]
                                                   withPrice:data[@"im:price"][@"label"]
                                                withProducer:data[@"im:artist"][@"label"]
                                                withImageURL:imageDict[@"label"]];
    [recordObjects addObject:cellData];
  }
  return recordObjects;
}

@end
