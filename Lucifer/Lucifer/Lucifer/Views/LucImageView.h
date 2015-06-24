//
//  ACustomImageView.h
//  News
//
//  Created by WangZhaoYun on 14/12/31.
//  Copyright (c) 2014年 wallstreetcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LucImageView : UIImageView
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
- (id)initWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;
@end
