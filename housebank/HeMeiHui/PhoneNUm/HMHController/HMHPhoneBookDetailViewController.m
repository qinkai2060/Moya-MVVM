//
//  HMHPhoneBookDetailViewController.m
//  housebank
//
//  Created by Qianhong Li on 2017/11/2.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHPhoneBookDetailViewController.h"
#import "HMHPhoneBookDetailInfoView.h"
#import "HMHSettingRemarkViewController.h"
#import "HMHMessageViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESSessionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CircleOfFriendUtil.h"

@interface HMHPhoneBookDetailViewController ()
<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>
{
    UILabel *HMH_areaLab;
    HMHPhoneBookDetailInfoView *HMH_headView;
    
}
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *HMH_fristBtn;
@property (nonatomic, strong) UIButton *HMH_secondBtn;

@property (nonatomic, strong) NSString *HMH_remarkStr;

@property (nonatomic, strong) HMHPhoneBookDetailInfoModel *HMH_detailInfoModel;

@property (nonatomic, strong) NSMutableArray *HMH_infoImageArr;

@end

@implementation HMHPhoneBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//
////    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    self.navigationItem.title = @"详细资料";
    
    [self HMH_createNav];
    
    self.HMH_infoImageArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    if (self.contactId.length > 0) {
        [self HMH_loadDetailData];
    }
    [self HMH_createTableview];
}

-(void)HMH_createNav{
    self.navigationController.navigationBarHidden = YES;
    
    UIView *HMH_navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44 + self.HMH_statusHeghit_wd)];
    HMH_navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:HMH_navView];
    //
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(70, self.HMH_statusHeghit_wd, HMH_navView.frame.size.width - 140, HMH_navView.frame.size.height - self.HMH_statusHeghit_wd)];
    bottomLab.text = @"详细资料";
    bottomLab.textAlignment = NSTextAlignmentCenter;
    [HMH_navView addSubview:bottomLab];

    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=CGRectMake(0,20, 60, 44);
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

#pragma mark 数据请求
- (void)HMH_loadDetailData{
    NSString *typeStr;

    if ([self.uid isEqual:self.contactId]) {
        typeStr = @"1"; // 自己
    } else {
        typeStr = @"2"; // 他人
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]]; // 登录的sid

    NSDictionary *getDic =@{
                            @"uid":self.contactId,
                            @"sid":sidStr, //
                            @"type":typeStr,
                            };
    NSString *urlStr = [[NetWorkManager shareManager] getForKey:@"sns.moments/info-base/get"];

    [self getData:getDic withUrl:urlStr isJsonRequest:YES andCurrentRequestName:@"detailInfo"];
}

- (void)guanZhuRequestWithType:(NSString *)type{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]]; // 登录的sid
    
    NSDictionary *getDic =@{
                            @"uids":self.contactId,
                            @"follow":type, // 1|0<关注，1关注，0取消关注>
                            @"sid":sidStr,
                            };
   NSString *urlStr = [[NetWorkManager shareManager] getForKey:@"sns.moments/info-follow/save"];
    if (urlStr) {
        [self getData:getDic withUrl:urlStr isJsonRequest:YES andCurrentRequestName:@"guanzhu"];
    }
}

- (BOOL)navigationShouldPopOnBackButton{
    if (self.updatePersonModel) {
        self.updatePersonModel(self.personInfoModel);
    }
    return YES;
}

