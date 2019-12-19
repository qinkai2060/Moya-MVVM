//
//  HFDefaultAddressView.m
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFDefaultAddressCell.h"

@implementation HFDefaultAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
         [self.contentView addSubview:self.selectImageV];
        [self.contentView addSubview:self.nameLb];
        [self.contentView addSubview:self.phoneNmLb];
        [self.contentView addSubview:self.defaultAdrLb];
        [self.contentView addSubview:self.tagLb];
        [self.contentView addSubview:self.enterEditingBtn];
        [self.contentView addSubview:self.detailAdressLb];
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
- (void)doSommthing {
    

    self.nameLb.text = self.model.receiptName;
 
    self.phoneNmLb.text =self.model.receiptPhone;
    
    self.detailAdressLb.text = self.model.completeAddress;
    
    if (self.model.defalutAddress&&self.model.fromeSource == 0) {
        self.selectImageV.hidden = NO;
        self.selectImageV.frame = CGRectMake(15, (self.height-15)*0.5, 15, 15);
    }else{
        self.selectImageV.hidden = YES;
        self.selectImageV.frame = CGRectMake(15, (self.height-15)*0.5, 0, 0);
    }
    
    CGSize sizeName2 =   [self.nameLb.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    self.nameLb.frame = CGRectMake(self.selectImageV.right+5, 15, sizeName2.width, 20);

    self.phoneNmLb.frame = CGRectMake(self.nameLb.right+10, 15, 120, 20);
    self.tagLb.text = @"公司";
    self.tagLb.hidden = YES;
    CGSize sizeTag = [self.tagLb sizeThatFits:CGSizeMake(50, 15)];
    self.defaultAdrLb.frame = CGRectMake(self.phoneNmLb.right+5, 18, sizeTag.width+10, 15);
    self.tagLb.frame = CGRectMake(self.defaultAdrLb.right+5, 18, sizeTag.width+10, 15);
     CGSize size;
    if (self.model.defalutAddress&&self.model.fromeSource == 0) {
        size = CGSizeMake(ScreenW-40-45, 45);
    }else {
        size = CGSizeMake(ScreenW-15-45, 45);
    }
    CGSize sizedetailAdress = [self.detailAdressLb sizeThatFits:size];
    self.detailAdressLb.frame = CGRectMake(self.selectImageV.right+5, self.phoneNmLb.bottom+10, sizedetailAdress.width, sizedetailAdress.height);
    self.enterEditingBtn.frame = CGRectMake(ScreenW -44-15, (80-44)*0.5, 44, 44);
    self.lineView.frame = CGRectMake(15, self.height-0.5, ScreenW-30, 0.5);
  
}
- (void)enterClick:(UIButton*)btn {
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock();
    }
}
- (UIImageView *)selectImageV {
    if (!_selectImageV) {
        _selectImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    }
    return _selectImageV;
}
- (UIButton *)enterEditingBtn {
    if (!_enterEditingBtn) {
        _enterEditingBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW -15-15, (80-44)*0.5, 44, 44)];
        [_enterEditingBtn setImage: [UIImage imageNamed:@"editing_icon"]forState:UIControlStateNormal] ;
        [_enterEditingBtn addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterEditingBtn;
}
- (UILabel *)tagLb {
    if (!_tagLb) {
        _tagLb = [[UILabel alloc] init];
        _tagLb.font = [UIFont systemFontOfSize:8];
        _tagLb.layer.cornerRadius = 7.5;
        _tagLb.layer.masksToBounds = YES;
        _tagLb.backgroundColor = [UIColor colorWithHexString:@"#4D88FF"];
        _tagLb.textColor = [UIColor whiteColor];
        _tagLb.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLb;
}
- (UILabel *)defaultAdrLb {
    if(!_defaultAdrLb){
        _defaultAdrLb = [[UILabel alloc] init];
//        _defaultAdrLb.text = @"默认";
        _defaultAdrLb.font = [UIFont systemFontOfSize:8];
        _defaultAdrLb.layer.cornerRadius = 7.5;
        _defaultAdrLb.layer.masksToBounds = YES;
//        _defaultAdrLb.backgroundColor = [UIColor colorWithHexString:@"FF0000"];
        _defaultAdrLb.textColor = [UIColor whiteColor];
        _defaultAdrLb.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultAdrLb;
}
- (UILabel *)detailAdressLb {
    if (!_detailAdressLb) {
        _detailAdressLb = [[UILabel alloc] init];
        _detailAdressLb.textColor = [UIColor colorWithHexString:@"666666"];
        _detailAdressLb.font = [UIFont systemFontOfSize:12];
        _detailAdressLb.numberOfLines = 3;
    }
    return _detailAdressLb;
}
- (UILabel *)phoneNmLb {
    if (!_phoneNmLb) {
        _phoneNmLb = [[UILabel alloc] init];
        _phoneNmLb.textColor = [UIColor blackColor];
        _phoneNmLb.font = [UIFont systemFontOfSize:16];
    }
    return _phoneNmLb;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [[UILabel alloc] init];
        _nameLb.textColor = [UIColor colorWithHexString:@"333333"];
        _nameLb.font = [UIFont boldSystemFontOfSize:16];
    }
    return _nameLb;
}
@end
