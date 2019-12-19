//
//  SunbathCircleViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/12/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SunbathCircleViewController.h"
#import "HFSegmentView.h"
#import "HFAsyncCircleNode.h"
#import "HFDescoverAsyncNode.h"
#import "UIView+addGradientLayer.h"
#import "UIButton+CustomButton.h"
#import "HFVideoViewController.h"
@interface SunbathCircleViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)HFSegmentView *sliderView;
@property(nonatomic,strong)UIScrollView *scrollerView;
@property(nonatomic,strong)HFAsyncCircleNode *asyncCircleNode;
@property(nonatomic,strong)HFDescoverAsyncNode *descoverNode;
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,strong)UIButton *publishBtn;
@end

@implementation SunbathCircleViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
}
- (void)setNavBar {
    [self.view addSubview:self.customNavBar];
    self.customNavBar.hidden = NO;
    [self.customNavBar addSubview:self.sliderView];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubnode:self.asyncCircleNode];
    [self.scrollerView addSubnode:self.descoverNode];
    [self.view addSubview:self.publishBtn];
    @weakify(self)
    self.sliderView.didSelect = ^(NSInteger index) {
        @strongify(self)
        self.selectIndex = index;
        self.sliderView.selectIndex = index;
    };
}
- (void)enterClick:(UIButton*)btn {
    [self.navigationController pushViewController:[HFVideoViewController new] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [self.asyncCircleNode didExitPreloadState];
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
     [self.scrollerView setContentOffset:CGPointMake(selectIndex*ScreenW, 0) animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    NSInteger   index = (scrollView.contentOffset.x + ScreenW * 0.5) / ScreenW;
    self.selectIndex = index;
    self.sliderView.selectIndex = index;
    [scrollView setContentOffset:CGPointMake(index*ScreenW, 0) animated:YES];
}
- (HFSegmentView *)sliderView {
    if(!_sliderView) {
        _sliderView = [[HFSegmentView alloc] initWithFrame:CGRectMake((ScreenW-100)*0.5, self.customNavBar.height-33, 100, 33)];
    }
    return _sliderView;
}
- (UIScrollView *)scrollerView {
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.customNavBar.bottom, kScreenWidth, ScreenH-self.customNavBar.bottom)];
        _scrollerView.backgroundColor = [UIColor orangeColor];
        _scrollerView.contentSize = CGSizeMake(kScreenWidth*2, 0);
        _scrollerView.pagingEnabled= YES;
        _scrollerView.delegate = self;
    }
    return _scrollerView;
}
- (HFAsyncCircleNode *)asyncCircleNode {
    if (!_asyncCircleNode) {
        _asyncCircleNode = [[HFAsyncCircleNode alloc] initWithStyle:UITableViewStylePlain];
        _asyncCircleNode.frame = CGRectMake(0, 0, kScreenWidth, self.scrollerView.height- (isIPhoneX()?83:49));
        
    }
    return _asyncCircleNode;
}
- (HFDescoverAsyncNode *)descoverNode {
    if (!_descoverNode) {
        _descoverNode = [[HFDescoverAsyncNode alloc] initWithLayoutDelegate:nil layoutFacilitator:nil];
        _descoverNode.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.scrollerView.height- (isIPhoneX()?83:49));
        
    }
    return _descoverNode;
}
- (UIButton *)publishBtn {
    if (!_publishBtn) {
        CGFloat tabH = isIPhoneX() ? 83+10:49;
        _publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100-10, kScreenHeight-tabH-10-35, 100, 35)];
        [_publishBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        [_publishBtn setImage:[UIImage imageNamed:@"circle_publish"] forState:UIControlStateNormal];
        [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_publishBtn bringSubviewToFront:_publishBtn.titleLabel];
        [_publishBtn bringSubviewToFront:_publishBtn.imageView];
        _publishBtn.layer.cornerRadius = 18;
        _publishBtn.layer.masksToBounds = YES;
        [_publishBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        [_publishBtn addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}
@end
