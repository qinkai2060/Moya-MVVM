//
//  HFVideoDYCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVideoDYCell.h"
#import "HFIConView.h"
#import "UIButton+CustomButton.h"
#import "UIView+addGradientLayer.h"
#import "HFProudctView.h"
@interface HFVideoDYCell ()

@property(nonatomic,strong)UIImageView *topImageView;
@property(nonatomic,strong)UIImageView *bottomImageView;
@property(nonatomic,strong)HFIConView *iconView;

@property(nonatomic,strong)UIButton *likeBtn;
@property(nonatomic,strong)UIButton *messageBtn;



@property(nonatomic,strong)ASButtonNode *fowardBtn1;
@property(nonatomic,strong)ASButtonNode *reportBtn1;
@property(nonatomic,strong)ASButtonNode *editBtn_own1;
@property(nonatomic,strong)ASButtonNode *deleteBtn_own1;

@property(nonatomic,strong)UIButton *payBtn;
@property(nonatomic,strong)HFProudctView *productView;
@property(nonatomic,strong)UILabel *contentLb;
@property(nonatomic,strong)ASButtonNode *nameBtn;
@end
@implementation HFVideoDYCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.productImageV];
        [self.contentView addSubview:self.topImageView];
        [self.contentView addSubview:self.bottomImageView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.messageBtn];

        [self.contentView addSubnode:self.fowardBtn1];
        [self.contentView addSubnode:self.reportBtn1];
        [self.contentView addSubnode:self.editBtn_own1];
        [self.contentView addSubnode:self.deleteBtn_own1];
        [self.contentView addSubview:self.payBtn];
        [self.contentView addSubview:self.productView];
        [self.contentView addSubview:self.contentLb];
        [self.contentView addSubnode:self.nameBtn];
        [self.iconView status:0 avatarUrl:@""];
        CGFloat navH = IS_IPHONE_X() ? 88:64;
        self.productImageV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.topImageView.frame = CGRectMake(0, 0, kScreenWidth, navH);
        self.bottomImageView.frame = CGRectMake(0, kScreenHeight-250, kScreenWidth, 250);
        self.iconView.frame = CGRectMake(kScreenWidth-45-10, self.topImageView.bottom+159, 45, 55);
        self.likeBtn.frame = CGRectMake(kScreenWidth-45-10, self.iconView.bottom+30, 45, 50);
        self.messageBtn.frame = CGRectMake(kScreenWidth-45-10, self.likeBtn.bottom+15, 45, 50);
    
    
        self.fowardBtn1.frame = CGRectMake(kScreenWidth-45-10, self.messageBtn.bottom+10, 45, 50);
        self.reportBtn1.frame = CGRectMake(kScreenWidth-45-10, CGRectGetMaxY(self.fowardBtn1.frame)+15, 45, 50);
        self.editBtn_own1.frame = CGRectMake(kScreenWidth-45-10, CGRectGetMaxY(self.fowardBtn1.frame)+15, 45, 50);
        self.deleteBtn_own1.frame = CGRectMake(kScreenWidth-45-10, CGRectGetMaxY(self.editBtn_own1.frame)+15, 45, 50);
        self.payBtn.frame = CGRectMake(kScreenWidth-100-10, kScreenHeight-KBottomSafeHeight-30, 100, 30);
        self.productView.frame = CGRectMake(15, 0, 225, 40);
        self.productView.centerY = self.payBtn.centerY;
        self.contentLb.frame = CGRectMake(15, self.productView.centerY-32-10-20, 242, 32);
        self.nameBtn.frame = CGRectMake(15, self.contentLb.top-16-5, 242, 16);
        self.productImageV.backgroundColor = [UIColor orangeColor];
        self.contentLb.text = @"AHC玻尿酸神仙水乳套装 特别适合用作夏季装嵌护肤，高保湿又不粘腻！…";
        [self.nameBtn setTitle:@"@土豆丝" withFont:[UIFont systemFontOfSize:11] withColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    }
    return self;
}
- (void)setData:(ZFTableData *)data {
    _data = data;
    if (data.thumbnail_width >= data.thumbnail_height) {
        self.productImageV.contentMode = UIViewContentModeScaleAspectFit;
        self.productImageV.clipsToBounds = NO;
    } else {
        self.productImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.productImageV.clipsToBounds = YES;
    }
    [self.productImageV sd_setImageWithURL:[NSURL URLWithString:data.thumbnail_url] placeholderImage:[UIImage imageNamed:@""]];
}

