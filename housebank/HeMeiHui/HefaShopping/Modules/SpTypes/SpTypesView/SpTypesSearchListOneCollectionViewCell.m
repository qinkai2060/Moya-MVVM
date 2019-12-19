//
//  SpTypesSearchListCollectionViewCell.m
//  housebank
//
//  Created by liqianhong on 2019/1/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpTypesSearchListOneCollectionViewCell.h"
#import "HFTextCovertImage.h"

@interface SpTypesSearchListOneCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iimageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *prirceLab;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UILabel *addrssLab;
@property (nonatomic, strong) UILabel *levelLab;
@property (nonatomic, strong) UILabel *cuXiaoLab;
@property (nonatomic, strong) UIButton *toShopBtn;

@property (nonatomic, assign) NSInteger indexPathRow;

@end

@implementation SpTypesSearchListOneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)createView{
    //
    self.iimageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 120,120)];
    [self.contentView addSubview:self.iimageView];
    
    //
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iimageView.frame) + 15, self.iimageView.frame.origin.y - 5, ScreenW - CGRectGetMaxX(self.iimageView.frame) - 25, 40)];
    self.titleLab.font = [UIFont systemFontOfSize:15.0];
    self.titleLab.textColor = RGBACOLOR(51, 51, 51, 1);
    self.titleLab.numberOfLines = 0;
    [self.contentView addSubview:self.titleLab];
    
    //
    self.levelLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.frame.origin.x, CGRectGetMaxY(self.iimageView.frame) - 58, 24, 12)];
    self.levelLab.textColor = [UIColor whiteColor];
    self.levelLab.font = [UIFont systemFontOfSize:9];
    self.levelLab.textAlignment = NSTextAlignmentCenter;
    self.levelLab.layer.masksToBounds = YES;
    self.levelLab.layer.cornerRadius = 3;
    self.levelLab.hidden = YES;
    [self.contentView addSubview:self.levelLab];
    
    //
    self.cuXiaoLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.levelLab.frame) + 3, self.levelLab.frame.origin.y, self.levelLab.frame.size.width, self.levelLab.frame.size.height)];
//    self.cuXiaoLab.layer.borderWidth = 1;
//    self.cuXiaoLab.layer.borderColor = RGBACOLOR(243, 52, 74, 1).CGColor;
    self.cuXiaoLab.font = [UIFont systemFontOfSize:9];
    self.cuXiaoLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.cuXiaoLab.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
    self.cuXiaoLab.textAlignment = NSTextAlignmentCenter;
    self.cuXiaoLab.layer.masksToBounds = YES;
    self.cuXiaoLab.layer.cornerRadius = 2;
    self.cuXiaoLab.hidden = YES;
    [self.contentView addSubview:self.cuXiaoLab];
    
    //
    self.prirceLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.frame.origin.x, CGRectGetMaxY(self.iimageView.frame) - 40, 200, 20)];
    self.prirceLab.textColor = RGBACOLOR(243, 52, 70, 1);
    self.prirceLab.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.prirceLab];
    
    //
    self.numLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.prirceLab.frame) + 5, self.prirceLab.frame.origin.y, 200, self.prirceLab.frame.size.height)];
    self.numLab.font = [UIFont systemFontOfSize:11.0];
    self.numLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:self.numLab];
    
    //
    self.addrssLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.origin.x, CGRectGetMaxY(self.prirceLab.frame)+ 2, self.titleLab.frame.size.width, 20)];
    self.addrssLab.font = [UIFont systemFontOfSize:11.0];
    self.addrssLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:self.addrssLab];
    
    // 进店 按钮
    self.toShopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toShopBtn.frame = CGRectMake(self.addrssLab.frame.origin.x, self.addrssLab.frame.origin.y, self.addrssLab.frame.size.width, self.addrssLab.frame.size.height);
    self.toShopBtn.backgroundColor = [UIColor clearColor];
    [self.toShopBtn addTarget:self action:@selector(toShopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.toShopBtn];
    
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentView.frame.size.height - 1, self.contentView.frame.size.width - 20, 1)];
    lineLab.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    [self.contentView addSubview:lineLab];
}

