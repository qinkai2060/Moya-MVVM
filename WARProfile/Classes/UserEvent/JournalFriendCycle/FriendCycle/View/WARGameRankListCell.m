//
//  WARGameRankCell.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/25.
//

#import "WARGameRankListCell.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"

#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"

@interface WARGameRankListCell()

/** nameLable */
@property (nonatomic, strong) UILabel *nameLable;
/** nameLable */
@property (nonatomic, strong) UILabel *rankLable;
/** scoreLable */
@property (nonatomic, strong) UILabel *scoreLable;
/** mineRankLable */
@property (nonatomic, strong) UILabel *mineRankLable;
/** paihangImageView */
@property (nonatomic, strong) UIImageView *paihangImageView;
/** rankImageView */
@property (nonatomic, strong) UIImageView *rankImageView;
/** userImageView */
@property (nonatomic, strong) UIImageView *userImageView;
/** line */
@property (nonatomic, strong) UIView *line;

/** scoreMaxWidth */
@property (nonatomic, assign) CGFloat scoreMaxWidth;
@end

@implementation WARGameRankListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARGameRankListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARGameRankListCell"];
    if (!cell) {
        cell = [[[WARGameRankListCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARGameRankListCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.nameLable];
        [self.contentView addSubview:self.rankLable];
        [self.contentView addSubview:self.scoreLable];
        [self.contentView addSubview:self.paihangImageView];
        [self.contentView addSubview:self.rankImageView];
        [self.contentView addSubview:self.userImageView];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)setRank:(WARFeedGameRank *)rank {
    _rank = rank;
    
    if (self.scoreMaxWidth < rank.listScoreWidth) {
        self.scoreMaxWidth = rank.listScoreWidth;
    }
     
    CGFloat maxWidth = (kScreenWidth) - (rank.isMultiPage ? 13 : 0);
    
    self.rankLable.text = rank.ranking == -1 ? @"-" : [NSString stringWithFormat:@"%ld",rank.ranking];
    [self.userImageView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(24, 24),rank.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.nameLable.text = rank.nickname;
    self.scoreLable.text = rank.score ;
    
    self.paihangImageView.hidden = !rank.isMine;
    self.rankLable.hidden = (rank.ranking <= 3) && (rank.ranking != -1);
    self.rankImageView.hidden = !(rank.ranking <= 3);
    self.scoreLable.textColor = (rank.ranking <= 3) ? HEXCOLOR(0xF2604D) : HEXCOLOR(0xADB1BE);
    
    self.scoreLable.font = (rank.ranking <= 3) ? [UIFont fontWithName:@"PingFangSC-Medium" size:15] : [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    UIImage *image;
    switch (rank.ranking) {
        case 1:
        {
            image = [UIImage war_imageName:@"guanjun" curClass:[self class] curBundle:@"WARProfile.bundle"];
            
        }
            break;
        case 2:
        {
            image = [UIImage war_imageName:@"yajun" curClass:[self class] curBundle:@"WARProfile.bundle"];
        }
            break;
        case 3:
        {
            image = [UIImage war_imageName:@"jijun" curClass:[self class] curBundle:@"WARProfile.bundle"];
        }
            break;
    }
    self.rankImageView.image = image;
    
    self.scoreLable.frame = CGRectMake(maxWidth - 23 - self.scoreMaxWidth, 17.5, self.scoreMaxWidth, 15);
    self.line.frame = CGRectMake(22.5, 49.5, maxWidth - 45, 0.5);
    self.nameLable.frame = CGRectMake(96.5, 17, rank.listNicknameWidth, 16);
    self.paihangImageView.frame = CGRectMake(96.5 + rank.listNicknameWidth + 10, 17.5, 51, 15);
}

- (UILabel *)rankLable {
    if (!_rankLable) {
        _rankLable = [[UILabel alloc]init];
        _rankLable.font = [UIFont fontWithName:@"Silom" size:14];
        _rankLable.frame = CGRectMake(29, 18, 38, 14);
        _rankLable.textAlignment = NSTextAlignmentLeft;
        _rankLable.textColor = HEXCOLOR(0x8D93A4);
    }
    return _rankLable;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _nameLable.frame = CGRectMake(96.5, 17, kScreenWidth * 0.5, 16);
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = HEXCOLOR(0x343C4F);
    }
    return _nameLable;
}

- (UILabel *)mineRankLable {
    if (!_mineRankLable) {
        CGFloat maxWidth = kScreenWidth;
        
        _mineRankLable = [[UILabel alloc]init];
        _mineRankLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        _mineRankLable.frame = CGRectMake(maxWidth - 102, 13.5, 48, 14);
        _mineRankLable.textAlignment = NSTextAlignmentCenter;
        _mineRankLable.text = @"我的排行";
        _mineRankLable.layer.cornerRadius = 7;
        _mineRankLable.layer.masksToBounds = YES;
        _mineRankLable.backgroundColor = HEXCOLOR(0x2CBE61);
        _mineRankLable.textColor = HEXCOLOR(0xffffff);
    }
    return _mineRankLable;
}

- (UIImageView *)paihangImageView {
    if (!_paihangImageView) {
        CGFloat maxWidth = kScreenWidth ;
        UIImage *image = [UIImage war_imageName:@"paihang" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _paihangImageView = [[UIImageView alloc] init];
        _paihangImageView.frame = CGRectMake(maxWidth - 102, 17.5, 51, 15);
        _paihangImageView.image = image;
        _paihangImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _paihangImageView;
}

- (UILabel *)scoreLable {
    if (!_scoreLable) {
        CGFloat maxWidth = kScreenWidth;
        
        _scoreLable = [[UILabel alloc]init];
        _scoreLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _scoreLable.frame = CGRectMake(maxWidth - 12 - 100, 14, 100, 13);
        _scoreLable.textAlignment = NSTextAlignmentRight;
        _scoreLable.textColor = HEXCOLOR(0xF2604D);//8D93A4
    }
    return _scoreLable;
}

- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.frame = CGRectMake(23.5, 13, 19, 24);
        _rankImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _rankImageView;
}

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.frame = CGRectMake(58.5, 10, 30, 30);
        _userImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _userImageView;
}



- (UIView *)line {
    if (!_line) {
        CGFloat maxWidth = kScreenWidth;
        _line = [[UIView alloc] init];
        _line.frame = CGRectMake(22.5, 49.5, maxWidth - 45, 0.5);
        _line.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _line;
}

@end
