//
//  HMHPhoneBookViewController.m
//  PhoneNumDemo
//
//  Created by Qianhong Li on 2017/8/31.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import "HMHPhoneBookViewController.h"
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import "HMHPersonInfoModel.h"
#import "HMHPhoneBookTableViewCell.h"
#import "ChineseToPinyin.h"
#import "HMHPBSearchResultViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESSessionViewController.h"
#import "NTESSessionListViewController.h"
#import "HMHMessageViewController.h"
#import "HMHPhoneBookDetailViewController.h"
#import "NTESPersonalCardViewController.h"
#import "HMHPopAppointViewController.h"
#import "AESTools.h"
#import "CloudVipAlertView.h"
// 加密key
#define AESKey @"d7b85f6e214abcda"
@interface HMHPhoneBookViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *HMH_sectionTitles; // 区头的title数组
@property (nonatomic, strong) NSMutableArray *HMH_suoYinSectionArr; // 创建索引中分区索引的数组
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *HMH_changeArrary;//要发送给服务端的
@property (nonatomic, strong) NSMutableArray *HMH_localArray;//本地的数据库
@property (nonatomic, strong) NSMutableArray *HMH_mobileAddress;//手机通讯录
@property (nonatomic, strong) NSMutableArray *HMH_comeBackAddress;//网络返回通讯录
@property (nonatomic, strong) NSMutableArray *HMH_dataSource;//网络返回通讯录
@property (nonatomic, strong) NSMutableArray *HMH_sectionNumArr;
@property (nonatomic, strong) UISearchController *HMH_searchController;
@property (nonatomic, strong) NSString *HMH_sendMessageMobile;
@property (nonatomic, strong) NSMutableDictionary *HMH_personModelsDictionary;
@property (nonatomic, strong) NSMutableDictionary *HMH_dataBasePersonModelsDictionary;
@property (nonatomic, strong)  HMHPBSearchResultViewController *result;
@property (nonatomic, strong)  UISearchBar *HMH_searchBar;
@property (nonatomic, assign) BOOL HMH_isFromSearchView;
@property (nonatomic, strong) UIView *HMH_coverView;
@property (nonatomic, strong) CloudVipAlertView *vipAlertView;


@end

