//
//  WARNewUserDiaryTableHeaderMonthView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import "WARNewUserDiaryTableHeaderMonthView.h"
#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"

#import "WARDiaryWeatherCollectionViewCell.h"

#import "WARNewUserDiaryMonthModel.h"

#define kMonthMinCount 5
#define kCollectionVHeight 74
#define kWARDiaryWeatherCollectionViewCellId @"kWARDiaryWeatherCollectionViewCellId"

@interface WARNewUserDiaryTableHeaderMonthView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WARNewUserDiaryTableHeaderMonthView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kCollectionVHeight));
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - collection view delegate & data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.monthLogs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARDiaryWeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARDiaryWeatherCollectionViewCellId forIndexPath:indexPath];
    if (indexPath.row < self.monthLogs.count) {
        cell.monthModel = self.monthLogs[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.monthLogs.count) {
        WARNewUserDiaryMonthModel *monthModel = self.monthLogs[indexPath.row];
        if (monthModel.momentOutlines == nil || monthModel.momentOutlines.count <= 0) {
            return ;
        }
        if ([self.delegate respondsToSelector:@selector(userDiaryMonthView:value:)]) {
            [self.delegate userDiaryMonthView:self value:self.monthLogs[indexPath.row]];
        }
    }
}

#pragma mark - Public

- (void)reloadData {
    
    [self.collectionView reloadData];
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMonthLogs:(NSMutableArray<WARNewUserDiaryMonthModel *> *)monthLogs {
    NSMutableArray *mutbArray = [NSMutableArray arrayWithArray:monthLogs];
    NSInteger count = mutbArray.count;
    WARNewUserDiaryMonthModel *firstMonthModel = mutbArray.firstObject;
    NSInteger monthValue = firstMonthModel.month.integerValue;
    NSInteger tempMonth = firstMonthModel.month.integerValue;
    if (tempMonth == 0) { 
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM"];
        tempMonth = [formatter stringFromDate:[NSDate new]].integerValue;
    }
    if (count < kMonthMinCount) {
        for (int i = 0; i < kMonthMinCount - count; i++) {
            WARNewUserDiaryMonthModel *monthModel = [[WARNewUserDiaryMonthModel alloc]init];
            NSInteger month = tempMonth + 1;
            NSInteger year = firstMonthModel.year.integerValue;
            if (month > 12) {
                monthModel.showYear = YES;
                year += 1;
                month = 1;
                
                tempMonth = 0;
            }
            tempMonth = month;
            
            monthModel.month = [NSString stringWithFormat:@"%ld",month];
            monthModel.year = [NSString stringWithFormat:@"%ld",year];
            
            [mutbArray insertObject:monthModel atIndex:0];
        }
    }
    
    //临时数据，默认展位图
    for (int i = 0; i < mutbArray.count; i++) {
        WARNewUserDiaryMonthModel *model = mutbArray[i];
        model.bgImageUrl = [NSString stringWithFormat:@"picture_%02d",((i + 1) % 4) == 0 ? 1 : ((i + 1) % 4)];
    }
    
    _monthLogs = mutbArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize =CGSizeMake(75, 50);
        layout.minimumLineSpacing = 6;
        layout.sectionInset = UIEdgeInsetsMake(0, 13, 0, 13);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WARDiaryWeatherCollectionViewCell class] forCellWithReuseIdentifier:kWARDiaryWeatherCollectionViewCellId];
        _collectionView.backgroundColor = kColor(clearColor);
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
