//
//  HFCountryCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCountryCell.h"
@interface HFCountryCell()
@property(nonatomic,strong)UILabel *countryNamelb;
@property(nonatomic,strong)UILabel *codeCountrylb;
@property(nonatomic,strong)UIView *lineLayer;
@end
@implementation HFCountryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hh_setupViews];
    }
    return self;
}
- (void)hh_setupViews {
    
    [self.contentView addSubview:self.codeCountrylb];
    [self.contentView addSubview:self.countryNamelb];
    [self.contentView addSubview:self.lineLayer];
}
- (void)doMessagesomthing {
    self.countryNamelb.text = [NSString stringWithFormat:@"%@",self.model.countryName];
    self.codeCountrylb.text = [NSString stringWithFormat:@"+%@",self.model.countryCode];
    self.codeCountrylb.frame = CGRectMake(ScreenW-40-100, 0, 100, 45);
    self.countryNamelb.frame = CGRectMake(30, 0, self.codeCountrylb.left-30, 45);
    self.lineLayer.frame = CGRectMake(30, self.countryNamelb.bottom, ScreenW-70, 0.5);
    
}
- (UILabel *)codeCountrylb {
    if (!_codeCountrylb) {
        _codeCountrylb = [[UILabel alloc] init];
        _codeCountrylb.textColor = [UIColor colorWithHexString:@"999999"];
        _codeCountrylb.font = [UIFont systemFontOfSize:12];
        _codeCountrylb.textAlignment = NSTextAlignmentRight;
    }
    return _codeCountrylb;
}
- (UILabel *)countryNamelb {
    if (!_countryNamelb) {
        _countryNamelb = [[UILabel alloc] init];
        _countryNamelb.textColor = [UIColor colorWithHexString:@"333333"];
        _countryNamelb.font = [UIFont systemFontOfSize:16];
    }
    return _countryNamelb;
}
- (UIView *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [[UIView alloc] init];
        _lineLayer.backgroundColor = [UIColor colorWithHexString:@"D5D5D5"];
    }
    return _lineLayer;
}
@end
