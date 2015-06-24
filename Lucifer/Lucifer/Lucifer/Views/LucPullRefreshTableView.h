//
//  PullRefreshTableView.h
//  TableViewPull
//
//  Created by wallstreetcn on 14-10-29.
//
//

#import <UIKit/UIKit.h>
#import "LucRefreshTableHeaderView.h"
#import "LucRefreshTableFooterView.h"

@interface LucPullRefreshTableView : UITableView <LucRefreshTableHeaderDelegate>
{
    LucRefreshTableHeaderView *_refreshHeaderView;
    LucRefreshTableFooterView *_refreshFooterView;
    NSString * _LUCLoadViewStateTapLoadValue;
    BOOL _reloading;
    BOOL _isPullUpReloding;
}
@property (nonatomic, assign) BOOL supportPullUpRefresh;
@property (nonatomic, assign) BOOL supportPullDownRefresh;
@property (nonatomic, assign) id target;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style target:(id)target;
- (void)scrollviewDidScrolled;
- (void)scrollViewDidEndDragging;
- (void)scrollViewDidEndDecelerating;
- (void)doneLoadingTableViewData;
- (void)doneLoadingTableViewDataByPullUpForState:(LUCLoadViewState)state;
- (void)triggerPullDownRefresh;

//各种色值
//头部背景颜色
- (void)setHeaderBackgroundColor:(UIColor *)color;
//头部圈圈的颜色
- (void)setHeaderCircleColor:(UIColor *)color;
//头部状态标签的颜色
- (void)setHeaderStatusLabelColor:(UIColor *)color;
//头部时间标签的颜色
- (void)setHeaderTimeLabelColor:(UIColor *)color;
//底部背景颜色
- (void)setFooterBackgroundColor:(UIColor *)color;
//底部状态标签的颜色
- (void)setFooterStatusLabelColor:(UIColor *)color;
//底部指示器样式
- (void)setFooterActivityStyle:(UIActivityIndicatorViewStyle)style;
//设置上拉刷新提示内容
- (void)setFooterRefreshTitle:(NSString *)title;
@end