@implementation HMHPhoneBookViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self isUserStatusDenied];
//    [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//    [[self class]attemptRotationToDeviceOrientation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultRealmForUser:self.uid];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:self.color];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
//   UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    [self requestAuthorizationForAddressBook];
    self.navigationItem.title = self.name;
    self.view.backgroundColor = RGBACOLOR(232, 232, 232, 1);
    _HMH_isFromSearchView = NO;
    _HMH_sectionTitles = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_suoYinSectionArr = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_sectionNumArr = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_localArray = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_changeArrary = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_mobileAddress = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_comeBackAddress = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_personModelsDictionary = [NSMutableDictionary dictionary];
    _HMH_dataBasePersonModelsDictionary = [NSMutableDictionary dictionary];
    _HMH_dataSource = [NSMutableArray array];
    [self HMH_getSendMessage];
    // 创建tableview和HMH_searchController
    [self HMH_createTabelview];
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus==CNAuthorizationStatusAuthorized) {
        [self HMH_getAdressModels];//获取通讯录
    }else{
        [self HMH_getInfoModelsAfterUpdateDateBase];//取本地数据库中的文件
    }
  //  [self getPersonInfoModels];
    
    
}
- (void)HMH_getSendMessage{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (self.mobilePhone) {
        
        [dic setValue:self.mobilePhone forKey:@"mobilePhone"];
        
    }else{
        
        [dic setValue:@"13524647086" forKey:@"mobilePhone"];
        
    }
    if (self.uid) {
        [dic setObject:self.uid forKey:@"uid"];
    }else{
        
        [dic setObject:@"uid" forKey:@"uid"];
        
    }
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./broker/contacts/sendInviteMemberMsg"];
    [self postData:dic withUrl:utrl isSendMessage:YES];
    
}
- (void)setDefaultRealmForUser:(NSString *)username {
/*    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
    config.schemaVersion = 1;
    设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
             什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
         }
     };
    告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
    [RLMRealmConfiguration setDefaultConfiguration:config];
     现在我们已经告诉了 Realm 如何处理架构的变化，打开文件之后将会自动执行迁移
     [RLMRealm defaultRealm];
 */
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 2;
    // 使用默认的目录，但是使用用户名来替换默认的文件名
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                       URLByAppendingPathComponent:username]
                      URLByAppendingPathExtension:@"realm"];
    // 将这个配置应用到默认的 Realm 数据库当中
    NSString *timestamp = [NSString stringWithFormat:@"%@timestamp",self.uid];
   
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:timestamp];
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的timestamp数据库架构
                }
            };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [self deleteNoMtemberModels];
    
}
- (void)deleteNoMtemberModels{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contactRole = %@",@"1"];
    RLMResults *infos = [HMHPersonInfoModel objectsWithPredicate:pred];
    RLMRealm*  realm= [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
  //  [realm deleteAllObjects];
    [realm deleteObjects:infos];
    [realm commitWriteTransaction];
}
- (void)addOrUpdateModel:(HMHPersonInfoModel*)model{

    RLMRealm*  realm= [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [HMHPersonInfoModel createOrUpdateInRealm:realm withValue:model];
    [realm commitWriteTransaction];
}
- (void)deleteModel:(HMHPersonInfoModel*)model{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"mobilePhone = %@",
                         model.mobilePhone];
    RLMArray *infos = [HMHPersonInfoModel objectsWithPredicate:pred];
    if (!infos.count) {
        return;
    }
    HMHPersonInfoModel*deleteModel = infos[0];
    RLMRealm*  realm= [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:deleteModel];
    [realm commitWriteTransaction];
}

// 判断用户是否是拒绝app使用
-(void)isUserStatusDenied{
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if(authorizationStatus == CNAuthorizationStatusDenied) { // 用户拒绝App使用

        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError*_Nullable error) {
            
            if(!granted){
                NSLog(@"授权失败, error=%@", error);

                // 回到主线程中刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你未授权访问通讯录,请前往设置界面设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                    [alter show];
                });
            }
        }];
    }
}
- (void)HMH_getAdressModels{//获取通讯录
    __weak typeof(self) weakSelf = self;
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 2.如果不是已经授权,则直接返回
    if (status != CNAuthorizationStatusAuthorized)  return ;
    // ios 9
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    // 获取姓名  手机号  头像
    NSArray *keys = @[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactImageDataKey];
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
         NSString *fullName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        // 获取联系人的电话号码(此处获取的是该联系人的第一个号码, 可以遍历所有的号码)
        NSArray *phoneNums = contact.phoneNumbers;
        
        
        for (int i= 0; i<phoneNums.count; i++) {//循环获取所有的手机号码
            
           HMHPersonInfoModel *infoModel = [[HMHPersonInfoModel alloc] init];
            if (fullName.length > 0) {
                
                infoModel.contactName = fullName;
                
            } else {
                infoModel.contactName = @"未知";
            }
            infoModel.UID = weakSelf.uid;
            CNLabeledValue *labeledValue;
            CNPhoneNumber *phoneNumer;
            labeledValue = phoneNums[i];
            phoneNumer = labeledValue.value;
            infoModel.mobilePhone = phoneNumer.stringValue;
            infoModel.mobileID = [infoModel.mobilePhone integerValue];
            if([infoModel.mobilePhone containsString:@" "]){
                NSArray *arr = [infoModel.mobilePhone componentsSeparatedByString:@" "];
                if (arr.count) {
                    infoModel.mobilePhone = @"";
                    for (NSString*str in arr) {
                        infoModel.mobilePhone =  [infoModel.mobilePhone stringByAppendingString:str];
                    }
                }
            } else if ([infoModel.mobilePhone rangeOfString:@"-"].location !=NSNotFound){
                NSArray *arr = [infoModel.mobilePhone componentsSeparatedByString:@"-"];
                if (arr.count) {
                    infoModel.mobilePhone = @"";
                    for (NSString*str in arr) {
                        infoModel.mobilePhone =  [infoModel.mobilePhone stringByAppendingString:str];
                    }
                }
                
            }
            NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                           invertedSet ];
            NSArray *phoneStrArr = [infoModel.mobilePhone componentsSeparatedByCharactersInSet:setToRemove];
            NSMutableString *currentPhoneNum = [NSMutableString string];
            for (NSString*str in phoneStrArr) {
                
                [currentPhoneNum appendString:str];
                
            }
            if ([weakSelf validatePhone:currentPhoneNum]) {
                
                infoModel.mobilePhone = currentPhoneNum;
                
            }
            if (infoModel.mobilePhone.length>11&&[weakSelf validatePhone:infoModel.mobilePhone]){
                
                infoModel.mobilePhone =  [infoModel.mobilePhone substringWithRange:NSMakeRange(infoModel.mobilePhone.length-11, 11)];
            }
            if (infoModel.mobilePhone.length==11&&[weakSelf validatePhone:infoModel.mobilePhone]) {
                infoModel.UID = weakSelf.uid;
                [dic setValue:infoModel forKey:infoModel.mobilePhone];
            }
        }
    }];
    NSArray *arr = [dic allKeys];
    for (NSString *str in arr) {
        
        HMHPersonInfoModel *infoModel = [dic objectForKey:str];
        
        [_HMH_mobileAddress addObject:infoModel];
        
    }