- (void)HMH_createTableview{
    
    HMH_headView = [[HMHPhoneBookDetailInfoView alloc] initWithFrame:CGRectMake(0,0,ScreenW, 90)];
    __weak typeof (self)weakSelf = self;
    HMH_headView.guanZhuClick = ^(UIButton *guanZhuBtn) {
        NSString *typeStr;
        if ([weakSelf.HMH_detailInfoModel.follow isEqualToString:@"true"]) { //
            
            [guanZhuBtn setTitle:@" 关注" forState:UIControlStateNormal];
            [guanZhuBtn setImage:[UIImage imageNamed:@"chat_detail_unconcern"] forState:UIControlStateNormal];
            typeStr = @"0";
            
        } else if([weakSelf.HMH_detailInfoModel.follow isEqualToString:@"false"]){ // 未关注
            [guanZhuBtn setTitle:@" 已关注" forState:UIControlStateNormal];
            [guanZhuBtn setImage:[UIImage imageNamed:@"chat_detail_concern"] forState:UIControlStateNormal];
            typeStr = @"1";
        }
        
        [weakSelf guanZhuRequestWithType:typeStr];
    };
    
    [self.view addSubview:HMH_headView];
    
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,  self.HMH_statusHeghit_wd + 44, ScreenW, ScreenH -  self.HMH_statusHeghit_wd - 44) style:UITableViewStylePlain];
    _tableview.backgroundColor = RGBACOLOR(240, 240, 244, 1);

    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.scrollEnabled = NO;
    _tableview.tableHeaderView = HMH_headView;
    _tableview.tableFooterView = [self HMH_CreateBottomView];
    _tableview.separatorColor = RGBACOLOR(240, 240, 244, 1);
    [self.view addSubview:_tableview];
    
    if (self.personInfoModel) {
        [HMH_headView reshDetailInfoViewWithModel:self.personInfoModel withDetailModel:self.HMH_detailInfoModel];
    }
    [self HMH_refreshBottomBtn];
}
- (UIView *)HMH_CreateBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 180)];
    bottomView.backgroundColor = RGBACOLOR(240, 240, 244, 1);
    
    //
    _HMH_fristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HMH_fristBtn.frame = CGRectMake(20, 40, ScreenW - 40, 44);
    _HMH_fristBtn.backgroundColor = RGBACOLOR(35, 174, 165, 1);
    _HMH_fristBtn.layer.masksToBounds = YES;
    _HMH_fristBtn.layer.cornerRadius = 5.0;
    _HMH_fristBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_HMH_fristBtn addTarget:self action:@selector(fristBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_HMH_fristBtn];
    
    //
    _HMH_secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HMH_secondBtn.frame = CGRectMake(_HMH_fristBtn.frame.origin.x, CGRectGetMaxY(_HMH_fristBtn.frame) + 20, _HMH_fristBtn.frame.size.width, _HMH_fristBtn.frame.size.height);
    _HMH_secondBtn.backgroundColor = RGBACOLOR(33, 142, 195, 1);
    _HMH_secondBtn.layer.masksToBounds = YES;
    _HMH_secondBtn.layer.cornerRadius = 5.0;
    [_HMH_secondBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
    [_HMH_secondBtn addTarget:self action:@selector(TelPhone:) forControlEvents:UIControlEventTouchUpInside];
    _HMH_secondBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [bottomView addSubview:_HMH_secondBtn];

    return bottomView;
    
}

- (void)fristBtnClick:(UIButton *)btn{
    if ([self.personInfoModel.inviteRole isEqualToString:@"1"]) { //会员
        NSString *message = [[NSUserDefaults standardUserDefaults]objectForKey:@"smsMsg"];
        [self sendContacts:@[self.personInfoModel.mobilePhone] message:message];
    } else { // 发送消息
//        if (self.personInfoModel.contactUserId.length > 0 || self.HMH_detailInfoModel.uid.length > 0) {
//            NIMSession *session;
//            if (self.HMH_detailInfoModel.uid.length > 0) {
//                session = [NIMSession session:self.HMH_detailInfoModel.uid type:NIMSessionTypeP2P];
//            } else if (self.personInfoModel.contactUserId.length > 0){
//                session = [NIMSession session:self.personInfoModel.contactUserId type:NIMSessionTypeP2P];
//            }
//
//            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
//            [self.navigationController pushViewController:vc animated:YES];
//        } else {
//            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"对方不是会员" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//            [alter addAction:action];
//            [self presentViewController:alter animated:YES completion:nil];
//        }
    }
}

