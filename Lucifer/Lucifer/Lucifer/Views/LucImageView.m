//
//  ACustomImageView.m
//  News
//
//  Created by WangZhaoYun on 14/12/31.
//  Copyright (c) 2014年 wallstreetcn. All rights reserved.
//

#import "LucImageView.h"

@implementation LucImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    self = [super initWithFrame:frame];
    if (self) {
        self.target = target;
        self.selector = selector;
        self.userInteractionEnabled = YES;
    }
    return self;
}


///  添加点击响应事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.selector && [self.target respondsToSelector:self.selector]) {
        [self.target performSelector:self.selector withObject:self];
    }
}

@end
