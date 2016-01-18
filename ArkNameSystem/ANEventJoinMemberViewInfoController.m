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
    
    NSDateFormatter *dateFormatter = [ANStatis instance].dateFormatter;
    self.eventJoinArray = [[ArkNameDataContainer instance] fetchMemberJoinInfo:self.eventName from:[dateFormatter dateFromString:self.dateStr] to:[dateFormatter dateFromString:self.dateStr]];
    
    UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
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

-(void)adjustSubviewLayout{
    self.joinedCollectionView.frame = CGRectMake(10, 20, self.view.frame.size.width - 20, self.view.frame.size.height - 64 - 40);
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
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    nameLabel.text = info.name;
    [nameLabel sizeToFit];
    
    return CGSizeMake(MAX(nameLabel.frame.size.width + 10, 100), 40);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

@end