//
//  HFSpecialCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/1/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSpecialCell.h"
#import "HFSPecialView.h"
@interface HFSpecialCell ()
@property(nonatomic,strong)UILabel *specialNamelb;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)HFSPecialView *specialView;

@end
@implementation HFSpecialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.specialNamelb];
        [self.contentView addSubview:self.specialView];
        self.specialNamelb.frame = CGRectMake(15, self.lineView.bottom+15, ScreenW-30, 15);
        self.specialView.frame = CGRectMake(15, self.specialNamelb.bottom+10, ScreenW-30, 30);
    }
    return self;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenW-30, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _lineView;
}
- (UILabel *)specialNamelb {
    if (!_specialNamelb) {
        _specialNamelb = [[UILabel alloc] init];
        _specialNamelb.textColor = [UIColor blackColor];
        _specialNamelb.font = [UIFont systemFontOfSize:13];
//        _specialNamelb.text = @"规格名称1";
    }
    return _specialNamelb;
}
- (HFSPecialView *)specialView {
    if (!_specialView) {
        _specialView = [[HFSPecialView alloc] initWithFrame:CGRectMake(0, self.specialNamelb.bottom+10, ScreenW, 100) dataArr:@[]];
    }
    return _specialView;
}
@end
