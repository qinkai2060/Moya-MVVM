//
//  WARUploadingViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import "WARUploadingViewController.h"
#import "WARMacros.h"
#import "WARImagePickerController.h"
#import "WARPhotoDetailView.h"
#import "UIImage+WARBundleImage.h"
#import "WARUploadListView.h"
#import "WARDownLoadListView.h"
#import "WARConfigurationMacros.h"
#import "WARAlertView.h"
#import "Masonry.h"
@interface WARUploadingViewController ()<WARImagePickerControllerDelegate>

@property(nonatomic,strong) WARGroupModel *model;
@property(nonatomic,strong) UIButton *uploadBtn;
@property(nonatomic,strong) UIButton *downloadBtn;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) UIView  *selectV;
@property(nonatomic,strong) UIView  *lineView;
@property(nonatomic,strong) WARUploadListView *uploadlistV;
@property(nonatomic,strong) WARDownLoadListView *downloadListV;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView  *lineV;
@property(nonatomic,assign) NSInteger  selectRow;
@end

@implementation WARUploadingViewController
- (instancetype)initWithModel:(WARGroupModel *)model {
    if (self = [super initWithModel:model]) {
        self.model = model;
      
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
}

- (void)initSubViews{
    [self.view addSubview:self.customBar];
     CGFloat navH =  WAR_IS_IPHONE_X ? 84:64;
    UIView *headerV = [[UIView alloc]  initWithFrame:CGRectMake(0, navH, kScreenWidth, 48)];
    headerV.backgroundColor = PlateBackgroundColor;
     [self.view addSubview:headerV];
    [headerV addSubview:self.uploadBtn];
    [headerV addSubview:self.downloadBtn];
    [headerV addSubview:self.selectV];
    [self.view addSubview:self.lineV];
    [self.view addSubview:self.scrollView];
     [self.scrollView addSubview:self.uploadlistV];
    [self.scrollView addSubview:self.downloadListV];
    [self.customBar.titleButton setTitle:WARLocalizedString(@"传输列表") forState:UIControlStateNormal];
    [self.customBar.titleButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.customBar.rightbutton setTitle:WARLocalizedString(@"全部取消") forState:UIControlStateNormal];
    [self.customBar.rightbutton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.customBar.rightbutton addTarget:self action:@selector(cleanData) forControlEvents:UIControlEventTouchUpInside];
    self.customBar.rightbutton.hidden = NO;
    [self.customBar.rightbutton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
    }];
    self.selectBtn = self.uploadBtn;
    [self.selectBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    CGPoint center = self.selectV.center;
    center.x = self.selectBtn.center.x;
    self.selectV.center = center;
    self.selectRow = 0;
    [self.scrollView setContentOffset:CGPointMake(self.selectRow*kScreenWidth, 0) animated:YES];
    
}
- (void)cleanData {
    [WARAlertView showWithTitle:WARLocalizedString(@"确定是否取消") Message:nil cancelTitle:@"取消" actionTitle:@"确定" cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } actionHandler:^(LGAlertView * _Nonnull alertView) {
        if (self.selectRow == 0) {
            [self.uploadlistV cleanData];
        }else{
            [self.downloadListV cleanData];
        }
    }];
   
   
}
- (void)switchClick:(UIButton*)btn {
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
     self.selectRow = btn.tag - 10000;
     [self.scrollView setContentOffset:CGPointMake(self.selectRow*kScreenWidth, 0) animated:YES];
    if (self.selectBtn) {
        
        self.selectBtn.selected = NO;
     
        [self.selectBtn setTitleColor:ThreeLevelTextColor forState:UIControlStateNormal];

        self.selectBtn = nil;
        
    }
    if (btn.selected) {
        
        self.selectBtn = btn;
        [self.selectBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        CGPoint center = self.selectV.center;
        center.x = self.selectBtn.center.x;
        self.selectV.center = center;
  
    }

}
- (WARUploadListView *)uploadlistV {
    if (!_uploadlistV) {
        _uploadlistV  = [[WARUploadListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.scrollView.frame)) atGroupModel:self.model];
    }
    return _uploadlistV;
}
- (WARDownLoadListView *)downloadListV {
    if (!_downloadListV) {
        _downloadListV  = [[WARDownLoadListView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(self.scrollView.frame)) atGroupModel:self.model];
    }
    return _downloadListV;
}
- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectV.frame)-0.5, kScreenWidth, 1)];
        _lineV.backgroundColor  = [UIColor clearColor];
        
    }
    return _lineV;
}
- (UIView *)selectV {
    if (!_selectV) {
        _selectV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.uploadBtn.frame), 23*kScale_iphone6, 3)];
        _selectV.backgroundColor  = ThemeColor;
        _selectV.layer.cornerRadius = 1.5;
        _selectV.layer.masksToBounds = YES;

    }
    return _selectV;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
      CGFloat navH =  WAR_IS_IPHONE_X ? 84:64;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navH+48, kScreenWidth, kScreenHeight- navH-45)];
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth*3, 0);
    }
    return _scrollView;
}
- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
          CGFloat navH =  WAR_IS_IPHONE_X ? 84:64;
        _uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.5, 45)];
        [_uploadBtn setTitle:WARLocalizedString(@"上传列表") forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
        [_uploadBtn setTitleColor:ThreeLevelTextColor forState:UIControlStateNormal];
        _uploadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _uploadBtn.backgroundColor = PlateBackgroundColor;
        [_uploadBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        _uploadBtn.tag = 10000;
    }
    return _uploadBtn;
}
- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        CGFloat navH =  WAR_IS_IPHONE_X ? 84:64;
        _downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, 0, kScreenWidth*0.5, 45)];
        [_downloadBtn setTitle:WARLocalizedString(@"下载列表") forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
        [_downloadBtn setTitleColor:ThreeLevelTextColor forState:UIControlStateNormal];
        _downloadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_downloadBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        _downloadBtn.backgroundColor = PlateBackgroundColor;
        _downloadBtn.tag = 10001;
    }
    return _downloadBtn;
}
@end
