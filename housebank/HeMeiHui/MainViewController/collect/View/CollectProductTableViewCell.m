//
//  CollectProductTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectProductTableViewCell.h"
#import "HandleEventDefine.h"
#import "CollectProductModel.h"
@interface CollectProductTableViewCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton * deleBtn;   // 删除按钮
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * moneyLabel;
@property (nonatomic, strong) UILabel * tag1Label;
@property (nonatomic, strong) UILabel * tag2Label;
@property (nonatomic, copy) void (^event) (NSDictionary *,NSString *);
@property (nonatomic, strong) CollectProductItemModel * itemModel;

@end

@implementation CollectProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.userInteractionEnabled = YES;
    self.mainScrollView.userInteractionEnabled = YES;
    self.tag1Label.hidden = YES;
    self.tag2Label.hidden = YES;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self setUpUI];
}

- (void)setUpUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 在cell上先添加滑动视图
    [self.contentView addSubview:self.mainScrollView];
    self.mainScrollView.frame = CGRectMake(10, 10, kWidth-20, 110);
    
    [self.mainScrollView addSubview:self.deleBtn];
    self.deleBtn.frame = CGRectMake(kWidth, 0, [self deleteButtonWdith], 110.f);
    
    [self.mainScrollView addSubview:self.icon];
    self.icon.frame = CGRectMake(10, 10, 90, 90);
    
    [self.mainScrollView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.width.equalTo(@(kWidth - 110));
        make.height.equalTo(@30);
    }];
    
    [self.mainScrollView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@15);
    }];
    
    [self.mainScrollView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    
    [self.mainScrollView addSubview:self.tag1Label];
    [self.tag1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(5);
        make.width.equalTo(@24);
        make.height.equalTo(@12);
    }];
    
    [self.mainScrollView addSubview:self.tag2Label];
    [self.tag2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tag1Label.mas_right).offset(3);
        make.top.height.width.equalTo(self.tag1Label);
    }];
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    self.indexPath = path;
    CollectProductModel *model = (CollectProductModel *)data;
    self.itemModel = model.dataSource.firstObject;
    self.titleLabel.text = objectOrEmptyStr(self.itemModel.title);
    NSString * priceStr = [NSString stringWithFormat:@"¥%@",self.itemModel.price];
    self.moneyLabel.text = objectOrEmptyStr(priceStr);
    NSString *city = [NSString stringWithFormat:@"%@ %@",self.itemModel.cityName,self.itemModel.regionName];
    self.detailLabel.text = objectOrEmptyStr(city);
    
    [self.icon sd_setImageWithURL:[self.itemModel.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];

   
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
    self.event = event;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self rounterEventWithName:MineProductCollect userInfo:@{
                                                             @"active":self.itemModel.active,
                                                             @"productId":objectOrEmptyStr(self.itemModel.productId),
                                                             }];
}

+ (id)loadFromXib {
    CollectProductTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                      owner:self
                                                                    options:nil][0];
    return cell;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint movePoint = self.mainScrollView.contentOffset;
    if (movePoint.x < 0) {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if (movePoint.x > [self deleteButtonWdith]) {
        self.deleBtn.frame = CGRectMake(ScreenW, 0, movePoint.x, 110.f);
    } else {
        self.deleBtn.frame = CGRectMake(ScreenW, 0, [self deleteButtonWdith], 110.f);
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGPoint endPoint = self.mainScrollView.contentOffset;
    if (endPoint.x < self.deleteButtonWdith) {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (self.sliderAction) {
        self.sliderAction();
    }
}

#pragma mark - Get方法
-(CGFloat)deleteButtonWdith {
    return 80.0 * (kWidth / 375.0);
}

- (BOOL)isOpen {
    return self.mainScrollView.contentOffset.x >= self.deleteButtonWdith;
}

#pragma mark -- lazy load
-(UIButton *)deleBtn {
    if (!_deleBtn) {
        _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _deleBtn.backgroundColor = [UIColor redColor];
        @weakify(self);
        [[_deleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.deleteAction) {
                // 解决删除按钮多次点击
                if ([self.indexPath isEqual:self.lastIndexPath]) {
                    return ;
                }
                self.deleteAction(self.indexPath,@{
                                                   @"productId":objectOrEmptyStr(self.itemModel.productId),
                                                   @"projectId":objectOrEmptyStr(self.itemModel.projectId)
                                                   });
                self.lastIndexPath  = self.indexPath;
            }
        }];
    }
    return _deleBtn;
}

-(UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        /// 设置滑动视图的偏移量是：屏幕宽+删除按钮宽
        _mainScrollView.contentSize = CGSizeMake(self.deleteButtonWdith + kWidth, 0);
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.userInteractionEnabled = YES;
        _mainScrollView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        _mainScrollView.layer.cornerRadius = 4;
    }
    return _mainScrollView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = kFONT_BOLD(12);
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.text = @"Lenovo/联想 小新潮7000 i5";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.text = @"6GB+128GB/全网通4G";
        _detailLabel.font = kFONT(12);
        _detailLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _detailLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.text = @"16880.00";
        _moneyLabel.font = kFONT(12);
        _moneyLabel.textColor = [UIColor colorWithHexString:@"FF0000"];
    }
    return _moneyLabel;
}

- (UILabel *)tag1Label {
    if (!_tag1Label) {
        _tag1Label = [UILabel new];
        _tag1Label.backgroundColor = [UIColor colorWithHexString:@"F63019"];
        _tag1Label.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _tag1Label.font = kFONT(9);
        _tag1Label.textAlignment = NSTextAlignmentCenter;
        _tag1Label.text = @"1 类";
    }
    return _tag1Label;
}
- (UILabel *)tag2Label {
    if (!_tag2Label) {
        _tag2Label = [UILabel new];
        _tag2Label.backgroundColor = [UIColor colorWithHexString:@"F63019"];
        _tag2Label.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _tag2Label.font = kFONT(9);
        _tag2Label.textAlignment = NSTextAlignmentCenter;
        _tag2Label.text = @"促销";
    }
    return _tag2Label;
}

- (CollectProductItemModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[CollectProductItemModel alloc]init];
    }
    return _itemModel;
}
@end
