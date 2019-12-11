//
//  WARTopToolView.h
//  Pods
//
//  Created by 秦恺 on 2018/5/15.
//

#import <UIKit/UIKit.h>
typedef void (^switchChooseBlock)(NSInteger tag);
typedef void (^creatFavriteBlock)();
@interface WARTopToolView : UIView
/**me*/
@property (nonatomic,strong) UIButton *mineBtn;
/**hot*/
@property (nonatomic,strong) UIButton *hotBtn;
/**creat*/
@property (nonatomic,strong) UIButton *creatBtn;
/**searchBtn*/
@property (nonatomic,strong) UIButton *searchBtn;

@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,copy) switchChooseBlock chooseBlock;
@property (nonatomic,copy) creatFavriteBlock creatBlock;
@end
