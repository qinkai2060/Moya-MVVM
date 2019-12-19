//
//  VipPlayCollectionViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipPlayCollectionViewCell.h"
@interface VipPlayCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation VipPlayCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backGroundImage.layer.masksToBounds = YES;
    self.backGroundImage.layer.cornerRadius = 10;
    self.backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setListModel:(VipGiftListModel *)listModel {
    _listModel = listModel;
    [self.backGroundImage sd_setImageWithURL:[self.listModel.videoImage get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.contentLabel.text = objectOrEmptyStr(self.listModel.videoTitle);
}
@end
