//
//  WARFeedSceneryCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARFeedSceneryCell.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"

@interface WARFeedSceneryCell()
/** 背景 */
@property (nonatomic, strong) UIView *contentBackgroundView;
/** 图片 */
@property (nonatomic, strong) UIImageView *iconView;
/** 右上图片 */
@property (nonatomic, strong) UIImageView *rightTopIconView;
/** 右下图片 */
@property (nonatomic, strong) UIImageView *rightBottomIconView;
/** 文本 */
@property (nonatomic, strong) UILabel *contentLabel;
/** title */
@property (nonatomic, strong) UILabel *mainTitleLable;

/** coverImageView */
@property (nonatomic, strong) UIImageView *coverImageView;
/** countLable */
@property (nonatomic, strong) UILabel *countLable;
@end

@implementation WARFeedSceneryCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFeedSceneryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFeedSceneryCell"];
    if (!cell) {
        cell = [[[WARFeedSceneryCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFeedSceneryCell"];
    }
    return cell;
}

- (void)setupSubViews{
    [super setupSubViews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.contentBackgroundView];
    [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, kContentLeftMargin, 10, 0));
    }];
    
    [self.contentBackgroundView addSubview:self.iconView];
    [self.contentBackgroundView addSubview:self.mainTitleLable];
    [self.contentBackgroundView addSubview:self.rightTopIconView];
    [self.contentBackgroundView addSubview:self.rightBottomIconView];
    [self.contentBackgroundView addSubview:self.coverImageView];
    [self.contentBackgroundView addSubview:self.countLable];
    [self.contentBackgroundView addSubview:self.contentLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap]; 
}

#pragma mark - Event Response

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.baseDelegate respondsToSelector:@selector(feedCell:didComponent:)]) {
        [self.baseDelegate feedCell:self didComponent:self.layout.component];
    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARFeedComponentLayout *)layout{
    [super setLayout:layout];
    
    WARFeedScenery *scenery = layout.component.content.scenery;
    WARFeedSceneryLayout *sceneryLayout = layout.sceneryLayout;
    
//    [self.iconView sd_setImageWithURL:scenery.mainImageId placeholderImage:[WARUIHelper war_defaultUserIcon]];
    [self.iconView sd_setImageWithURL:kOriginMediaUrl(scenery.mainImageId) placeholderImage:DefaultPlaceholderImageWtihSize(sceneryLayout.imageFrame.size)];
    if (scenery.images.count >= 2) {
        NSString *rightTopImageId = scenery.images[0];
        NSString *rightBottomImageId = scenery.images[1];
//        [self.rightTopIconView sd_setImageWithURL:rightTopImageId placeholderImage:[WARUIHelper war_defaultUserIcon]];
//        [self.rightBottomIconView sd_setImageWithURL:rightBottomImageId placeholderImage:[WARUIHelper war_defaultUserIcon]];
        [self.rightTopIconView sd_setImageWithURL:kOriginMediaUrl(rightTopImageId) placeholderImage:DefaultPlaceholderImageWtihSize(sceneryLayout.rightTopImageFrame.size)];
        [self.rightBottomIconView sd_setImageWithURL:kOriginMediaUrl(rightBottomImageId) placeholderImage:DefaultPlaceholderImageWtihSize(sceneryLayout.rightBottomImageFrame.size)];
        
        self.rightTopIconView.frame = sceneryLayout.rightTopImageFrame;
        self.rightBottomIconView.frame = sceneryLayout.rightBottomImageFrame;
        
        self.coverImageView.frame = sceneryLayout.rightBottomImageFrame;
        self.countLable.frame = sceneryLayout.rightBottomImageFrame;
        
        if (scenery.images.count > 2) {
            self.coverImageView.hidden = NO;
            self.countLable.hidden = NO;
            self.countLable.text = [NSString stringWithFormat:@"+ %ld",scenery.imageCount - 3];
        } else {
            self.coverImageView.hidden = YES;
            self.countLable.hidden = YES;
        }
    }
    self.mainTitleLable.text = scenery.title;
    self.contentLabel.text = scenery.subTitle;
    
    self.iconView.frame = sceneryLayout.imageFrame;
    self.mainTitleLable.frame = sceneryLayout.titleFrame;
    self.contentLabel.frame = sceneryLayout.contentFrame;
}

- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc]init];
        _contentBackgroundView.userInteractionEnabled = YES;
        _contentBackgroundView.backgroundColor = HEXCOLOR(0xF3F3F5);
    }
    return _contentBackgroundView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 5;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = HEXCOLOR(0x343C4F);
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kLinkFontSize(18)];
    }
    return _contentLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}
- (UIImageView *)rightTopIconView {
    if (!_rightTopIconView) {
        _rightTopIconView = [[UIImageView alloc]init];
        _rightTopIconView.contentMode = UIViewContentModeScaleAspectFill;
        _rightTopIconView.layer.masksToBounds = YES;
    }
    return _rightTopIconView;
}
- (UIImageView *)rightBottomIconView {
    if (!_rightBottomIconView) {
        _rightBottomIconView = [[UIImageView alloc]init];
        _rightBottomIconView.contentMode = UIViewContentModeScaleAspectFill;
        _rightBottomIconView.layer.masksToBounds = YES;
    }
    return _rightBottomIconView;
}

- (UILabel *)mainTitleLable {
    if (!_mainTitleLable) {
        _mainTitleLable = [[UILabel alloc]init];
        _mainTitleLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:kLinkFontSize(19)];
        _mainTitleLable.numberOfLines = 0;
        _mainTitleLable.textAlignment = NSTextAlignmentLeft;
        _mainTitleLable.textColor = HEXCOLOR(0x343C4F);
    }
    return _mainTitleLable;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.alpha = 0.4;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.hidden = YES;
    }
    return _coverImageView;
}

- (UILabel *)countLable {
    if (!_countLable) {
        _countLable = [[UILabel alloc]init];
        _countLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _countLable.numberOfLines = 1;
        _countLable.textAlignment = NSTextAlignmentCenter;
        _countLable.textColor = HEXCOLOR(0xffffff);
        _countLable.hidden = YES;
    }
    return _countLable;
}

@end
