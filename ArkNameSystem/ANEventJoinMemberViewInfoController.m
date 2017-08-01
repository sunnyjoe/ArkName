//
//  ANEventJoinMemberViewInfoController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 25/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANEventJoinMemberViewInfoController.h"
#import "ArkNameDataContainer.h"
#import "ANStatis.h"
#import "ANMumberCollectionViewCell.h"
#import "ArkNameMemberJoinInfo.h"

@interface ANEventJoinMemberViewInfoController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *joinedCollectionView;
@property (strong, nonatomic) NSArray *eventJoinArray;
@end

@implementation ANEventJoinMemberViewInfoController

-(void)viewDidLoad{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.title = @"详细人员";
  
  NSDateFormatter *dateFormatter = [ANStatis instance].dateFormatter;
  self.eventJoinArray = [[ArkNameDataContainer instance] fetchMemberJoinInfo:self.eventName from:[dateFormatter dateFromString:self.dateStr] to:[dateFormatter dateFromString:self.dateStr]];
  
  UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
  collectionViewLayout.sectionInset = UIEdgeInsetsMake(-35, 10, 10, 10);
  collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  self.joinedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
  self.joinedCollectionView.layer.borderColor = [UIColor darkGrayColor].CGColor;
  self.joinedCollectionView.layer.borderWidth = 1;
  self.joinedCollectionView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.joinedCollectionView];
  self.joinedCollectionView.dataSource = self;
  self.joinedCollectionView.delegate = self;
  [self.joinedCollectionView registerClass:[ANMumberCollectionViewCell class] forCellWithReuseIdentifier:kArkNameEventJoinMumberCollectionCell];
}

-(void)viewWillLayoutSubviews{
  [super viewWillLayoutSubviews];
  self.joinedCollectionView.frame = CGRectMake(10, 84, self.view.frame.size.width - 20, self.view.frame.size.height - 84 - 40);
  [self.joinedCollectionView reloadData];
}

#pragma UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.eventJoinArray.count;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
  ANMumberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kArkNameEventJoinMumberCollectionCell forIndexPath:indexPath];
  
  ArkNameMemberJoinInfo *info = self.eventJoinArray[indexPath.row];
  cell.nameLabel.text = info.name;
  return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  ArkNameMemberJoinInfo *info = self.eventJoinArray[indexPath.row];
  CGFloat cellWidth = MIN(collectionView.frame.size.width / 3.5, 115);
  UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, cellWidth - 4, 20)];
  nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
  nameLabel.text = info.name;
  [nameLabel sizeToFit];
  
  return CGSizeMake(cellWidth, 40);
}

@end
