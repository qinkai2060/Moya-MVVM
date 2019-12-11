//
//  WARMemberHeaderView.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import "WARMemberHeaderView.h"

#import "WARMacros.h"
#import "Masonry.h"


@interface WARMemberHeaderView()<WARCornerButtonViewDelegate>
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, assign) BOOL  isEdit;
@end

@implementation WARMemberHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        _cornerBtn = [[WARCornerButtonView alloc] initWithButtonType:WARCornerButtonViewTypeOfBorder bounds:CGRectMake(0, 0, 50, 18) cornerRadius:5];
        [_cornerBtn titleText:WARLocalizedString(@"编辑")];
        [_cornerBtn titleFont:kFont(11)];
        _cornerBtn.delegate = self;
        
        [self addSubview:self.titleLab];
        [self addSubview:self.cornerBtn];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        
        [self.cornerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 18));
        }];
        
        self.isEdit = NO;
    }
    return self;
}

-(void)setType:(WARMemberHeaderViewType)type{
    _type = type;
    switch (type) {
        case WARMemberHeaderViewTypeOfMember:
        {
            self.titleLab.text = WARLocalizedString(@"分组成员");
            self.cornerBtn.hidden = NO;

        }
            break;
        case WARMemberHeaderViewTypeOfOthers:
        {
                self.titleLab.text = WARLocalizedString(@"可选择成员");
                self.cornerBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - WARCornerButtonViewDelegate
- (void)cornerButtonDidClickWithButtonActionString:(NSString *)string{
    if (!self.isDefault) {
        if (self.type == WARMemberHeaderViewTypeOfMember) {
            self.isEdit = !self.isEdit;
            if (self.isEdit) {
                [self.cornerBtn titleText:WARLocalizedString(@"完成")];
            }else{
                [self.cornerBtn titleText:WARLocalizedString(@"编辑")];
            }
            
            self.didClickEditBlock(self.isEdit);
        }
    }
    
}

#pragma mark - getter methods
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = kFont(14);
        _titleLab.textColor = RGB(153, 153, 153);
    }
    return _titleLab;
}

//- (WARCornerButtonView *)btn{
//    if (!_btn) {
//         _btn = [[WARCornerButtonView alloc] initWithButtonType:WARCornerButtonViewTypeOfBorder bounds:CGRectMake(0, 0, 50, 18) cornerRadius:5];
//        [_btn titleText:WARLocalizedString(@"编辑")];
//        [_btn titleFont:kFont(11)];
//        _btn.delegate = self;
////        WS(weakSelf);
////        _btn.cornerButtonDidClick = ^(NSString *buttonActionString) {
////            weakSelf.isEdit = !weakSelf.isEdit;
//////            dispatch_async(dispatch_get_main_queue(), ^{
////                if (weakSelf.isEdit) {
////
////                    NDLog(@"444444444444444444444");
////                    [_btn titleText:WARLocalizedString(@"完成")];
////                }else{
////                    NDLog(@"77777777777777777777");
////
////                    [_btn titleText:WARLocalizedString(@"编辑")];
////                }
//////            });
////            weakSelf.didClickEditBlock(weakSelf.isEdit);
////        };
//    }
//    return _btn;
//}

@end
