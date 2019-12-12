//
//  WARNavgationBar.h
//  Pods
//
//  Created by 秦恺 on 2018/1/30.
//

#import <UIKit/UIKit.h>

typedef void (^WARNavgationBarDidClickButtonBlock) (void);

@interface WARNavgationBar : UIView
@property (nonatomic,strong)  UIButton *qrButton;// she'zhi
@property (nonatomic,strong)  UIButton *editButton;//编辑
@property (nonatomic,strong)  UILabel *namelabel;
@property (nonatomic,strong)  UIButton *leftbtn;
@property (nonatomic,strong)  UIButton *backbtn;
@property (nonatomic,assign)  CGFloat dl_alpha;
@property (nonatomic,strong)  UILabel *accoutlb;
@property (nonatomic,strong)  UIImageView *backImageView;
@property (nonatomic,strong)  UIActivityIndicatorView *loadingView;
@property (nonatomic,assign)  BOOL isMine;
@property (nonatomic,assign)  BOOL isOtherFromWindow;
@property (nonatomic,strong)  UIScrollView *scrollerView;
@property (nonatomic,strong)  UIImageView *maskView;
@property (nonatomic,  copy)  WARNavgationBarDidClickButtonBlock settingBlock;
/**
 将要刷新
 */
-(void)dl_willRefresh;

/**
 刷新
 */
-(void)dl_refresh;

/**
 结束刷新
 */
-(void)dl_endRefresh;

- (void)stopAnmation:(void(^)())block;

- (void)changeOffset: (CGFloat)offset;
@end
