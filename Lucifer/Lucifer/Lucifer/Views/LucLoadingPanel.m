//
//  LoadingPanel.m
//  三个点动画
//
//  Created by wallstreetcn on 14-10-29.
//  Copyright (c) 2014年 WallStreetcn. All rights reserved.
//

#import "LucLoadingPanel.h"

@implementation LucLoadingPanel

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}


- (void)setupDefaults
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _circlesArr = [NSMutableArray new];
    self.internalSpacing = 4;
    self.radius = 4;
    self.delay = 0.2;
    self.duration = 0.5;
    self.defaultColor = [UIColor blueColor];
    self.maxCirclesNumber = 3;
}

- (void)addACircle
{
    if (_circlesArr.count+1 > _maxCirclesNumber) {
        return;
    }
    UIView *aCircle = [self createCircleWithRadius:self.radius color:_defaultColor positionX:(_circlesArr.count * ((2 * self.radius) + self.internalSpacing))];
    [self addSubview:aCircle];
//    CGFloat f = _circlesArr.count/_maxCirclesNumber;
    [_circlesArr addObject:aCircle];
    [UIView animateWithDuration:.3 animations:^{
        aCircle.frame = CGRectMake((_circlesArr.count * ((2 * self.radius) + self.internalSpacing)), 0, self.radius * 2, self.radius * 2);
        if (_circlesArr.count == 2) {
            aCircle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
        } else if (_circlesArr.count == 3) {
            aCircle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
        }
        [self adjustFrame];
    }];
}

- (void)removeACircle
{
    if (_circlesArr.count > 0) {
        UIView *circle = _circlesArr.lastObject;
        [_circlesArr removeObject:circle];
        [UIView animateWithDuration:.3 animations:^{
            CGRect rect = circle.frame;
            rect.origin.y = -75;
            circle.frame = rect;
        } completion:^(BOOL finished) {
            [circle removeFromSuperview];
//            [self adjustFrame];
        }];
    }
}

- (void)removeAllCircles
{
    for (int i = 0; i <_circlesArr.count; i++) {
        [self removeACircle];
    }
}

- (UIView *)createCircleWithRadius:(CGFloat)radius
                             color:(UIColor *)color
                         positionX:(CGFloat)x
{
    radius = radius;
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(x, -90, radius * 2, radius * 2)];
    circle.backgroundColor = color;
    circle.layer.cornerRadius = radius;
    circle.translatesAutoresizingMaskIntoConstraints = NO;
    return circle;
}

- (CABasicAnimation *)createSigleAnimationWithDuration:(CGFloat)duration withIndex:(int)index
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.fromValue = [NSNumber numberWithFloat:1.f];
    anim.toValue = [NSNumber numberWithFloat:index/_maxCirclesNumber];
    anim.duration = duration;
    anim.removedOnCompletion = YES;
    anim.beginTime = CACurrentMediaTime();
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fillMode = kCAFillModeBoth;
    return anim;
}

- (CABasicAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.delegate = self;
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.toValue = [NSNumber numberWithFloat:1.0f];
    anim.autoreverses = YES;
    anim.duration = duration;
    anim.removedOnCompletion = NO;
    anim.beginTime = CACurrentMediaTime()+delay;
    anim.repeatCount = INFINITY;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fillMode = kCAFillModeBoth;
    return anim;
}

//开始动画
- (void)doAnimation
{
    for (int i = 0; i < _circlesArr.count; i++) {
        UIView *circle = _circlesArr[i];
        [circle.layer removeAllAnimations];
        [circle.layer addAnimation:[self createAnimationWithDuration:self.duration delay:(i * self.delay)] forKey:@"scale"];
    }
}

//结束动画
- (void)stopAnimation
{
    for (int i = 0; i < _circlesArr.count; i++) {
        UIView *circle = _circlesArr[i];
        [circle.layer removeAllAnimations];
    }
}

- (void)keepNumber:(int)number
{
    if (number == 0 || number < 0) {
        for (int i = 0; i < _circlesArr.count; i++) {
            UIView *circle = _circlesArr[i];
            [circle removeFromSuperview];
        }
         [_circlesArr removeAllObjects];
        return;
    }
    else if (_circlesArr.count < number) {
        for (int i = (int)_circlesArr.count; i < number; i++) {
            [self addACircle];
        }
    }
    else if (_circlesArr.count > number) {
        for (int i = number; i < _circlesArr.count; i++) {
            [self removeACircle];
        }
    }
}

- (void)setOffsetY:(CGFloat)offsetY
{
    _offsetY = offsetY;
    float per = 65 / _maxCirclesNumber;
    if (_offsetY < per) {
        
        [self keepNumber:1];
    }
    else if (_offsetY < per*2) {
        
        [self keepNumber:2];
    }
    else if(_offsetY < per*3) {
        
        [self keepNumber:3];
    }
    else {
        NSLog(@"超出啦");
    }
}

- (void)adjustFrame
{
    CGRect frame = self.bounds;
    frame.size.width = (_circlesArr.count * ((2 * self.radius) + self.internalSpacing)) - self.internalSpacing;
    frame.size.height = self.radius * 2;
    self.bounds = frame;
    for (int i = 0; i < _circlesArr.count; i++) {
        UIView *circle = _circlesArr[i];
        CGRect rect = circle.frame;
        rect.origin.x = (i * ((2 * self.radius) + self.internalSpacing));
        circle.frame = rect;
    }
}

- (void)setDefaultColor:(UIColor *)defaultColor
{
    _defaultColor = defaultColor;
    for (int i = 0; i < _circlesArr.count; i++) {
        UIView *circle = _circlesArr[i];
        [circle setBackgroundColor:defaultColor];
    }
}



- (void)doAutoPullDown
{
    float per = 65 / _maxCirclesNumber;
    self.offsetY = 3*per - 1;
}


//开始页面加载动画
- (void)doPageLoadingAnimation
{
    [self stopPageLoadingAnimation];
    //添加3个点
    [self keepNumber:3];
    [self doAnimation];
}

- (void)stopPageLoadingAnimation
{
    [self stopAnimation];
    
    for (UIView *circle in _circlesArr) {
        [circle removeFromSuperview];
    }
    [_circlesArr removeAllObjects];
    
}

@end
