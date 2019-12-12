//
//  WARUserDiaryForTopRankCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//


#import "WARUserDiaryHeaderView.h"

#import "WARMacros.h"
#import "Masonry.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"

#import "WARUserDiaryModel.h"

#define kWARProfileBundle @"WARProfile.bundle"
#define kSmallIconSize CGSizeMake(15, 15)

@interface WARUserDiaryHeaderView()
@property (nonatomic, strong) UILabel *yearLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIImageView *festivalImgV;
@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, strong) UIImageView *locationIconImgV;
@property (nonatomic, strong) UILabel *locationLab;

@property (nonatomic, strong) UIButton *inputPhotosBtn;

@property (nonatomic, copy)NSArray *photos;
@property (nonatomic, assign) BOOL  isClickInput;

@end
@implementation WARUserDiaryHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    [self.contentView addSubview:self.yearLab];
    [self.contentView addSubview:self.dateLab];
    [self.contentView addSubview:self.festivalImgV];
    [self.contentView addSubview:self.textLab];
    [self.contentView addSubview:self.inputPhotosBtn];
    [self.contentView addSubview:self.locationIconImgV];
    [self.contentView addSubview:self.locationLab];
    
    

    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = RGBA(0,216,183,0.3);
    [self.contentView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(2, 15));
    }];
    
    
    [self.yearLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(lineV.mas_bottom).offset(15);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yearLab.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.festivalImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLab.mas_right).offset(13);
        make.size.mas_equalTo(CGSizeMake(23, 23));
        make.centerY.equalTo(self.dateLab);
    }];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateLab);
        make.left.equalTo(self.festivalImgV.mas_right).offset(10);
    }];
    
    [self.locationIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kSmallIconSize);
        make.top.equalTo(self.textLab.mas_bottom).offset(7);
        make.left.equalTo(self.dateLab.mas_right).offset(13);
    }];
    
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locationIconImgV);
        make.left.equalTo(self.locationIconImgV.mas_right).offset(10);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    
    
    [self.inputPhotosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.textLab);
    }];
    

    
}


- (void)updateYearLabConstraintWithIsShowYear:(BOOL)isShowYear {
    if (isShowYear) {
        [self.dateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.yearLab.mas_bottom).offset(30);
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
        }];
    }else{
        [self.dateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.yearLab);
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
        }];
    }
    
}

- (void)updateTextConstraintWithIsShowFestival:(BOOL)isShowFestival {

    if (isShowFestival) {
        [self.textLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLab);
            make.left.equalTo(self.festivalImgV.mas_right).offset(10);
        }];
    }else{
        [self.textLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLab);
            make.left.equalTo(self.festivalImgV);
        }];
    }

}


- (void)configureModel:(WARUserDiaryModel *)model{
    
    BOOL isYear = NO;
    if (model.isShowYear && !model.isCurrentYear) {
        isYear = YES;
        self.yearLab.hidden = NO;
        self.yearLab.text = model.yearStr;
    }else{
        isYear = NO;
        self.yearLab.hidden = YES;
        self.yearLab.text = @"";
    }
    [self updateYearLabConstraintWithIsShowYear:isYear];


    self.dateLab.text = model.showDateStr;
    self.textLab.text = [NSString stringWithFormat:WARLocalizedString(@"今天共走了%.0f步，排名第5"),model.todaySteps];
    
    
    BOOL isShow = model.festivalImg ? YES:NO;
    [self updateTextConstraintWithIsShowFestival:isShow];
    if (isShow) {
        self.festivalImgV.image = model.festivalImg;
        self.festivalImgV.hidden = NO;
    }else{
        self.festivalImgV.hidden = YES;
    }
    
    
    if (model.diaryLocationStr.length) {
        self.locationIconImgV.hidden = NO;
        self.locationLab.hidden = NO;
        
    }else{
        self.locationIconImgV.hidden = YES;
        self.locationLab.hidden = YES;
    }
    
    if (self.isClickInput) {
        self.inputPhotosBtn.hidden = YES;
    }else{
        if (model.isHiddenInputBtn) {
            self.inputPhotosBtn.hidden = YES;
        }else{
            if (model.inputPhotos.count) {
                self.inputPhotosBtn.hidden = NO;
                self.photos = model.inputPhotos;
            }else{
                self.inputPhotosBtn.hidden = YES;
            }
        }

    }

}

- (void)inputPhotosBtnAction:(UIButton *)button{
    if (self.didClickInputPhotosBlock) {
        self.isClickInput = YES;
        self.didClickInputPhotosBlock(self.photos);
    }

}


#pragma mark - getter methods
- (UILabel *)yearLab{
    if (!_yearLab) {
        _yearLab = [[UILabel alloc]init];
        _yearLab.font = kFont(18);
        _yearLab.textColor = RGB(153, 153, 153);
    }
    return _yearLab;
}

- (UILabel *)dateLab{
    if (!_dateLab) {
        _dateLab = [[UILabel alloc]init];
        _dateLab.font = kFont(12);
        _dateLab.textColor = RGB(153, 153, 153);
    }
    return _dateLab;
}

- (UIImageView *)festivalImgV{
    if (!_festivalImgV) {
        _festivalImgV = [[UIImageView alloc]init];
    }
    return _festivalImgV;
}

- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.font = kFont(12);
        _textLab.textColor = RGB(51, 51, 51);
    }
    return _textLab;
}

- (UIImageView *)locationIconImgV{
    if (!_locationIconImgV) {
        _locationIconImgV = [[UIImageView alloc]init];
    }
    return _locationIconImgV;
}

- (UILabel *)locationLab{
    if (!_locationLab) {
        _locationLab = [[UILabel alloc]init];
    }
    return _locationLab;
}

- (UIButton *)inputPhotosBtn{
    if (!_inputPhotosBtn) {
        _inputPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inputPhotosBtn setImage:[UIImage war_imageName:@"personal_import" curClass:self curBundle:kWARProfileBundle] forState:UIControlStateNormal];
        [_inputPhotosBtn addTarget:self action:@selector(inputPhotosBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputPhotosBtn;
}


@end
