//
//  CollectShopTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectGlobalHomeViewCell.h"
#import "CollectGlobalModel.h"
#import "HandleEventDefine.h"
@interface CollectGlobalHomeViewCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton * deleBtn;   // 删除按钮
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * remarkLabel; // 点评
@property (nonatomic, strong) UILabel * typeLabel;   // 类型 (高档型)
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) CollectGlobalItemModel * itemModel;
@end

@implementation CollectGlobalHomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    self.detailLabel.numberOfLines = 0;
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
        make.width.equalTo(@(kWidth - 120));
        make.height.equalTo(@20);
    }];
    
    [self.mainScrollView addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.height.equalTo(@20);
    }];
    
    [self.mainScrollView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.remarkLabel.mas_bottom).offset(2);
        make.height.equalTo(@20);
    }];
    
    [self.mainScrollView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(2);
        make.height.equalTo(@20);
    }];
    
    [self.mainScrollView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainScrollView);
        make.right.equalTo(self.titleLabel.mas_right).offset(-17);
        make.height.equalTo(@30);
    }];
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    self.indexPath = path;
    CollectGlobalModel *model = (CollectGlobalModel *)data;
    self.itemModel = model.dataSource.firstObject;
    self.titleLabel.text = self.itemModel.title;
    
    NSString * comment ;
    if (self.itemModel.commentNum > 0) {
        comment = [NSString stringWithFormat:@"%ld点评数据",self.itemModel.commentNum];
    }else {
        comment = @"暂无点评数据";
    }
    self.remarkLabel.text = objectOrEmptyStr(comment);
    if ([self.itemModel.starName isNotNil]) {
        self.typeLabel.text = objectOrEmptyStr(self.itemModel.starName);
    }
    
    if ([self.itemModel.price isNotNil]) {
        NSString * priceNum = ([self.itemModel.price isNotNil]) ? self.itemModel.price : @"";
        NSString * priceString = [NSString stringWithFormat:@"¥%@ 起",priceNum];
        NSDictionary *attributedDict = @{
                                         NSFontAttributeName:kFONT(16),
                                         NSForegroundColorAttributeName:[UIColor redColor],
                                         };
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
        
        [attributedString setAttributes:attributedDict range:NSMakeRange(0, priceString.length - 1)];
        self.priceLabel.attributedText = attributedString;
    }
    
    self.detailLabel.text = self.itemModel.addressCn.length>0? objectOrEmptyStr(self.itemModel.addressCn):@"";

    if (self.itemModel.imageUrl.length > 0) {
         [self.icon sd_setImageWithURL:[NSURL URLWithString:self.itemModel.imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    }
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self rounterEventWithName:MineGlobalHome userInfo:@{
                                         @"hotelId":objectOrEmptyStr(self.itemModel.hotelId),
                                                             }];
}

+ (id)loadFromXib {
    CollectGlobalHomeViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
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
                self.lastIndexPath  = self.indexPath;
                self.deleteAction(self.indexPath,@{
                                             @"hotelId":objectOrEmptyStr(self.itemModel.hotelId),

                                                   });
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
        _mainScrollView.scrollEnabled = YES;
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
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = kFONT(12);
        _detailLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _detailLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        _typeLabel.font = kFONT(12);
        _typeLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _typeLabel;
}

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [UILabel new];
        _remarkLabel.font = kFONT(12);
        _remarkLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _remarkLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = kFONT(12);
    }
    return _priceLabel;
}

- (CollectGlobalItemModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[CollectGlobalItemModel alloc]init];
    }
    return _itemModel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
