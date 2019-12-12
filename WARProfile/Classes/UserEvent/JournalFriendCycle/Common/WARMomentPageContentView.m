//
//  WARMomentPageContentView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARMomentPageContentView.h"
#import "WARFeedHeader.h"
#import "WARFeedRichTextCell.h"
#import "WARDiaryMagicImageCell.h"
#import "WARFeedLinkCell.h"
#import "WARFeedLinkSummaryCell.h"
#import "WARSimpleSceneryCell.h"
#import "WARSimpleStoreOrHotelCell.h"
#import "WARFeedSceneryCell.h"
#import "WARFeedStoreLayout.h"
#import "WARFeedStoreCell.h"
#import "WARFeedAlbumCell.h"
#import "WARGameRankCell.h"

@interface WARMomentPageContentView()<UITableViewDelegate, UITableViewDataSource, WARDiaryMagicImageCellDelegate,WARFeedLinkCellDelegate,WARFeedLinkSummaryCellDelegate,WARFeedCellDelegate,WARGameRankCellDelegate>
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation WARMomentPageContentView


#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, -5, 0, 0));
    }];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didAction:)];
    //    [self addGestureRecognizer:tap];
}

- (void)dealloc {
    [_tableView removeFromSuperview];
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

#pragma mark - Event Response

- (void)didAction:(UITapGestureRecognizer *)tap {
    //    if ([self.delegate respondsToSelector:@selector(didSinglePageContentView:)]) {
    //        [self.delegate didSinglePageContentView:self];
    //    }
}

#pragma mark - Delegate

#pragma mark  UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.pageLayoutArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WARFeedPageLayout *pageLayout = [self.pageLayoutArray objectAtIndex:section];
    return pageLayout.componentLayoutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARFeedPageLayout *pageLayout = [self.pageLayoutArray objectAtIndex:indexPath.section];
    WARFeedComponentLayout* componentLayout = pageLayout.componentLayoutArr[indexPath.row];
    if (componentLayout.component.componentType == WARFeedComponentTextType) {//文本组件cell
        WARFeedRichTextCell* cell = [WARFeedRichTextCell cellWithTableView:tableView];
        cell.hasTopMargin = componentLayout.component.isFirstComponent && self.componentHasExtraHeight;
        cell.layout = componentLayout;
        return cell;
    } else if (componentLayout.component.componentType == WARFeedComponentMediaType){//图片组件cell
        WARDiaryMagicImageCell* cell = [WARDiaryMagicImageCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.layout = componentLayout;
        return cell;
    } else if (componentLayout.component.componentType == WARFeedComponentSceneryType) {//景点组件cell
        WARFeedScenery *scenery = componentLayout.component.content.scenery;
        if (scenery.editionEnum == WARFeedComponentIntegrityTypeSimple) {//简版
            WARSimpleSceneryCell *cell = [WARSimpleSceneryCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        } else if (scenery.editionEnum == WARFeedComponentIntegrityTypeComplete) {//完整版
            WARFeedSceneryCell *cell = [WARFeedSceneryCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        }
        
        return [UITableViewCell new];
    } else if (componentLayout.component.componentType == WARFeedComponentStoryType) {//商店组件cell
        WARFeedStore *store = componentLayout.component.content.store;
        if (store.editionEnum == WARFeedComponentIntegrityTypeSimple) {//简版
            WARSimpleStoreOrHotelCell *cell = [WARSimpleStoreOrHotelCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        } else if (store.editionEnum == WARFeedComponentIntegrityTypeComplete) {//完整版
            WARFeedStoreCell *cell = [WARFeedStoreCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        }
        
        return [UITableViewCell new];
    } else if (componentLayout.component.componentType == WARFeedComponentHotelType) {//酒店组件cell
        WARFeedStore *hotel = componentLayout.component.content.hotel;
        if (hotel.editionEnum == WARFeedComponentIntegrityTypeSimple) {//简版
            WARSimpleStoreOrHotelCell *cell = [WARSimpleStoreOrHotelCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        } else if (hotel.editionEnum == WARFeedComponentIntegrityTypeComplete) {//完整版
            WARFeedStoreCell *cell = [WARFeedStoreCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        }
        
        return [UITableViewCell new];
    } else if (componentLayout.component.componentType == WARFeedComponentLinkType){//链接组件cell
        WARFeedLinkComponentType linkType = componentLayout.component.content.link.linkType;
        if (linkType == WARFeedLinkComponentTypeDefault) {
            WARFeedLinkCell* cell = [WARFeedLinkCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.layout = componentLayout;
            return cell;
        } else if (linkType == WARFeedLinkComponentTypeRead) {
            WARFeedLinkCell* cell = [WARFeedLinkCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.layout = componentLayout;
            return cell;
        } else if (linkType == WARFeedLinkComponentTypeSummary) {
            WARFeedLinkSummaryCell* cell = [WARFeedLinkSummaryCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.layout = componentLayout;
            return cell;
        } else if (linkType == WARFeedLinkComponentTypeWeiBo) {
            WARFeedLinkSummaryCell* cell = [WARFeedLinkSummaryCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.layout = componentLayout;
            return cell;
        }
        return [UITableViewCell new];
    } else if(componentLayout.component.componentType == WARFeedComponentAlbumType){//相册组件cell
        WARFeedAlbumCell* cell = [WARFeedAlbumCell cellWithTableView:tableView];
        //        cell.baseDelegate = self;
        cell.layout = componentLayout;
        return cell;
    } else if(componentLayout.component.componentType == WARFeedComponentFavourType){
        WARFeedAlbumCell* cell = [WARFeedAlbumCell cellWithTableView:tableView];
        //        cell.baseDelegate = self;
        cell.layout = componentLayout;
        return cell;
    } else if(componentLayout.component.componentType == WARFeedComponentGameType){
        WARGameRankCell* cell = [WARGameRankCell cellWithTableView:tableView];
        cell.layout = componentLayout;
        cell.delegate = self;
        return cell;
    } else{
        static NSString *cellID = @"cellID";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"section:%ld row:%ld",indexPath.section,indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARFeedPageLayout *pageLayout = [self.pageLayoutArray objectAtIndex:indexPath.section];
    WARFeedComponentLayout* componentLayout = pageLayout.componentLayoutArr[indexPath.row];
    return componentLayout.diaryCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    WARFeedPageLayout *pageLayout = [self.pageLayoutArray objectAtIndex:indexPath.section];
    //    WARFeedComponentLayout* componentLayout = pageLayout.componentLayoutArr[indexPath.row];
    //    if (componentLayout.component.componentType == WARFeedComponentLinkType){
    //        if ([self.delegate respondsToSelector:@selector(pageContentView:didLink:)]) {
    //            [self.delegate pageContentView:self didLink:componentLayout.component.content];
    //        }
    //    }
}

#pragma mark - WARGameRankCellDelegate

- (void)gameRankCell:(WARGameRankCell *)cell didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(pageContentView:didGameLink:)]) {
        [self.delegate pageContentView:self didGameLink:link];
    }
}

- (void)gameRankCellDidAllRank:(WARGameRankCell *)cell game:(WARFeedGame *)game {
    if ([self.delegate respondsToSelector:@selector(pageContentViewDidAllRank:game:)]) {
        [self.delegate pageContentViewDidAllRank:self game:game];
    } 
}

#pragma mark - WARDiaryMagicImageCellDelegate

- (void)didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(didIndex:imageComponents:magicImageView:)]) {
        [self.delegate didIndex:index imageComponents:imageComponents magicImageView:magicImageView ];
    }
}

#pragma mark - WARFeedCellDelegate

- (void)feedCell:(WARFeedCell *)cell didComponent:(WARFeedComponentModel *)component {
    WARFeedLinkComponent *link = [[WARFeedLinkComponent alloc]init];
    switch (component.componentType) {
        case WARFeedComponentSceneryType:
        {
            link.url = component.content.scenery.url;
        }
            break;
        case WARFeedComponentHotelType:
        {
            link.url = component.content.hotel.url;
        }
            break;
        case WARFeedComponentStoryType:
        {
            link.url = component.content.store.url;
        }
            break;
            
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(pageContentView:didLink:)]) {
        [self.delegate pageContentView:self didLink:link];
    }
}


#pragma mark - WARFeedLinkCellDelegate

- (void)linkCell:(WARFeedLinkCell *)cell didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(pageContentView:didLink:)]) {
        [self.delegate pageContentView:self didLink:link];
    }
}

#pragma mark - WARFeedLinkSummaryCellDelegate

- (void)linkSummaryCell:(WARFeedLinkSummaryCell *)cell didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(pageContentView:didLink:)]) {
        [self.delegate pageContentView:self didLink:link];
    }
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setPageLayoutArray:(NSMutableArray<WARFeedPageLayout *> *)pageLayoutArray {
    _pageLayoutArray = pageLayoutArray;
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}


@end
