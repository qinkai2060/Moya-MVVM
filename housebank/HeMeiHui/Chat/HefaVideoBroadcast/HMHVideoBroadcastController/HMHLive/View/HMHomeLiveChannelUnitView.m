//
//  HMHomeLiveChannelUnitView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHomeLiveChannelUnitView.h"

@interface HMHomeLiveChannelUnitView()

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic,strong)UILabel *firstLabel;

@property (nonatomic,strong)UILabel *secoundLabel;

@property (nonatomic,strong)UILabel *signLabel;

@property (nonatomic,strong)UIImageView *playImageView;

@property (nonatomic,strong)NSMutableArray<UILabel *> *labelArray;

@end

@implementation HMHomeLiveChannelUnitView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementaztion adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray<UILabel *> *)labelArray {
    if (_labelArray == nil) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubview];
        
        [self initMessage];
    }
    return self;
}

- (void)setSubview {
    
    UIImageView *iconImageView = [UIImageView new];
    self.iconImageView = iconImageView;
    [self addSubview:iconImageView];
    [self.iconImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    iconImageView.radius = WScale(4);
    iconImageView.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [iconImageView addGestureRecognizer:tapGesture];
    
//    UIImageView *playImageView = [UIImageView new];
//    self.playImageView = playImageView;
//    [self.iconImageView addSubview:playImageView];
//    [self.playImageView setImage:I(@"play")];
    
    UILabel *contentLabel = [UILabel wd_labelWithText:@"AntV 是蚂蚁金服全新一代数据可视化解决方案，致力于提供一套简单方便、专业可靠、无限可能的数据可视化最佳实践。" font:15 textColorStr:@"#333333"];
    self.contentLabel = contentLabel;
    [self addSubview:contentLabel];
    contentLabel.numberOfLines = 2;
    contentLabel.textAlignment = NSTextAlignmentLeft;
   // contentLabel.userInteractionEnabled = YES;
    
    UILabel *firstLabel = [UILabel wd_labelWithText:@"资讯" font:10 textColorStr:@"#FFFFFF"];
    self.firstLabel = firstLabel;
    [self addSubview:firstLabel];
    firstLabel.backgroundColor = [UIColor colorWithHexString:@"#4D88FF"];
    firstLabel.radius = 2;
    firstLabel.alpha = 0;
 //   firstLabel.userInteractionEnabled = YES;
    
    
    UILabel *secoundLabel = [UILabel wd_labelWithText:@"发布会" font:10 textColorStr:@"#FFFFFF"];
    self.secoundLabel = secoundLabel;
    [self addSubview:secoundLabel];
    secoundLabel.backgroundColor = [UIColor colorWithHexString:@"#4D88FF"];
    secoundLabel.radius = 2;
    secoundLabel.alpha = 0;
  //  secoundLabel.userInteractionEnabled = YES;
    
    [self.labelArray addObject:firstLabel];
    [self.labelArray addObject:secoundLabel];
    
    UILabel *signLabel = [UILabel wd_labelWithText:@"13.1万人观看" font:12 textColorStr:@"#AAAAAA"];
    self.signLabel = signLabel;
    [self addSubview:signLabel];
    signLabel.textAlignment = NSTextAlignmentLeft;
  //  signLabel.userInteractionEnabled = YES;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self);
        make.height.mas_equalTo(WScale(90));
        make.width.mas_equalTo(WScale(140));
    }];
    
//    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.iconImageView);
//    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self);
        make.leading.mas_equalTo(iconImageView.mas_trailing).mas_offset(WScale(15));
    }];
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentLabel.mas_leading);
    
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(WScale(10));
     //   make.width.mas_equalTo(WScale(30));
        
    }];
    [self.secoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.firstLabel.mas_trailing).mas_offset(WScale(15));
        
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(WScale(10));
      //  make.width.mas_equalTo(WScale(40));
        
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.firstLabel.mas_bottom).mas_offset(WScale(5));
    }];
    
    
}

