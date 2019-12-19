//
//  HFGlobalFamilyCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFGlobalFamilyCell.h"
#import "HFTextCovertImage.h"
@interface HFGlobalFamilyCell ()
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UIImageView *hotelImageV;
@property(nonatomic,strong)UILabel *reivewLb;
@property(nonatomic,strong)UILabel *gradeTypeLb;
@property(nonatomic,strong)CALayer *linelayer;
@property(nonatomic,strong)UILabel *yearTypeLb;
//@property(nonatomic,strong)UILabel *tagLb;
//@property(nonatomic,strong)UILabel *discountLb;
@property(nonatomic,strong)UILabel *priceLb;
@property(nonatomic,strong)UILabel *distanceLb;
@end
@implementation HFGlobalFamilyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hh_setsubviews];
//        [self doMessageSommthing];
    }
    return self;
}
- (void)hh_setsubviews {
    [self.contentView addSubview:self.hotelImageV];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.reivewLb];
    [self.contentView addSubview:self.gradeTypeLb];
    [self.contentView.layer addSublayer:self.linelayer];
    [self.contentView addSubview:self.yearTypeLb];
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.distanceLb];
}
- (void)doMessageSommthing {

    [self.hotelImageV sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLb.text = self.model.hotelName;
    if (self.model.commentScore > 0 &&self.model.commentNum > 0) {
           self.reivewLb.attributedText = [HFTextCovertImage attrbuteStr:[NSString stringWithFormat:@"%ld分 来自 %ld 条点评",self.model.commentScore,self.model.commentNum] rangeOfArray:@[[NSString stringWithFormat:@"%ld分",self.model.commentScore],[NSString stringWithFormat:@"%ld",self.model.commentNum]] font:12 color:@"FF6600"];
    }else {
        self.reivewLb.text = @"暂无点评数据";
        self.reivewLb.font = [UIFont systemFontOfSize:12];
    }
    self.gradeTypeLb.text = self.model.starName;
    if (self.model.renovationDate.length == 0) {
         self.yearTypeLb.text = @"日期不详";
    }else {
          self.yearTypeLb.text = self.model.renovationDate;
    }

    self.priceLb.attributedText = [HFTextCovertImage str:[NSString stringWithFormat:@"¥%ld起",self.model.price]];
    self.distanceLb.text = self.model.address;
    self.hotelImageV.frame = CGRectMake(10, 10, 100, 100);
    self.titleLb.frame = CGRectMake(self.hotelImageV.right+10, 10, ScreenW-15-self.hotelImageV.right-10, [self.titleLb sizeThatFits:CGSizeMake(ScreenW-15-self.hotelImageV.right-10, 40)].height);
    self.reivewLb.frame = CGRectMake(self.hotelImageV.right+10, self.titleLb.bottom+5,  self.titleLb.width, 15);
    self.gradeTypeLb.frame = CGRectMake(self.hotelImageV.right+10, self.reivewLb.bottom+5, [self.gradeTypeLb sizeThatFits:CGSizeMake(60, 40)].width, 15);
    self.linelayer.frame = CGRectMake(self.gradeTypeLb.right+10, self.reivewLb.bottom+5, 0.5, 15);
    self.yearTypeLb.frame = CGRectMake(CGRectGetMaxX(self.linelayer.frame)+10, self.reivewLb.bottom+5, [self.yearTypeLb sizeThatFits:CGSizeMake(60, 40)].width, 15);
    self.priceLb.frame = CGRectMake(self.yearTypeLb.right+10, self.reivewLb.bottom, ScreenW-self.yearTypeLb.right-10-15, 28);
    self.distanceLb.frame = CGRectMake(self.hotelImageV.right+10, self.gradeTypeLb.bottom+10, ScreenW-self.hotelImageV.right-10-15, [self.distanceLb sizeThatFits:CGSizeMake(ScreenW-self.hotelImageV.right-10-15, 40)].height);
    
    
}

- (CALayer *)linelayer {
    if (!_linelayer) {
        _linelayer = [CALayer layer];
        _linelayer.backgroundColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    }
    return _linelayer;
}
-  (UILabel *)distanceLb {
    if (!_distanceLb) {
        _distanceLb  = [[UILabel alloc] init];
        _distanceLb.textColor = [UIColor colorWithHexString:@"333333"];
        _distanceLb.font = [UIFont systemFontOfSize:12];
          _distanceLb.numberOfLines = 2;
    }
    return _distanceLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [[UILabel alloc] init];
        _priceLb.textColor = [UIColor colorWithHexString:@"333333"];
        _priceLb.font = [UIFont systemFontOfSize:15];
        _priceLb.textAlignment = NSTextAlignmentRight;
    }
    return _priceLb;
}
- (UILabel *)yearTypeLb {
    if (!_yearTypeLb) {
        _yearTypeLb = [[UILabel alloc] init];
        _yearTypeLb.textColor = [UIColor colorWithHexString:@"333333"];
        _yearTypeLb.font = [UIFont systemFontOfSize:12 ];
    }
    return _yearTypeLb;
}
- (UILabel *)gradeTypeLb {
    if (!_gradeTypeLb) {
        _gradeTypeLb = [[UILabel alloc] init];
        _gradeTypeLb.textColor = [UIColor colorWithHexString:@"333333"];
        _gradeTypeLb.font = [UIFont systemFontOfSize:12 ];
    }
    return _gradeTypeLb;
}
- (UILabel *)reivewLb {
    if (!_reivewLb) {
        _reivewLb = [[UILabel alloc] init];
    }
    return _reivewLb;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLb.font = [UIFont boldSystemFontOfSize:16];
        _titleLb.numberOfLines = 2;
    }
    return _titleLb;
}
- (UIImageView *)hotelImageV {
    if (!_hotelImageV) {
        _hotelImageV = [[UIImageView alloc] init];
        _hotelImageV.layer.cornerRadius = 4;
        _hotelImageV.layer.masksToBounds = YES;
    }
    return _hotelImageV;
}
@end
