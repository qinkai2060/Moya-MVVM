//
//  WARCommonViewController.m
//  Pods
//
//  Created by huange on 2017/8/10.
//
//

#import "WARCommonViewController.h"
#import "WARLanguageViewController.h"
#import "WARThemeSettingViewController.h"
#import "WARUserSettingBackgroundViewController.h"

@interface WARCommonViewController ()

@end

@implementation WARCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    [super initData];
    
    self.settinsItemArray = [NSMutableArray new];

    for (int i = 0; i < 3; i++) {
        WARSettingCellItem *item = [WARSettingCellItem new];
        
        switch (i) {
            case 0:{
                item.titleString =  WARLocalizedString(@"语言设置");
            }
            break;
            case 1:{
                item.titleString =  WARLocalizedString(@"聊天背景");
            }
                break;
            case 2:{
                item.titleString =  WARLocalizedString(@"设置主题");
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
    self.title = WARLocalizedString(@"通用");
    
    self.tableView.rowHeight = commonCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        WARLanguageViewController *languageVC = [WARLanguageViewController new];
        [self.navigationController pushViewController:languageVC animated:YES];
    }else if (indexPath.row == 1) {
        WARUserSettingBackgroundViewController *vc = [WARUserSettingBackgroundViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        WARThemeSettingViewController *vc = [WARThemeSettingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
