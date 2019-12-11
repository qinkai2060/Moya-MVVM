//
//  WARMomentSendFailView.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/26.
//

#import "WARMomentSendFailView.h"
#import "WARMacros.h"

#import "UIImage+WARBundleImage.h"

@interface WARMomentSendFailView()
/** sendFailLable */
@property (nonatomic, strong) UILabel *sendFailLable;
/** deleteButton */
@property (nonatomic, strong) UIButton *deleteButton;
/** sendButton */
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation WARMomentSendFailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sendFailLable];
        [self addSubview:self.sendButton];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (void)sendAction:(UIButton *)button {
    if (self.didSendBlock) {
        self.didSendBlock();
    }
}

- (void)deleteAction:(UIButton *)button {
    if (self.didDeleteBlock) {
        self.didDeleteBlock();
    }
}

- (UILabel *)sendFailLable {
    if (!_sendFailLable) {
        _sendFailLable = [[UILabel alloc]init];
        _sendFailLable.frame = CGRectMake(0, 0, 50, 17);
        _sendFailLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _sendFailLable.textColor = HEXCOLOR(0xF2604D);
        _sendFailLable.text = WARLocalizedString(@"发送失败");
    }
    return _sendFailLable;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        UIImage *image = [UIImage war_imageName:@"sendfail_delete" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(93, 0, 15, 15);
        _deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_deleteButton setImage:image forState:UIControlStateNormal];
        _deleteButton.adjustsImageWhenHighlighted = NO;
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}


- (UIButton *)sendButton {
    if (!_sendButton) {
        UIImage *image = [UIImage war_imageName:@"message_issuance2" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(63, 0, 15, 15);
        _sendButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_sendButton setImage:image forState:UIControlStateNormal];
        _sendButton.adjustsImageWhenHighlighted = NO;
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
