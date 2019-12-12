//
//  WARGameRankView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import "WARGameRankView.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "WARFeedMacro.h"
#import "WARUIHelper.h"
#import "UIImage+WARBundleImage.h"
#import "NSString+Size.h"
 
@interface WARGameSegmentView()
/** line */
@property (nonatomic, strong) UIView *line;
/** tagBtns */
@property (nonatomic, strong) NSMutableArray <UIButton *>*tagBtns;
/** tagLines */
@property (nonatomic, strong) NSMutableArray <UIView *>*tagLines;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation WARGameSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [HEXCOLOR(0xF4F4F4) colorWithAlphaComponent:0.5];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.line];
}

- (void)setTags:(NSMutableArray<NSString *> *)tags {
    _tags = tags;
    // 移除之前所有的子控件
    [self.tagBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLines makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
    [self.tagBtns removeAllObjects];
    [self.tagLines removeAllObjects];
    
    // 添加最新的子控件
    for (int i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [btn setTitleColor:HEXCOLOR(0xADB1BE) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x343C4F) forState:UIControlStateSelected];
        [btn setTitle:tag forState:UIControlStateNormal];
        [self addSubview:btn];
//        [btn sizeToFit];
        
        // 保存到一个数组中
        [self.tagBtns addObject:btn];
        
        if (i != tags.count - 1) {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = HEXCOLOR(0xBFC2CC);
            [self addSubview:line];
            [self.tagLines addObject:line];
        }
    }
    
    // 重新布局
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    // 默认选中第一个选项卡
    [self tagClick:[self.tagBtns firstObject]];
}

/**
 *  点击某个选项卡调用的事件
 */
- (void)tagClick:(UIButton *)btn {
    //恢复普通状态
    for (UIButton *originalBtn in self.tagBtns) {
        originalBtn.selected = NO;
    }
    
    //改变当前按钮状态
    btn.selected = YES;
    _selectedIndex = btn.tag;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(gameSegmentView:didIndex:)]) {
        [self.delegate gameSegmentView:self didIndex:btn.tag];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxWidth = self.bounds.size.width;
    CGFloat w = (maxWidth - (self.tagBtns.count - 1)) / self.tagBtns.count;
    CGFloat h = self.bounds.size.height - 0.5;
    CGFloat y = 0;
    
    if (!self.tagBtns || self.tagBtns.count <= 0) {
        return;
    }
    
    for (int i = 0; i < self.tagBtns.count; i++) {
        CGFloat x = (w + 1) * i;
        UIButton *btn = self.tagBtns[i];
        btn.frame = CGRectMake(x, y, w, h);
        
        if (i <= self.tagLines.count - 1 && i >= 0) {
            UIView *line = self.tagLines[i];
            line.frame = CGRectMake((w + 1) + x , 8, 1, 13.5);
        }
    }
    self.line.frame = CGRectMake(0, h, maxWidth, 0.5);
}

- (void)action:(UIButton *)button {
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
}

/** 用于存储选项卡的数组 */
- (NSMutableArray<UIButton *> *)tagBtns {
    if (!_tagBtns) {
        _tagBtns = [NSMutableArray <UIButton *>array];
    }
    return _tagBtns;
}
- (NSMutableArray<UIView *> *)tagLines {
    if (!_tagLines) {
        _tagLines = [NSMutableArray <UIView *>array];
    }
    return _tagLines;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _line;
}

@end

#pragma mark - WARGameRankViewCell

@interface WARGameRankViewCell()
/** nameLable */
@property (nonatomic, strong) UILabel *nameLable;
/** nameLable */
@property (nonatomic, strong) UILabel *rankLable;
/** scoreLable */
@property (nonatomic, strong) UILabel *scoreLable;
/** mineRankLable */
@property (nonatomic, strong) UILabel *mineRankLable;
/** paihangImageView */
@property (nonatomic, strong) UIImageView *paihangImageView;
/** rankImageView */
@property (nonatomic, strong) UIImageView *rankImageView;
/** userImageView */
@property (nonatomic, strong) UIImageView *userImageView;
/** line */
@property (nonatomic, strong) UIView *line;

/** scoreMaxWidth */
@property (nonatomic, assign) CGFloat scoreMaxWidth;
@end

