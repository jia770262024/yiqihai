//
//  lucRefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormluc. All rights reserved.
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

#import "LucRefreshTableHeaderView.h"
#import "LucLoadingPanel.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface LucRefreshTableHeaderView (Private)
- (void)setState:(LUCPullRefreshState)aState;
@end

@implementation LucRefreshTableHeaderView

//@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        [self setupdefault];
        self.backgroundColor = _bgColor;
        LucLoadingPanel *loading = [[LucLoadingPanel alloc]init];
        loading.center = CGPointMake(frame.size.width/2-50,frame.size.height - 30.0f);
        loading.backgroundColor = [UIColor clearColor];
        loading.offsetY = 0;
        _loadingPanel = loading;
        [self addSubview:loading];
        
        UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-20, frame.size.height - 50.0f, frame.size.width/2, 20.0f)];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont systemFontOfSize:14.f];
        statusLabel.textColor = _statusColor;
        statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel = statusLabel;
        [self addSubview:statusLabel];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-20, frame.size.height - 30.0f, frame.size.width/2, 20.0f)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:12.f];
        timeLabel.textColor = _timeColor;
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.text = @"从未更新";
        NSString *last = [[NSUserDefaults standardUserDefaults]objectForKey:@"lucRefreshTableView_LastRefresh"];
        if (last && last.length > 0) {
            timeLabel.text = last;
        }
        _lastUpdatedLabel = timeLabel;
        [self addSubview:timeLabel];
        [self setState:LUCPullRefreshNormal];
    }
    return self;
}

- (void)setupdefault
{
    _bgColor = [UIColor whiteColor];
    _timeColor = [UIColor lightGrayColor];
    _statusColor = [UIColor darkTextColor];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
	if ([_delegate respondsToSelector:@selector(lucRefreshTableHeaderDataSourceLastUpdated:)])
    {
		NSDate *date = [_delegate lucRefreshTableHeaderDataSourceLastUpdated:self];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MM-dd HH:mm"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"lucRefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(LUCPullRefreshState)aState{
	
	switch (aState) {
		case LUCPullRefreshPulling:
			
            _statusLabel.text = @"释放立即刷新";
			break;
            
		case LUCPullRefreshNormal:
            
            _statusLabel.text = @"下拉刷新";
            [_loadingPanel stopAnimation];
			break;
            
		case LUCPullRefreshLoading:
            
            _statusLabel.text = @"正在刷新...";
            [_loadingPanel doAnimation];
			break;
        
        case LUCPullRefreshComplete:
            
            _statusLabel.text = @"刷新完成";
            [_loadingPanel stopAnimation];
            
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)lucRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_state == LUCPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
        
		if (_delegate && [_delegate respondsToSelector:@selector(lucRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate lucRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == LUCPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:LUCPullRefreshNormal];
		} else if (_state == LUCPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:LUCPullRefreshPulling];
		}
//       可能崩溃--A
//		if (scrollView.contentInset.top != 0) {
//			scrollView.contentInset = UIEdgeInsetsZero;
//		}
        if (scrollView.contentOffset.y < 70) {
            
            CGFloat pullDownOffset = MIN(ABS(scrollView.contentOffset.y), 65) - 20;
            _loadingPanel.offsetY = pullDownOffset;
        }
	}
	
}

- (void)lucRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = NO;
	if (_delegate && [_delegate respondsToSelector:@selector(lucRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate lucRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		if (_delegate && [_delegate respondsToSelector:@selector(lucRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate lucRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:LUCPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.8];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
//        [_loadingPanel removeAllCircles];
	}
	
}

- (void)lucRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [self refreshLastUpdatedDate];
//    [self setState:LUCPullRefreshComplete];
//    [self performSelector:@selector(doEnd:) withObject:scrollView afterDelay:.6];
    [self doEnd:scrollView];
}

- (void)doEnd:(UIScrollView *)scroll
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [_loadingPanel removeAllCircles];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.6];
        scroll.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        [self setState:LUCPullRefreshNormal];
        [UIView commitAnimations];
    });
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    [_loadingPanel stopAnimation];
    _loadingPanel = nil;
	_delegate = nil;
	_statusLabel = nil;
	_lastUpdatedLabel = nil;
}

#pragma mark - set方法
//头部背景颜色
- (void)setHeaderBackgroundColor:(UIColor *)color
{
    _bgColor = color;
    [self setBackgroundColor:_bgColor];
}

//头部圈圈的颜色
- (void)setHeaderCircleColor:(UIColor *)color
{
    _loadingPanel.defaultColor = color;
}

//头部状态标签的颜色
- (void)setHeaderStatusLabelColor:(UIColor *)color
{
    _statusColor = color;
    [_statusLabel setTextColor:_statusColor];
}

//头部时间标签的颜色
- (void)setHeaderTimeLabelColor:(UIColor *)color
{
    _timeColor = color;
    [_lastUpdatedLabel setTextColor:color];
}

- (void)doAutoPullDown
{
    [_loadingPanel doAutoPullDown];
}

@end
