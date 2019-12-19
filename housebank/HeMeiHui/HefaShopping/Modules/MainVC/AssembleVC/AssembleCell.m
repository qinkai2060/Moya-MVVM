//
//  AssembleCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/21.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleCell.h"
#import "UIView+addGradientLayer.h"
#import "UILable+addSetWidthAndheight.h"
@interface AssembleCell ()<ZJJTimeCountDownDelegate>
{
    dispatch_source_t _timer;
}
@end
@implementation AssembleCell

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
    //icon图片
    self.HMH_iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 120, 120)];
    self.HMH_iconImage.layer.masksToBounds = YES;
    self.HMH_iconImage.layer.cornerRadius = 5;
    [self.contentView addSubview:self.HMH_iconImage];
    //    倒计时
    self.twoTimeLabel=[[ZJJTimeCountDownLabel alloc]initWithFrame:CGRectMake(0, self.HMH_iconImage.height-9-20, self.HMH_iconImage.width, 20)];
    [self.HMH_iconImage addSubview:self.twoTimeLabel];
//    self.timerLable= [[UILabel alloc] initWithFrame:CGRectMake(0, self.HMH_iconImage.height-9-20, self.HMH_iconImage.width, 20)];
//    self.timerLable.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
//    self.timerLable.textColor = HEXCOLOR(0xFFFFFF);
//    self.timerLable.backgroundColor=HEXCOLOR(0x000000);
//    self.timerLable.alpha=0.6;
//    self.timerLable.text=@"54天 7时 3分 6秒";
//    self.timerLable.textAlignment=NSTextAlignmentCenter;
//    [self.HMH_iconImage addSubview:self.timerLable];
    //主标题
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_iconImage.frame) + 15, self.HMH_iconImage.frame.origin.y, ScreenW - CGRectGetMaxX(self.HMH_iconImage.frame) - 45, 40)];
    self.HMH_titleLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.HMH_titleLab.numberOfLines=0;
    self.HMH_titleLab.textColor = HEXCOLOR(0x333333);
    [self.contentView addSubview:self.HMH_titleLab];
//    [cell.timeLabel setupCellWithModel:model indexPath:indexPath];
//    //在不设置为过时自动删除情况下 设置该方法后，滑动过快的时候时间不会闪情况
//    cell.timeLabel.attributedText = [self.countDown countDownWithTimeLabel:cell.timeLabel];
    //副标题
    self.HMH_subLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_titleLab.frame)+5, self.HMH_titleLab.frame.size.width, 15)];
    self.HMH_subLab.textColor =  HEXCOLOR(0x999999);
    self.HMH_subLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [self.contentView addSubview:self.HMH_subLab];
//    标签，待定
    self.tagLable= [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_subLab.frame)+5, 33, 14)];
    self.tagLable.textColor =  HEXCOLOR(0xFFFFFF);
    self.tagLable.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    self.tagLable.backgroundColor=HEXCOLOR(0xF63019);
    [self.contentView addSubview:self.HMH_subLab];
