//
//  WARLanguageViewController.m
//  Pods
//
//  Created by huange on 2017/8/10.
//
//

#import "WARLanguageViewController.h"
#import "WARProgressHUD.h"

#define LanguageSettingsCellID    @"LanguageSettingsCellID"

@interface WARLanguageViewController ()

@end

@implementation WARLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initData {
    [super initData];
    
    self.settinsItemArray = [NSMutableArray new];
    NSString *laguage = [[WARLocalizedHelper  standardHelper] currentLanguage];
    for (int i = 0; i < 1; i++) {
        WARSettingCheckMarkCellItem *item = [WARSettingCheckMarkCellItem new];
        
        switch (i) {
            case 0:{
                item.titleString =  WARLocalizedString(@"中文（简体）");
                if ([laguage hasPrefix:@"zh"]) {
                    item.checked = YES;
                }
            }
                break;
            case 1:{
                item.titleString =  WARLocalizedString(@"English");
                if ([laguage hasPrefix:@"en"]) {
                    item.checked = YES;
                }

            }
                break;
            default:
                break;
        }
        
        [self.settinsItemArray addObject:item];
    }
}

- (void)initUI {
    [super initUI];
    self.title = WARLocalizedString(@"语言设置");
    
    self.tableView.rowHeight = commonCellHeight;
    
    [self.tableView registerClass:[WARSettingsCheckMarkCell class] forCellReuseIdentifier:LanguageSettingsCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARSettingCheckMarkCellItem *item = [self.settinsItemArray objectAtIndex:indexPath.row];
    WARSettingsCheckMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:LanguageSettingsCellID];
    cell.descriptionText = item.titleString;
    cell.isChecked = item.checked;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WARSettingCheckMarkCellItem *item = [self.settinsItemArray objectAtIndex:indexPath.row];
//    for (WARSettingCheckMarkCellItem *item in self.settinsItemArray) {
//         item.checked = NO;
//    }
//    item.checked = YES;
    
//    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
    if (0 == indexPath.row) {
        [[WARLocalizedHelper standardHelper] setUserLanguage:@"zh-Hans"];
    }else if (1 == indexPath.row) {
        [[WARLocalizedHelper standardHelper] setUserLanguage:@"en"];
    }
    
    [WARProgressHUD showSuccessMessage:[NSString stringWithFormat:@"%@%@", WARLocalizedString(@"语言设置为："),item.titleString]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeLanguageNotification object:nil];
    });
}

@end
