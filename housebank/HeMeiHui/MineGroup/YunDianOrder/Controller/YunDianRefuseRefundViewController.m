//
//  YunDianRefuseRefundViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianRefuseRefundViewController.h"
#import "YunDianNewRefundProductView.h"
#import "YunDianRefundSelectImgView.h"
#import "UIView+addGradientLayer.h"
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"

@interface YunDianRefuseRefundViewController ()<UITextViewDelegate,YunDianRefundSelectImgViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *viewOnScroll;

@property (nonatomic, strong) UILabel *refundNoLabel;
@property (nonatomic, strong) YunDianNewRefundProductView *productView;
@property (nonatomic, strong) UILabel *refundMoneyLabel;

@property (nonatomic, strong) UITextView *irTextView;
@property (nonatomic, strong) UILabel *labelTextNum;
@property (nonatomic, strong) YunDianRefundSelectImgView *refundSelectImgView;
@end

@implementation YunDianRefuseRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"拒绝退款";
    
    [self setUI];
    
}
- (void)setUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 50)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenW, 458 + ((ScreenW - 75) / 4 ) * 2);
    [self.view addSubview:self.scrollView];
    //    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //        [self requestReturnDetails];
    //    }];
    
    self.viewOnScroll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 458 + ((ScreenW - 75) / 4 ) * 2)];
    [self.scrollView addSubview:self.viewOnScroll];
    
    [self.viewOnScroll addSubview:self.refundNoLabel];
    self.refundNoLabel.text = [NSString stringWithFormat:@"退款编号：%@",self.refundModel.refundNo];
    [self.refundNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOnScroll).offset(15);
        make.height.mas_equalTo(40);
    }];
    
    [self.viewOnScroll addSubview:self.productView];
    self.productView.refundDetailModel = self.refundModel;
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewOnScroll);
        make.top.equalTo(self.refundNoLabel.mas_bottom);
        make.height.mas_equalTo(113);
    }];
    
    [self.viewOnScroll addSubview:self.refundMoneyLabel];
    
    NSString *stringMoney = [NSString stringWithFormat:@"退款金额：¥%.2f",[self.refundModel.returnMoney floatValue]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringMoney];
    [attrString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0,6)];
    [attrString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xF3344A) range:NSMakeRange(5,stringMoney.length - 5)];

    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0,5)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(5,1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(6,stringMoney.length - 6)];

    
    
    self.refundMoneyLabel.attributedText = attrString;

    [self.refundMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOnScroll).offset(15);
        make.top.equalTo(self.productView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.viewOnScroll addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOnScroll).offset(15);
        make.right.equalTo(self.viewOnScroll).offset(-15);
        make.top.equalTo(self.refundMoneyLabel.mas_bottom);
        make.height.mas_equalTo(0.8);
    }];
    
    
    _irTextView = [[UITextView alloc] init];
    _irTextView.delegate = self;
    [self.viewOnScroll addSubview:_irTextView];
    [_irTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOnScroll).offset(10);
        make.right.equalTo(self.viewOnScroll).offset(-10);
        make.top.equalTo(line1.mas_bottom);
        make.height.mas_equalTo(140);
    }];
    
    // _placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入拒绝理由";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = HEXCOLOR(0x999999);
    [placeHolderLabel sizeToFit];
    [_irTextView addSubview:placeHolderLabel];
    
    // same font
    _irTextView.font = [UIFont systemFontOfSize:14];
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    [_irTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    
    _labelTextNum = [[UILabel alloc] init];
    _labelTextNum.textColor =  HEXCOLOR(0x666666);
    _labelTextNum.font = [UIFont systemFontOfSize:13];
    _labelTextNum.textAlignment = NSTextAlignmentRight;
    _labelTextNum.text = @"0/300";
    [self.viewOnScroll addSubview:_labelTextNum];
    [_labelTextNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.irTextView).offset(-10);
        make.bottom.equalTo(self.irTextView).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(13);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UITextViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.viewOnScroll addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOnScroll).offset(15);
        make.right.equalTo(self.viewOnScroll).offset(-15);
        make.top.equalTo(self.irTextView.mas_bottom);
        make.height.mas_equalTo(0.8);
    }];
    
    UILabel *labelt = [[UILabel alloc] init];
    labelt.text = @"上传凭证";
    labelt.font = [UIFont systemFontOfSize:14];
    labelt.textColor = HEXCOLOR(0x333333);
    labelt.textAlignment = NSTextAlignmentLeft;
    [self.viewOnScroll addSubview:labelt];
    [labelt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOnScroll).offset(15);
        make.top.equalTo(line2.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    
    
    [self.viewOnScroll addSubview:self.refundSelectImgView];
    [self.refundSelectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelt.mas_bottom);
        make.left.equalTo(self.viewOnScroll);
        make.right.equalTo(self.viewOnScroll);
        make.height.mas_equalTo(((ScreenW - 75) / 4 ) * 2 + 45);
    }];
    
    
    UIButton *btnSubmit = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSubmit setTitle:@"确认提交" forState:(UIControlStateNormal)];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnSubmit.backgroundColor = HEXCOLOR(0xFF0000);
    btnSubmit.titleLabel.font = PFR16Font;
    [btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnSubmit];
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.view layoutIfNeeded];
    [btnSubmit addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [btnSubmit bringSubviewToFront:btnSubmit.titleLabel];
    
}
- (void)btnSubmitAction{
    NSLog(@"submit");
    if (self.irTextView.text.length == 0) {
        [self showSVProgressHUDErrorWithStatus:@"请输入拒绝理由!"];
        return;
    }
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    
    NSString *url = [NSString stringWithFormat:@"%@?sid=%@",[[NetWorkManager shareManager] getForKey:@"order.user/m/order-refund/seller-confirm-refund"],sid];

    NSMutableArray *arrImage = [self requsetImageArrFromSelectImgView];
    
    NSMutableDictionary *dicParams = [@{
        @"refundNo":self.refundModel.refundNo,
        
        @"refundState":@(3),//2=同意，3=拒绝
        
        @"reason":self.irTextView.text,
        
       
    } mutableCopy];
    if (arrImage.count > 0) {
        [dicParams setObject:arrImage forKey:@"imageInfoList"];
    }
    [HFCarRequest requsetUrl:url withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dicParams success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:@"已拒绝退款!"];
            if (self.block) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.scrollView.mj_header endRefreshing];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location == 0 && [text isEqualToString:@" "]){
        return NO;
    }
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return [self validateNumber:text textView:textView range:range length:300];
}
#pragma mark - 获取图片url数组
- (NSMutableArray*)imageArrFromSelectImgView{
    NSMutableArray *arrImg = [NSMutableArray array];
    for (NSDictionary *dic in self.refundSelectImgView.arr) {
        if ([[dic objectForKey:@"flag"] isEqualToString:@"added"]) {
            [arrImg addObject:[[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]] get_Image_String]];
        }
    }
    return arrImg;
}
#pragma mark - 获取图片请求url数组
- (NSMutableArray*)requsetImageArrFromSelectImgView{
    NSMutableArray *arrImg = [NSMutableArray array];
    for (NSDictionary *dic in self.refundSelectImgView.arr) {
        if ([[dic objectForKey:@"flag"] isEqualToString:@"added"]) {
            NSDictionary *dicImg = @{@"imagePath":[dic objectForKey:@"url"]};
            [arrImg addObject:dicImg];
        }
    }
    return arrImg;
}
- (void)yunDianRefundSelectImgViewDelegateAtction:(NSInteger)index{
    [self yunDianRefundSelectImgViewDelegateClickImgIndex:index imgArr:[self imageArrFromSelectImgView]];
}
#pragma mark - 图片点击模态
- (void)yunDianRefundSelectImgViewDelegateClickImgIndex:(NSInteger)index imgArr:(NSArray *)imgArr{
    if (imgArr.count > index) {
        [SVProgressHUD show];
        NSMutableArray * selectImageTap = [NSMutableArray arrayWithCapacity:1];
        /*先从缓存中取图片  看有没有  如果没有 在根据url来转换data 获取到image
         如果有 则取出  存到数组中*/
        for (int i = 0; i < imgArr.count; i++) {
            [selectImageTap addObject:[MyUtil getCacheImageWithImageUrl:imgArr[i]]];
        }
        [SVProgressHUD dismiss];
        if (selectImageTap.count > 0) {
            CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
            // 传入图片数组
            pictureVC.picArray = selectImageTap;
            pictureVC.picUrlArray = imgArr;
            // 标记点击的是哪一张图片
            pictureVC.touchIndex = index;
            //    pictureVC.hiddenTextLable = YES;  // 控制lable是否显示
            CLPresent *present = [CLPresent sharedCLPresent];
            pictureVC.modalPresentationStyle = UIModalPresentationCustom;
            pictureVC.transitioningDelegate = present;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:pictureVC animated:YES completion:nil];
        }
    }
}
- (void)UITextViewTextDidChangeNotification:(NSNotification *)notify{
    
    
    if (_irTextView.isFirstResponder) {
        UITextRange *rang = self.irTextView.markedTextRange; // 获取非=选中状态文字范围
        if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
            NSString *keyword = self.irTextView.text;
            _labelTextNum.text = [NSString stringWithFormat:@"%lu/100", (unsigned long)keyword.length];
            
        }
    }
    
    
}



