//
//  WARDiaryWeatherCollectionViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import "WARDiaryWeatherCollectionViewCell.h"

#import "WARMacros.h"
#import "WARLocalizedHelper.h"
#import "Masonry.h"
#import "UIView+WARSetCorner.h"
#import "WARUIHelper.h"
#import "NSString+Size.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "WARNewUserDiaryMonthModel.h"

@interface WARDiaryWeatherCollectionViewCell()
@property (nonatomic, strong) UIImageView *containerV;

@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *yearLab;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIView *line;

@end
@implementation WARDiaryWeatherCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kColor(whiteColor);
        
        [self.contentView addSubview:self.containerV];
        [self.containerV addSubview:self.textLab];
        [self.containerV addSubview:self.dateLab];
        [self.containerV addSubview:self.line];
        [self.containerV addSubview:self.yearLab];
    }
    return self;
}


- (void)containerVWithCorner{
    CGFloat width =self.bounds.size.width;
    CGFloat height =self.bounds.size.height-30;
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:5];
    CAShapeLayer* maskLayer = [CAShapeLayer new];
    maskLayer.frame = CGRectMake(0, 0, width, height);
    maskLayer.path = maskPath.CGPath;
    self.containerV.layer.mask = maskLayer;
}

#pragma mark - setter / getter methods

- (void)setMonthModel:(WARNewUserDiaryMonthModel *)monthModel {
    _monthModel = monthModel;
    
    //data
    if (monthModel.count > 0) {
        self.textLab.text = [NSString stringWithFormat:@"%ld篇",monthModel.count];
    } else {
        self.textLab.text = @"";
    }
      
    self.dateLab.text = [NSString stringWithFormat:@"%@月",monthModel.month];
    if (monthModel.showYear) {
        self.yearLab.text = [NSString stringWithFormat:@"%@",monthModel.year];
        self.line.hidden = NO;
    } else {
        self.line.hidden = YES;
        self.yearLab.text = @"";
    }
    UIImage *image = [UIImage war_imageName:monthModel.bgImageUrl curClass:[self class] curBundle:@"WARProfile.bundle"];
    self.containerV.image = image;
    
    //frame
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
 
    self.containerV.frame = CGRectMake(0, 0, width, height);
    self.textLab.frame = CGRectMake(0, height - 15, width - 5, 11);
    
    CGFloat dateLWidth = [self.dateLab.text widthWithFont:self.dateLab.font constrainedToHeight:14];
    self.dateLab.frame = CGRectMake(5, 5, dateLWidth, 14);
    
    self.line.frame = CGRectMake(self.dateLab.right + 4, 6, 1, 10);
    
    CGFloat yearLWidth = [self.yearLab.text widthWithFont:self.yearLab.font constrainedToHeight:11];
    self.yearLab.frame = CGRectMake(self.line.right + 4, 5, yearLWidth, 11);
}

- (UIImageView *)containerV{
    if (!_containerV) {
        _containerV = [[UIImageView alloc]init];
        _containerV.backgroundColor = kColor(blackColor);
        _containerV.layer.cornerRadius = 2.0;
        _containerV.layer.masksToBounds = YES;
        _containerV.contentMode = UIViewContentModeScaleAspectFill;
//        _containerV.image = [WARUIHelper war_defaultUserIcon];
    }
    return _containerV;
}

- (UILabel *)dateLab{
    if (!_dateLab) {
        _dateLab = [[UILabel alloc]init];
        _dateLab.textAlignment = NSTextAlignmentLeft;
        _dateLab.font = kFont(14);
        _dateLab.textColor = HEXCOLOR(0xffffff);
    }
    return _dateLab;
}

- (UILabel *)yearLab{
    if (!_yearLab) {
        _yearLab = [[UILabel alloc]init];
        _yearLab.textAlignment = NSTextAlignmentLeft;
        _yearLab.font = kFont(11);
        _yearLab.textColor = HEXCOLOR(0xffffff);
    }
    return _yearLab;
}

- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.textAlignment = NSTextAlignmentRight;
        _textLab.font = kFont(11);
        _textLab.textColor = HEXCOLOR(0xffffff);
    }
    return _textLab;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.hidden = YES;
        _line.backgroundColor = [UIColor whiteColor];
    }
    return _line;
}


@end