//    _HMH_suoYinSectionArr = [self createSuoYin:_HMH_dataSource];
//    [self.tableview reloadData];
    [self getPersonInfoModels];
}

- (void)getPersonInfoModels{
//    RLMResults<HMHPersonInfoModel *> *infoModels = [HMHPersonInfoModel allObjects];
//    if (infoModels.count) {
//        
//        for (HMHPersonInfoModel *model in infoModels) {
////            HMHPersonInfoModel *dataModel = [[HMHPersonInfoModel alloc]init];
////            dataModel.contactRole = model.contactRole;
////            dataModel.synchStatus = model.synchStatus;
////            dataModel.inviteRole = model.inviteRole;
//            if ([model.inviteRole isEqualToString:@"3"]) {
//                [self deleteModel:model];
//            }
//        }
//    }

    RLMResults<HMHPersonInfoModel *> *infoModels = [HMHPersonInfoModel allObjects];
    
    if (_HMH_mobileAddress.count) {
        
        for (HMHPersonInfoModel *model in _HMH_mobileAddress) {
            
            [_HMH_personModelsDictionary setValue:model forKey:model.mobilePhone];
        }
    }
    if (infoModels.count) {
       
        for (HMHPersonInfoModel *model in infoModels) {
            
            HMHPersonInfoModel *dataModel = [[HMHPersonInfoModel alloc]init];
            dataModel.contactName = model.contactName;
            dataModel.mobilePhone = model.mobilePhone;
            dataModel.mobileID = model.mobileID;
            dataModel.contactRole = model.contactRole;
            dataModel.contactPic = model.contactPic;
            dataModel.synchStatus = model.synchStatus;
            dataModel.inviteRole = model.inviteRole;
            dataModel.synchStatus = model.synchStatus;
            dataModel.UID = model.UID;
            dataModel.contactUserId = model.contactUserId;
            dataModel.contactRemark = model.contactRemark;
            dataModel.cityName = model.cityName;
            dataModel.regionName = model.regionName;
            dataModel.blockName = model.blockName;
            [_HMH_personModelsDictionary setValue:dataModel forKey:dataModel.mobilePhone];//用来刷新tableView的字典
            [_HMH_dataBasePersonModelsDictionary setValue:dataModel forKey:dataModel.mobilePhone];//用来比较数据的字典
        }
        
    }
    _HMH_suoYinSectionArr = [self createSuoYin:[_HMH_personModelsDictionary allValues]];
    _HMH_localArray = [NSMutableArray arrayWithArray:[_HMH_personModelsDictionary allValues]];

   // _result.datas = _HMH_localArray;

    //不在主线程执行的时候，获取主线程修改UI
    if ([NSThread isMainThread]){// 主线程就执行{}
        [self.tableview reloadData];
        
        } else{// 不是主线程，就调用gcd的函数+主队列，实现回到主线程刷新UI
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
            });
    }

//    [self.tableview reloadData];
    //不在主线程执行的时候，获取主线程修改UI

    [self HMH_commpareListModel];//比较
}

-(void)HMH_getInfoModelsAfterUpdateDateBase{
    RLMResults<HMHPersonInfoModel *> *infoModels = [HMHPersonInfoModel allObjects];
    if (infoModels.count) {

        for (HMHPersonInfoModel *model in infoModels) {
            HMHPersonInfoModel *dataModel = [[HMHPersonInfoModel alloc]init];
            dataModel.contactName = model.contactName;
            dataModel.mobilePhone = model.mobilePhone;
            dataModel.mobileID = model.mobileID;
            dataModel.contactRole = model.contactRole;
            dataModel.contactPic = model.contactPic;
            dataModel.synchStatus = model.synchStatus;
            dataModel.inviteRole = model.inviteRole;
            dataModel.synchStatus = model.synchStatus;
            dataModel.contactUserId = model.contactUserId;
            dataModel.UID = model.UID;
            dataModel.contactRemark = model.contactRemark;
            dataModel.cityName = model.cityName;
            dataModel.regionName = model.regionName;
            dataModel.blockName = model.blockName;

            [_HMH_personModelsDictionary setValue:dataModel forKey:dataModel.mobilePhone];//用来刷新tableView的字典
            [_HMH_dataBasePersonModelsDictionary setValue:dataModel forKey:dataModel.mobilePhone];//用来比较数据的字典
        }
    }
    _HMH_suoYinSectionArr = [self createSuoYin:[_HMH_personModelsDictionary allValues]];
    _HMH_localArray = [NSMutableArray arrayWithArray:[_HMH_personModelsDictionary allValues]];
    [self.tableview reloadData];
}

