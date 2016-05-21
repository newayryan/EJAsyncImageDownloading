//
//  EJTableViewCell.h
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/7/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EJCellData.h"

@interface EJTableViewCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)configureUIWithData:(EJCellData *)data;
@end
