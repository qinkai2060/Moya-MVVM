//
//  WARFeedLinkCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/24.
//

#import "WARFeedLinkCell.h"

static CGFloat contentTopMargin = 0;
static CGFloat contentLeftRightMargin = 5;
static CGFloat iconWidthHeight = 84 * kLinkContentScale;
static CGFloat iconAndTextMargin = 8;

static CGFloat linkIconWidthHeight = 18;
static CGFloat linkIconAndTextMargin = 3;

@interface WARFeedLinkCell()

/** 图片 */
@property (nonatomic, strong) UIImageView *iconView;
/** 文本 */
@property (nonatomic, strong) UILabel *contentLabel;
/** 背景 */
@property (nonatomic, strong) UIView *contentBackgroundView;

/** 图片link */
@property (nonatomic, strong) UIImageView *iconLinkView;
/** 文本link */
@property (nonatomic, strong) UILabel *contentLinkLabel;
/** 背景link*/
@property (nonatomic, strong) UIView *contentLinkBackgroundView;

@end

@implementation WARFeedLinkCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFeedLinkCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFeedLinkCell"];
    if (!cell) {
        cell = [[[WARFeedLinkCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFeedLinkCell"];
    }
    return cell;
}
 
- (void)setupSubViews{ 
    [super setupSubViews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    /** deafult */
    [self.contentView addSubview:self.contentBackgroundView];
    [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentLeftRightMargin);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(contentTopMargin);
        make.height.mas_equalTo(iconWidthHeight);
    }];
    
    [self.contentBackgroundView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentBackgroundView);
        make.left.mas_equalTo(self.contentBackgroundView);
        make.width.height.mas_equalTo(iconWidthHeight);
    }];
    
    [self.contentBackgroundView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(iconAndTextMargin);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(self.contentBackgroundView);
    }];
    
    /**  link */
    [self.contentView addSubview:self.contentLinkBackgroundView];
    [self.contentLinkBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentLeftRightMargin);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(contentTopMargin);
        make.height.mas_equalTo(iconWidthHeight);
    }];
    
    [self.contentLinkBackgroundView addSubview:self.iconLinkView];
    [self.iconLinkView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentLinkBackgroundView);
        make.left.mas_equalTo(self.contentLinkBackgroundView);
        make.width.height.mas_equalTo(linkIconWidthHeight);
        make.centerY.equalTo(self.contentLinkBackgroundView);
    }];
    
    [self.contentLinkBackgroundView addSubview:self.contentLinkLabel];
    [self.contentLinkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconLinkView.mas_right).offset(linkIconAndTextMargin);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(self.contentLinkBackgroundView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:tap];
}

- (void)setLayout:(WARFeedComponentLayout *)layout{
    [super setLayout:layout];
    
    WARFeedLinkComponent *link = layout.component.content.link;
    switch (link.linkType) {
        case WARFeedLinkComponentTypeDefault:
        {
            self.contentLabel.text = link.title;
            
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:link.imgURL] placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(iconWidthHeight, iconWidthHeight))];
            self.contentBackgroundView.hidden = NO;
            self.contentLinkBackgroundView.hidden = YES;
        }
            break;
        case WARFeedLinkComponentTypeRead:
        {
            self.contentLinkLabel.text = link.title;
            
            [self.iconLinkView setImage:[UIImage war_imageName:@"link_s" curClass:[self class] curBundle:@"WARControl.bundle"]];
            self.contentBackgroundView.hidden = YES;
            self.contentLinkBackgroundView.hidden = NO;
        }
            break;
        case WARFeedLinkComponentTypeWeiBo:
        case WARFeedLinkComponentTypeSummary:
        {
            self.contentLinkLabel.text = link.title;
            
            [self.iconLinkView setImage:[UIImage war_imageName:@"link_s" curClass:[self class] curBundle:@"WARControl.bundle"]];
            self.contentBackgroundView.hidden = YES;
            self.contentLinkBackgroundView.hidden = NO;
        }
            break;
    }
}

#pragma mark - Event Response

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(linkCell:didLink:)]) {
        [self.delegate linkCell:self didLink:self.layout.component.content.link];
    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 2;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = HEXCOLOR(0x343C4F);
        _contentLabel.font = [UIFont systemFontOfSize:15];
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

- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc]init];
        _contentBackgroundView.userInteractionEnabled = YES;
//        _contentBackgroundView.hidden = YES;
        _contentBackgroundView.backgroundColor = HEXCOLOR(0xF6F6F6);
    }
    return _contentBackgroundView;
}

- (UILabel *)contentLinkLabel {
    if (!_contentLinkLabel) {
        _contentLinkLabel = [[UILabel alloc]init];
        _contentLinkLabel.numberOfLines = 0;
        _contentLinkLabel.textAlignment = NSTextAlignmentLeft;
        _contentLinkLabel.textColor = HEXCOLOR(0x386DB4);
        _contentLinkLabel.font = [UIFont systemFontOfSize:12];
    }
    return _contentLinkLabel;
}

- (UIImageView *)iconLinkView {
    if (!_iconLinkView) {
        _iconLinkView = [[UIImageView alloc]init];
        _iconLinkView.contentMode = UIViewContentModeScaleAspectFill;
        _iconLinkView.layer.masksToBounds = YES;
    }
    return _iconLinkView;
}

- (UIView *)contentLinkBackgroundView {
    if (!_contentLinkBackgroundView) {
        _contentLinkBackgroundView = [[UIView alloc]init];
        _contentLinkBackgroundView.userInteractionEnabled = YES;
//        _contentLinkBackgroundView.hidden = YES;
        _contentLinkBackgroundView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _contentLinkBackgroundView;
}

@end
