//
//  MygroupTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MygroupTableViewCell.h"
#import "MyGroupModel.h"
#import "HandleEventDefine.h"
@interface MygroupTableViewCell ()<ZJJTimeCountDownDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;      // 图片
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;           // 新人团标签
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;     // 主标题
@property (weak, nonatomic) IBOutlet UILabel *titleContentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleContentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;         // 售出
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;     // 参团
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;   // 参团人数
@property (weak, nonatomic) IBOutlet UILabel *afterDiscountLabel; // 折扣后钱
@property (weak, nonatomic) IBOutlet UILabel *beforeDiscountLabel;// 折扣前的钱
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *defineBtn;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (nonatomic, strong) MyGroupItemModel * itemModel;

@end
@implementation MygroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = 7.5;
    
    self.defineBtn.layer.masksToBounds = YES;
    self.defineBtn.layer.cornerRadius = 12.5;
    
    @weakify(self);
    [[self.defineBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:MineGroupTouch userInfo:@{@"orderNo":objectOrEmptyStr(self.itemModel.orderNo),
                                                             @"changeType":self.changeType == EndType ? @"已结束":@"正在进行"
                                                             }];
    }];
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    MyGroupModel * myGroupModel = (MyGroupModel *)data;
    self.itemModel = myGroupModel.dataSource.firstObject;
  
    if ([self.itemModel.activeType isEqual:@1]) {
        self.tagLabel.text = @"新人团";
        self.tagLabel.hidden = NO;
        self.mainTitleLabel.text = [@"          " stringByAppendingString:objectOrEmptyStr(self.itemModel.activeTitle)];
    }else {
        self.tagLabel.hidden = YES;
        self.mainTitleLabel.text = objectOrEmptyStr(self.itemModel.activeTitle);
    }
    
    self.titleContentLabel1.text = objectOrEmptyStr(self.itemModel.activeSubtitle1);
    self.titleContentLabel2.text = objectOrEmptyStr(self.itemModel.activeSubtitle2);
    self.countLabel.text = [NSString stringWithFormat:@"已售%@",objectOrEmptyStr(self.itemModel.initialNumber.description)];
    self.peopleNumLabel.text = [NSString stringWithFormat:@"参团人数%@",self.itemModel.groupNum.description];
    self.peopleCountLabel.text = [NSString stringWithFormat:@"(%@人团)",self.itemModel.activeNum.description];
    self.afterDiscountLabel.text = [NSString stringWithFormat:@"¥%@",objectOrEmptyStr(self.itemModel.cashPrice.description)];

    NSString * beforeString = [NSString stringWithFormat:@"¥%@",objectOrEmptyStr(self.itemModel.peaceTimeCashPric.description)];
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:beforeString attributes:attribtDic];
    self.beforeDiscountLabel.attributedText = attribtStr;
    if (self.itemModel.cashPrice.description.length == 0) {
        self.afterDiscountLabel.hidden = YES;
    }else {
         self.afterDiscountLabel.hidden = NO;
    }
    if (self.itemModel.peaceTimeCashPric.description == 0) {
        self.beforeDiscountLabel.hidden = YES;
    }else {
        self.beforeDiscountLabel.hidden = NO;
    }
    
    NSTimeInterval interval    =[self.itemModel.createDate.description doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    self.timeLabel.text = [NSString stringWithFormat:@"开团时间: %@",dateString];
    
    /** 时间戳比较*/
    if(self.itemModel.groupEndDate.description) {
        NSString *nowTime=[MyUtil getNowTimeTimestamp3];
        self.speaceTime =[MyUtil compareTwoTime:self.itemModel.groupEndDate.description time2:nowTime];
        /** 判断当前的状态是不是已经结束*/
        if (self.speaceTime > 0) {
            // 则结束时间大于当前时间,那么开启定时器
            self.changeType = UnderNowType;
        }else {
            // 则说明已经结束
            self.changeType = EndType;
        }
    }
    [self.iconImage sd_setImageWithURL:[self.itemModel.imageUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
   
}

- (void)setChangeType:(StateType)changeType {
    if (changeType == EndType) {
        self.endLabel.text = @"已结束";
    }else if(changeType == UnderNowType) {
        //    添加倒计时
        [self.countDown addTimeLabel:self.twoTimeLabel time:[ZJJTimeCountDownDateTool dateByAddingSeconds:self.speaceTime timeStyle:self.countDown.timeStyle]];
        self.countDown.timeStyle = ZJJCountDownTimeStyleTamp;
        self.countDown.delegate = self;
    }
}

//过时回调方法
- (void)outDateTimeLabel:(ZJJTimeCountDownLabel *)timeLabel timeCountDown:(ZJJTimeCountDown *)timeCountDown{
    
}

/** 定时器的代理回调*/
- (NSAttributedString *)customTextWithTimeLabel:(ZJJTimeCountDownLabel *)timeLabel timeCountDown:(ZJJTimeCountDown *)timeCountDown{
    self.endLabel.text=[NSString stringWithFormat:@"%.2ld天%.2ld时%.2ld分%.2ld秒",(long)timeLabel.days,(long)timeLabel.hours,(long)timeLabel.minutes,(long)timeLabel.seconds];
    self.endLabel.textAlignment=NSTextAlignmentCenter;
    self.endLabel.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.6];
    self.endLabel.font=[UIFont systemFontOfSize:8 weight:UIFontWeightRegular];
    self.endLabel.backgroundColor=HEXCOLOR(0x000000);
    self.endLabel.alpha=0.6;
    return nil;
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self rounterEventWithName:MineGroupTouch userInfo:@{@"orderNo":objectOrEmptyStr(self.itemModel.orderNo),
//          @"changeType":self.changeType == EndType ? @"已结束":@"正在进行"
//                                                         }];
}

+ (id)loadFromXib {
    MygroupTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                      owner:self
                                                                    options:nil][0];
    return cell;
}

#pragma -- lazy load 
- (MyGroupItemModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[MyGroupItemModel alloc]init];
    }
    return _itemModel;
}

- (ZJJTimeCountDown *)countDown{
    if (!_countDown) {
        _countDown = [[ZJJTimeCountDown alloc] init];
        _countDown.timeStyle = ZJJCountDownTimeStyleTamp;
        _countDown.delegate = self;
    }
    return _countDown;
}

- (ZJJTimeCountDownLabel *)twoTimeLabel {
    if (!_twoTimeLabel) {
        _twoTimeLabel = [[ZJJTimeCountDownLabel alloc]init];
        _twoTimeLabel.textStyle = ZJJTextStlyeCustom;
        _twoTimeLabel.isRetainFinalValue = YES;
    }
    return _twoTimeLabel;
}

- (void)dealloc {
     [self.countDown destoryTimer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
