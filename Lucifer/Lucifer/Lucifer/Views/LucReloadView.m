//
//  LucReloadView.m
//  News
//
//  Created by wallstreetcn on 14-11-1.
//  Copyright (c) 2014年 wallstreetcn. All rights reserved.
//

#import "LucReloadView.h"

@implementation LucReloadView


#pragma mark - public methods
//初始化方法
- (id)initWithFrame:(CGRect)frame forTarget:(id)obj
{
    if (self == [self initWithFrame:frame]) {
        self.frame = frame;
        self.target = obj;
        [self buildUI];
    }
    return self;
}

//开始加载
- (void)startLoading
{
    self.hidden = NO;
    _loadView.hidden = NO;
    [_loadingPanel doPageLoadingAnimation];
    _reloadView.hidden = YES;
    _loadView.hidden = NO;
}

//停止加载
- (void)stopLoading
{
    self.hidden = NO;
    _reloadView.hidden = NO;
    _loadView.hidden = YES;
    [_loadingPanel stopPageLoadingAnimation];
}

//完成加载
- (void)completeLoading
{
    _loadView.hidden = YES;
    _reloadView.hidden = YES;
    [_loadingPanel stopPageLoadingAnimation];
    self.hidden = YES;
}


#pragma mark - 绘制UI视图
- (void)buildUI
{
    self.backgroundColor = [UIColor clearColor];
    //正在加载的view
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    v.center = self.center;
    v.bounds = self.bounds;
    v.hidden = YES;
    v.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _loadView = v;
    [self addSubview:v];
    
    LucLoadingPanel *loading = [[LucLoadingPanel alloc]init];
    loading.center = CGPointMake(v.frame.size.width/2,v.frame.size.height/2-40);
    loading.backgroundColor = [UIColor clearColor];
    _loadingPanel = loading;
    [_loadView addSubview:loading];
    
    //重新加载的view
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor clearColor];
    v1.frame = self.bounds;
    v1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    v1.hidden = YES;
    _reloadView = v1;
    [self addSubview:v1];

    //背景按钮
    UIButton *bgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgbtn.frame = self.bounds;
    bgbtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bgbtn.backgroundColor = [UIColor clearColor];
    [bgbtn addTarget:self action:@selector(doReload) forControlEvents:UIControlEventTouchDown];
    _bgButton = bgbtn;
    [_reloadView addSubview:bgbtn];
    
    UIImageView *iv = [[UIImageView alloc]init];
    iv.backgroundColor = [UIColor clearColor];
    _reloadImageView = iv;
    [_reloadView addSubview:iv];
    [self setReladImage:[UIImage imageNamed:@"reload"]];
}

#pragma mark - action事件
- (void)doReload
{
    //开始加载
    [self startLoading];
    if (_target && [_target respondsToSelector:@selector(doReload)]) {
        [_target doReload];
    } else {
        NSLog(@"没有target");
        [self stopLoading];
    }
}

#pragma mark - setter方法
- (void)setReladImage:(UIImage *)reladImage
{
    if (!reladImage) {
        return;
    }
    _reladImage = reladImage;
    CGSize size = reladImage.size;
    _reloadImageView.image = _reladImage;
    _reloadImageView.center = _bgButton.center;
    _reloadImageView.bounds = CGRectMake(0, 0, size.width, size.height);
    
//    _reloadImageView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2-20);
}

- (void)setCircleColor:(UIColor *)color
{
    [_loadingPanel setDefaultColor:color];
}

@end
