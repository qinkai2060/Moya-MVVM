//
//  WARCreatEditPhotoView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//

#import <UIKit/UIKit.h>
#import "WARTagView.h"
#import "WARGroupModel.h"
typedef NS_ENUM(NSInteger,WARCreatEditPhotoViewType) {
   WARCreatEditPhotoViewTypeNewCreat,
   WARCreatEditPhotoViewTypeEditing,
};

typedef void (^WarCreatEditBlock)(WARGroupModel *model);
typedef void (^WARCreatEditingBlock)(WARGroupModel *model );
typedef void (^WARCreatEditingCoverBlock)();
typedef void (^WARCreatDeleteBlock)();
typedef void (^WarCreatAuthBlock)(NSString *type);
@interface WARCreatEditPhotoView : UIView
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIView *lineFirtV;
@property(nonatomic,strong)UILabel *authlb;
@property(nonatomic,strong)UIView *lineSedV;
@property(nonatomic,strong)UILabel *phototypelb;
@property(nonatomic,strong)UIView *lineThirdV;
/**封面*/
@property (nonatomic,strong) UILabel *coverLb;
@property (nonatomic,strong) UIImageView *coverIconImg;
@property (nonatomic,strong) UIView *lineFourV;
@property (nonatomic,strong) UIButton *settingCoverBtn;
/**arrows*/
@property (nonatomic,strong) UIImageView *arrowsimgVTwo;
@property(nonatomic,strong)UIImageView *arrowsimgV;
@property(nonatomic,strong)UILabel *authNamelb;
@property(nonatomic,strong)WARTagView *tagV;
@property(nonatomic,strong)UIButton *unloadBtn;
@property(nonatomic,strong)UIButton *finshBtn;
@property(nonatomic,strong)UIButton *pushAuthBtn;
@property(nonatomic,strong)UIButton *deletPhotoBtn;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)WARGroupModel *Editingmodel;
@property(nonatomic,copy)WarCreatEditBlock pushBlock;
@property(nonatomic,copy)WarCreatAuthBlock authBlock;
@property(nonatomic,copy)WARCreatEditingBlock EditingBlock;
@property(nonatomic,copy)WARCreatEditingCoverBlock EditingCoverBlock;
@property(nonatomic,copy)WARCreatDeleteBlock deleteBlock;
@property(nonatomic,assign)WARCreatEditPhotoViewType type;
- (instancetype)initWithType:(WARCreatEditPhotoViewType)type;
- (void)editingGroupInfoModel:(WARGroupModel*)model;

- (NSString*)showAccessName:(NSString*)accessPermission;
- (NSString*)accessPermission:(NSString*)accessPermission;
@end