- (void)HMH_commpareListModel{
    
    //构建参数contacts
    for (HMHPersonInfoModel *model in _HMH_mobileAddress) {
        
        if (model.mobilePhone) {
            
            HMHPersonInfoModel *changeModel =  [_HMH_dataBasePersonModelsDictionary objectForKey:model.mobilePhone];

            if (changeModel&&![changeModel.contactName isEqualToString:model.contactName] ) {//修改的Model
                
                model.synchStatus = @"3";
                [_HMH_changeArrary addObject:model];
                
            }else if(!changeModel){//数据库中没有这条数据，新增
            
                 model.synchStatus = @"1";
                
                [_HMH_changeArrary addObject:model];
                
            }
//            else if ([changeModel.inviteRole isEqualToString:@"3"]){ // 非会员
//                model.synchStatus = @"2";
//                [_HMH_changeArrary addObject:model];
//            }
        }
    }
    
    NSMutableArray *reqInfoArr = [NSMutableArray array];
    for (int i= 0; i<_HMH_changeArrary.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        HMHPersonInfoModel *model =_HMH_changeArrary[i];
        if (model.contactName) {
            
            [dic setObject:model.contactName forKey:@"contactName"];
            
        }
        if (model.mobilePhone) {
            
            [dic setObject:model.mobilePhone forKey:@"mobilePhone"];
        }
        if (model.synchStatus) {
            
            [dic setObject:model.synchStatus forKey:@"synchStatus"];
            
        }
        for (int i =0; i<reqInfoArr.count; i++) {
            
            NSDictionary *ModelDic = reqInfoArr[i];
            NSString *mobileStr = [ModelDic objectForKey:@"mobilePhone"];
            if ([mobileStr isEqualToString:model.mobilePhone]) {
                
                [reqInfoArr removeObject:ModelDic];
            }
            
        }
        
        [reqInfoArr addObject:dic];
    }
    NSString *timestamp = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@timestamp",self.uid]];
    if (!timestamp) {
        timestamp = @" ";
    }
    if (!reqInfoArr.count) {
        
        reqInfoArr = [NSMutableArray array];
    }
    
    NSDictionary *postDic = @{
                              @"uid":self.uid,
                              @"contacts":reqInfoArr,
                              @"timestamp":timestamp
                              };
    NSString *aesInfoStr = [AESTools AES128Encrypt:[self convertToJsonData:postDic] key:AESKey];
    NSLog(@"加密后：%@",aesInfoStr);
    
    NSDictionary *reqDic = @{
                            @"contactsJson":aesInfoStr
                          };
    
    [self alertTongBuDataWithDic:reqDic];
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (void)alertTongBuDataWithDic:(NSDictionary *)dic {
    
    @weakify(self);
    [self.vipAlertView showAlertString:@"为了保证会员数据的完整性，合美惠将同步您的通讯录数据" isSure:YES changeBlock:^{
        @strongify(self);

//        [self postData:dic withUrl:@"/broker/contacts/v2/upload" isSendMessage:NO];
//        /broker/contacts/checkMemberUser
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"user./contacts/check-member-user/get"];
        if (getUrlStr) {
            [self postData:dic withUrl:getUrlStr isSendMessage:NO];
        }
        [self.vipAlertView removeFromSuperview];

    }];
    
}

- (CloudVipAlertView *)vipAlertView{
    if (!_vipAlertView) {
        _vipAlertView = [[CloudVipAlertView alloc]init];
        _vipAlertView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        [_vipAlertView resetContext_styleWithSure:@"同意" cancel:@"拒绝"];
    }
    return _vipAlertView;

}



//两个接口的封装 要加以区分
- (void)postData:(NSDictionary*)dic withUrl:(NSString *)url isSendMessage:(BOOL)isSendMessage{
 NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    if (isSendMessage) {//短信
        [HFCarRequest requsetUrl:urlstr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
              [self prcessdata:request.responseObject isSendMessage:isSendMessage];
              
          } error:^(__kindof YTKBaseRequest * _Nonnull request) {
              NSLog(@"11111");
          }];
    }else
    {
        [HFCarRequest requsetUrl:urlstr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
              [self prcessdata:request.responseObject isSendMessage:isSendMessage];
              
          } error:^(__kindof YTKBaseRequest * _Nonnull request) {
              NSLog(@"11111");
          }];
    }
}