- (void)actionTap:(UITapGestureRecognizer *)sender {
    if (self.model) {
        [self sendNotificationName:HMHliveCellTapNotification Object:self.model];
    } else if (self.attentionModel) {
        [self sendNotificationName:HMHliveCellTapNotification Object:self.attentionModel];
    } else {
        
        [self sendNotificationName:HMHliveCellTapNotification Object:self.listNewModel];
    }
}
- (void)initMessage {
    
    @weakify(self)
    [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.model) {
          [self sendNotificationName:HMHliveCellTapNotification Object:self.model];
        } else if (self.attentionModel) {
           [self sendNotificationName:HMHliveCellTapNotification Object:self.attentionModel];
        } else {
            
            [self sendNotificationName:HMHliveCellTapNotification Object:self.listNewModel];
        }
        
        
    }];
    
}

- (void)setModel:(HMHLivereCommendModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL(model.imagePath)] placeholderImage:ImageLive(@"SpTypes_default_image")];
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
    
    //标签
    NSString *text = model.videoTagName;
    
    if (text.length > 0) {
        
        NSArray<NSString *> *titleArray = [text componentsSeparatedByString:@","];
        
        for (int i = 0; i < titleArray.count; i++) {
            if (i >= 2) {
                break;
            }
            self.labelArray[i].attributedText = [titleArray[i] addBlank];
            self.labelArray[i].alpha = 1;
        }
    }
    
}

- (void)setAttentionModel:(HMHLiveAttentionModel *)attentionModel {
    _attentionModel = attentionModel;
    if (attentionModel.coverImageUrl) {
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL(attentionModel.coverImageUrl)] placeholderImage:ImageLive(@"SpTypes_default_image")];
    }
    if (attentionModel.title) {
         self.contentLabel.text = attentionModel.title;
    }
   
    
    if (attentionModel.hits) {
        NSInteger tempInt = attentionModel.hits.integerValue;
        
        if (tempInt >= 10000) {
            CGFloat end = tempInt / 10000.0;
            self.signLabel.text = [NSString stringWithFormat:@"%0.2f万人观看",end];
        } else {
            self.signLabel.text = [NSString stringWithFormat:@"%@人观看",attentionModel.hits];
        }
    }
    
    //标签
    NSString *text = attentionModel.videoTagName;
    
    if (text.length > 0) {
        
        NSArray<NSString *> *titleArray = [text componentsSeparatedByString:@","];
        
        for (int i = 0; i < titleArray.count; i++) {
            
            if (i >= 2) {
                break;
            }
            
            self.labelArray[i].attributedText = [titleArray[i] addBlank];
            self.labelArray[i].alpha = 1;
        }
    }
    
}

- (void)setListNewModel:(HMHVideoListNewModel *)listNewModel {
    _listNewModel = listNewModel;
    if (listNewModel.coverImageUrl) {
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL(listNewModel.coverImageUrl)] placeholderImage:ImageLive(@"SpTypes_default_image")];
    }
    if (listNewModel.title) {
        self.contentLabel.text = listNewModel.title;
    }
    
    
    if (listNewModel.hits) {
        NSInteger tempInt = listNewModel.hits.integerValue;
        
        if (tempInt >= 10000) {
            CGFloat end = tempInt / 10000.0;
            self.signLabel.text = [NSString stringWithFormat:@"%0.2f万人观看",end];
        } else {
            self.signLabel.text = [NSString stringWithFormat:@"%@人观看",listNewModel.hits];
        }
    }
    
    NSLog(@"+++++++++++++++%@",imageURL(listNewModel.coverImageUrl));
    
    //标签
    NSString *text = listNewModel.videoTagName;
    
    if (text.length > 0) {
        
        NSArray<NSString *> *titleArray = [text componentsSeparatedByString:@","];
        
        for (int i = 0; i < titleArray.count; i++) {
            if (i >= 2) {
                break;
            }
            self.labelArray[i].attributedText = [titleArray[i] addBlank];
            self.labelArray[i].alpha = 1;        }
    }
    
    
}

@end














