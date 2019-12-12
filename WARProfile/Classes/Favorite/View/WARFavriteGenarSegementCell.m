//
//  WARFavriteGenarSegementCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import "WARFavriteGenarSegementCell.h"
#import "WARConfigurationMacros.h"
#import "Masonry.h"
#import "WARMacros.h"
@implementation WARFavriteGenarSegementCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.namelb];
        [self.namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.equalTo(@37);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.namelb.highlighted = selected;

}

- (UILabel *)namelb {
    if (!_namelb) {
        _namelb = [[UILabel alloc] init];
        _namelb.textColor = ThreeLevelTextColor;
        _namelb.highlightedTextColor = ThemeColor;
        _namelb.textAlignment = NSTextAlignmentCenter;
        _namelb.font = kFont(15);
    }
    return _namelb;
}
@end
