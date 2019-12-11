//
//  WARFeedPageContentViewController.m
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import "WARPageContentViewController.h"
#import "WARFeedHeader.h"
#import "WARFeedCell.h"
#import "WARFeedComponentLayout.h"
#import "WARFeedModel.h"
#import "WARFeedRichTextCell.h"
#import "WARFeedMagicImageCell.h"
#import "WARFeedLinkCell.h"
#import "WARFeedLinkSummaryCell.h"
#import "WARSimpleSceneryCell.h"
#import "WARSimpleStoreOrHotelCell.h"
#import "WARFeedSceneryCell.h"
#import "WARFeedStoreLayout.h"
#import "WARFeedStoreCell.h"
#import "WARFeedAlbumCell.h"
#import "WARGameRankCell.h"

@interface WARPageContentViewController () <UITableViewDelegate, UITableViewDataSource, WARFeedLinkCellDelegate, WARFeedMagicImageCellDelegate,WARFeedLinkSummaryCellDelegate,WARFeedCellDelegate,WARGameRankCellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation WARPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}



- (void)setPageLayout:(WARFeedPageLayout *)pageLayout {
    
    _pageLayout = pageLayout;
    
    
    [self.tableView reloadData];
}



#pragma mark  UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pageLayout.componentLayoutArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WARFeedComponentLayout* componentLayout = self.pageLayout.componentLayoutArr[indexPath.row];
    if (componentLayout.component.componentType == WARFeedComponentTextType) {
        WARFeedRichTextCell* cell = [WARFeedRichTextCell cellWithTableView:tableView];
        cell.layout = componentLayout;
        return cell;
    } else if (componentLayout.component.componentType == WARFeedComponentMediaType){
        WARFeedMagicImageCell* cell = [WARFeedMagicImageCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.layout = componentLayout;
        return cell;
    } else if (componentLayout.component.componentType == WARFeedComponentSceneryType) {
        WARFeedScenery *scenery = componentLayout.component.content.scenery;
        if (scenery.editionEnum == WARFeedComponentIntegrityTypeSimple) {
            WARSimpleSceneryCell *cell = [WARSimpleSceneryCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        } else if (scenery.editionEnum == WARFeedComponentIntegrityTypeComplete) {
            WARFeedSceneryCell *cell = [WARFeedSceneryCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        }
        WARSimpleSceneryCell *cell = [WARSimpleSceneryCell cellWithTableView:tableView];
        return cell;
    } else if (componentLayout.component.componentType == WARFeedComponentStoryType) {
        WARFeedStore *store = componentLayout.component.content.store;
        if (store.editionEnum == WARFeedComponentIntegrityTypeSimple) {
            WARSimpleStoreOrHotelCell *cell = [WARSimpleStoreOrHotelCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        } else if (store.editionEnum == WARFeedComponentIntegrityTypeComplete) {
            WARFeedStoreCell *cell = [WARFeedStoreCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        }
        
        return [UITableViewCell new];
    }  else if (componentLayout.component.componentType == WARFeedComponentHotelType) {
        WARFeedStore *hotel = componentLayout.component.content.hotel;
        if (hotel.editionEnum == WARFeedComponentIntegrityTypeSimple) {
            WARSimpleStoreOrHotelCell *cell = [WARSimpleStoreOrHotelCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        } else if (hotel.editionEnum == WARFeedComponentIntegrityTypeComplete) {
            WARFeedStoreCell *cell = [WARFeedStoreCell cellWithTableView:tableView];
            cell.layout = componentLayout;
            cell.baseDelegate = self;
            return cell;
        }
        
        return [UITableViewCell new];
    } else if (componentLayout.component.componentType == WARFeedComponentLinkType){
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
    } else if(componentLayout.component.componentType == WARFeedComponentAlbumType){
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
    WARFeedComponentLayout* componentLayout = self.pageLayout.componentLayoutArr[indexPath.row];
    return componentLayout.cellHeight;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WARFeedComponentLayout* componentLayout = self.pageLayout.componentLayoutArr[indexPath.row];
//    if (componentLayout.component.componentType == WARFeedComponentLinkType){
//        if ([self.delegate respondsToSelector:@selector(pageContentView:didLink:)]) {
//            [self.delegate pageContentView:self didLink:componentLayout.component.content];
//        }
//    }
//}

#pragma mark - WARGameRankCellDelegate

- (void)gameRankCell:(WARGameRankCell *)cell didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(controller:didGameLink:)]) {
        [self.delegate controller:self didGameLink:link];
    }
}

#pragma mark - WARFeedLinkCellDelegate

- (void)linkCell:(WARFeedLinkCell *)cell didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(controller:didLink:)]) {
        [self.delegate controller:self didLink:link];
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
    if ([self.delegate respondsToSelector:@selector(controller:didLink:)]) {
        [self.delegate controller:self didLink:link];
    }
}


#pragma mark - WARFeedLinkSummaryCellDelegate

- (void)linkSummaryCell:(WARFeedLinkSummaryCell *)cell didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(controller:didLink:)]) {
        [self.delegate controller:self didLink:link];
    }
}

#pragma mark - WARFeedMagicImageCellDelegate

- (void)didIndex:(NSInteger)index imageComponents:(NSArray<WARFeedImageComponent *> *)imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(controller:didIndex:imageComponents:magicImageView:)]) {
        [self.delegate controller:self didIndex:index imageComponents:imageComponents magicImageView:magicImageView];
    }
}
  
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    
    [_tableView removeFromSuperview];
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}
@end
