//
//  HFVideoNewView.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVideoNewView.h"
#import "HFVideoDYCell.h"
#import "ZFTableData.h"
#import <ZFPlayer/ZFPlayer.h>
@interface HFVideoNewView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HFVideoNewView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
    self.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    self.pagingEnabled = YES;
    [self requestData];
    @weakify(self)
    self.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.player.playingIndexPath) return;
        if (indexPath.row == self.dataSourceD.count-1) {
            /// 加载下一页数据
            [self requestData];
            self.player.assetURLs = self.urls;
            [self reloadData];
        }
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    };
    }
    return self;
}
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.playerControl resetControlView];
    ZFTableData *data = self.dataSourceD[indexPath.row];
    UIViewContentMode imageMode;
    if (data.thumbnail_width >= data.thumbnail_height) {
        imageMode = UIViewContentModeScaleAspectFit;
    } else {
        imageMode = UIViewContentModeScaleAspectFill;
    }
    [self.playerControl showCoverViewWithUrl:data.thumbnail_url withImageMode:imageMode];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceD.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFVideoDYCell *cell = [tableView dequeueReusableCellWithIdentifier:@"video"];
    if (!cell) {
        cell = [[HFVideoDYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"video"];
    }
    cell.data = self.dataSourceD[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight;
}
- (void)requestData {
    self.urls = @[].mutableCopy;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Videodata" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.dataSourceD = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"list"];
    for (NSDictionary *dataDic in videoList) {
        ZFTableData *data = [[ZFTableData alloc] init];
        [data setValuesForKeysWithDictionary:dataDic];
        [self.dataSourceD addObject:data];
        NSURL *url = [NSURL URLWithString:data.video_url];
        [self.urls addObject:url];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self zf_scrollViewWillBeginDragging];
}

@end
