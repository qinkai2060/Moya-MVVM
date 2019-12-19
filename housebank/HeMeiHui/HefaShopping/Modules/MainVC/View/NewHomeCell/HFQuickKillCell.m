//
//  HFQuickKillCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFQuickKillCell.h"
#import "HFTimeLimitCollectionCell.h"
#import "ZTGCDTimerManager.h"

@interface HFQuickKillCell(){
    CADisplayLink *_link;
}
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger timestamp;
@property (nonatomic ,strong)dispatch_source_t timer2;

@end
@implementation HFQuickKillCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeTimeLimitKillType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.timelimtiKillImageView];
    [self.contentView addSubview:self.secondlb];
    [self.contentView addSubview:self.minAndSecondlb];
    [self.contentView addSubview:self.minlb];
    [self.contentView addSubview:self.hourlbAndMinlb];
    [self.contentView addSubview:self.hourlb];
    [self.contentView addSubview:self.distanceTimeTitlelb];
    [self.contentView addSubview:self.collectionView];
    
}

- (void)doMessageRendering {
    self.topView.frame = CGRectMake(0, 0, ScreenW, 10);
    self.timelimtiKillImageView.frame = CGRectMake(15, self.topView.bottom+13, 124, 20);
    self.secondlb.frame = CGRectMake(ScreenW-10-22, self.topView.bottom+10, 22, 25);
    self.minAndSecondlb.frame = CGRectMake(self.secondlb.left-12, self.topView.bottom+10, 12, 25);
    self.minlb.frame = CGRectMake(self.minAndSecondlb.left-22, self.topView.bottom+10, 22, 25);
    self.hourlbAndMinlb.frame = CGRectMake(self.minlb.left-12, self.topView.bottom+10, 12, 25);
    self.hourlb.frame = CGRectMake(self.hourlbAndMinlb.left-22, self.topView.bottom+10, 22, 25);
    self.distanceTimeTitlelb.frame = CGRectMake(self.hourlb.left-60, self.topView.bottom+14, 50, 17);
    self.collectionView.frame = CGRectMake(0, self.topView.bottom+45, ScreenW, 155);
    self.timeKillModel = (HFTimeLimitModel*)self.model;
    _timestamp = self.timeKillModel.timersmp;
    if (_timestamp > 0) {
        self.distanceTimeTitlelb.text = @"距离下场";
        [self getDetailTimeWithTimestamp:_timestamp];
    }else {

    }
    self.hourlb.hidden = !(_timestamp>0);
    self.minlb.hidden = !(_timestamp>0);
    self.secondlb.hidden = !(_timestamp>0);
    self.minAndSecondlb.hidden = !(_timestamp>0);
    self.hourlbAndMinlb.hidden = !(_timestamp>0);
    self.distanceTimeTitlelb.hidden = !(_timestamp>0);
    self.minAndSecondlb.text = @":";
    self.hourlbAndMinlb.text = @":";
    if (self.timeKillModel.isOpentimer) {
        [self setupTimer];
    }
  
}
- (void)setTimeKillModel:(HFTimeLimitModel *)timeKillModel {
    _timeKillModel = timeKillModel;
    [self.collectionView reloadData];
}
- (void)setupTimer {
    
    [[ZTGCDTimerManager sharedInstance] scheduleGCDTimerWithName:NSStringFromClass([HFQuickKillCell class]) interval:2 queue:dispatch_get_main_queue() repeats:YES option:CancelPreviousTimerAction action:^{
        _timestamp--;
        self.timeKillModel.timersmp = _timestamp;
        [self getDetailTimeWithTimestamp:_timestamp];
        if (_timestamp == 0) {
            [self invalidateTimer];
            if (self.didQuickCellBlock) {
                self.didQuickCellBlock(self.model);
            }
        }
    }];
    
    
}
- (void)invalidateTimer {
    [[ZTGCDTimerManager sharedInstance] cancelTimerWithName:NSStringFromClass([HFQuickKillCell class])];
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    
    self.hourlb.text = [NSString stringWithFormat:@"%02zd",hour];
    self.minlb.text = [NSString stringWithFormat:@"%02zd",minute];
    self.secondlb.text = [NSString stringWithFormat:@"%02zd",second];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.timeKillModel.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFTimeLimitCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"limitTime" forIndexPath:indexPath];

    HFTimeLimitSmallModel *model =   self.timeKillModel.dataArray[indexPath.row];
    cell.smallModel = model;
    [cell doMessageRendering];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     HFTimeLimitSmallModel *model =   self.timeKillModel.dataArray[indexPath.row];
    if (self.didTimeKillBlock) {
        self.didTimeKillBlock(model);
    }
}
- (UIImageView *)timelimtiKillImageView {
    if (!_timelimtiKillImageView) {
        _timelimtiKillImageView = [[UIImageView alloc] init];
        _timelimtiKillImageView.image = [UIImage imageNamed:@"home_miaosha_title"];
    }
    return _timelimtiKillImageView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _topView;
}
- (UILabel *)secondlb {
    if (!_secondlb) {
        _secondlb = [[UILabel alloc] init];
        _secondlb.backgroundColor = [UIColor colorWithHexString:@"323232"];
        _secondlb.font = [UIFont systemFontOfSize:12];
        _secondlb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _secondlb.layer.cornerRadius = 2;
        _secondlb.layer.masksToBounds = YES;
        _secondlb.textAlignment = NSTextAlignmentCenter;
    }
    return _secondlb;
}
- (UILabel *)hourlb {
    if (!_hourlb) {
        _hourlb = [[UILabel alloc] init];
        _hourlb.backgroundColor = [UIColor colorWithHexString:@"323232"];
        _hourlb.font = [UIFont systemFontOfSize:12];
        _hourlb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _hourlb.layer.cornerRadius = 2;
        _hourlb.layer.masksToBounds = YES;
        _hourlb.textAlignment = NSTextAlignmentCenter;
    }
    return _hourlb;
}
- (UILabel *)minlb {
    if (!_minlb) {
        _minlb = [[UILabel alloc] init];
        _minlb.backgroundColor = [UIColor colorWithHexString:@"323232"];
        _minlb.font = [UIFont systemFontOfSize:12];
        _minlb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _minlb.layer.cornerRadius = 2;
        _minlb.layer.masksToBounds = YES;
        _minlb.textAlignment = NSTextAlignmentCenter;
    }
    return _minlb;
}
- (UILabel *)minAndSecondlb {
    if (!_minAndSecondlb) {
        _minAndSecondlb = [[UILabel alloc] init];
        _minAndSecondlb.font = [UIFont systemFontOfSize:12];
        _minAndSecondlb.textColor = [UIColor colorWithHexString:@"323232"];
        _minAndSecondlb.textAlignment = NSTextAlignmentCenter;
    }
    return _minAndSecondlb;
}
- (UILabel *)hourlbAndMinlb {
    if (!_hourlbAndMinlb) {
        _hourlbAndMinlb = [[UILabel alloc] init];
        _hourlbAndMinlb.font = [UIFont systemFontOfSize:12];
        _hourlbAndMinlb.textColor = [UIColor colorWithHexString:@"323232"];
        _hourlbAndMinlb.textAlignment = NSTextAlignmentCenter;
    }
    return _hourlbAndMinlb;
}
- (UILabel *)distanceTimeTitlelb {
    if (!_distanceTimeTitlelb) {
        _distanceTimeTitlelb = [[UILabel alloc] init];
        _distanceTimeTitlelb.font = [UIFont systemFontOfSize:12];
        _distanceTimeTitlelb.textColor = [UIColor colorWithHexString:@"4c4c4c"];
    }
    return _distanceTimeTitlelb;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake((ScreenW-45)/3,155);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HFTimeLimitCollectionCell class] forCellWithReuseIdentifier:@"limitTime"];
        _collectionView.bounces=NO;
        
    }
    return _collectionView;
}
@end
