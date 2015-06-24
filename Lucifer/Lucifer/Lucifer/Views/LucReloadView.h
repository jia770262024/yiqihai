//
//  LucReloadView.h
//  News
//
//  Created by wallstreetcn on 14-11-1.
//  Copyright (c) 2014年 wallstreetcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LucLoadingPanel.h"

@interface LucReloadView : UIView
{
    UIButton *_bgButton;
    UIImageView *_reloadImageView;
    LucLoadingPanel *_loadingPanel;
    UIView *_loadView;
    UIView *_reloadView;
}

@property (weak, nonatomic) id target;
@property (strong, nonatomic) UIImage *reladImage;

- (id)initWithFrame:(CGRect)frame forTarget:(id)obj;
- (void)startLoading;
- (void)stopLoading;
- (void)completeLoading;
- (void)setCircleColor:(UIColor *)color;
@end
