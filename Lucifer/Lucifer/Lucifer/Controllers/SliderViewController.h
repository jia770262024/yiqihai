//
//  SliderViewController.h
//  SliderTabbar
//
//  Created by wallstreetcn on 14-3-20.
//  Copyright (c) 2014年 wallstreetcn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SliderDataSource;
@protocol SliderDelegate;
@interface SliderViewController : UIViewController <UIScrollViewDelegate>
@property id <SliderDataSource> dataSource;
@property id <SliderDelegate> delegate;
@property (strong, nonatomic) UIButton *leftButton;
- (void)reloadDatas;
@end

#pragma mark dataSource
@protocol SliderDataSource <NSObject>
- (NSArray *)titleArrayForViewPager:(SliderViewController *)sliderVC;
- (UIView *)viewPager:(SliderViewController *)sliderVC viewForTabAtIndex:(NSUInteger)index;
- (CGRect)frameForTopbar;
- (CGRect)frameForContentView;
@end

#pragma mark delegate
@protocol SliderDelegate <NSObject>
@optional
//当tab发生切换的时候 实现此代理方法
- (void)viewPager:(SliderViewController *)sliderVC didChangeTabToIndex:(NSUInteger)index;
- (void)viewPager:(SliderViewController *)sliderVC viewAppearAtIndex:(NSUInteger)index forView:(UIView *)view;
- (void)viewPager:(SliderViewController *)sliderVC viewDisappearAtIndex:(NSUInteger)index forView:(UIView *)view;
@end