- (void)prcessdata:(id)data isSendMessage:(BOOL)isSendMessage{
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        if (isSendMessage) {
            NSDictionary *resDic = data;

            NSInteger state = [resDic[@"state"] integerValue];
            if (state == 1) {
                NSDictionary *dataDic = resDic[@"data"];
                if (dataDic) {
                    NSString *message = dataDic[@"smsMsg"];
                    if (message) {
                        
                        [[NSUserDefaults standardUserDefaults]setObject:message forKey:@"smsMsg"];
                    }
                }
            }
        }else{
            NSDictionary *resDic = data;
            NSInteger state = [resDic[@"state"] integerValue];
            if (state == 1) {
                NSDictionary *dataDic = resDic[@"data"];
//                NSArray *contactsArry =dataDic[@"contacts"];
                NSString *contactsArryStr =dataDic[@"contactsJson"];
                NSString *str = dataDic[@"timestamp"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if (str) {
                    
                    [userDefaults setValue:str forKey:[NSString stringWithFormat:@"%@timestamp",self.uid]];
                    [userDefaults synchronize];
                    
                }
                NSString *jiaStr = [AESTools AES128Decrypt:contactsArryStr key:AESKey];
                NSLog(@"解密后：%@",jiaStr);

                NSData* jsonData = [jiaStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *contactsArry = [NSKeyedUnarchiver unarchiveObjectWithData:jsonData];
//                NSArray *contactsArry = [NSArray modelArrayWithClass:[NSData class] json:jsonData];
                
                if (contactsArry.count) {
                    for (NSDictionary *dic in contactsArry) {
                        HMHPersonInfoModel *model = [[HMHPersonInfoModel alloc] init];
                        [model setValuesForKeysWithDictionary:dic];
                        model.mobileID = [model.mobilePhone integerValue];
                        if (self.uid) {
                            model.UID = self.uid;
                        }
                        [_HMH_comeBackAddress addObject:model];
                   }
                    [self updateLocalDataBase];
                }
            }
            
        }

    }else {
        
        return;
    
    }
   
}
- (void)updateLocalDataBase{

      //1.在本地数据库新增，新增的
    for (int i=0; i<_HMH_comeBackAddress.count; i++) {
        
        HMHPersonInfoModel *comeBackModel = _HMH_comeBackAddress[i];
        
        [self addOrUpdateModel:comeBackModel];
    
        if ([comeBackModel.synchStatus isEqualToString: @"2"]) {
            
            [self deleteModel:comeBackModel];
        }
    }
    [self HMH_getInfoModelsAfterUpdateDateBase];
}

- (void)HMH_createTabelview{
    
    _HMH_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    _HMH_searchBar.delegate = self;
    _HMH_searchBar.placeholder = @"搜索";
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88) style:UITableViewStylePlain];

    _tableview.tableHeaderView = _HMH_searchBar;
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableview.backgroundColor = [UIColor clearColor];
   // _tableview.tableHeaderView = searchVC.searchBar;
   
    self.tableview.sectionIndexBackgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableview];
    
    
    
//
//    if (@available(iOS 11.0, *)) {
//
//        _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//
//    } else {
//
//        self.automaticallyAdjustsScrollViewInsets = NO;
//
//    }
    // 修改索引条的背景颜色

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    NSArray *modelArrary = [_HMH_personModelsDictionary allKeys];
    if (!modelArrary.count) {
        return;
    }
    [_HMH_dataSource removeAllObjects];
    [_HMH_suoYinSectionArr removeAllObjects];
    for (NSString *mobleNum in modelArrary) {
        HMHPersonInfoModel *model = [_HMH_personModelsDictionary objectForKey:mobleNum];
        NSString *nameStr = model.contactName;
        NSString *phoneNumStr = model.mobilePhone;
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:nameStr];
        if ([nameStr.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound || [phoneNumStr.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound ||[firstLetter.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
            
            [self.HMH_dataSource addObject:model];
        }
    }
    _HMH_suoYinSectionArr = [self createSuoYin:self.HMH_dataSource];
    if ([searchText isEqualToString:@""]) {
        
        _HMH_suoYinSectionArr = [self createSuoYin:[_HMH_personModelsDictionary allValues]];
    
    }
    [self.tableview reloadData];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    if (!self.HMH_coverView) {
        self.HMH_coverView = [[UIView alloc]initWithFrame:CGRectMake(0,searchBar.height, self.tableview.width, self.tableview.height-searchBar.height)];
        self.HMH_coverView.backgroundColor = [UIColor grayColor];
        self.HMH_coverView.alpha = 0.5;
        self.HMH_coverView.userInteractionEnabled = NO;
    }
    [self.view addSubview:self.HMH_coverView];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
    [self.HMH_coverView removeFromSuperview];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    _HMH_suoYinSectionArr = [self createSuoYin:[_HMH_personModelsDictionary allValues]];
    _HMH_localArray = [NSMutableArray arrayWithArray:[_HMH_personModelsDictionary allValues]];
    [self.tableview reloadData];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];

}

