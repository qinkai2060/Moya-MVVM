//
//  WARFaceMaskCollectionViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/3/21.
//

#import "WARFaceMaskCollectionViewCell.h"

#import "Masonry.h"
#import "WARMacros.h"

#import "UIView+WARSetCorner.h"

@interface WARFaceMaskCollectionViewCell()

@property (nonatomic, strong) UIView *containerV;
@end
@implementation WARFaceMaskCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kColor(clearColor);
        [self initUI];
        
        UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPreAction:)];
        longPre.minimumPressDuration = 1;
        [self addGestureRecognizer:longPre];
        
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.containerV];
    [self.containerV addSubview:self.faceImgV];
    [self.faceImgV addSubview:self.faceLab];
    
    self.faceImgV.backgroundColor = kColor(redColor);
    
    [self.containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    
    [self.faceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerV);
    }];
    
    [self.faceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.mas_equalTo(0);
    }];
}

- (void)longPreAction:(UILongPressGestureRecognizer *)longPre{
    if (longPre.state == UIGestureRecognizerStateEnded) {
        if (self.didLongPreBlock) {
            self.didLongPreBlock();
        }
    }
}

#pragma mark - getter methods
- (UIView *)containerV{
    if (!_containerV) {
        _containerV = [[UIView alloc]init];
        _containerV.layer.masksToBounds = YES;
        _containerV.layer.cornerRadius = 3;
    }
    return _containerV;
}

- (UIImageView *)faceImgV{
    if (!_faceImgV) {
        _faceImgV = [[UIImageView alloc]init];
    }
    return _faceImgV;
}

- (UILabel *)faceLab{
    if (!_faceLab) {
        _faceLab = [[UILabel alloc]init];
        _faceLab.backgroundColor = RGBA(0, 0, 0, 0.3);
        _faceLab.textColor = kColor(whiteColor);
        _faceLab.font = kFont(14);
        _faceLab.textAlignment = NSTextAlignmentCenter;
    }
    return _faceLab;
}


@end
