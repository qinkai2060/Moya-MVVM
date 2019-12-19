//
//  HMHSettingRemarkViewController.m
//  housebank
//
//  Created by Qianhong Li on 2017/11/3.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHSettingRemarkViewController.h"
#import "NIMGrowingTextView.h"

@interface HMHSettingRemarkViewController ()<NIMGrowingTextViewDelegate>
{
    UIView *HMH_whiteView;
}
@property (nonatomic, strong) NIMGrowingTextView *HMH_inputTextView;

@end

@implementation HMHSettingRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(240, 240, 244, 1);
//    self.navigationItem.title = @"设置备注";
    
    [self HMH_createNav];
    
    [self HMH_createUI];
}

-(void)HMH_createNav{
    self.navigationController.navigationBarHidden = YES;
    
    UIView *HMH_navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44 + self.HMH_statusHeghit_wd)];
    HMH_navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:HMH_navView];
    //
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(70, self.HMH_statusHeghit_wd, HMH_navView.frame.size.width - 140, HMH_navView.frame.size.height - self.HMH_statusHeghit_wd)];
    bottomLab.text = @"设置备注";
    bottomLab.textAlignment = NSTextAlignmentCenter;
    [HMH_navView addSubview:bottomLab];

    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0,self.HMH_statusHeghit_wd, 60, 44 -1);
    [backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 44, 44 - 1)];
    backImageView.image=[UIImage imageNamed:@"VH_blackBack"];
    [backButton addSubview:backImageView];
    [HMH_navView addSubview:backButton];
}

// 返回上一页
- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)HMH_createUI{
    //
    HMH_whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + self.HMH_statusHeghit_wd + 20, ScreenW, 80)];

    HMH_whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:HMH_whiteView];
    
    _HMH_inputTextView = [[NIMGrowingTextView alloc] initWithFrame:CGRectMake(0, 10,ScreenW, 60)];
    _HMH_inputTextView.font = [UIFont systemFontOfSize:16.0f];
    _HMH_inputTextView.maxNumberOfLines = 4;
    _HMH_inputTextView.minNumberOfLines = 1;
    _HMH_inputTextView.isFromRemark = YES;
    _HMH_inputTextView.textColor = [UIColor blackColor];
    _HMH_inputTextView.backgroundColor = [UIColor whiteColor];
    //    NSLog(@"%f",[[UIDevice currentDevice].systemVersion floatValue]);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11.0f) {
        [_HMH_inputTextView setContentInset:UIEdgeInsetsMake(-65, 2, 5, -2)];//设置UITextView的内边距
        [_HMH_inputTextView setTextAlignment:NSTextAlignmentLeft];//并设置左对齐
    }
    //    _HMH_inputTextView.nim_size = [_HMH_inputTextView intrinsicContentSize];
    _HMH_inputTextView.textViewDelegate = self;
    NSString *remarkStr = @"设置备注";
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:remarkStr];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, remarkStr.length)];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(168, 168, 168, 1) range:NSMakeRange(0, remarkStr.length)];
    if (self.remarkInfo.length == 0) {
        _HMH_inputTextView.placeholderAttributedText = aAttributedString;
    } else {
        _HMH_inputTextView.text = self.remarkInfo;
    }
    _HMH_inputTextView.returnKeyType = UIReturnKeyDefault;
    
    [HMH_whiteView addSubview:_HMH_inputTextView];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, ScreenH - 40 - 44, ScreenW - 20, 44);
    sureBtn.backgroundColor = RGBACOLOR(33, 142, 195, 1);
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 5.0;
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

- (void)sureBtnClick:(UIButton *)btn{
    [_HMH_inputTextView resignFirstResponder];
    if (_HMH_inputTextView.text.length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"备注信息不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    NSDictionary *postDic = @{
                              @"uid":self.uid,
                              @"mobilePhone":self.mobilePhone,
                              @"contactRemark":_HMH_inputTextView.text
                              };
NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./broker/contacts/modifyContactRemark"];
    [self postData:postDic withUrl:utrl];
}

- (void)postData:(NSDictionary*)dic withUrl:(NSString *)url{

    NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    
    [HFCarRequest requsetUrl:urlstr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resDic = request.responseObject;
            NSInteger state = [resDic[@"state"] integerValue];
            if (state == 1) {
                NSDictionary *dataDic = resDic[@"data"];
                if (self.remarkCallBack) {
                    self.remarkCallBack(_HMH_inputTextView.text);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            return;
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_HMH_inputTextView resignFirstResponder];
}


- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText{
    
    NSString *remarkStr = [NSString stringWithFormat:@"%@%@",_HMH_inputTextView.text,replacementText];
    if (range.length==1) {//删除键
        if (_HMH_inputTextView.text.length>0) {
            remarkStr = [remarkStr substringWithRange:NSMakeRange(0, remarkStr.length-1)];
        }
    }
    if (remarkStr.length > 100) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"备注字数不能大于100" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}


-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end

