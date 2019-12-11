//
//  WARTopToolView.m
//  Pods
//
//  Created by 秦恺 on 2018/5/15.
//

#import "WARTopToolView.h"
#import "UIColor+WARCategory.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
@implementation WARTopToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.mineBtn];
        [self addSubview:self.hotBtn];
        [self addSubview:self.lineV];
        [self addSubview:self.searchBtn];
        [self addSubview:self.creatBtn];

        self.selectBtn = self.mineBtn;
        [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"343C4F"] forState:UIControlStateNormal];
    }
    return self;
}
- (void)switchChooseClick:(UIButton*)btn {
    if ([self.selectBtn isEqual:btn]) {
        return;
    }
    if (self.selectBtn) {
       [ self.selectBtn setTitleColor:[UIColor colorWithHexString:@"8D93A4"] forState:UIControlStateNormal];
        self.selectBtn = nil;
    }
    self.selectBtn = btn;
    [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"343C4F"] forState:UIControlStateNormal];
    if (self.chooseBlock) {
        self.chooseBlock(btn.tag);
    }

}
- (void)creatBtnClick:(UIButton*)btn {
    if (self.creatBlock) {
        self.creatBlock();
    }
}
- (UIButton *)mineBtn {
    if (!_mineBtn) {
        _mineBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
        [_mineBtn setTitle:WARLocalizedString(@"我的收藏") forState:UIControlStateNormal];
        [_mineBtn setTitleColor:[UIColor colorWithHexString:@"8D93A4"] forState:UIControlStateNormal];
        [_mineBtn setTitleColor:[UIColor colorWithHexString:@"343C4F"] forState:UIControlStateSelected];
        [_mineBtn addTarget:self action:@selector(switchChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        _mineBtn.titleLabel.font = kFont(14);
        _mineBtn.tag = 10001;
    }
    return _mineBtn;
}
- (UIButton *)hotBtn {
    if (!_hotBtn) {
        _hotBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, 90, 44)];
        [_hotBtn setTitle:WARLocalizedString(@"热门收藏") forState:UIControlStateNormal];
        [_hotBtn setTitleColor:[UIColor colorWithHexString:@"8D93A4"]  forState:UIControlStateNormal];
        [_hotBtn setTitleColor:[UIColor colorWithHexString:@"343C4F"] forState:UIControlStateSelected];
        [_hotBtn addTarget:self action:@selector(switchChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        _hotBtn.titleLabel.font = kFont(14);
            _mineBtn.tag = 10002;
    }
    return _hotBtn;
}
- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 44, kScreenWidth-20, 1)];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _lineV;
}
- (UIButton *)creatBtn {
    if (!_creatBtn) {
        _creatBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-11-22.5-12-22.5, 11, 22.5, 21)];
        [_creatBtn setImage: [UIImage war_imageName:@"personal_collect_new" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_creatBtn addTarget:self action:@selector(creatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _creatBtn;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-11-22.5, 11, 22.5, 21)];
        [_searchBtn setImage: [UIImage war_imageName:@"personal_collect_search" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        
    }
    return _searchBtn;
}
@end