//    提醒剩余时间
    self.timerAlterLable= [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_subLab.frame)+5, self.HMH_titleLab.frame.size.width, 15)];
    self.timerAlterLable.textColor =  HEXCOLOR(0xF3344A);
    self.timerAlterLable.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [self.contentView addSubview:self.timerAlterLable];
    //现价
    self.HMH_subscribeNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_subLab.frame.origin.x, CGRectGetMaxY(self.tagLable.frame)+9, 100, 15)];
    self.HMH_subscribeNumLab.textColor = HEXCOLOR(0xF3344A);
    self.HMH_subscribeNumLab.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.HMH_subscribeNumLab];
    
    //原价
    self.HMH_contentNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_subscribeNumLab.frame) + 5, CGRectGetMaxY(self.tagLable.frame)+16, 100, 10)];
    self.HMH_contentNumLab.textColor = HEXCOLOR(0x999999);
    self.HMH_contentNumLab.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:self.HMH_contentNumLab];
    
    //
    self.HMH_subscribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_subscribeBtn.frame = CGRectMake(ScreenW - 15 - 57, CGRectGetMaxY(self.tagLable.frame)+5, 57, 25);
    [self.HMH_subscribeBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [self.HMH_subscribeBtn setTitle:@"去拼团" forState:UIControlStateNormal];
    self.HMH_subscribeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.HMH_subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.HMH_subscribeBtn.layer.masksToBounds = YES;
    self.HMH_subscribeBtn.layer.cornerRadius = 12.5;
    self.HMH_subscribeBtn.userInteractionEnabled=NO;
    [self.contentView addSubview:self.HMH_subscribeBtn];
   
    self.lineLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 139, ScreenW-30, 1)];
    self.lineLable.backgroundColor=HEXCOLOR(0xE5E5E5);
    [self.contentView addSubview:self.lineLable];
   
}
//设置倒计时
- (void)setupTwoTimeLabelP{
    //    隐藏计数字
    //自定义模式，
    self.twoTimeLabel.textStyle = ZJJTextStlyeCustom;
    //设置水平方向居中
    self.twoTimeLabel.jj_textAlignment = ZJJTextAlignmentStlyeHorizontalCenter;
    //设置偏左距离
    self.twoTimeLabel.textLeftDeviation = 0;
    //过时后保留最终的样式
    self.twoTimeLabel.isRetainFinalValue = YES;
    self.twoTimeLabel.backgroundColor=HEXCOLOR(0x000000);
    self.twoTimeLabel.alpha=0.6;
    //整体背景图片
    //    self.twoTimeLabel.backgroundImage = [UIImage imageNamed:@"timeBackground2"];
  
}
- (void)refreshCellWithModel:(id)model{
        DataItem *dataItem=model;
    if (dataItem.endDate) {//结束日期有值
        self.spacEndDateTime=[NSString stringWithFormat:@"%ld",(long)dataItem.endDate];
        //  设置倒计时时间
        NSString *nowTime=[MyUtil getNowTimeTimestamp3];
        self.spaceTime=[MyUtil compareTwoTime:self.spacEndDateTime time2:nowTime];
    }

    self.HMH_iconImage.backgroundColor = RGBACOLOR(239, 239, 239, 1);
   
    [self.HMH_iconImage sd_setImageWithURL:[dataItem.imageUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
//    self.HMH_iconImage
    self.HMH_titleLab.text = dataItem.activeTitle;
    self.HMH_subLab.text =dataItem.activeSubtitle1;
    
    // timeStampString 是服务器返回的13位时间戳
    NSString *timeStampString  =[NSString stringWithFormat:@"%ld",(long)dataItem.startDate];
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
 
    self.timerAlterLable.text=[NSString stringWithFormat:@"%@开始",dateString];
    
    NSString *str =@"";
    if (dataItem.price&&dataItem.price!=0) {
        str =[HFUntilTool thousandsFload:dataItem.price];
    }else
    {
         str =[HFUntilTool thousandsFload:dataItem.naturalPrice];

    }
  
    NSRange range = [str rangeOfString:@"."];//匹配得到的下标
    self.HMH_subscribeNumLab.attributedText = [MyUtil getAttributedWithString:str Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:17.0] range:NSMakeRange(1, range.location)];
    UIFont *font1=PFR17Font;
    CGFloat width1=[UILabel getWidthWithTitle:str font:font1];
    self.HMH_subscribeNumLab.width=width1;
    NSString *str2=[NSString stringWithFormat:@"¥%.2f",dataItem.naturalPrice];
    NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:str2 lineColor:HEXCOLOR(0x666666)];
    CGFloat width2=[UILabel getWidthWithTitle:str2 font:[UIFont systemFontOfSize:10.0]];
    if (dataItem.price&&dataItem.price!=0) {
        
        self.HMH_contentNumLab.attributedText=setLineStr;
        //    self.HMH_contentNumLab.width=width2;
        self.HMH_contentNumLab.frame=CGRectMake(self.HMH_subscribeNumLab.rightX, CGRectGetMaxY(self.tagLable.frame)+16, width2, 10);
    }
    
   
    switch (self.changeType) {
        case UnderwayType:
        {//正在进行
            self.timerAlterLable.hidden=YES;
            self.HMH_subscribeBtn.hidden=NO;
            self.twoTimeLabel.hidden=NO;
            self.twoTimeLabel.hidden=NO;
            //    添加倒计时
            self.countDown.timeStyle = ZJJCountDownTimeStyleTamp;
            self.countDown.delegate = self;
            [self setupTwoTimeLabelP];
            //  设置倒计时时间
           if ([self.spaceTime intValue]>0) {
               [self.countDown addTimeLabel:self.twoTimeLabel time:[ZJJTimeCountDownDateTool dateByAddingSeconds:self.spaceTime timeStyle:self.countDown.timeStyle]];
            }else
            {
              self.twoTimeLabel.hidden=YES;
            }
            
            
            self.HMH_subscribeNumLab.frame=CGRectMake(self.HMH_subLab.frame.origin.x, CGRectGetMaxY(self.tagLable.frame)+9, width1, 15);
            self.HMH_contentNumLab.frame=CGRectMake(self.HMH_subscribeNumLab.rightX, CGRectGetMaxY(self.tagLable.frame)+16, width2, 10);
        }
            break;
        case WillBeginType:
        {//即将开始
             self.twoTimeLabel.hidden=YES;
            self.timerAlterLable.hidden=NO;
            self.HMH_subscribeBtn.hidden=YES;
             self.HMH_subscribeNumLab.frame=CGRectMake(self.HMH_subLab.frame.origin.x, CGRectGetMaxY(self.tagLable.frame)+13, width1, 15);
            self.HMH_contentNumLab.frame=CGRectMake(self.HMH_subscribeNumLab.rightX, CGRectGetMaxY(self.tagLable.frame)+20, width2, 10);
        }
            break;
        case EndType:
        {//已结束
              self.twoTimeLabel.hidden=YES;
            self.HMH_subscribeBtn.hidden=YES;
            self.timerAlterLable.hidden=YES;
             self.HMH_subscribeNumLab.frame=CGRectMake(self.HMH_subLab.frame.origin.x, CGRectGetMaxY(self.tagLable.frame)+9,width1, 15);
            self.HMH_contentNumLab.frame=CGRectMake(self.HMH_subscribeNumLab.rightX, CGRectGetMaxY(self.tagLable.frame)+16, width2, 10);
        }
            break;
            
        default:
            break;
    }
}

