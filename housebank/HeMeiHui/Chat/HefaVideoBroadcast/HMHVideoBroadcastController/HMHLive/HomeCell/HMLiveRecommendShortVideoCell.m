//
//  HMLiveRecommendShortVideoCell.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMLiveRecommendShortVideoCell.h"
#import "HMHomeLiveChannelUnitView.h"

@interface HMLiveRecommendShortVideoCell()

@property (nonatomic,strong)HMHomeLiveUintMoreView *moreView;

@property (nonatomic,strong)NSMutableArray<HMHomeLiveChannelUnitView *> *unitViewArray;


@end

@implementation HMLiveRecommendShortVideoCell

- (NSMutableArray<HMHomeLiveChannelUnitView *> *)unitViewArray {
    
    if (_unitViewArray == nil) {
        _unitViewArray = [NSMutableArray array];
        
        for (int i = 0; i < self.modelArray.count; i++) {
            
            if (i >= 3) {
                break;
            }
            HMHomeLiveChannelUnitView *tempView = [[HMHomeLiveChannelUnitView alloc] initWithFrame:CGRectZero];
            tempView.model = self.modelArray[i];
            [_unitViewArray addObject:tempView];
            [self.contentView addSubview:tempView];
        }
    }
    
    return _unitViewArray;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSubviews {
    [super setSubviews];
    
    HMHomeLiveUintMoreView *moreView = [[HMHomeLiveUintMoreView alloc] initWithFrame:CGRectZero];
    self.moreView = moreView;
    [self.contentView addSubview:moreView];
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
}



- (void)refreshCell {
    
    if (self.modelArray.count <= 0) {
        //   [self.moreView ];
        self.moreView.hidden = YES;
    }
    
    //这里需要清空Cell
    NSInteger rowH = 0; //表示行
    NSInteger rowL = 0; //表示列
    CGFloat midMargin = WScale(15);
    for (int i = 0; i < self.unitViewArray.count; i ++) {
        
        rowH = i / 1;
        rowL = i % 1;
        
        [self.unitViewArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.mas_equalTo(self.moreView.mas_bottom);
                
            } else {
                make.top.mas_equalTo(self.unitViewArray[i - 1].mas_bottom).mas_offset(midMargin);
            }
            
            make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(midMargin);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(-midMargin);
           
            
          //  make.width.mas_equalTo(WScale(90));
            
            if (i == self.unitViewArray.count - 1) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(- WScale(15));
            }
            
        }];
        
    }
    
    //刷新数据
    for (int i = 0; i < self.unitViewArray.count; i++) {
        self.unitViewArray[i].model = self.modelArray[i];
    };
    
}

- (void)setCurrentMoreType:(HMHomeLiveMoreType)currentMoreType {
    [super setCurrentMoreType:currentMoreType];
    self.moreView.type = currentMoreType;
}

- (void)setModelArray:(NSArray<HMHLivereCommendModel *> *)modelArray {
    [super setModelArray:modelArray];
    
    
    
}

- (void)setMoreModel:(HMHLiveMoreModel *)moreModel {
    [super setMoreModel:moreModel];
    
    self.moreView.moreModel = moreModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
