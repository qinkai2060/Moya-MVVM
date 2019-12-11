//
//  WARProfilePersonalCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/21.
//

#import "WARProfilePersonalCell.h"
#import "WARMacros.h"
#import "WARConfigurationMacros.h"
@implementation WARProfilePersonalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.namelb];
        [self.contentView addSubview:self.infolb];
        
    }
    return self;
}
- (void)setModel:(WARProfileUserMasksModel *)model {
    _model = model;
    self.namelb.text = model.name;
    CGFloat MAXW = kScreenWidth - 99 -15;
    self.infolb.text = model.detailInfoStr;
    CGRect rect = [self.infolb.text boundingRectWithSize:CGSizeMake(MAXW , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    self.infolb.frame = CGRectMake(CGRectGetMaxX(self.namelb.frame), 18, MAXW, rect.size.height);
    
}
- (UILabel *)infolb {
    if (!_infolb) {
        _infolb = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 99, 19)];
        _infolb.textColor = TextColor;
        _infolb.font = kFont(16);
        _infolb.numberOfLines = 0;
    }
    return _infolb;
}
- (UILabel *)namelb {
    if (!_namelb) {
        _namelb = [[UILabel alloc] initWithFrame:CGRectMake(15, 19, 84, 16)];
        _namelb.textColor = ThreeLevelTextColor;
        _namelb.font = kFont(16);
    }
    return _namelb;
}

@end
