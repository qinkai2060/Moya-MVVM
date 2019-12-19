//
//  HMHomeLivePlayUnitView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHomeLivePlayUnitView.h"
#import "HMHliveParamsModel.h"
@interface HMHomeLivePlayUnitView()

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *signLabel;
@property (nonatomic, strong) UILabel *flagLabel;

@end

@implementation HMHomeLivePlayUnitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubview];
        
        [self initMessage];
    }
    return self;
}

- (void)initMessage {
    
    @weakify(self)
    [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self sendNotificationName:HMHliveCellTapNotification Object:self.model];
    }];
}

- (void)setSubview {
    
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    UIImageView *iconImageView = [UIImageView new];
    self.iconImageView = iconImageView;
    [self addSubview:iconImageView];
    [self.iconImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    iconImageView.radius = WScale(4);
   // iconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [iconImageView addGestureRecognizer:tapGesture];
    
    UILabel *contentLabel = [UILabel wd_labelWithText:@"语雀是一款优雅高效的在线文档编辑与协同工具， 让每个企业轻松拥有文档中心阿里巴巴集团内部使用多年，众多中小企业首选。" font:15 textColorStr:@"#333333"];
    self.contentLabel = contentLabel;
    [self addSubview:contentLabel];
    contentLabel.numberOfLines = 2;
    contentLabel.textAlignment = NSTextAlignmentLeft;
   // contentLabel.userInteractionEnabled = YES;
    
    UILabel *signLabel = [UILabel wd_labelWithText:@"13.1万人观看" font:12 textColorStr:@"#AAAAAA"];
    self.signLabel = signLabel;
    [self addSubview:signLabel];
    signLabel.textAlignment = NSTextAlignmentLeft;
  //  signLabel.userInteractionEnabled = YES;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(WScale(105));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.mas_equalTo(self);
    make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(WScale(11));
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(WScale(4));
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
    }];
    
    self.flagLabel = [[UILabel alloc] init];
    self.flagLabel.backgroundColor = HEXCOLOR(0xFF0000);
    self.flagLabel.textColor = [UIColor whiteColor];
    self.flagLabel.layer.cornerRadius = 2;
    self.flagLabel.font = [UIFont systemFontOfSize:11];
    self.flagLabel.layer.masksToBounds = YES;
    [self addSubview:self.flagLabel];
    [self.flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView).offset(5);
        make.top.equalTo(self.iconImageView).offset(5);
        make.height.mas_equalTo(16);
    }];

    
}

- (void)actionTap:(UITapGestureRecognizer *)sender {
    
     [self sendNotificationName:HMHliveCellTapNotification Object:self.model];
}

- (void)setModel:(HMHLivereCommendModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL(model.imagePath)] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.contentLabel.text = model.text;
    
    if (model.hits) {
        NSInteger tempInt = model.hits.integerValue;
        
        if (tempInt >= 10000) {
            CGFloat end = tempInt / 10000.0;
            self.signLabel.text = [NSString stringWithFormat:@"%0.2f万人观看",end];
        } else {
            self.signLabel.text = [NSString stringWithFormat:@"%@人观看",model.hits];
        }
    }
    
    self.flagLabel.hidden = NO;
    switch ([model.videoStatus integerValue]) {
        case 1:
        {
            self.flagLabel.attributedText = @"预告".addBlank;
        }
            break;
        case 2:
        {
            self.flagLabel.attributedText = @"直播中".addBlank;

        }
            break;
        case 3:
        case 4:
        {
            self.flagLabel.attributedText = @"回放".addBlank;

        }
            break;
            
        default:
            self.flagLabel.hidden = YES;
            break;
    }
}

@end
