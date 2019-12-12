//
//  WARNewMessageTipView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/4.
//

#import "WARNewMessageTipView.h"
#import "WARBaseMacros.h"
#import "WARMacros.h"
#import "UIView+Frame.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"   
#import "UIImage+WARBundleImage.h"

@interface WARNewMessageTipView()

/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** imageView */
@property (nonatomic, strong) UIImageView *imageView;
/** tipLable */
@property (nonatomic, strong) UILabel *tipLable;

@end

@implementation WARNewMessageTipView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.bounds = CGRectMake(0, 0, kScreenWidth, 49);
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.tipLable];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:kOriginMediaUrl(imageUrl) placeholderImage:[WARUIHelper war_defaultUserIcon]];
}

- (void)setMessageCount:(NSInteger)messageCount {
    _messageCount = messageCount;
    
    self.tipLable.text = [NSString stringWithFormat:@"%ld条消息",messageCount];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.frame = CGRectMake((kScreenWidth - 142) * 0.5, 14, 142, 34);
        _contentView.backgroundColor = HEXCOLOR(0x303036);
        _contentView.layer.cornerRadius = 2;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 26, 26)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.layer.cornerRadius = 2.0f;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)tipLable {
    if (!_tipLable) {
        _tipLable = [[UILabel alloc]initWithFrame:CGRectMake(34, 0, 108, 34)];
        _tipLable.font = [UIFont systemFontOfSize:12];
        _tipLable.textAlignment = NSTextAlignmentCenter;
        _tipLable.textColor = HEXCOLOR(0xFFFFFF);
    }
    return _tipLable;
}

@end