- (void)refreshCellWithModel:(GetProductListByConditionModel *)model{
    //
    self.indexPathRow = model.cellIndexRow;
    
    NSString *iconStr = model.imageUrl;
    
    if (iconStr.length > 0) {
        NSString *str3 = [iconStr substringToIndex:1];
        if ([str3 isEqualToString:@"/"]) {
            ManagerTools *manageTools =  [ManagerTools ManagerTools];
            if (manageTools.appInfoModel) {
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@!%@/unsharp/true/quality/99",manageTools.appInfoModel.imageServerUrl,iconStr,IMGWH(CGSizeMake(self.iimageView.width, self.iimageView.height))];
                [self.iimageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
            }
        } else {
            [self.iimageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        }
    } else {
         [self.iimageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    }
    self.titleLab.text = model.productName;
    
//    [HFUntilTool thousandsFload:self.smallModel.cashPrice]
//    [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:self.smallModel.cashPrice] twoText:@"3000"];
    NSString *str =[NSString stringWithFormat:@"¥%.2f",[model.price floatValue]];
  //  NSRange range = [str rangeOfString:@"."];//匹配得到的下标
//    self.prirceLab.attributedText = [MyUtil getAttributedWithString:str Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:17.0] range:NSMakeRange(1, range.location)];
     self.prirceLab.attributedText = [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:[model.price floatValue]] twoText:@""];
    CGFloat priceW = [MyUtil getWidthWithFont:[UIFont systemFontOfSize:17.0] height:20 text:str];
    CGRect rect = self.prirceLab.frame;
    rect.size.width = priceW + 5;
    self.prirceLab.frame = rect;
    self.numLab.text = [NSString stringWithFormat:@"月销 %lld 件",[model.salesCount longLongValue]];
    CGRect numrect = self.numLab.frame;
    numrect.origin.x = CGRectGetMaxX(self.prirceLab.frame) + 5;
    self.numLab.frame = numrect;
   
    // 类别
    self.levelLab.hidden = NO;
    if ([[NSString stringWithFormat:@"%@",model.productLevel] isEqualToString:@"1"]) {
        self.levelLab.backgroundColor = RGBACOLOR(240, 23, 21, 1); // I类
        self.levelLab.text = @"I类";
    } else if ([[NSString stringWithFormat:@"%@",model.productLevel] isEqualToString:@"2"]){
        self.levelLab.backgroundColor = RGBACOLOR(253, 134, 9, 1); // II类
        self.levelLab.text = @"II类";

    } else if ([[NSString stringWithFormat:@"%@",model.productLevel] isEqualToString:@"3"]){
        self.levelLab.backgroundColor = RGBACOLOR(165, 165, 165, 1); // III类
        self.levelLab.text = @"III类";
    } else {
        self.levelLab.hidden = YES;
    }
    // 促销
    if (model.promotionTag.length != 0) {
        self.cuXiaoLab.hidden = NO;
        if (self.levelLab.hidden) {
            self.cuXiaoLab.x = self.titleLab.frame.origin.x;
        } else {
            self.cuXiaoLab.x = CGRectGetMaxX(self.levelLab.frame) + 3;
        }
        self.cuXiaoLab.text = model.promotionTag;
    } else {
        self.cuXiaoLab.hidden = YES;
    }
    self.cuXiaoLab.width = [self.cuXiaoLab sizeThatFits:CGSizeMake(100, 15)].width+5;
    // 店铺名称
    NSString *shopStr =[NSString stringWithFormat:@"%@  进店 >",model.shopsName];
    self.addrssLab.attributedText = [MyUtil getAttributedWithString:shopStr Color:RGBACOLOR(102, 102, 102, 1) font:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(shopStr.length - 4, 2)];
}
// 进店按钮点击事件
- (void)toShopBtnClick:(UIButton *)btn{
    if (self.toShopBtnClickBlock) {
        self.toShopBtnClickBlock(self, self.indexPathRow);
    }
}

@end
