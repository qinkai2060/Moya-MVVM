//
//  HMLiveActivityTableViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HMLiveActivityTableViewCell.h"
#import "HMHomeLiveUintMoreView.h"
@interface HMLiveActivityTableViewCell()

@property (nonatomic,strong)HMHomeLiveUintMoreView *moreView;



@end
@implementation HMLiveActivityTableViewCell

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
    float weight = (ScreenW - 30) / 3.0;

    UIView *bgview = [[UIView alloc] initWithFrame:CGRectZero];

    [self.contentView addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(50 + WScale(135) + 15 + weight);
    }];
    
    HMHomeLiveUintMoreView *moreView = [[HMHomeLiveUintMoreView alloc] initWithFrame:CGRectZero];
    moreView.type = HMHomeLiveMoreType_Activity;
    self.moreView = moreView;
    [self.contentView addSubview:moreView];
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.imgViewTop];
    [self.contentView addSubview:self.imageBannerView1];
    [self.contentView addSubview:self.imageBannerView2];
    [self.contentView addSubview:self.imageBannerView3];

    [self.imgViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moreView.mas_bottom);
        make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(WScale(10));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(- WScale(10));
        make.height.mas_equalTo(WScale(135));
    }];
    [self.imageBannerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewTop.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).mas_offset(WScale(10));
        make.width.mas_equalTo(weight);
        make.height.mas_equalTo(weight);
    }];
    [self.imageBannerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewTop.mas_bottom).offset(5);
        make.left.equalTo(self.imageBannerView1.mas_right).mas_offset(5);
        make.width.mas_equalTo(weight);
        make.height.mas_equalTo(weight);
    }];
    [self.imageBannerView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewTop.mas_bottom).offset(5);
        make.left.equalTo(self.imageBannerView2.mas_right).mas_offset(5);
        make.width.mas_equalTo(weight);
        make.height.mas_equalTo(weight);
    }];
    
}
- (void)setModel:(HMHLiveModules_4Model *)model{
    _model = model;
    if (self.model.items.count >= 4) {
        [self.imgViewTop sd_setImageWithURL:[NSURL URLWithString:_model.items[0].img] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        self.imageBannerView1.fourLiveModuleModel = _model.items[1];
        self.imageBannerView2.fourLiveModuleModel = _model.items[2];
        self.imageBannerView3.fourLiveModuleModel = _model.items[3];
        [self.imageBannerView1 doMessageRendering];
        [self.imageBannerView2 doMessageRendering];
        [self.imageBannerView3 doMessageRendering];
    }
    
}
- (UIImageView *)imgViewTop{
    if (!_imgViewTop) {
        _imgViewTop = [[UIImageView alloc] init];
        _imgViewTop.layer.cornerRadius = 5;
        _imgViewTop.layer.masksToBounds = YES;
        _imgViewTop.contentMode = UIViewContentModeScaleAspectFit;
        _imgViewTop.clipsToBounds = YES;
        _imgViewTop.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_imgViewTop addGestureRecognizer:tapGesture];
    }
    return _imgViewTop;
}
- (void)tapOne:(UITapGestureRecognizer *)ger{
    
   HMHLiveModules_4ItemsModel *liveModuleModel = (HMHLiveModules_4ItemsModel *)_model.items[0];
    if (liveModuleModel.link.length == 0 || CHECK_STRING_ISNULL(liveModuleModel.link)) {
        [SVProgressHUD showErrorWithStatus:@"跳转链接为空"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    if (self.cellClick) {
        self.cellClick(liveModuleModel);
    }
}
- (void)tap:(UITapGestureRecognizer *)ger{
    HFModuleTwoView *zuberView = (HFModuleTwoView*)ger.view;
    if (zuberView.fourLiveModuleModel.link.length == 0 || CHECK_STRING_ISNULL(zuberView.fourLiveModuleModel.link)) {
        [SVProgressHUD showErrorWithStatus:@"跳转链接为空"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    if (self.cellClick) {
        self.cellClick(zuberView.fourLiveModuleModel);
    }
}
- (HFModuleTwoView *)imageBannerView1 {
    if (!_imageBannerView1) {
        _imageBannerView1 = [[HFModuleTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageBannerView1 addGestureRecognizer:tapGesture];
    }
    return  _imageBannerView1;
}
- (HFModuleTwoView *)imageBannerView2 {
    if (!_imageBannerView2) {
        _imageBannerView2 = [[HFModuleTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageBannerView2 addGestureRecognizer:tapGesture];
    }
    return  _imageBannerView2;
}
- (HFModuleTwoView *)imageBannerView3 {
    if (!_imageBannerView3) {
        _imageBannerView3 = [[HFModuleTwoView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageBannerView3 addGestureRecognizer:tapGesture];
    }
    return  _imageBannerView3;
}
@end
