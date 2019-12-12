//
//  WARFriendDetailMoreThumbCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/15.
//

#import "WARJournalDetailMoreThumbCell.h"
#import "WARMacros.h"
#import "Masonry.h"

@interface WARJournalDetailMoreThumbCell()
/** 查看全部点赞 */
@property (nonatomic, strong) UILabel *allPraiseButton;

@property (nonatomic, strong) UIView * separatorView;
@end

@implementation WARJournalDetailMoreThumbCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = kColor(whiteColor);
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.contentView addSubview:self.allPraiseButton];
    [self.allPraiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
//    [self.contentView addSubview:self.separatorView];
//    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//        make.bottom.mas_equalTo(0);
//    }];
}

#pragma mark - Event Response
 
#pragma mark - Delegate


#pragma mark - Private

#pragma mark - Public

- (void)configPraiseCount:(NSInteger)count {
    if (count > 0) {
        NSString *allPraiseDesc = [NSString stringWithFormat:@"查看全部%ld赞>>",count];
        self.allPraiseButton.text = allPraiseDesc;
        [self.allPraiseButton setHidden:NO];
    } else {
        [self.allPraiseButton setHidden:YES];
    }
}

#pragma mark - Setter And Getter

- (UILabel *)allPraiseButton {
    if (!_allPraiseButton) {
        _allPraiseButton = [[UILabel alloc] init];
        _allPraiseButton.backgroundColor = HEXCOLOR(0xF4F4F6);
        _allPraiseButton.textColor = HEXCOLOR(0x8D93A4);
        _allPraiseButton.textAlignment = NSTextAlignmentCenter;
        _allPraiseButton.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _allPraiseButton;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = HEXCOLOR(0xF4F4F4);
    }
    return _separatorView;
}

@end
