//
//  ANEventJoinMemberViewInfoController.m
//  ArkNameSystem
//
//  Created by Jiao on 24/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANEventJoinMemberViewInfoController.h"
#import "ArkNameDataContainer.h"
#import "ANMumberCollectionViewCell.h"
#import "ArkNameMemberJoinInfo.h"

@interface ANEventJoinMemberViewInfoController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *joinedArray;
@property (strong, nonatomic) UICollectionView *joinedCollectionView;
@end


@implementation ANEventJoinMemberViewInfoController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.joinedArray = [[ArkNameDataContainer instance] fetchMemberJoinInfo:self.eventName inDate:self.dateStr];
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self adjustSubviewLayout];
}

-(void)adjustSubviewLayout{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.joinedCollectionView.frame = CGRectMake(10, 20, self.view.frame.size.width - 20, self.view.frame.size.height - 40 - 64);
}

#pragma UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.joinedArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ANMumberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kArkNameEventJoinMumberCollectionCell forIndexPath:indexPath];
    NSString *name = @"";
    ArkNameMemberJoinInfo *joinInfo = self.joinedArray[indexPath.row];
    name = joinInfo.name;
   
    cell.nameLabel.text = name;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = @"";
    ArkNameMemberJoinInfo *joinInfo = self.joinedArray[indexPath.row];
    name = joinInfo.name;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    nameLabel.text = name;
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
