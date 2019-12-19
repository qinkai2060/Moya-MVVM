//
//  SpTypesSearchListTableViewCell.m
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesSearchListTableViewCell.h"
// 140
@interface SpTypesSearchListTableViewCell ()

@property (nonatomic, strong) UIImageView *iimageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *prirceLab;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UILabel *addrssLab;

@end

@implementation SpTypesSearchListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    //
    self.iimageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120,120)];
    [self.contentView addSubview:self.iimageView];
    
    //
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iimageView.frame) + 10, self.iimageView.frame.origin.y, ScreenW - CGRectGetMaxX(self.iimageView.frame) - 20, 50)];
    self.titleLab.font = [UIFont systemFontOfSize:15.0];
    self.titleLab.textColor = RGBACOLOR(51, 51, 51, 1);
    self.titleLab.numberOfLines = 0;
    [self.contentView addSubview:self.titleLab];
    
    //
    self.prirceLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.frame.origin.x, CGRectGetMaxY(self.iimageView.frame) - 50, 200, 20)];
    self.prirceLab.textColor = RGBACOLOR(243, 52, 70, 1);
    self.prirceLab.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.prirceLab];
    
    //
    self.numLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.prirceLab.frame) + 5, self.prirceLab.frame.origin.y, 200, self.prirceLab.frame.size.height)];
    self.numLab.font = [UIFont systemFontOfSize:11.0];
    self.numLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:self.numLab];
    
    //
    self.addrssLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.origin.x, CGRectGetMaxY(self.prirceLab.frame) + 5, self.titleLab.frame.size.width, 20)];
    self.addrssLab.font = [UIFont systemFontOfSize:11.0];
    self.addrssLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:self.addrssLab];
}

- (void)refreshCellWithModel:(GetProductListByConditionModel *)model{
    //
    self.iimageView.backgroundColor = [UIColor grayColor];
    
    NSString *iconStr = [NSString stringWithFormat:@"%@%@%@",@"https://img-test0.hfhomes.cn",model.imageUrl,@"!D02"];
            [self.iimageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLab.text = model.productName;
    
    NSString *str =[NSString stringWithFormat:@"¥%.2f",[model.price floatValue]];
    NSRange range = [str rangeOfString:@"."];//匹配得到的下标
    self.prirceLab.attributedText = [MyUtil getAttributedWithString:str Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:17.0] range:NSMakeRange(1, range.location)];
    
    CGFloat priceW = [MyUtil getWidthWithFont:[UIFont systemFontOfSize:17.0] height:20 text:str];
    CGRect rect = self.prirceLab.frame;
    rect.size.width = priceW + 5;
    self.prirceLab.frame = rect;
    self.numLab.text = [NSString stringWithFormat:@"月销 %lld 件",[model.salesCount longLongValue]];
    CGRect numrect = self.numLab.frame;
    numrect.origin.x = CGRectGetMaxX(self.prirceLab.frame) + 5;
    self.numLab.frame = numrect;
    
    self.addrssLab.text = [NSString stringWithFormat:@"%@  %@",model.cityName,model.regionName];
}

@end
