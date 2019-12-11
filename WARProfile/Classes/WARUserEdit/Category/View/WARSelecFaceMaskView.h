//
//  WARSelecFaceMaskView.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/27.
//

#import <UIKit/UIKit.h>

@class WARContactCategoryModel;

typedef void (^WARSelecFaceMaskViewSureBlock)(NSString *faceId);


@interface WARSelecFaceMaskView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIView *cornerView;
@property (nonatomic,strong)UILabel *titleLabei;
@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,strong)UITableView *tbView;
@property (nonatomic,strong)NSArray *groupArr;
@property (nonatomic, assign) BOOL  isSelectRow;
@property (nonatomic,assign)NSInteger selectRow;
@property (nonatomic,copy)WARSelecFaceMaskViewSureBlock sureBlock;


@end


@interface WARSelecFaceMaskCell : UITableViewCell
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIView *lineView;
- (void)setData:(WARContactCategoryModel*)model;
@end