// 此处调用的是弹框中是否可以访问通讯录
- (void)requestAuthorizationForAddressBook {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusNotDetermined) {
        
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError*_Nullable error) {
            
            if(granted) {
                // 授权成功
                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [GiFHUD setGifWithImageName:@"pika.gif"];
//                    [GiFHUD show];
                    [SVProgressHUD show];
                });
                [self HMH_getAdressModels];
                NSLog(@"%@",[NSThread currentThread]);
            }else{
                NSLog(@"授权失败, error=%@", error);
                [self HMH_getDataPersonFromServer];
            }
        }];
    }
}
- (void)HMH_getDataPersonFromServer{

    NSMutableArray *reqInfoArr = [NSMutableArray array];
    for (int i= 0; i<_HMH_changeArrary.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        HMHPersonInfoModel *model =_HMH_changeArrary[i];
        if (model.contactName) {
            
            [dic setObject:model.contactName forKey:@"contactName"];
            
        }
        if (model.mobilePhone) {
            
            [dic setObject:model.mobilePhone forKey:@"mobilePhone"];
        }
        if (model.synchStatus) {
            
            [dic setObject:model.synchStatus forKey:@"synchStatus"];
            
        }
        [reqInfoArr addObject:dic];
    }
    NSString *timestamp = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@timestamp",self.uid]];
    if (!timestamp) {
        timestamp = @" ";
    }
    
    if (!reqInfoArr.count) {
        
        reqInfoArr = [NSMutableArray array];
    }
    NSDictionary *postDic = @{
                                @"uid":self.uid,
                                @"contacts":reqInfoArr,
                                @"timestamp":timestamp
                            };
    NSString *aesInfoStr = [AESTools AES128Encrypt:[self convertToJsonData:postDic] key:AESKey];
    NSLog(@"加密后：%@",aesInfoStr);
    
    NSDictionary *reqDic = @{
                            @"contactsJson":aesInfoStr
                          };
    
    [self alertTongBuDataWithDic:reqDic];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)firstGetPhoneaddress{
#pragma mark  获取现在数据库中的联系人的个数****************
   // static NSInteger mobileID = 0;
//    RLMResults<HMHPersonInfoModel *> *infoModels = [HMHPersonInfoModel allObjects];
//    mobileID = infoModels.count;
#pragma ******************************************
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 2.如果不是已经授权,则直接返回
    if (status != CNAuthorizationStatusAuthorized)  return ;

    // ios 9
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    // 获取姓名  手机号  头像
    NSArray *keys = @[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactImageDataKey];
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];

    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {

        NSString *fullName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
       
        // 获取联系人的电话号码(此处获取的是该联系人的第一个号码, 可以遍历所有的号码)
        NSArray *phoneNums = contact.phoneNumbers;
        
        for (int i= 0; i<phoneNums.count; i++) {//遍历联系人的所有的手机号
            HMHPersonInfoModel *infoModel = [[HMHPersonInfoModel alloc] init];
            if (fullName.length > 0) {//取名字
              
                infoModel.contactName = fullName;
                
            } else {
                infoModel.contactName = @"未知";
            }
            infoModel.UID = self.uid;//赋值id
            CNLabeledValue *labeledValue;
            CNPhoneNumber *phoneNumer;
            if (phoneNums.count > 0) {
                labeledValue = phoneNums[0];
                phoneNumer = labeledValue.value;
                infoModel.mobilePhone = phoneNumer.stringValue;
            } else {
                infoModel.mobilePhone = @"";
            }
            if([infoModel.mobilePhone rangeOfString:@" "].location !=NSNotFound){
                NSArray *arr = [infoModel.mobilePhone componentsSeparatedByString:@" "];
                if (arr.count) {
                    infoModel.mobilePhone = @"";
                    for (NSString*str in arr) {
                        infoModel.mobilePhone =  [infoModel.mobilePhone stringByAppendingString:str];
                    }
                }
                
            } else if ([infoModel.mobilePhone rangeOfString:@"-"].location !=NSNotFound){
                NSArray *arr = [infoModel.mobilePhone componentsSeparatedByString:@"-"];
                if (arr.count) {
                    infoModel.mobilePhone = @"";
                    for (NSString*str in arr) {
                        infoModel.mobilePhone =  [infoModel.mobilePhone stringByAppendingString:str];
                    }
                }
                
            }
            if (infoModel.mobilePhone.length>11&&[self validatePhone:infoModel.mobilePhone]){
                
                infoModel.mobilePhone =  [infoModel.mobilePhone substringWithRange:NSMakeRange(0, infoModel.mobilePhone.length-11)];
            }
            if (infoModel.mobilePhone.length==11&&[self validatePhone:infoModel.mobilePhone]) {
                [_HMH_changeArrary addObject:infoModel];
                [self addOrUpdateModel:infoModel];
            }
        }
}];
    [self.tableview reloadData];
