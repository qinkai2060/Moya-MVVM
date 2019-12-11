//
//  WARUserDiaryBaseTableViewCell.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/24.
//

#import "WARUserDiaryBaseTableViewCell.h"

#import "WARMacros.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface WARUserDiaryBaseTableViewCell()



@end
@implementation WARUserDiaryBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        
        self.backgroundColor = kColor(clearColor);
        
        [self setUpUI];
        
    }
    return self;
}


- (void)setUpUI{
    
//        self.contentView.layer.contents = [UIImage imageNamed:@"WARProfile.bundle/personalinformation_ty"];
//    self.contentView.backgroundColor = [UIColor redColor];
    
}

- (CGFloat)updateCollectionViewHeight{
    NSInteger count = self.photos.count;
    if (count > 0 && count < 5) {
        return kPhotoImgHeight;
    }else if (count == 0){
        return 0.f;
    }else {
        return kPhotosMaxHeight;
    }
}



#pragma mark - getter methods 
- (UIImageView *)dayOrNightImgV{
    if (!_dayOrNightImgV) {
        _dayOrNightImgV = [[UIImageView alloc]init];
    }
    return _dayOrNightImgV;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.font = kFont(12);
        _timeLab.textColor = RGB(153, 153, 153);
    }
    return _timeLab;
}

- (UIImageView *)tweetImgV{
    if (!_tweetImgV) {
        _tweetImgV = [[UIImageView alloc]init];

    }
    return _tweetImgV;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
