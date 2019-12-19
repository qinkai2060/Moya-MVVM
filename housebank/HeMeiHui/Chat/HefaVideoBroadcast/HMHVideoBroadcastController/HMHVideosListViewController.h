//
//  VideosListViewController.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/28.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHBasePrimaryViewController.h"
// 视频列表页
@interface HMHVideosListViewController : HMHBasePrimaryViewController
// 0 最热   1 直播   2 预告 4 盗铃空间 5 合发购 6 全球家 7 OTO
//@property (nonatomic, assign) NSInteger index;

// module->模块菜单  scene->精选、推荐、短视频  tag->按照标签检索   category->指定类别（分类）检索   search->检索
/**
 searchType：module，scene，tag，category，keyword
 searchValue：参照各自的说明
 ●searchType=module 时候： searchValue为 hot（最热）|live（直播）|preview（预告）|category（分类）|u2u（盗龄空间）|mall（商城）|globalhome（全球家）|oto（OTO） 八个模块菜单标记
 ●searchType=scene 时候： searchValue为 wellchosen（精选）|recommend（推荐）|short（短视频）
 ●searchType=category 时候： searchValue为 视频类别id
 ●searchType=tag 时候： searchValue为 视频标签id
 ●searchType=keyword 时候： searchValue为 检索关键字
 
 pageNo:页号（数字）
 */
@property (nonatomic, strong) NSString *searchType;

@property (nonatomic, strong) NSString *searchValue;

@property (nonatomic, strong) NSString *tagOrCategoryNameStr;

@end
