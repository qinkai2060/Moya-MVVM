//
//  WARFriendDetailTitleCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/15.
//

#import "WARFriendDetailTitleCell.h"
#import "Masonry.h"
#import "WARMacros.h"

@interface WARFriendDetailTitleCell()

/** bottomLabel */
@property (nonatomic, strong) UILabel *bottomLabel;
/** bottomLabel */
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation WARFriendDetailTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = kColor(whiteColor);
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.contentView addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(12);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(-8);
    }];
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-0.5);
    }];
}

- (void)configCommentCount:(NSInteger)count {
//    if (count > 0) {
//        self.bottomLabel.text = [NSString stringWithFormat:@"全部评论(%ld)",count];
//    } else {
//        self.bottomLabel.text = [NSString stringWithFormat:@"全部评论"];
//    }
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLabel.font = [UIFont systemFontOfSize:14];
        _bottomLabel.textColor = HEXCOLOR(0x343C4F);
        _bottomLabel.text = WARLocalizedString(@"全部评论");
    }
    
    return _bottomLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor =HEXCOLOR(0xEEEEEE);
    }
    
    return _bottomLine;
}



@end