//    // 回到主线程中刷新UI
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.self.tableview reloadData];
//    });
}

//手机号码验证
- (BOOL)validatePhone:(NSString *)phone
{
//    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    return [phoneTest evaluateWithObject:phone];
    
     NSString *first = [phone substringToIndex:1];//字符串开始
    if ([first isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
}


- (NSMutableArray *)createSuoYin :(NSArray*)dataArrary{
     //建立索引
    UILocalizedIndexedCollation *indexCollection = [UILocalizedIndexedCollation currentCollation];
    if (self.HMH_sectionTitles.count > 0) {
        [self.HMH_sectionTitles removeAllObjects];
    }
    
    [self.HMH_sectionTitles addObjectsFromArray:[indexCollection sectionTitles]];
    //返回27，是a－z和＃
    NSInteger highSection = [self.HMH_sectionTitles count];
    
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++)
    {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    /*
     for (NSString *moblieNum in dataArrary)
     {
     HMHPersonInfoModel *cUser = [_HMH_personModelsDictionary objectForKey:moblieNum];
     //getUserName是实现中文拼音检索的核心，见NameIndex类
     

     */
    for (int i=0;i<dataArrary.count;i++)
    {
        HMHPersonInfoModel *cUser = dataArrary[i];
        //getUserName是实现中文拼音检索的核心，见NameIndex类
       
        if (cUser) {
            NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:cUser.contactName];
            if (firstLetter.length>0) {
                NSInteger section = [indexCollection sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
                NSMutableArray *array = [sortedArray objectAtIndex:section];
                [array addObject:cUser];
            }
            else{
                if (sortedArray.count>0) {
                    NSMutableArray *array = [sortedArray lastObject];
                    [array addObject:cUser];
                }
            }

        }
        
    }
    return sortedArray;
}

#pragma mark tabelview协议方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _HMH_suoYinSectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_HMH_suoYinSectionArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMHPhoneBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HMHPhoneBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
           cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (_HMH_suoYinSectionArr.count > indexPath.section && [_HMH_suoYinSectionArr[indexPath.section] count] > indexPath.row) {
        HMHPersonInfoModel *model = _HMH_suoYinSectionArr[indexPath.section][indexPath.row];
        if (model) {
            
            [cell refreshTableViewCellWithInfoModel:model];
        }
    }
    __weak typeof(self) weakSelf = self;
    cell.clickBtnBlock = ^(HMHPhoneBookTableViewCell *cell) {
        [weakSelf cellStateBtnClickWithIndexPath:cell.indexPath];
    };
    
    cell.chatBtnBlock = ^(HMHPhoneBookTableViewCell *cell) {
        [weakSelf cellChatBtnClickWithIndexPaht:cell.indexPath];
    };
    
    if (cell.selected) {
        cell.contentView.backgroundColor = [[UIColor colorWithHexString:@"#ffb100"]colorWithAlphaComponent:0.1];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
//    [GiFHUD dismiss];
    [SVProgressHUD dismiss];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark 用户详情===========
    HMHPhoneBookDetailViewController *vc = [[HMHPhoneBookDetailViewController alloc] init];
    vc.updatePersonModel = ^(HMHPersonInfoModel *HMHPersonInfoModel) {
        [self addOrUpdateModel:HMHPersonInfoModel];
    };
    vc.uid = self.uid;
    if (_HMH_suoYinSectionArr.count > indexPath.section && [_HMH_suoYinSectionArr[indexPath.section] count] > indexPath.row) {
        HMHPersonInfoModel *ymodel = [[HMHPersonInfoModel alloc] init];
        ymodel = _HMH_suoYinSectionArr[indexPath.section][indexPath.row];
        vc.personInfoModel = ymodel;
        vc.contactId = ymodel.contactUserId;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMHPhoneBookTableViewCell *cell =  [self.tableview cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor =[UIColor whiteColor];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [_HMH_searchBar setShowsCancelButton:NO];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.HMH_suoYinSectionArr.count > section) {
        NSArray *dataList = [self.HMH_suoYinSectionArr objectAtIndex:section];
        if ([dataList count]>0)
        {
            return 20;
        }
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    [contentView setBackgroundColor:RGBACOLOR(232, 232, 232, 1)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBACOLOR(138, 137, 137, 1);
    
    label.text = _HMH_sectionTitles[section];
    [contentView addSubview:label];
    return contentView;
    
}

// 返回侧边的索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _HMH_sectionTitles;
}

#pragma mark searchBar协议方法

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    for (id obj in [searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    [searchBar setShowsCancelButton:YES];
    return YES;
}

#pragma mark 聊天按钮的点击事件  ======测试数据=========
- (void)cellChatBtnClickWithIndexPaht:(NSIndexPath *)indexPath{
    
    BOOL islogin =  [[[NIMSDK sharedSDK]loginManager] isLogined];
    if (!islogin) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"连接失败，请退出通讯录或者重新登录账号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:action];
        [self presentViewController:alter animated:YES completion:nil];
        return;
    }
    HMHPersonInfoModel *model = _HMH_suoYinSectionArr[indexPath.section][indexPath.row];
    // liqianhongliqianhon1  这个是测试数据 只是数据为对方的id
//    NIMSession *session = [NIMSession session:@"liqianhongliqianhon1" type:NIMSessionTypeP2P];
    
    if (model.contactUserId.length) {
        NIMSession *session = [NIMSession session:model.contactUserId type:NIMSessionTypeP2P];
        
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"对方不是会员" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:action];
        [self presentViewController:alter animated:YES completion:nil];
    }

}

#pragma mark // cell 上按钮的点击事件
- (void)cellStateBtnClickWithIndexPath:(NSIndexPath *)indexPath{
    
    HMHPersonInfoModel *model = _HMH_suoYinSectionArr[indexPath.section][indexPath.row];
    
    if ([model.inviteRole isEqualToString:@"1"] || (model.inviteRole.length == 0)) { // 会员
        //        http://mall-api.fybanks.cn/broker/contacts/sendInviteMemberMsg
        if (_HMH_suoYinSectionArr.count > indexPath.section && [_HMH_suoYinSectionArr[indexPath.section] count] > indexPath.row) {
            
            HMHPersonInfoModel *model = _HMH_suoYinSectionArr[indexPath.section][indexPath.row];
            _HMH_sendMessageMobile = model.mobilePhone;
            [self cellSendMessageWithModel:model andIsSearchView:NO];
        }
    }
//        else if ([model.inviteRole isEqualToString:@"2"]){ // 门店
//        if (_HMH_suoYinSectionArr.count > indexPath.section && [_HMH_suoYinSectionArr[indexPath.section] count] > indexPath.row) {
//
//            HMHPersonInfoModel *phonemodel = _HMH_suoYinSectionArr[indexPath.section][indexPath.row];
//            PopAppointViewControllerToos *toos = [PopAppointViewControllerToos sharePopAppointViewControllerToos];
//            for (int i=0;i<toos.pageUrlConfigArrary.count; i++) {
//                PageUrlConfigModel *model = toos.pageUrlConfigArrary[i];
//                if ([model.pageTag isEqualToString:@"fy_uc_mls_register_chain"]) {
//                    NSString *url = model.url;
//                    if ([model.url containsString:@"?"]) {
//                        NSString *exUrl = [NSString stringWithFormat:@"&phone=%@",phonemodel.mobilePhone];
//                        url = [url stringByAppendingString:exUrl];
//                    }else{
//
//                        NSString *exUrl = [NSString stringWithFormat:@"?phone=%@",phonemodel.mobilePhone];
//                        url = [url stringByAppendingString:exUrl];
//                    }
//                    HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
//                    //                    pvc.title = model.title;
//                    //                    pvc.naviBg = model.naviBg;
//                    //                    pvc.isNavigationBarshow = model.showNavi;
//                    //                    pvc.naviMask = model.naviMask;
//                    //                    pvc.naviMaskHeight = model.naviMaskHeight;
//                    pvc.urlStr = url;
//                    pvc.pageTag = model.pageTag;
//                    pvc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:pvc animated:YES];
//                }
//
//            }
//            //            if (self.InviteClick) {
//            //                self.InviteClick(model.mobilePhone);
//            //
//            //                [self.navigationController popViewControllerAnimated:YES];
//            //            }
//
//        }
//
//    }
}

- (void)cellSendMessageWithModel:(HMHPersonInfoModel *)model andIsSearchView:(BOOL)isSearchView{
    
    self.HMH_isFromSearchView = isSearchView;
    _HMH_sendMessageMobile = model.mobilePhone;
    NSString *message = [[NSUserDefaults standardUserDefaults]objectForKey:@"smsMsg"];
    if (message.length > 0) {
        [self sendContacts:@[_HMH_sendMessageMobile] message:message];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"服务器数据异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)sendContacts:(NSArray*)phoneNumbers message:(NSString *)message {
        HMHMessageViewController *messageVC = [[HMHMessageViewController alloc]init];
        messageVC.messageComposeDelegate = self;
        messageVC.body = message;
        messageVC.recipients = phoneNumbers;
        //         [[[[messageVC viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        
        if (self.HMH_isFromSearchView) {
            self.HMH_searchController.searchBar.text = @"";
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.HMH_searchController.searchResultsController
                 presentViewController:messageVC animated:YES completion:nil];
            });
            
        } else {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self presentViewController:messageVC animated:YES completion:^{
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                }];
            });
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
@end
