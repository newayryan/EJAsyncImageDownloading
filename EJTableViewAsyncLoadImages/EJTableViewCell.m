//
//  EJTableViewCell.m
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/7/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import "EJTableViewCell.h"
#import "UIImageView+AsyncDownloading.h"

static const CGSize sCellIconSize = {60, 60};
static const CGFloat sCellPriceWidth = 60;
static const CGFloat sCellPrimaryTextHeight = 20;
static const CGFloat sCellSecondaryTextHeight = 15;
static const CGFloat sCellControlInnerMargin = 10;
static const CGFloat sCellControlTextVertMargin = 4;

@interface EJTableViewCell ()

@property (nonatomic, weak) UIImageView *EJCellIconView;
@property (nonatomic, weak) UILabel     *EJCellTitleLabel;
@property (nonatomic, weak) UILabel     *EJCellCategoryLabel;
@property (nonatomic, weak) UILabel     *EJCellPriceLabel;
@property (nonatomic, weak) UILabel     *EJCellProducerLabel;

@end

@implementation EJTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    [self setupUI];
    [self setupConstraints];
  }
  return self;
}

#pragma mark - Utility / Internal

- (void)setupUI {
  UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]];
  CGRect newFrame = iconView.frame;
  newFrame.size = sCellIconSize;
  iconView.frame = newFrame;
  [self.contentView addSubview:iconView];
  _EJCellIconView = iconView;
  
  UILabel *titleLabel = [UILabel new];
  titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size: 17];
  [self.contentView addSubview:titleLabel];
  _EJCellTitleLabel = titleLabel;
  
  UILabel *categoryLabel = [UILabel new];
  categoryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size: 12];
  [self.contentView addSubview:categoryLabel];
  _EJCellCategoryLabel = categoryLabel;
  
  UILabel *priceLabel = [UILabel new];
  priceLabel.textAlignment = NSTextAlignmentRight;
  priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 14];
  [self.contentView addSubview:priceLabel];
  _EJCellPriceLabel = priceLabel;
  
  UILabel *producerLabel = [UILabel new];
  producerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size: 12];
  [self.contentView addSubview:producerLabel];
  _EJCellProducerLabel = producerLabel;
}

- (void)setupConstraints {

  self.EJCellIconView.translatesAutoresizingMaskIntoConstraints = NO;
  self.EJCellTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.EJCellCategoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.EJCellPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.EJCellProducerLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSDictionary *viewDict = NSDictionaryOfVariableBindings(_EJCellIconView, _EJCellTitleLabel, _EJCellCategoryLabel, _EJCellPriceLabel, _EJCellProducerLabel);
  NSDictionary *metricDict = @{@"iconSize":@(sCellIconSize.width), @"innerMargin":@(sCellControlInnerMargin), @"textMargin":@(sCellControlTextVertMargin), @"priceWidth":@(sCellPriceWidth), @"primaryTextHeight":@(sCellPrimaryTextHeight), @"secondaryTextHeight":@(sCellSecondaryTextHeight)};
  
  // icon view
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-innerMargin-[_EJCellIconView(iconSize)]" options:0 metrics:metricDict views:viewDict]];
  
  // title, category, and producer
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-innerMargin-[_EJCellIconView(iconSize)]-innerMargin-[_EJCellTitleLabel]-innerMargin-|" options:0 metrics:metricDict views:viewDict]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-innerMargin-[_EJCellIconView(iconSize)]-innerMargin-[_EJCellCategoryLabel]-innerMargin-[_EJCellPriceLabel(priceWidth)]-innerMargin-|" options:0 metrics:metricDict views:viewDict]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-innerMargin-[_EJCellIconView(iconSize)]-innerMargin-[_EJCellProducerLabel]-innerMargin-|" options:0 metrics:metricDict views:viewDict]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-innerMargin-[_EJCellTitleLabel(primaryTextHeight)]-textMargin-[_EJCellCategoryLabel]-textMargin-[_EJCellProducerLabel]-innerMargin-|" options:0 metrics:metricDict views:viewDict]];
  // price
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_EJCellPriceLabel(primaryTextHeight)]" options:0 metrics:metricDict views:viewDict]];
}

#pragma mark - Public methods

- (void)configureUIWithData:(EJCellData *)data {
  NSAssert(data != nil, @"data is nil");
  self.EJCellTitleLabel.text = data.title;
  self.EJCellCategoryLabel.text = data.category;
  self.EJCellPriceLabel.text = data.price;
  self.EJCellProducerLabel.text = data.producer;
  [self.EJCellIconView setImageURL:data.imageURL withCompletionBlock:nil];
}

+ (CGFloat)cellHeight {
  return 80.0;
}

@end
