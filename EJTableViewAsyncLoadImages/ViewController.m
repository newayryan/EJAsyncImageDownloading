//
//  ViewController.m
//  EJTableViewAsyncLoadImages
//
//  Created by Wei Liu on 5/6/16.
//  Copyright © 2016 EJ. All rights reserved.
//

#import "ViewController.h"
#import "EJTableViewCell.h"
#import "EJCellData.h"
#import "EJDataManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *mainTableView;
@property (nonatomic) NSArray *tableData;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupUI];
  [self setupData];
  [self setupConstraints];
}

- (void)setupData {
  
  __weak typeof(self) weakSelf = self;
  [[EJDataManager sharedDataManager] loadDataWithCompletionBlock:^(BOOL success, NSArray *data, NSError *error){
    if (success) {
      weakSelf.tableData = data;
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.mainTableView reloadData];
      });
    } else {
      NSLog(@"something wrong");
    }
  }];

}

- (void)setupUI {
  _mainTableView = [UITableView new];
  _mainTableView.frame = self.view.bounds;
  _mainTableView.delegate = self;
  _mainTableView.dataSource = self;
  _mainTableView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_mainTableView];
}

- (void)setupConstraints {
  _mainTableView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:0 metrics:nil views:@{@"table":self.mainTableView}]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][table]|" options:0 metrics:nil views:@{@"table":self.mainTableView, @"topLayoutGuide":self.topLayoutGuide}]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.tableData && self.tableData.count > 0) {
    return self.tableData.count;
  } else {
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"EJTableViewCell";
  EJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[EJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  [cell configureUIWithData:[self.tableData objectAtIndex:indexPath.row]];
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [EJTableViewCell cellHeight];
}

@end
