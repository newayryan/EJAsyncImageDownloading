//
//  EJCellData.h
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/13/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EJCellData : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *producer;
@property (nonatomic) NSURL *imageURL;

- (instancetype)initWithTitle:(NSString *)title
       withCategory:(NSString *)category
          withPrice:(NSString *)price
       withProducer:(NSString *)producer
       withImageURL:(NSString *)urlString;

@end