- (ASButtonNode *)nameBtn {
    if (!_nameBtn) {
        _nameBtn = [[ASButtonNode alloc] init];
        _nameBtn.contentHorizontalAlignment = ASHorizontalAlignmentLeft;
    }
    return _nameBtn;
}
- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [[UIButton alloc] init];
        _payBtn.bounds = CGRectMake(0, 0, 100, 30);
        [_payBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        [_payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_payBtn bringSubviewToFront:_payBtn.titleLabel];
        _payBtn.layer.cornerRadius = 15;
        _payBtn.layer.masksToBounds = YES;
    }
    return _payBtn;
}
- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 242, 32)];
        _contentLb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _contentLb.font = [UIFont systemFontOfSize:11];
        _contentLb.numberOfLines = 2;
    }
    return _contentLb;
}
- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 50)];
        [_likeBtn setImage:[UIImage imageNamed:@"video_like_circle"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"video_like_circle"] forState:UIControlStateSelected];
        [_likeBtn setTitle:@"0" forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_likeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:0];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    }
    return _likeBtn;
}
- (ASButtonNode *)fowardBtn1 {
    if (!_fowardBtn1) {
        _fowardBtn1 = [[ASButtonNode alloc] init];
        _fowardBtn1.contentVerticalAlignment = ASVerticalAlignmentCenter;
        [_fowardBtn1 setImage:[UIImage imageNamed:@"video_foward_circle"] forState:UIControlStateNormal];
        [_fowardBtn1 setImage:[UIImage imageNamed:@"video_foward_circle"] forState:UIControlStateSelected];
        [_fowardBtn1 setTitle:@"分享" withFont:[UIFont systemFontOfSize:11] withColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _fowardBtn1.laysOutHorizontally = NO;
    }
    return _fowardBtn1;
}
- (ASButtonNode *)reportBtn1 {
    if (!_reportBtn1) {
        _reportBtn1 = [[ASButtonNode alloc] init];
        
        _reportBtn1.contentVerticalAlignment = ASVerticalAlignmentCenter;
        [_reportBtn1 setImage:[UIImage imageNamed:@"video_warning_circle"] forState:UIControlStateNormal];
        [_reportBtn1 setImage:[UIImage imageNamed:@"video_warning_circle"] forState:UIControlStateSelected];
        [_reportBtn1 setTitle:@"举报" withFont:[UIFont systemFontOfSize:11] withColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reportBtn1.laysOutHorizontally = NO;
    }
    return _reportBtn1;
}
- (ASButtonNode *)editBtn_own1 {
    if (!_editBtn_own1) {
        _editBtn_own1 = [[ASButtonNode alloc] init];
        _editBtn_own1.contentVerticalAlignment = ASVerticalAlignmentCenter;
        [_editBtn_own1 setImage:[UIImage imageNamed:@"video_edit_circle"] forState:UIControlStateNormal];
        [_editBtn_own1 setImage:[UIImage imageNamed:@"video_edit_circle"] forState:UIControlStateSelected];
        [_editBtn_own1 setTitle:@"编辑" withFont:[UIFont systemFontOfSize:11] withColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editBtn_own1.laysOutHorizontally = NO;
    }
    return _editBtn_own1;
}
- (ASButtonNode *)deleteBtn_own1 {
    if (!_deleteBtn_own1) {
        _deleteBtn_own1 = [[ASButtonNode alloc] init];
        _deleteBtn_own1.contentVerticalAlignment = ASVerticalAlignmentCenter;
        [_deleteBtn_own1 setImage:[UIImage imageNamed:@"video_delete_circle"] forState:UIControlStateNormal];
        [_deleteBtn_own1 setImage:[UIImage imageNamed:@"video_delete_circle"] forState:UIControlStateSelected];
        [_deleteBtn_own1 setTitle:@"删除" withFont:[UIFont systemFontOfSize:11] withColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn_own1.laysOutHorizontally = NO;
    }
    return _deleteBtn_own1;
}

- (UIButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 50)];
        [_messageBtn setImage:[UIImage imageNamed:@"video_message_circle"] forState:UIControlStateNormal];
        [_messageBtn setImage:[UIImage imageNamed:@"video_message_circle"] forState:UIControlStateSelected];
        [_messageBtn setTitle:@"0" forState:UIControlStateNormal];
        [_messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:0];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    }
    return _messageBtn;
}
- (HFIConView *)iconView {
    if (!_iconView) {
        _iconView = [[HFIConView alloc] initWithFrame:CGRectMake(0, 0, 45, 55)];
    }
    return _iconView;
}
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"circle_video_topCover"];
    }
    return _topImageView;
}
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.image = [UIImage imageNamed:@"circle_video_bottomCover"];
    }
    return _bottomImageView;
}
- (UIImageView *)productImageV {
    if (!_productImageV) {
        _productImageV = [[UIImageView alloc] init];
//        _productImageV.userInteractionEnabled = YES;
        _productImageV.tag = 100;
    }
    return _productImageV;
}
- (HFProudctView *)productView {
    if (!_productView) {
        _productView = [[HFProudctView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    }
    return _productView;
}
@end
