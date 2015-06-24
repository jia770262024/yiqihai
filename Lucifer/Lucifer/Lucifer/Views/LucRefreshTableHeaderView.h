//
//  EGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LucLoadingPanel.h"


typedef enum{
	LUCPullRefreshPulling = 0,
	LUCPullRefreshNormal,
	LUCPullRefreshLoading,
    LUCPullRefreshComplete,
} LUCPullRefreshState;

@protocol LucRefreshTableHeaderDelegate;
@interface LucRefreshTableHeaderView : UIView
{
	
	LUCPullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
    LucLoadingPanel *_loadingPanel;
    UIColor *_bgColor;
    UIColor *_circleColor;
    UIColor *_statusColor;
    UIColor *_timeColor;
}

@property(nonatomic,assign) id <LucRefreshTableHeaderDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)lucRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)lucRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)lucRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


//头部背景颜色
- (void)setHeaderBackgroundColor:(UIColor *)color;
//头部圈圈的颜色
- (void)setHeaderCircleColor:(UIColor *)color;
//头部状态标签的颜色
- (void)setHeaderStatusLabelColor:(UIColor *)color;
//头部时间标签的颜色
- (void)setHeaderTimeLabelColor:(UIColor *)color;

- (void)doAutoPullDown;

@end


@protocol LucRefreshTableHeaderDelegate <NSObject>
- (void)lucRefreshTableHeaderDidTriggerRefresh:(LucRefreshTableHeaderView*)view;
- (BOOL)lucRefreshTableHeaderDataSourceIsLoading:(LucRefreshTableHeaderView*)view;
@optional
- (NSDate*)lucRefreshTableHeaderDataSourceLastUpdated:(LucRefreshTableHeaderView*)view;

@end
