//
//  WARProfileGatherViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/14.
//

#import "WARProfileFavoriteViewController.h"
#import "WARTopToolView.h"
#import "WARMacros.h"
#import "WARFavriteNetWorkTool.h"
#import "WARFavoriteModel.h"
#import "YYModel.h"
#import "WARActionSheet.h"
#import "WARProgressHUD.h"
@interface WARProfileFavoriteViewController ()
/**ToolView*/
@property (nonatomic,strong) WARTopToolView *toolView;
@property (nonatomic,strong) UIScrollView *scrollerV;
@property (nonatomic,strong) WARFavriteMineView *mineV;
@end

@implementation WARProfileFavoriteViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNetData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.scrollerV];
    [self.scrollerV addSubview:self.mineV];
    [self toolClickEven];
}
- (void)loadNetData {
    WS(weakself);
    [WARFavriteNetWorkTool postFavoriteDatalistWithLastCreateTime:@"" lastType:@"" callback:^(id response) {
        WARFavoriteModel *model = [WARFavoriteModel yy_modelWithJSON:response];
        weakself.mineV.model = model;
        weakself.mineV.favdataSource = [weakself datasource:model];
    } failer:^(id response) {
        
    }];
}
- (NSMutableArray*)datasource:(WARFavoriteModel*)model {
    NSMutableArray *sourceData = [NSMutableArray arrayWithArray:model.favorites];
    NSArray *typeArr = [sourceData valueForKeyPath:@"favoriteType"];
    NSSet *typeSet = [NSSet setWithArray:typeArr];
    NSMutableArray *datasource = [NSMutableArray array];
    [typeSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *typeDict = [NSMutableDictionary dictionary];
        [typeDict setObject:obj forKey:@"favoriteType"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favoriteType LIKE %@ ",obj];
        NSArray *indexArray = [sourceData filteredArrayUsingPredicate:predicate];
        [typeDict setObject:indexArray forKey:@"favorite"];
        [datasource addObject:typeDict];
        
    }];
    return datasource;
}
- (void)actionSheetClick:(WARFavoriteInfoModel*)model {
    [WARActionSheet actionSheetWithButtonTitles:@[WARLocalizedString(@"编辑内容"),WARLocalizedString(@"分享"),WARLocalizedString(@"设置"),WARLocalizedString(@"删除")] cancelTitle:WARLocalizedString(@"取消") actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        if (index == 0) {
            
        }
        if (index == 2) {
            if (self.editingBlock) {
                self.editingBlock(model);
            }
        }
        if (index == 3) {
            [WARFavriteNetWorkTool deleteFavriteCreatWithFavoriteId:model.favoriteId byParams:nil callback:^(id response) {
                [self loadNetData];
                [WARProgressHUD showSuccessMessage:@"删除成功"];
            } failer:^(id response) {
                [WARProgressHUD showSuccessMessage:@"删除失败"];
            }];
        }
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } completionHandler:^{
        
    }];
}
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (!canScroll) {
        self.mineV.collectionView.contentOffset = CGPointZero;
    }
}
- (void)toolClickEven {
    WS(weakself);
    self.toolView.creatBlock = ^{
        if (weakself.creatBlock) {
            weakself.creatBlock();
        }
    };
    self.toolView.chooseBlock = ^(NSInteger tag) {
        
    };
}
- (WARFavriteMineView *)mineV {
    if (!_mineV) {
        _mineV = [[WARFavriteMineView alloc] initWithFrame:self.scrollerV.bounds];
    }
    return _mineV;
}
- (WARTopToolView *)toolView {
    if (!_toolView) {
        _toolView = [[WARTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    }
    return _toolView;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIScrollView *)scrollerV {
    if (!_scrollerV) {
        _scrollerV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), kScreenWidth, kScreenHeight-83-88-45)];
        _scrollerV.contentSize = CGSizeMake(kScreenWidth, 0);
        
    }
    return _scrollerV;
}
@end
