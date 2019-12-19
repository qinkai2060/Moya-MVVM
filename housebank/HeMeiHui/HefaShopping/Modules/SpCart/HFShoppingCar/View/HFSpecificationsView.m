//
//  HFSpecificationsView.m
//  HeMeiHui
//
//  Created by usermac on 2019/1/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSpecificationsView.h"
#import "HFSpecialCell.h"
#import "HFTextCovertImage.h"
@interface HFSpecificationsView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *cornarView;

@property(nonatomic,strong)UIImageView *goodsImageV;

@property(nonatomic,strong)UILabel *pintuanLb;

@property(nonatomic,strong)UILabel *princelb;

@property(nonatomic,strong)UILabel *stocklb;

@property(nonatomic,strong)UILabel *tipsLb;

@property(nonatomic,strong)UIButton *closeBtn;

@property(nonatomic,strong)UITableView *tableView;
@end
@implementation HFSpecificationsView

- (void)hh_setupViews {
    self. backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.cornarView];
    [self.cornarView addSubview:self.goodsImageV];
    [self.cornarView addSubview:self.tipsLb];
    [self.cornarView addSubview:self.pintuanLb];
    [self.cornarView addSubview:self.princelb];
    [self.cornarView addSubview:self.stocklb];
    [self.cornarView addSubview:self.tipsLb];
    [self.cornarView addSubview:self.closeBtn];
    [self.cornarView addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"spID" forIndexPath:indexPath];
    
    
    return cell;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.goodsImageV.bottom+15, ScreenW, self.cornarView.height - self.goodsImageV.bottom -44) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HFSpecialCell class] forCellReuseIdentifier:@"spID"];
         _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-15-20, 15, 20, 20)];
        [_closeBtn setImage:[UIImage imageNamed:@"close666"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
- (UIView *)cornarView {
    if (!_cornarView) {
        _cornarView = [[UIView alloc] initWithFrame:CGRectMake(0, 214, ScreenW, ScreenH-214)];
        _cornarView.backgroundColor = [UIColor whiteColor];
    }
    return _cornarView;
}
- (UIImageView *)goodsImageV {
    if (!_goodsImageV) {
        _goodsImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 100, 100)];
          _goodsImageV.image = [UIImage imageNamed:@"product_4"];
        _goodsImageV.layer.borderColor = [UIColor redColor].CGColor;
        _goodsImageV.layer.borderWidth = 1;
         _goodsImageV.layer.cornerRadius = 5;
        _goodsImageV.layer.masksToBounds = YES;
      
    }
    return _goodsImageV;
}
- (UILabel *)pintuanLb {
    if (!_pintuanLb) {
        _pintuanLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+10, 20, 200, 15)];
        _pintuanLb.textColor = [UIColor colorWithHexString:@"666666"];
        _pintuanLb.font = [UIFont systemFontOfSize:12];
        _pintuanLb.text = @"拼团价:";
    }
    return _pintuanLb;
}
- (UILabel *)princelb {
    if(!_princelb) {
        _princelb = [[UILabel alloc] init];
        _princelb.attributedText = [HFTextCovertImage exchangeCommonString: [NSString stringWithFormat:@"¥%.2f",3500.10]];
        CGFloat maxFlotPrice = 200;
        CGSize size =  [_princelb sizeThatFits:CGSizeMake(maxFlotPrice, 38)];
       _princelb.frame = CGRectMake(self.goodsImageV.right+10, self.pintuanLb.bottom+5, size.width, size.height);
    }
    return _princelb;
}
- (UILabel *)stocklb {
    if (!_stocklb) {
        _stocklb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+10, self.princelb.bottom+5, ScreenW-self.goodsImageV.right-10, 15)];
        _stocklb.textColor = [UIColor colorWithHexString:@"666666"];
        _stocklb.font = [UIFont systemFontOfSize:12];
        _stocklb.text = @"库存18件";
    }
    return _stocklb;
}
- (UILabel *)tipsLb {
    if (!_tipsLb) {
        _tipsLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+10, self.stocklb.bottom+5, ScreenW-self.goodsImageV.right-10, 15)];
        _tipsLb.textColor = [UIColor colorWithHexString:@"333333"];
        _tipsLb.font = [UIFont systemFontOfSize:13];
        _tipsLb.text = @"请选择规格";
    }
    return _tipsLb;
}
@end
