//
//  WARNewCreatFavriteView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//

#import <UIKit/UIKit.h>
#import "WARFavriteTagView.h"
#import "WARFavoriteModel.h"
typedef void (^WARCreatEditingCoverBlock)();
typedef void (^WarCreatAuthBlock)(NSString *type);
@interface WARNewCreatFavriteView : UIView
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UIView *lineFirtV;
@property(nonatomic,strong) UILabel *authlb;
@property(nonatomic,strong) UIView *lineSedV;
@property(nonatomic,strong) UILabel *phototypelb;

/**封面*/
@property (nonatomic,strong) UILabel *coverLb;
@property (nonatomic,strong) UIImageView *coverIconImg;
@property (nonatomic,strong) UIView *lineFourV;
@property (nonatomic,strong) UIButton *settingCoverBtn;
/**arrows*/
@property (nonatomic,strong) UIImageView *arrowsimgVTwo;
@property(nonatomic,strong) UIImageView *arrowsimgV;
@property(nonatomic,strong) UILabel *authNamelb;
@property(nonatomic,strong) WARFavriteTagView *tagV;
@property(nonatomic,copy) WARCreatEditingCoverBlock block;
@property(nonatomic,copy) WarCreatAuthBlock authBlock;
@property(nonatomic,copy) NSString   *favoriteID;
@property(nonatomic,copy) NSString   *coverID;
@property(nonatomic,assign) NSInteger   type;
@property(nonatomic,copy) NSString   *url;
@property(nonatomic,strong) UIButton *pushAuthBtn;
@property(nonatomic,strong) UIButton *deletPhotoBtn;
@property(nonatomic,strong) WARFavoriteInfoModel *model;
@property(nonatomic,strong) WARFavoriteInfoModel *originmodel;

@end
