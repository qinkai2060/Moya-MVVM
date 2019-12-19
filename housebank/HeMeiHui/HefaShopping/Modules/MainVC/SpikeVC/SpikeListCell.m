//
//  SpikeListCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/20.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpikeListCell.h"
#import "UILable+addSetWidthAndheight.h"

@implementation SpikeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.HMH_iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 120, 120)];
    self.HMH_iconImage.layer.masksToBounds = YES;
    self.HMH_iconImage.layer.cornerRadius = 5;
    [self.contentView addSubview:self.HMH_iconImage];
    
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_iconImage.frame) + 15, self.HMH_iconImage.frame.origin.y, ScreenW - CGRectGetMaxX(self.HMH_iconImage.frame) - 45, 40)];
    self.HMH_titleLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.HMH_titleLab.numberOfLines=0;
    self.HMH_titleLab.textColor = HEXCOLOR(0x333333);
    [self.contentView addSubview:self.HMH_titleLab];
    
    //
    self.HMH_subLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_titleLab.frame)+5, self.HMH_titleLab.frame.size.width, 15)];
    self.HMH_subLab.textColor = RGBACOLOR(133, 133, 133, 1);
    self.HMH_subLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [self.contentView addSubview:self.HMH_subLab];
    
    //
    self.HMH_subscribeNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_subLab.frame.origin.x, CGRectGetMaxY(self.HMH_subLab.frame)+35, 100, 15)];
    self.HMH_subscribeNumLab.textColor = HEXCOLOR(0xF3344A);
    self.HMH_subscribeNumLab.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.HMH_subscribeNumLab];
    
    //
    self.HMH_contentNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_subscribeNumLab.frame) + 5, CGRectGetMaxY(self.HMH_subLab.frame)+37, 100, 10)];
    self.HMH_contentNumLab.textColor = HEXCOLOR(0x999999);
    self.HMH_contentNumLab.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:self.HMH_contentNumLab];
    self.progressView = [[SptimeKillProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_iconImage.frame) + 15, self.HMH_subLab.bottom+5, 120, 13)];
    self.progressView.gradientLayer.colors =    @[(id)HEXCOLOR(0xFF3939).CGColor,(id)HEXCOLOR(0xF5981B).CGColor];
    self.progressView.hidden = YES;
    [self.contentView addSubview:self.progressView];
    [self.contentView.layer addSublayer:self.gradientLayer];
    self.gradientLayer.frame = CGRectMake(ScreenW - 15 - 70, CGRectGetMaxY(self.HMH_subLab.frame)+25+5, 70, 25);
    //
    self.HMH_subscribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_subscribeBtn.frame = CGRectMake(ScreenW - 15 - 70, CGRectGetMaxY(self.HMH_subLab.frame)+25+5, 70, 25);
    [self.HMH_subscribeBtn setTitle:@"去抢购" forState:UIControlStateNormal];
    self.HMH_subscribeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.HMH_subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.HMH_subscribeBtn.layer.masksToBounds = YES;
    self.HMH_subscribeBtn.layer.cornerRadius = 12.5;
    self.HMH_subscribeBtn.userInteractionEnabled=NO;
    [self.contentView addSubview:self.HMH_subscribeBtn];
//    [self refreshCellWithModel:nil];
}