- (BOOL)validateNumber:(NSString*)string
              textView:(UITextView *)textView
                 range:(NSRange)range
                length:(NSInteger)length
{
    
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    // Check for total length
    NSUInteger proposedNewLength = textView.text.length - range.length + string.length;
    if (proposedNewLength >= length + 1) {
        return NO;//限制长度
    }
    
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character > 0 && character < 128){
            
            return YES; // 48 unichar for 0
        }
        
    }
    
    
    if([self matchStringFormat:string withRegex:@"^[A-Za-z]*$"]){
        
        return YES;
    }
    if([self matchStringFormat:string withRegex:@"^[\u4e00-\u9fa5]*$"]){
        
        return YES;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data.length > 3) {
        //        showAlert(@"提示", @"禁止输入表情");
        return NO;
    }
    
    return YES;
}
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:matchedStr];
}


- (UILabel *)refundMoneyLabel{
    if (!_refundMoneyLabel) {
        _refundMoneyLabel = [[UILabel alloc] init];
        _refundMoneyLabel.text = @"退 款 金 额：";
        _refundMoneyLabel.font = [UIFont systemFontOfSize:13];
        _refundMoneyLabel.textColor = HEXCOLOR(0x333333);
        _refundMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundMoneyLabel;
}
- (YunDianNewRefundProductView *)productView{
    if (!_productView) {
        _productView = [[YunDianNewRefundProductView alloc] init];
        _productView.orderInfoView.hidden = YES;
        _productView.isRefuseRefund = YES;
    }
    return _productView;
}
- (YunDianRefundSelectImgView *)refundSelectImgView{
    if (!_refundSelectImgView) {
        _refundSelectImgView = [[YunDianRefundSelectImgView alloc] init];
        _refundSelectImgView.delegate = self;
    }
    return _refundSelectImgView;
}
- (UILabel *)refundNoLabel{
    if (!_refundNoLabel) {
        _refundNoLabel = [[UILabel alloc] init];
        _refundNoLabel.text = @"退 款 编 号 ：";
        _refundNoLabel.font = [UIFont systemFontOfSize:13];
        _refundNoLabel.textColor = HEXCOLOR(0x333333);
        _refundNoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundNoLabel;
    
}
@end
