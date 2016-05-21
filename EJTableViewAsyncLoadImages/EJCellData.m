//
//  EJCellData.m
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/13/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import "EJCellData.h"

@implementation EJCellData

- (instancetype)initWithTitle:(NSString *)title
       withCategory:(NSString *)category
          withPrice:(NSString *)price
       withProducer:(NSString *)producer
       withImageURL:(NSString *)urlString {
  if (self = [super init]) {
    _title = title;
    _category = category;
    _price = price;
    _producer = producer;
    _imageURL = [NSURL URLWithString:urlString];
  }
  return self;
}

@end
