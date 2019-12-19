//
//  HMLiveRecommendAttentionCell.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMLiveRecommendAttentionCell.h"
#import "HMHomeLiveChannelUnitView.h"

@interface HMLiveRecommendAttentionCell()

@property (nonatomic,strong)HMHomeLiveChannelUnitView *unitView;



@end

@implementation HMLiveRecommendAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSubviews {
    [super setSubviews];
    
    
    
    HMHomeLiveChannelUnitView *unitView = [[HMHomeLiveChannelUnitView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:unitView];
    self.unitView = unitView;
    
    [unitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(WScale(15));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(- WScale(15));
    }];
    
    
}
- (void)setModel:(HMHLivereCommendModel *)model {
    _model = model;
    
    self.unitView.model = model;
}

- (void)setAttentionModel:(HMHLiveAttentionModel *)attentionModel {
    _attentionModel = attentionModel;
    self.unitView.attentionModel = attentionModel;
}

- (void)setListNewModel:(HMHVideoListNewModel *)listNewModel {
    _listNewModel = listNewModel;
    self.unitView.listNewModel = listNewModel;
}



@end
