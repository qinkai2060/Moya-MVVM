//
//  HFHomeCollectionHeaderView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeCollectionHeaderView.h"

@implementation HFHomeCollectionHeaderView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.topView];
    [self addSubview:self.titilelb];
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
}
- (void)hh_bindViewModel {

}
- (void)setSectionModel:(HFSectionModel *)sectionModel {
    _sectionModel = sectionModel;
    self.titilelb.text = sectionModel.moduleTitle;
    CGSize size = [self.titilelb sizeThatFits:CGSizeMake(60, 20)];
    self.titilelb.frame = CGRectMake((ScreenW - size.width)*0.5, self.topView.bottom+10, size.width, size.height);
    self.leftImageView.frame = CGRectMake(self.titilelb.left-5-58, self.topView.bottom+11, 58, 17);
    self.rightImageView.frame = CGRectMake(self.titilelb.right+5, self.topView.bottom+11, 58, 17);
    
    if (self.sectionModel.contentMode == HFSectionModelFashionType||self.sectionModel.contentMode  == HFSectionModelModuleGoodsVideo) {
//        self.titilelb.text = @"天天时尚";
        self.leftImageView.image = [UIImage imageNamed:@"group_style_three"];
        self.rightImageView.image = [UIImage imageNamed:@"group_style_four"];
        //8146EC
        self.titilelb.textColor = [UIColor colorWithHexString:@"8146EC"];
    }
    if (self.sectionModel.contentMode == HFSectionModelZuberType || self.sectionModel.contentMode == HFSectionModelModuleFourType) {
        self.leftImageView.image = [UIImage imageNamed:@"group_style_five"];
        self.rightImageView.image = [UIImage imageNamed:@"group_style_six"];
        self.titilelb.textColor = [UIColor colorWithHexString:@"4D88FF"];
//        self.titilelb.text = @"天天租房";
    }
    if (self.sectionModel.contentMode == HFSectionModelFiveOneType || self.sectionModel.contentMode == HFSectionModelFiveTwoType||self.sectionModel.contentMode == HFSectionModelFiveThreeType || self.sectionModel.contentMode == HFSectionModelSpecialPriceType) {
        self.leftImageView.image = [UIImage imageNamed:@"group_style_one"];
        self.rightImageView.image = [UIImage imageNamed:@"group_style_two"];
        self.titilelb.textColor = [UIColor colorWithHexString:@"F3344A"];
//        self.titilelb.text = @"天天促销";
    }
    if (self.sectionModel.contentMode == HFSectionModelModuleSixType) {
//        self.titilelb.text = @"天天租房";
        self.leftImageView.image = [UIImage imageNamed:@"group_style_one"];
        self.rightImageView.image = [UIImage imageNamed:@"group_style_two"];
        self.titilelb.textColor = [UIColor colorWithHexString:@"F3344A"];
    }
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        
    }
    return _leftImageView;
}
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}
- (UILabel *)titilelb {
    if (!_titilelb) {
        _titilelb = [[UILabel alloc] init];
        _titilelb.font = [UIFont systemFontOfSize:15];
    }
    return _titilelb;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _topView;
}
@end