- (void)refreshCellWithModel:(id)model{
    self.itemmodel=model;
    self.HMH_iconImage.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    self.HMH_titleLab.text = self.itemmodel.productName;
    self.HMH_subLab.text = self.itemmodel.productSubtitle;
    /*
     [self.HMH_subscribeBtn setTitle:@"去抢购" forState:UIControlStateNormal];
     [self.HMH_subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     self.HMH_subscribeBtn.enabled = YES;
     self.gradientLayer.hidden = NO;
     **/
    [self.HMH_subscribeBtn setTitle:self.itemmodel.stateStr forState:UIControlStateNormal];
    [self.HMH_subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([self.itemmodel.stateStr isEqualToString:@"去抢购"]) {
        self.HMH_subscribeBtn.enabled = YES;
        self.gradientLayer.hidden = NO;
        self.progressView.hidden = NO;
        self.progressView.progress = self.itemmodel.progress;
        self.progressView.stateLb.text = [NSString stringWithFormat:@"已抢%ld件",self.itemmodel.purchasedQuantity];
        CGFloat progress = self.itemmodel.progress*100.0;
        if(progress < 1 &&progress >0 ) {
            progress = 1;
        }
        if (progress>=99 && progress<100) {
            progress = 99;
        }
        self.progressView.percentageLb.text = [NSString stringWithFormat:@"%.f%%",floor(progress)];
    }else if ([self.itemmodel.stateStr isEqualToString:@"已抢光"]) {
        self.HMH_subscribeBtn.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
        [self.HMH_subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.HMH_subscribeBtn.enabled = NO;
        self.gradientLayer.hidden = YES;
        self.progressView.hidden = NO;
        self.progressView.progress = 1.0;
        self.progressView.stateLb.text = @"已抢光";
        self.progressView.percentageLb.text = @"";
    }else if ([self.itemmodel.stateStr isEqualToString:@"即将开始"]) {
        self.HMH_subscribeBtn.backgroundColor = [UIColor whiteColor];
        self.HMH_subscribeBtn.layer.borderWidth = 0.5;
        self.HMH_subscribeBtn.layer.borderColor = [UIColor colorWithHexString:@"5BB63A"].CGColor;
        self.HMH_subscribeBtn.layer.cornerRadius = 12.5;
        self.HMH_subscribeBtn.layer.masksToBounds = YES;
        [self.HMH_subscribeBtn setTitleColor:[UIColor colorWithHexString:@"5BB63A"] forState:UIControlStateNormal];
        self.HMH_subscribeBtn.enabled = YES;
        self.gradientLayer.hidden = YES;
        self.progressView.hidden = YES;
    }else {
        self.HMH_subscribeBtn.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
        self.HMH_subscribeBtn.enabled = NO;
        self.gradientLayer.hidden = YES;
        self.progressView.hidden = YES;
    }
   
    [self.HMH_iconImage sd_setImageWithURL:[self.itemmodel.productImage get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    NSString *str=@"";
    if (self.itemmodel.promotionPrice) {
        str =[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:self.itemmodel.promotionPrice]];
    }else
    {
        str =[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:self.itemmodel.cashPrice]];
    }
    
    NSRange range = [str rangeOfString:@"."];//匹配得到的下标
    self.HMH_subscribeNumLab.attributedText = [MyUtil getAttributedWithString:str Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:17.0] range:NSMakeRange(1, range.location)];
    UIFont *font1=PFR17Font;
    CGFloat width1=[UILabel getWidthWithTitle:str font:font1];
    self.HMH_subscribeNumLab.width=width1;
    
    if (self.itemmodel.promotionPrice) {//有促销价显示
        NSString *str2=[HFUntilTool thousandsFload:self.itemmodel.cashPrice];
        NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:str2 lineColor:HEXCOLOR(0x666666)];
        CGFloat width2=[UILabel getWidthWithTitle:str2 font:[UIFont systemFontOfSize:10.0]];
        self.HMH_contentNumLab.attributedText=setLineStr;
        //    self.HMH_contentNumLab.width=width2;
        self.HMH_contentNumLab.frame=CGRectMake(self.HMH_subscribeNumLab.rightX, CGRectGetMaxY(self.HMH_subLab.frame)+37+5, width2, 10);
    }
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];//渐变数组
        gradientLayer.cornerRadius = 12.5;
        gradientLayer.masksToBounds = YES;
        gradientLayer.hidden = YES;
        _gradientLayer = gradientLayer;
        //        [self.layer addSublayer:gradientLayer];
    }
    return _gradientLayer;
}
@end
