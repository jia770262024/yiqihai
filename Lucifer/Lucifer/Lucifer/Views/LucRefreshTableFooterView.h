//
//  LoadMoreView.h
//  WSCNNewsReader
//
//  Created by wallstreetcn on 13-12-25.
//  Copyright (c) 2013年 wallstreetcn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LUCLoadViewStateClickable = 0, //点击加载更多
    LUCLoadViewStateLoading = 1, //正在加载
    LUCLoadViewStateNoMore = 2, //没有更多内容了
}LUCLoadViewState;

@interface LucRefreshTableFooterView : UIView
{
    UIActivityIndicatorView *_loadingView;
    UILabel *_loadingLabel;
    UIColor *_bgcolor;
    UIColor *_labelColor;
}
@property (nonatomic, copy) NSString * LUCLoadViewStateTapLoadValue ;
@property (nonatomic, assign) BOOL  isLoading;
@property (nonatomic, assign) BOOL  isComplete;
-(void)setViewState:(LUCLoadViewState)state;
//设置UI的颜色
- (void)setFooterBackgroundColor:(UIColor *)bgColor;
- (void)setFooterLabelColor:(UIColor *)labelColor;
- (void)setFooterIndicatoerStyle:(UIActivityIndicatorViewStyle )style;

@end
