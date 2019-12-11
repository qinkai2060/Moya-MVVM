//
//  WARNavgationCutsomBar.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/20.
//

#import <UIKit/UIKit.h>
typedef void(^WARNavgationCutsomBarleftBlock)();
typedef void(^WARNavgationCutsomBarrRightBlock)();
@interface WARNavgationCutsomBar : UIView
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIButton *rightbutton;
@property(nonatomic,strong)UIButton *titleButton;
@property(nonatomic,strong)UIButton *lineButton;
@property(nonatomic,strong)UIButton *progressBtn;
@property(nonatomic,assign)CGFloat dl_alpha;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIImageView *failiConV;
@property(nonatomic,strong)UILabel *countLb;
@property(nonatomic,copy)WARNavgationCutsomBarleftBlock leftHandler;
@property(nonatomic,copy)WARNavgationCutsomBarrRightBlock rightHandler;
- (instancetype)initWithTile:(NSString*)title rightTitle:(NSString*)rightTitle alpha:(CGFloat)alpha backgroundColor:(UIColor*)color rightHandler:(void(^)())rightHander leftHandler:(void(^)())leftHandler;
@end
