//
//  WARActivationExplorationCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARActivationExplorationCell.h"

#import "WARMacros.h"
#import "WARUIHelper.h"

#import "WARMomentTrackInfoView.h"

#import "UIImageView+WebCache.h"

@interface WARActivationExplorationCell()
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *timeLable;
/** trackInfoView */
@property (nonatomic, strong) WARMomentTrackInfoView *trackInfoView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation WARActivationExplorationCell

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

- (void)setUpUI{ 
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.trackInfoView];
    [self.contentView addSubview:self.lineView];
}

#pragma mark - Event Response 

- (void)tapUserHeader:(UITapGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(activationExplorationCell:indexPath:accountId:)]) {
        [self.delegate activationExplorationCell:self indexPath:self.indexPath accountId:nil];
    }
}

- (void)tapUserName:(UITapGestureRecognizer *)ges {
    if ([self.delegate respondsToSelector:@selector(activationExplorationCell:indexPath:accountId:)]) {
        [self.delegate activationExplorationCell:self indexPath:self.indexPath accountId:nil];
    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARActivationExplorationLayout *)layout {
    _layout = layout;
    
    /// data
    WARActivationExploration *activationExploration = layout.activationExploration;
    [self.userImageView sd_setImageWithURL:kOriginMediaUrl(activationExploration.friendModel.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.nameLable.text = activationExploration.friendModel.nickname;
    self.timeLable.text = activationExploration.formatTime;
    
    /// frame
    self.trackInfoView.layout = layout.trackInfoLayout;
    self.userImageView.frame = layout.userNameF;
    self.nameLable.frame = layout.userNameF;
    self.timeLable.frame = layout.timeF;
    self.lineView.frame = layout.lineF;
}

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init];
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        _userImageView.layer.cornerRadius = 4.0f;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeader:)];
        [_userImageView addGestureRecognizer:tapGesture];
    }
    return _userImageView;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = HEXCOLOR(0x576B95);
        _nameLable.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserName:)];
        [_nameLable addGestureRecognizer:tapGesture];
    }
    return _nameLable;
}

- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLable.textAlignment = NSTextAlignmentRight;
        _timeLable.textColor = HEXCOLOR(0x737373);
    }
    return _timeLable;
}

- (WARMomentTrackInfoView *)trackInfoView {
    if (!_trackInfoView) {
        _trackInfoView = [[WARMomentTrackInfoView alloc]initWithFrame:CGRectZero trackType:WARMomentTrackTypeActivation];
    }
    return _trackInfoView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xE1E1DF);
    }
    return _lineView;
}
@end