- (void)HMH_refreshBottomBtn{
    if (self.HMH_detailInfoModel.contactRemark.length > 0) {
        _HMH_remarkStr = self.HMH_detailInfoModel.contactRemark;
    } else if (self.personInfoModel.contactRemark.length > 0){
        _HMH_remarkStr = self.personInfoModel.contactRemark;
    }
    if ([self.personInfoModel.inviteRole isEqualToString:@"1"]) { //会员
        _HMH_fristBtn.hidden = NO;
        [_HMH_fristBtn setTitle:@"邀请成为会员" forState:UIControlStateNormal];
    } else {
        _HMH_fristBtn.hidden = YES;
    }
//    else {
//        [_HMH_fristBtn setTitle:@"发送消息" forState:UIControlStateNormal];
//    }
}
#pragma mark
- (void)TelPhone:(UIButton *)btn{
    if (self.HMH_detailInfoModel.mobilePhone.length > 0) {
        [self telWithPhoneNum:self.HMH_detailInfoModel.mobilePhone];
    } else if (self.personInfoModel.mobilePhone.length > 0){
        [self telWithPhoneNum:self.personInfoModel.mobilePhone];
    }
}

- (UIView *)createImagesViewWithImages:(NSArray *)imagesArr andWithImageType:(NSArray *)imageType{
    UIView *imageBottomView =[[UIView alloc] initWithFrame:CGRectMake(100, 0, ScreenW - 100 - 50, 70)];
    imageBottomView.backgroundColor = [UIColor whiteColor];
    
    long imageCount = 0;
    if (imagesArr.count >= 4) {
        imageCount = 4;
    }else if (imagesArr.count == 1){
        NSString *str1 = imagesArr[0];
        if (str1.length > 0) {
            imageCount = 1;
        } else {
            imageCount = 0;
        }
    } else {
        imageCount = imagesArr.count;
    }
    
    for (int i = 0; i < imageCount; i++) {
        NSString *typeStr = [NSString stringWithFormat:@"%@",imageType[i]];
        
        if ([typeStr isEqualToString:@"1"]) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((50 + 5) * i, 10, 50, 50)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagesArr[i]] placeholderImage:[UIImage imageNamed:@"circle_default_loading_error"]];
            
            [imageBottomView addSubview:imageView];
            
        } else if ([typeStr isEqualToString:@"2"]){
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((50 + 5) * i, 10, 50, 50)];
            //            [imageView sd_setImageWithURL:[NSURL URLWithString:imagesArr[i]] placeholderImage:[UIImage imageNamed:@"headerImage"]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageBottomView addSubview:imageView];
            
            UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            playBtn.frame = CGRectMake(0, 0, imageView.frame.size.width,imageView.frame.size.height);
            [playBtn setImage:[UIImage imageNamed:@"circle_video_play_small"] forState:UIControlStateNormal];
            playBtn.backgroundColor = [UIColor clearColor];
            [imageView addSubview:playBtn];
            
            if ([imagesArr[i] length] <= 0) {
                imageView.image = [UIImage imageNamed:@"circle_default_loading_error"];
            } else {
                NSString *str = [NSString stringWithFormat:@"%@%@",imagesArr[i],@".jpg"];
                
                dispatch_queue_t imagequeue = dispatch_queue_create("com.company.imageLoadingQueue", NULL);
                dispatch_async(imagequeue, ^{
                    UIImage *cashImage;
                    cashImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:str];
                    
                    if (!cashImage) {
                        cashImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:str];
                    }
                    if (!cashImage) {
                        cashImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:str];
                    }
                    UIImage *image1;
                    if (!cashImage) {
                        image1 = [CircleOfFriendUtil getVideoPreViewImage:[NSURL URLWithString:imagesArr[i]]];
                        
                        [[SDImageCache sharedImageCache] storeImage:image1 forKey:str completion:^{
                        }];
                        [[SDImageCache sharedImageCache] storeImage:image1 forKey:str toDisk:YES completion:^{
                        }];
                    }
                    dispatch_async(dispatch_get_main_queue(),^{
                                       if (cashImage) {
                                           imageView.image = cashImage;
                                       } else if(image1){
                                           imageView.image = image1;
                                       } else {
                                           imageView.image = [UIImage imageNamed:@"circle_default_loading_error"];
                                       }
                                   });
                });
            }
        }
    }
    return imageBottomView;
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ManagerTools *manageTools =  [ManagerTools ManagerTools];
    if (manageTools.appInfoModel) {
        if (((!manageTools.appInfoModel.momentsSwitch) && (![manageTools.appInfoModel.momentsSwitch isEqualToString:@"0"]))|| [manageTools.appInfoModel.momentsSwitch isEqualToString:@"1"]) { // 开关 判断是否打开 个人相册
            if (self.personInfoModel.contactUserId.length > 0 || self.HMH_detailInfoModel.uid.length > 0) {
                // 打开相册 （合友圈的入口）
//                return 3;
            }
        }
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor =  RGBACOLOR(240, 240, 244, 1);
        cell.textLabel.numberOfLines = 2;
        if (_HMH_remarkStr.length == 0) {
            cell.textLabel.text = @"设置备注";
        } else {
            cell.textLabel.text = _HMH_remarkStr;
        }
        cell.textLabel.textColor = RGBACOLOR(97, 97, 97, 1);
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    } else if (indexPath.row == 1){
        cell.textLabel.text = @"地区";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        //
        HMH_areaLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, ScreenW - 200, 40)];
        HMH_areaLab.font = [UIFont systemFontOfSize:14.0];
        
        NSString *areaStr = [[NSString alloc] init];
        if (self.HMH_detailInfoModel) {
            if (self.HMH_detailInfoModel.cityName.length == 0) {
                self.HMH_detailInfoModel.cityName = @"";
            }
            if (self.HMH_detailInfoModel.regionName.length == 0) {
                self.HMH_detailInfoModel.regionName = @"";
            }
            if (self.HMH_detailInfoModel.blockName.length == 0) {
                self.HMH_detailInfoModel.blockName = @"";
            }
            areaStr = [NSString stringWithFormat:@"%@%@%@",self.HMH_detailInfoModel.cityName,self.HMH_detailInfoModel.regionName,self.HMH_detailInfoModel.blockName];
        } else if(self.personInfoModel){
            if (self.personInfoModel.cityName.length == 0) {
                self.personInfoModel.cityName = @"";
            }
            if (self.personInfoModel.regionName.length == 0) {
                self.personInfoModel.regionName = @"";
            }
            if (self.personInfoModel.blockName.length == 0) {
                self.personInfoModel.blockName = @"";
            }
            areaStr = [NSString stringWithFormat:@"%@%@%@",self.personInfoModel.cityName,self.personInfoModel.regionName,self.personInfoModel.blockName];
        }
        
        if (areaStr.length == 0) {
            areaStr = @"未知";
        }
        
        HMH_areaLab.text = areaStr;
        
        for (UILabel *lab in cell.contentView.subviews) {
            [lab removeFromSuperview];
        }
        [cell.contentView addSubview:HMH_areaLab];
        
    } else if (indexPath.row == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.textLabel.text = @"个人相册";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];

        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        if (self.HMH_infoImageArr.count > 0) {
            [self.HMH_infoImageArr removeAllObjects];
        }
        
        NSArray *imgArr = [self.HMH_detailInfoModel.pubMedia componentsSeparatedByString:@","];
        NSArray *typeArr = [self.HMH_detailInfoModel.recentPubType componentsSeparatedByString:@","];
        
        [self.HMH_infoImageArr addObjectsFromArray:imgArr];
        
        [cell.contentView addSubview:[self createImagesViewWithImages:self.HMH_infoImageArr andWithImageType:typeArr]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HMHSettingRemarkViewController *vc = [[HMHSettingRemarkViewController alloc] init];
        vc.remarkInfo = _HMH_remarkStr;
        if (self.HMH_detailInfoModel.mobilePhone.length > 0) {
            vc.mobilePhone = self.HMH_detailInfoModel.mobilePhone;
        } else {
            vc.mobilePhone = self.personInfoModel.mobilePhone;
        }
        __weak typeof(self) wself = self;
        vc.remarkCallBack = ^(NSString *remarkStr) {
            wself.personInfoModel.contactRemark = remarkStr;
            _HMH_remarkStr = remarkStr;
            [_tableview reloadData];
        };
        vc.uid = self.uid;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2){
        //  合友圈
//        HMHHeFaCircleOfFriendViewController *VC = [[HMHHeFaCircleOfFriendViewController alloc]init];
//        if (self.HMH_detailInfoModel.uid.length > 0) {
//            VC.uidStr = self.HMH_detailInfoModel.uid;
//        } else {
//            VC.uidStr = self.personInfoModel.contactUserId;
//        }
//        VC.personInfoModel = self.HMH_detailInfoModel;
//        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;

    } else if (indexPath.row == 1){
        return 40;
    } else {
        return 70;
    }
}

