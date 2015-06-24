//
//  PullRefreshTableView.m
//  TableViewPull
//
//  Created by wallstreetcn on 14-10-29.
//
//

#import "LucPullRefreshTableView.h"

@implementation LucPullRefreshTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style target:(id)target
{
    self = [self initWithFrame:frame style:style];
    if (self)
    {
        _target = target;
    }
    return self;
}

- (void)dealloc
{
    _target = nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.frame = frame;
        [self initModal];
        [self buildUI];
    }
    return self;
}

- (void)setTarget:(id)target
{
    _target = target;
}

-(void)setFooterRefreshTitle:(NSString *)title {
    _LUCLoadViewStateTapLoadValue = title;
}

- (void)initModal
{
    //默认为支持
    self.supportPullDownRefresh = YES;
}

- (void)buildUI
{

}

- (void) createTableFooter
{
    if (!_refreshFooterView) {
        
        LucRefreshTableFooterView *loadmoewView = [[LucRefreshTableFooterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 40.0f)];
        _refreshFooterView = loadmoewView;
        if (_LUCLoadViewStateTapLoadValue) {
            [_refreshFooterView setLUCLoadViewStateTapLoadValue:_LUCLoadViewStateTapLoadValue];
        }
        self.tableFooterView = loadmoewView;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = loadmoewView.bounds;
        btn.center = loadmoewView.center;
        btn.backgroundColor = [UIColor clearColor];
        [loadmoewView addSubview:btn];
        [btn addTarget:self action:@selector(reloadDataSourceByPullup) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setSupportPullUpRefresh:(BOOL)supportPullUpRefresh
{
    _supportPullUpRefresh = supportPullUpRefresh;
    if (_supportPullUpRefresh)
    {
        [self createTableFooter];
    }
    else
    {
        if (_refreshFooterView) {
            [_refreshFooterView removeFromSuperview];
        }
    }
}

- (void)setSupportPullDownRefresh:(BOOL)supportPullDownRefresh
{
    _supportPullDownRefresh = supportPullDownRefresh;
    if (_supportPullDownRefresh)
    {
        if (!_refreshHeaderView) {
            LucRefreshTableHeaderView *view = [[LucRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
            view.delegate = self;
            _refreshHeaderView = view;
            [self addSubview:view];
        }
    }
    else
    {
        if (_refreshHeaderView) {
            _refreshHeaderView.delegate = nil;
            [_refreshHeaderView removeFromSuperview];
            _refreshHeaderView = nil;
        }
    }
}


#pragma mark - 上拉刷新

- (void)reloadDataSourceByPullup
{
    if (!_reloading) {
        if (_refreshFooterView.isComplete) {
            [_refreshFooterView setViewState:LUCLoadViewStateNoMore];
            return;
        }
        else if (_refreshFooterView.isLoading) {
            //什么也不做
            return;
        }
        else
        {
            //TODO PullUpRequest
            [_refreshFooterView setViewState:LUCLoadViewStateLoading];
            SEL sel = NSSelectorFromString(@"doPullUpRefresh");
            if (_target && [_target respondsToSelector:sel])
            {
                [_target performSelector:sel];
            }
            else
            {
                [self performSelector:@selector(doneLoadingTableViewDataByPullUpForState:) withObject:nil afterDelay:3];
            }
        }
    }
}


- (void)doneLoadingTableViewDataByPullUpForState:(LUCLoadViewState)state
{
    if (!state) {
        [_refreshFooterView setViewState:LUCLoadViewStateClickable];
        return;
    }
    [_refreshFooterView setViewState:state];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView lucRefreshScrollViewDataSourceDidFinishedLoading:self];
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods


- (void)scrollviewDidScrolled
{
    [_refreshHeaderView lucRefreshScrollViewDidScroll:self];
    
}

- (void)scrollViewDidEndDragging
{
    [_refreshHeaderView lucRefreshScrollViewDidEndDragging:self];

}

- (void)scrollViewDidEndDecelerating
{
    //tableview 滑动到底部的时候 开始加载更多
    CGPoint contentOffsetPoint = self.contentOffset;
    CGRect frame = self.frame;
    if (contentOffsetPoint.y+5 >= self.contentSize.height - frame.size.height)
    {
        if (_supportPullUpRefresh && _refreshFooterView) {
            [self reloadDataSourceByPullup];
        }
    }
}


#pragma mark -
#pragma mark LUcRefreshTableHeaderDelegate Methods

- (void)lucRefreshTableHeaderDidTriggerRefresh:(LucRefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
     SEL sel = NSSelectorFromString(@"doPullDownRefresh");
    if (_target && [_target respondsToSelector:sel])
    {
        [_target performSelector:sel];
    }
    else
    {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    }
//    [self reloadTableViewDataSource];
//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)lucRefreshTableHeaderDataSourceIsLoading:(LucRefreshTableHeaderView*)view
{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)lucRefreshTableHeaderDataSourceLastUpdated:(LucRefreshTableHeaderView*)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
}

- (void)triggerPullDownRefresh
{
    [self setContentOffset:CGPointMake(0, -70) animated:NO];
     NSLog(@"AAAAAAAAAAAAAAAAAA  %lf", self.contentOffset.y);
    [_refreshHeaderView doAutoPullDown];
//    [self performSelector:@selector(test) withObject:nil afterDelay:0.2999];
    [self performSelector:@selector(scrollViewDidEndDragging) withObject:nil afterDelay:0.3];
}

- (void)test {
    [self setContentOffset:CGPointMake(0, -70) animated:NO];
}

#pragma mark - 上拉下拉UI各种色值设置
//头部背景颜色
- (void)setHeaderBackgroundColor:(UIColor *)color
{
    [_refreshHeaderView setHeaderBackgroundColor:color];
}

//头部圈圈的颜色
- (void)setHeaderCircleColor:(UIColor *)color
{
    [_refreshHeaderView setHeaderCircleColor:color];

}

//头部状态标签的颜色
- (void)setHeaderStatusLabelColor:(UIColor *)color
{
    [_refreshHeaderView setHeaderStatusLabelColor:color];

}

//头部时间的颜色
- (void)setHeaderTimeLabelColor:(UIColor *)color
{
    [_refreshHeaderView setHeaderTimeLabelColor:color];

}

//底部背景颜色
- (void)setFooterBackgroundColor:(UIColor *)color
{
    [_refreshFooterView setFooterBackgroundColor:color];
}

//底部状态标签的颜色
- (void)setFooterStatusLabelColor:(UIColor *)color
{
    [_refreshFooterView setFooterLabelColor:color];
}

//底部状态标签的颜色
- (void)setFooterActivityStyle:(UIActivityIndicatorViewStyle)style
{
    [_refreshFooterView setFooterIndicatoerStyle:style];
}
@end