//过时回调方法
- (void)outDateTimeLabel:(ZJJTimeCountDownLabel *)timeLabel timeCountDown:(ZJJTimeCountDown *)timeCountDown{
    
    if ([timeLabel isEqual:self.twoTimeLabel]) {
        self.twoTimeLabel.textColor = [UIColor redColor];
        
    }
    
}

- (NSAttributedString *)customTextWithTimeLabel:(ZJJTimeCountDownLabel *)timeLabel timeCountDown:(ZJJTimeCountDown *)timeCountDown{
    
    if ([timeLabel isEqual:self.twoTimeLabel]) {
        
//        NSArray *textArray = @[[NSString stringWithFormat:@" %.2ld",(long)timeLabel.days],
//                               @"天",
//                               [NSString stringWithFormat:@" %.2ld",(long)timeLabel.hours],
//                               @"时",
//                               [NSString stringWithFormat:@" %.2ld",(long)timeLabel.minutes],
//                               @"分",
//                               [NSString stringWithFormat:@" %.2ld",(long)timeLabel.seconds],
//                               @"秒"];
//        return [self dateAttributeWithTexts:textArray];
        self.twoTimeLabel.text=[NSString stringWithFormat:@"%.2ld天 %.2ld时 %.2ld分 %.2ld秒",(long)timeLabel.days,(long)timeLabel.hours,(long)timeLabel.minutes,(long)timeLabel.seconds];
        self.twoTimeLabel.textAlignment=NSTextAlignmentCenter;
        self.twoTimeLabel.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.6];
        self.twoTimeLabel.font=[UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        self.twoTimeLabel.backgroundColor=HEXCOLOR(0x000000);
        self.twoTimeLabel.alpha=0.6;
    }
    return nil;
}

- (NSAttributedString *)dateAttributeWithTexts:(NSArray *)texts{
    
//    NSDictionary *datedic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeWidthAttributeName:@(0),NSStrokeColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:HEXCOLOR(0x323232)};
    NSDictionary *datedic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeWidthAttributeName:@(0),NSStrokeColorAttributeName:[UIColor whiteColor]};
    NSMutableAttributedString *dateAtt = [[NSMutableAttributedString alloc] init];
    
    [texts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *text = (NSString *)obj;
        text = text ? text : @"";
        //说明是时间字符串
        if ([text integerValue] || [text rangeOfString:@"0"].length) {
            [dateAtt appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:datedic]];
            
        }else{
            //          UIColor *color = (idx+1)%4?[UIColor greenColor]:[UIColor blueColor];
            UIColor *color=[UIColor whiteColor];
            [dateAtt appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:color}]];
        }
        
    }];
    return dateAtt;
}

- (ZJJTimeCountDown *)countDown{
    
    if (!_countDown) {
        
        _countDown = [[ZJJTimeCountDown alloc] init];
    }
    return _countDown;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)dealloc{
    [self.countDown destoryTimer];
}

@end
