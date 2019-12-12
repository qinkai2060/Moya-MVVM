//
//  WARPhotoHeaderView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/20.
//

#import <UIKit/UIKit.h>
@class WARGroupModel;
typedef NS_ENUM(NSInteger, WARPhotoHeaderViewType) {
    WARPhotoHeaderViewTypeDefualt,
    WARPhotoHeaderViewTypeCustom,

};

@interface WARPhotoHeaderView : UIImageView
//@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIImageView *maskV;
@property(nonatomic,strong)UILabel *titlelb;
@property(nonatomic,strong)UIImageView *lockImgV;
@property(nonatomic,strong)UILabel *countlb;
@property(nonatomic,strong)UILabel *phototypelb;
- (instancetype)initWithType:(WARPhotoHeaderViewType)type;
- (void)setCoveriD:(NSString *)coverID;
- (void)setGroupModel:(WARGroupModel *)model;
@end