#pragma mark 打电话事件
- (void)telWithPhoneNum:(NSString *)phoneNum{
    
    NSString *phone =[NSString string]; ;
    NSArray *arr = [phoneNum componentsSeparatedByString:@" "];
    if (arr.count) {
        for (NSString*str in arr) {
            phone =  [phone stringByAppendingString:str];
        }
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    });
}

#pragma mark 发送短信
- (void)sendContacts:(NSArray*)phoneNumbers message:(NSString *)message {
    HMHMessageViewController *messageVC = [[HMHMessageViewController alloc]init];
    messageVC.messageComposeDelegate = self;
    messageVC.body = message;
    messageVC.recipients = phoneNumbers;
    //         [[[[messageVC viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self presentViewController:messageVC animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    });
}

#pragma mark 数据请求 =====get=====
- (void)getData:(NSDictionary*)dic withUrl:(NSString *)url isJsonRequest:(BOOL)isJsonRequest andCurrentRequestName:(NSString *)currentRequestName{

    NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    
   
    [HFCarRequest requsetUrl:urlstr withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([currentRequestName isEqualToString:@"detailInfo"]) { // 基本信息
            
            [self HMH_getPrcessdata:request.responseObject];
            
        } else if ([currentRequestName isEqualToString:@"guanzhu"]){ // 关注
            [self getGuanZhuBtnCallBack:request.responseObject withRequestDic:dic];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}

// 关注数据返回
- (void)getGuanZhuBtnCallBack:(id)data withRequestDic:(NSDictionary *)requestDic{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resDic = data;
        NSInteger state = [resDic[@"state"] integerValue];
        if (state == 1) {
            if ([requestDic[@"follow"] length] > 0) {
                if ([requestDic[@"follow"] isEqualToString:@"1"]) { // 状态是关注 请求成功之后是取消
                    self.HMH_detailInfoModel.follow = @"true";
                } else if ([requestDic[@"follow"] isEqualToString:@"0"]){
                    self.HMH_detailInfoModel.follow = @"false";
                }
            }
            [HMH_headView reshDetailInfoViewWithModel:self.personInfoModel withDetailModel:self.HMH_detailInfoModel];
        } else {
            NSLog(@"%@",resDic[@"state"]);
        }
    }
}
#pragma mark   // 列表数据返回
- (void)HMH_getPrcessdata:(id)data{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resDic = data;
        NSInteger state = [resDic[@"state"] integerValue];
        if (state == 1) {
            NSDictionary *dataDic = resDic[@"data"];
            NSDictionary *content = dataDic[@"content"];
            if ([content isKindOfClass:[NSDictionary class]]) {
                self.HMH_detailInfoModel = [[HMHPhoneBookDetailInfoModel alloc] init];
                [self.HMH_detailInfoModel setValuesForKeysWithDictionary:content];
            }
        } else {
            NSLog(@"%@",resDic[@"state"]);
        }
        [HMH_headView reshDetailInfoViewWithModel:self.personInfoModel withDetailModel:self.HMH_detailInfoModel];

        [_tableview reloadData];
    }
}

/** 发送信息后的回调方法 **/
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:^{}];
    switch (result) {
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        case MessageComposeResultSent:
            //信息传送成功
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            break;
        default:
            break;
    }
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
