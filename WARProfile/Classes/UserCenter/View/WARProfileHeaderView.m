//
//  WARProfileHeaderView.m
//  Pods
//
//  Created by huange on 2017/8/3.
//
//

#import "WARProfileHeaderView.h"
#import "UIImage+WARBundleImage.h"

#import "Masonry.h"
#import "WARLocalizedHelper.h"
#import "WARMacros.h"


const float IconImageHeight = 90;
const float IconImageViewTop = 64;

const float TitleTopMargin = 10;
const float TitleHeight = 40;

const float BottomHeight = 80;
const float BottomTopMargin = 10;

@implementation WARProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}


- (void)initUI {
    [self createBackgroundView];
    [self createBackRadiusView];
    [self createIconImageView];
    [self createTitleLabel];
    [self createLikeView];
    [self createfansView];
    [self createArrangeView];
}

- (void)createBackgroundView {
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.image = [UIImage war_imageName:@"ProfileHeader" curClass:[WARProfileHeaderView class] curBundle:@"WARProfile.bundle"];
    
    [self addSubview:self.bgImageView];
}

- (void)createBackRadiusView {
    self.radiusBackView = [[UIView alloc] init];
    self.radiusBackView.backgroundColor = [UIColor clearColor];
    self.radiusBackView.clipsToBounds = YES;
    self.radiusBackView.layer.borderColor = RGBA(255, 255, 255, 0.5).CGColor;
    self.radiusBackView.layer.borderWidth = 15;
    self.radiusBackView.layer.cornerRadius = IconImageHeight / 2;

    [self addSubview:self.radiusBackView];
}

- (void)createIconImageView {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    self.iconImageView.image = [UIImage war_imageName:@"ProfileHeader" curClass:[WARProfileHeaderView class] curBundle:@"WARProfile.bundle"];
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = (IconImageHeight - 15) / 2;
    self.iconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon)];
    [self.iconImageView addGestureRecognizer:tapGuesture];
    
    [self addSubview:self.iconImageView];
}

- (void)createTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.titleLabel];
}

- (void)createLikeView {
    self.likeView = [self getLikeViewByImage:@"profileLike" title:WARLocalizedString(@"关注")];
    
    [self addSubview:self.likeView];
}

- (void)createfansView {
    self.fansView = [self getLikeViewByImage:@"profileFans" title:WARLocalizedString(@"粉丝")];
    
    [self addSubview:self.fansView];
}

- (void)createArrangeView {
    self.arrangeView = [self getLikeViewByImage:@"profileArrange" title:WARLocalizedString(@"排行")];
    
    [self addSubview:self.arrangeView];
}


- (void)clickIcon {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickIconAction)]) {
        [self.delegate clickIconAction];
    }
}


- (WARLikeView *)getLikeViewByImage:(NSString *)imageName title:(NSString *)title {
    WARLikeView *likeView = [[WARLikeView alloc] initWithFrame:CGRectZero];
    
    likeView.iconImageView.image = [UIImage war_imageName:imageName curClass:[WARLikeView class] curBundle:@"WARProfile.bundle"];
    likeView.titleLabel.text = title;
    
    return likeView;
}


- (void)updateConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.radiusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self).with.offset(IconImageViewTop);
        make.width.mas_equalTo(IconImageHeight);
        make.height.mas_equalTo(IconImageHeight);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.mas_equalTo(self.radiusBackView);
        make.width.mas_equalTo(IconImageHeight - 15);
        make.height.mas_equalTo(IconImageHeight - 15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom);
        make.height.mas_equalTo(TitleHeight);
        make.trailing.leading.equalTo(self);
    }];
    
    [@[self.likeView, self.fansView, self.arrangeView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BottomHeight);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(BottomTopMargin);
    }];
    
    
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_right).multipliedBy(0.25);
    }];

    [self.fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_right).multipliedBy(0.5);
    }];

    [self.arrangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_right).multipliedBy(0.75);
    }];
    

    [super updateConstraints];

}


@end


#pragma mark - likeView
/************************ likeView *********************/

const float likeIconImageWidth = 25;
const float likeIconImageHeight = 25;

const float likeTitleLabelTopMargin = 10;

@implementation WARLikeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}


- (void)initUI {
    [self createIconImageView];
    [self createTitleLabel];
}

- (void)createIconImageView {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.iconImageView];
}

- (void)createTitleLabel {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(likeIconImageHeight);
        make.width.mas_equalTo(likeIconImageWidth);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(likeTitleLabelTopMargin);
        make.left.right.bottom.mas_equalTo(self);
    }];
}

@end
