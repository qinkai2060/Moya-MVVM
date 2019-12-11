//
//  WARTagView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//

#import "WARTagView.h"
#import "UIColor+WARCategory.h"
#import "WARMacros.h"
#import "LGAlertViewTextField.h"
#import "WARAlertView.h"
#import "WARConfigurationMacros.h"
@implementation WARTagView

-(instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array atType:(WARTagViewViewType)type{
    
    if (self = [super initWithFrame:frame]) {
        for (UIView *v in self.subviews) {
            [v removeFromSuperview];
        }
     
        [self.array addObjectsFromArray:array];
        self.maxY = 0;
        UIButton *recordBtn =nil;
        if (self.array.count > 0) {
            
            
            for (int i = 0; i < self.array.count; i ++)
            {
                //        Area *are = cell_Array[i];
                
                NSString *name = self.array[i];
            
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
 
                CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width , 14) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
                
                CGFloat BtnW = rect.size.width + 26;
                CGFloat BtnH = rect.size.height + 6;
                btn.layer.borderColor = [DisabledTextColor CGColor];
                btn.layer.cornerRadius =3;
                btn.layer.masksToBounds = YES;
                //设置边框宽度
                btn.layer.borderWidth = 1.0f;
                btn.layer.masksToBounds = YES;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                
                if (type == WARTagViewViewTypeDefualt) {
                    if (BtnW >= self.frame.size.width) {
                        BtnW = self.frame.size.width;
                    }
                    if (i == 0) {
                        
                        btn.frame =CGRectMake(0, 0, BtnW, BtnH);
                    }else {
                        CGFloat yuWidth = self.frame.size.width  -recordBtn.frame.origin.x -recordBtn.frame.size.width;
                        
                        
                        if (yuWidth >= BtnW) {
                            
                            btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 8, recordBtn.frame.origin.y, BtnW, BtnH);
                        }else{
                            
                            btn.frame =CGRectMake(0, recordBtn.frame.origin.y+recordBtn.frame.size.height+8, BtnW, BtnH);
                        }
                    }
                    
                    
                    [btn setTitle:name forState:UIControlStateNormal];
                    [btn setTitleColor:ThemeColor forState:UIControlStateSelected];
                    [btn setTitleColor:DisabledTextColor forState:UIControlStateNormal];
                    [self addSubview:btn];
                    
                    if (btn.frame.origin.y>30) {
                        btn.hidden= NO;
                    }
                    self.maxY = CGRectGetMaxY(btn.frame);
                    recordBtn = btn;
                    
                    btn.tag = 100 + i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i == 0) {
                        btn.selected = YES;
                        self.selectBtn = btn;
                        self.selectBtn.layer.borderColor = [ThemeColor CGColor];
                    }
                }else{
                    btn.selected = YES;
                    btn.layer.borderColor = [ThemeColor CGColor];
                    if (BtnW >= self.frame.size.width) {
                        BtnW = self.frame.size.width;
                    }
                    if (i == 0) {
                        
                        btn.frame =CGRectMake(0, 0, BtnW, BtnH);
                    }else {
                        CGFloat yuWidth = self.frame.size.width  -recordBtn.frame.origin.x -recordBtn.frame.size.width;
                        
                        
                        if (yuWidth >= BtnW) {
                            
                            btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 8, recordBtn.frame.origin.y, BtnW, BtnH);
                        }else{
                            
                            btn.frame =CGRectMake(0, recordBtn.frame.origin.y+recordBtn.frame.size.height+8, BtnW, BtnH);
                        }
                    }
                    
                    [btn setTitle:name forState:UIControlStateNormal];
                    [btn setTitleColor:ThemeColor forState:UIControlStateSelected];
                    [btn setTitleColor:DisabledTextColor forState:UIControlStateNormal];
                    [self addSubview:btn];
                    
                    if (btn.frame.origin.y>30) {
                        btn.hidden= NO;
                    }
                    self.maxY = CGRectGetMaxY(btn.frame);
                    recordBtn = btn;
                    
                    btn.tag = 100 + i;
                }
                
            }
        }
    }
    
    
    return self;
    
}
- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (void)settingTagStr:(NSString *)type{
    for (UIButton *btn in self.subviews) {
        if ([btn.currentTitle isEqualToString:type]) {
            if (self.selectBtn) {
                self.selectBtn.selected = NO;
                self.selectBtn.layer.borderColor = [DisabledTextColor CGColor];
                self.selectBtn = nil;
                
            }
            btn.selected = YES;
            self.selectBtn = btn;
            self.selectBtn.layer.borderColor = [ThemeColor CGColor];
            break;
        }else {
            self.selectBtn.selected = NO;
            self.selectBtn.layer.borderColor = [DisabledTextColor CGColor];
            self.selectBtn = nil;
            
        }
    }
}
-(void) BtnClick:(UIButton *)sender{

    WS(weakSelf);
 
    
    if ([sender.currentTitle isEqualToString:@"自定义"]) {
        
        [[LGAlertView alertViewWithTextFieldsAndTitle:@"编辑书签" message:nil numberOfTextFields:1 textFieldsSetupHandler:^(UITextField * _Nonnull textField, NSUInteger index) {
            
        } buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            LGAlertViewTextField *textField  =  [alertView.textFieldsArray firstObject];
           
            [weakSelf.array removeObjectAtIndex:weakSelf.array.count-1];
            [weakSelf.array insertObject:textField.text atIndex:0];
            [weakSelf reloadData];
        }] show];
    
    }else {
        sender.selected = !sender.selected;
        if (self.selectBtn) {
            self.selectBtn.selected = NO;
            self.selectBtn.layer.borderColor = [DisabledTextColor CGColor];
            self.selectBtn = nil;
            
        }
        if (sender.selected) {
            
            self.selectBtn = sender;
            self.selectBtn.layer.borderColor = [ThemeColor CGColor];
            
        }
    }
}
- (void)reloadData {
  
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.array];
    [self.array removeAllObjects];
    [self initWithFrame:self.frame  dataArr:newArray atType:WARTagViewViewTypeDefualt];
}
- (void)alertView:(nonnull LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title {
    
}
- (void)alertView:(nonnull LGAlertView *)alertView didDismissAfterClickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title {
    
}
@end
