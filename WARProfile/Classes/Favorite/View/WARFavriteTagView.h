//
//  WARFavriteTagView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/6/4.
//

#import <UIKit/UIKit.h>

@interface WARFavriteTagView : UIView
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIScrollView *scroller;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,assign)CGFloat maxY;
-(instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array ;
- (void)settingTagStr:(NSString *)type;
@end
