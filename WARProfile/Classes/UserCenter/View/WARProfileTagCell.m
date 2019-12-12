//
//  WARProfileTagCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/21.
//

#import "WARProfileTagCell.h"
#import "WARProfileDataTagCenterView.h"
#import "WARMacros.h"
#import "WARConfigurationMacros.h"

@implementation WARProfileTagCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.namelb];
    }
    return self;
}
- (void)setModel:(WARProfileUserMasksModel *)model {
    _model = model;
    for (UIView *v in self.contentView.subviews) {
        if (v.tag == 10001) {
            [v removeFromSuperview];
        }
    }
    self.namelb.text = WARLocalizedString(model.name);
    WARProfileDataTagCenterView *tag = [[WARProfileDataTagCenterView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.namelb.frame), 18, kScreenWidth - 61-56, 0) dataArr:model.tags];
    tag.frame =  CGRectMake(CGRectGetMaxX(self.namelb.frame), 18, kScreenWidth - 61-56, tag.maxY);
    tag.tag = 10001;
    [self.contentView addSubview:tag];
}
- (UILabel *)namelb {
    if (!_namelb) {
        _namelb = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 61, 16)];
        _namelb.textColor = ThreeLevelTextColor;
        _namelb.textAlignment = NSTextAlignmentCenter;
        _namelb.font = kFont(16);
    }
    return _namelb;
}

@end
