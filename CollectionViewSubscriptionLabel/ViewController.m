//
//  ViewController.m
//  CollectionViewSubscriptionLabel
//
//  Created by chenyk on 15/4/24.
//  Copyright (c) 2015年 chenyk. All rights reserved.
//

#define kControllerHeaderViewHeight                90
#define kControllerHeaderToCollectionViewMargin    0
#define kCollectionViewCellsHorizonMargin          12
#define kCollectionViewCellHeight                  30
#define kCollectionViewItemButtonImageToTextMargin 5

#define kCollectionViewToLeftMargin                16
#define kCollectionViewToTopMargin                 12
#define kCollectionViewToRightMargin               16
#define kCollectionViewToBottomtMargin             10

#define kCellImageToLabelMargin                    10
#define kCellBtnCenterToBorderMargin               19


#import "ViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "CollectionViewCell.h"
#import "CollectionHeaderView.h"


typedef void(^ISLimitWidth)(BOOL yesORNo,id data);


static NSString * const kCellIdentifier           = @"CellIdentifier";
static NSString * const kHeaderViewCellIdentifier = @"HeaderViewCellIdentifier";

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *dataSource;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.dataSource = [NSMutableArray array];
    NSMutableArray * array1 = [@[@"推荐",@"热点",@"汽车",@"财经频道",@"热点",@"社会",@"明星八卦",@"IT科技",@"移动互联网",@"金融",@"大数据",@"股票期货",@"食品安全新闻",@"自定义标签"]mutableCopy];
    
    [self.dataSource addObject:array1];
    NSMutableArray * array2 = [@[@"推荐",@"热点",@"汽车",@"财经频道",@"热点",@"社会",@"明星八卦",@"IT科技",@"移动互联网",@"金融",@"大数据",@"股票期货",@"食品安全新闻食品食品安全"]mutableCopy];
    
    [self.dataSource addObject:array2];
    
    [self addCollectionView];
    
}

- (void)addCollectionView {
    CGRect collectionViewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40);
    UICollectionViewLeftAlignedLayout * layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.allowsMultipleSelection = YES;
    
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewCellIdentifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    self.collectionView.scrollsToTop = NO;
    //self.collectionView.scrollEnabled = NO;
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.dataSource count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray * array = self.dataSource[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    
    NSMutableArray * array = self.dataSource[indexPath.section];
    
    NSString *text = array[indexPath.row];
    //cell.titleLabel.backgroundColor = [UIColor orangeColor];
    cell.titleLabel.text = text;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    
    NSMutableArray * array1 = indexPath.section == 0?self.dataSource[1]:self.dataSource[0];
    NSMutableArray * array2 = indexPath.section == 1?self.dataSource[1]:self.dataSource[0];
    [array1 addObject:array2[indexPath.row]];
    [array2 removeObjectAtIndex:indexPath.row];
    
    [self.collectionView reloadData];
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewCellIdentifier forIndexPath:indexPath];
        NSString * str = indexPath.section == 0 ? @"我的订阅":@"未订阅";
        headerView.titleLabel.text = str;
        return (UICollectionReusableView *)headerView;
    }
    return nil;
}


- (float)getCollectionCellWidthText:(NSString *)text{
    float cellWidth;
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:13]}];
    
    cellWidth = ceilf(size.width) + kCellBtnCenterToBorderMargin;
    cellWidth = [self checkCellLimitWidth:cellWidth isLimitWidth:nil];
    return cellWidth;
}


- (float)checkCellLimitWidth:(float)cellWidth isLimitWidth:(ISLimitWidth)isLimitWidth {
    float limitWidth = (CGRectGetWidth(self.collectionView.frame)-kCollectionViewToLeftMargin-kCollectionViewToRightMargin);
    if (cellWidth >= limitWidth) {
        cellWidth = limitWidth;
        isLimitWidth?isLimitWidth(YES,@(cellWidth)):nil;
        return cellWidth;
    }
    isLimitWidth?isLimitWidth(NO,@(cellWidth)):nil;
    return cellWidth;
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // cell 的宽
    NSMutableArray * array = self.dataSource[indexPath.section];
    NSString *text = array[indexPath.row];
    float cellWidth = [self getCollectionCellWidthText:text];
    return CGSizeMake(cellWidth, kCollectionViewCellHeight);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionViewCellsHorizonMargin;//cell之间的间隔
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 38);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //四周边距
    return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
