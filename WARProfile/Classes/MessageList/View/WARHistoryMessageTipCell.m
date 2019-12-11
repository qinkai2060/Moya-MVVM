//
//  WARHistoryMessageTipCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/13.
//

#import "WARHistoryMessageTipCell.h"
#import "WARMacros.h"
#import "Masonry.h"

@interface WARHistoryMessageTipCell()
/** tipLable */
@property (nonatomic, strong) UILabel *tipLable;
@end

@implementation WARHistoryMessageTipCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARHistoryMessageTipCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARHistoryMessageTipCell"];
    if (!cell) {
        cell = [[[WARHistoryMessageTipCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARHistoryMessageTipCell"];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.tipLable];
    [self.tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (UILabel *)tipLable {
    if (!_tipLable) {
        _tipLable = [[UILabel alloc]init];
        _tipLable.text = WARLocalizedString(@"查看更多历史通知...");
        _tipLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _tipLable.textAlignment = NSTextAlignmentCenter;
        _tipLable.textColor = HEXCOLOR(0x575C68);
        _tipLable.numberOfLines = 0;
    }
    return _tipLable;
}

@end
