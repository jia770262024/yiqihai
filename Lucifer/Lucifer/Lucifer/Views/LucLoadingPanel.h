//
//  LoadingPanel.h
//  三个点动画
//
//  Created by wallstreetcn on 14-10-29.
//  Copyright (c) 2014年 WallStreetcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LucLoadingPanel : UIView
{
    NSMutableArray *_circlesArr;
}
//最多允许多少个圆
@property (assign, nonatomic) int maxCirclesNumber;

//圆的半径
@property (readwrite, nonatomic) CGFloat radius;

//圆与圆之间的空隙
@property (readwrite, nonatomic) CGFloat internalSpacing;

//每个圆的动画延迟
@property (readwrite, nonatomic) CGFloat delay;

//每个月的动画时间
@property (readwrite, nonatomic) CGFloat duration;

//圆的颜色
@property (strong, nonatomic) UIColor *defaultColor;

//偏移量
@property (nonatomic, assign) CGFloat offsetY;

//添加一个圆
- (void)addACircle;

//删除一个圆
- (void)removeACircle;

- (void)removeAllCircles;

//开始下拉刷新动画
- (void)doAnimation;

//结束动画
- (void)stopAnimation;

//自动下拉
- (void)doAutoPullDown;

//开始页面加载动画
- (void)doPageLoadingAnimation;

- (void)stopPageLoadingAnimation;
@end