@implementation WARGameRankViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARGameRankViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARGameRankViewCell"];
    if (!cell) {
        cell = [[[WARGameRankViewCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARGameRankViewCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [HEXCOLOR(0xF6F6F6) colorWithAlphaComponent:0.3];
        
        [self.contentView addSubview:self.nameLable];
        [self.contentView addSubview:self.rankLable];
        [self.contentView addSubview:self.scoreLable];
        [self.contentView addSubview:self.paihangImageView];
        [self.contentView addSubview:self.rankImageView];
        [self.contentView addSubview:self.userImageView];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)setRank:(WARFeedGameRank *)rank {
    _rank = rank;
    
    if (self.scoreMaxWidth < rank.scoreWidth) {
        self.scoreMaxWidth = rank.scoreWidth;
    }
    
    
    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - (rank.isMultiPage ? 13 : 0);
    
    self.rankLable.text = rank.ranking == -1 ? @"-" : [NSString stringWithFormat:@"%ld",rank.ranking];
    [self.userImageView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(24, 24),rank.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.nameLable.text = rank.nickname;
    self.scoreLable.text = rank.score ;
    
    self.paihangImageView.hidden = !rank.isMine;
    self.rankLable.hidden = (rank.ranking <= 3) && (rank.ranking != -1);
    self.rankImageView.hidden = !(rank.ranking <= 3);
    self.scoreLable.textColor = (rank.ranking <= 3) ? HEXCOLOR(0xF2604D) : HEXCOLOR(0xADB1BE);
    
    self.scoreLable.font = (rank.ranking <= 3) ? [UIFont fontWithName:@"PingFangSC-Medium" size:13] : [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    
    UIImage *image;
    switch (rank.ranking) {
        case 1:
        {
            image = [UIImage war_imageName:@"guanjun" curClass:[self class] curBundle:@"WARProfile.bundle"];
            
        }
            break;
        case 2:
        {
            image = [UIImage war_imageName:@"yajun" curClass:[self class] curBundle:@"WARProfile.bundle"];
        }
            break;
        case 3:
        {
            image = [UIImage war_imageName:@"jijun" curClass:[self class] curBundle:@"WARProfile.bundle"];
        }
            break;
    }
    self.rankImageView.image = image;
    
    CGFloat nicknameWidth = rank.nicknameWidth <= 0 ? 56 : rank.nicknameWidth;
    
    self.scoreLable.frame = CGRectMake(maxWidth - 12 - self.scoreMaxWidth, 14, self.scoreMaxWidth, 13);
    self.line.frame = CGRectMake(14, 39.5, maxWidth - 28, 0.5);
    self.nameLable.frame = CGRectMake(68, 13.5, nicknameWidth, 13);
    self.paihangImageView.frame = CGRectMake(68 + nicknameWidth + 6 , 13.5, 48, 14);
}

- (UILabel *)rankLable {
    if (!_rankLable) {
        _rankLable = [[UILabel alloc]init];
        _rankLable.font = [UIFont fontWithName:@"Silom" size:12];
        _rankLable.frame = CGRectMake(0, 11.5, 38, 18.5);
        _rankLable.textAlignment = NSTextAlignmentCenter;
        _rankLable.textColor = HEXCOLOR(0x8D93A4);
    }
    return _rankLable;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLable.frame = CGRectMake(68, 13.5, kScreenWidth * 0.5, 13);
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = HEXCOLOR(0x343C4F);
    }
    return _nameLable;
}

- (UILabel *)mineRankLable {
    if (!_mineRankLable) {
        CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin);
        
        _mineRankLable = [[UILabel alloc]init];
        _mineRankLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
        _mineRankLable.frame = CGRectMake(maxWidth - 102, 13.5, 48, 14);
        _mineRankLable.textAlignment = NSTextAlignmentCenter;
        _mineRankLable.text = @"我的排行";
        _mineRankLable.layer.cornerRadius = 7;
        _mineRankLable.layer.masksToBounds = YES;
        _mineRankLable.backgroundColor = HEXCOLOR(0x2CBE61);
        _mineRankLable.textColor = HEXCOLOR(0xffffff);
    }
    return _mineRankLable;
}

- (UIImageView *)paihangImageView {
    if (!_paihangImageView) {
        CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin);
        UIImage *image = [UIImage war_imageName:@"paihang" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _paihangImageView = [[UIImageView alloc] init];
        _paihangImageView.frame = CGRectMake(maxWidth - 102, 13.5, 48, 14);
        _paihangImageView.image = image;
        _paihangImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _paihangImageView;
}

- (UILabel *)scoreLable {
    if (!_scoreLable) {
        CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin);
        
        _scoreLable = [[UILabel alloc]init];
        _scoreLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _scoreLable.frame = CGRectMake(maxWidth - 12 - 100, 14, 100, 13);
        _scoreLable.textAlignment = NSTextAlignmentRight;
        _scoreLable.textColor = HEXCOLOR(0xF2604D);//8D93A4
    }
    return _scoreLable;
}

- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.frame = CGRectMake(11, 11, 16, 19);
        _rankImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _rankImageView;
}

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.frame = CGRectMake(38, 8, 24, 24);
        _userImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _userImageView;
}



- (UIView *)line {
    if (!_line) {
        CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin);
        _line = [[UIView alloc] init];
        _line.frame = CGRectMake(14, 39.5, maxWidth - 28, 0.5);
        _line.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _line;
}

@end

#pragma mark - WARAllGameRankCell

@interface WARAllGameRankCell()
/** seeAllRankLable */
@property (nonatomic, strong) UILabel *seeAllRankLable;
/** line */
@property (nonatomic, strong) UIView *line;
@end

@implementation WARAllGameRankCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARAllGameRankCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARAllGameRankCell"];
    if (!cell) {
        cell = [[[WARAllGameRankCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARAllGameRankCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [HEXCOLOR(0xF6F6F6) colorWithAlphaComponent:0.3];
        [self.contentView addSubview:self.seeAllRankLable];
//        [self.contentView addSubview:self.line];
    }
    return self;
}


- (UILabel *)seeAllRankLable {
    if (!_seeAllRankLable) {
        CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin);
        _seeAllRankLable = [[UILabel alloc]init];
        _seeAllRankLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _seeAllRankLable.frame = CGRectMake(0, 0, maxWidth, 40);
        _seeAllRankLable.textAlignment = NSTextAlignmentCenter;
        _seeAllRankLable.textColor = HEXCOLOR(0x576B95);
        _seeAllRankLable.text = @"查看全部排行 >>";
    }
    return _seeAllRankLable;
}

- (UIView *)line {
    if (!_line) {
        CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin);
        _line = [[UIView alloc] init];
        _line.frame = CGRectMake(14, 39.5, maxWidth - 28, 0.5);
        _line.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _line;
}

@end

#pragma mark - WARGameRankView

@interface WARGameRankView()<UITableViewDelegate,UITableViewDataSource,WARGameSegmentViewDelegate>
/** segmentView */
@property (nonatomic, strong) WARGameSegmentView *segmentView;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** currentRanks */
@property (nonatomic, strong) NSMutableArray <WARFeedGameRank *>*currentRanks;
@end

@implementation WARGameRankView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [HEXCOLOR(0xF6F6F6) colorWithAlphaComponent:0.3];
        [self addSubview:self.segmentView];
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return self.currentRanks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        WARAllGameRankCell *cell = [WARAllGameRankCell cellWithTableView:tableView];
        
        return cell;
    } else {
        WARFeedGameRank *rank = self.currentRanks[indexPath.row];
//        rank.ranking = indexPath.row + 1;
        rank.isMultiPage = self.game.isMultiPage;
        
        WARGameRankViewCell *cell = [WARGameRankViewCell cellWithTableView:tableView];
        cell.rank = rank;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (self.allRankBlock) {
            self.allRankBlock();
        }
    }
}

#pragma mark - WARGameSegmentViewDelegate

- (void)gameSegmentView:(WARGameSegmentView *)gameSegmentView didIndex:(NSInteger)index {
    self.currentRanks = self.gameRanks[index].ranks;
    [self.tableView reloadData];
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setGame:(WARFeedGame *)game {
    _game = game;
    
    self.gameRanks = game.gameRanks;
    self.segmentView.tags = [_gameRanks valueForKey:@"rankName"];
    
    self.segmentView.hidden = !game.showRank;
    self.tableView.hidden = !game.showRank;
    
    self.segmentView.frame = CGRectMake(0, 0, (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - (game.isMultiPage ? 14 : 0), 30);
    self.tableView.frame = CGRectMake(0, 30, (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - (game.isMultiPage ? 13 : 0), 204);
}

- (WARGameSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[WARGameSegmentView alloc] init];
        _segmentView.frame = CGRectMake(0, 0, (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 13, 30);
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 30, (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 13, 204);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.scrollEnabled = NO;
        _tableView.hidden = YES;
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


