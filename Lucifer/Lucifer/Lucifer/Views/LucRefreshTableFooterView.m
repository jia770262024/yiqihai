//
//  LoadMoreView.m
//  WSCNNewsReader
//
//  Created by wallstreetcn on 13-12-25.
//  Copyright (c) 2013年 wallstreetcn. All rights reserved.
//

#import "LucRefreshTableFooterView.h"
#define kLABELFONT  [UIFont systemFontOfSize:14]
#define kLABELCOLORN [UIColor darkGrayColor]
#define kLABELCOLORLOAD [UIColor lightGrayColor]
//get the left top origin's x,y of a view
#define kVIEW_TX(view) (view.frame.origin.x)
#define kVIEW_TY(view) (view.frame.origin.y)

//get the width size of the view:width,height
#define kVIEW_W(view)  (view.frame.size.width)
#define kVIEW_H(view)  (view.frame.size.height)

//get the right bottom origin's x,y of a view
#define kVIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define kVIEW_BY(view) (view.frame.origin.y + view.frame.size.height )

//get the x,y of the frame
#define kFRAME_TX(frame)  (frame.origin.x)
#define kFRAME_TY(frame)  (frame.origin.y)
//get the size of the frame
#define kFRAME_W(frame)  (frame.size.width)
#define kFRAME_H(frame)  (frame.size.height)

#define kVIEW_W1(view)  (view.bounds.size.width)
#define kVIEW_H1(view)  (view.bounds.size.height)
static NSString *LUCLoadViewStateLoadingValue = @"加载中...";
//static NSString *LUCLoadViewStateTapLoadValue = @"上拉加载更多...";
static NSString *LUCLoadViewStateNoMoreValue = @"没有更多内容了...";

@implementation LucRefreshTableFooterView
@synthesize isLoading;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _LUCLoadViewStateTapLoadValue = @"上拉加载更多...";
        self.frame = frame;
        [self loadModel];
        [self drawView];
    }
    return self;
}

//-(void)dealloc
//{
//    [self removeNoti];
//}

- (void)setLUCLoadViewStateTapLoadValue:(NSString *)LUCLoadViewStateTapLoadValue {
    _LUCLoadViewStateTapLoadValue = LUCLoadViewStateTapLoadValue;
    if (_loadingLabel) {
        [_loadingLabel removeFromSuperview];
    }
    if (_loadingView) {
        [_loadingView removeFromSuperview];
    }
    [self loadModel];
    [self drawView];
}


#pragma mark - init methods
- (void)loadModel
{
    self.isLoading = NO;
    _labelColor = [UIColor darkGrayColor];
    _bgcolor = [UIColor clearColor];
}

- (void)drawView
{
    self.userInteractionEnabled = YES;
    CGSize sizeTapLoadLabel = [LucRefreshTableFooterView sizeWithString:_LUCLoadViewStateTapLoadValue font:kLABELFONT constraintSize:CGSizeMake(kVIEW_W(self), kVIEW_H(self))];
    self.backgroundColor = _bgcolor;
    //添加状态标签
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((kVIEW_W(self)-sizeTapLoadLabel.width)/2, (kVIEW_H(self)-sizeTapLoadLabel.height)/2, sizeTapLoadLabel.width, sizeTapLoadLabel.height)];
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.font = kLABELFONT;
    _loadingLabel.textColor = _labelColor;
    [self addSubview:_loadingLabel];
    //进度指示器
    _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize size = [_loadingView sizeThatFits:CGSizeZero];
    _loadingView.hidesWhenStopped = YES;
    _loadingView.frame = CGRectMake(kVIEW_TX(_loadingLabel)-size.width-3, (kVIEW_H(self)-size.height)/2, size.width, size.height);
    [self addSubview:_loadingView];
    [self setViewState:LUCLoadViewStateClickable];
    _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

#pragma mark - public method
//设置当前的状态
-(void)setViewState:(LUCLoadViewState)state
{
    CGSize sizeLoadLabel = CGSizeZero;
    switch (state) {
        case LUCLoadViewStateClickable:
            sizeLoadLabel = [LucRefreshTableFooterView sizeWithString:_LUCLoadViewStateTapLoadValue font:kLABELFONT constraintSize:CGSizeMake(kVIEW_W(self), kVIEW_H(self))];
            _loadingLabel.text = _LUCLoadViewStateTapLoadValue;
            _loadingLabel.textColor = _labelColor;
            [_loadingView stopAnimating];
            self.isComplete = NO;
            self.isLoading = NO;
            break;
        case LUCLoadViewStateLoading:
            sizeLoadLabel = [LucRefreshTableFooterView sizeWithString:LUCLoadViewStateLoadingValue font:kLABELFONT constraintSize:CGSizeMake(kVIEW_W(self), kVIEW_H(self))];
            _loadingLabel.text = LUCLoadViewStateLoadingValue;
            [_loadingView startAnimating];
            self.isComplete = NO;
            self.isLoading = YES;
            break;
        case LUCLoadViewStateNoMore:
            sizeLoadLabel = [LucRefreshTableFooterView sizeWithString:LUCLoadViewStateNoMoreValue font:kLABELFONT constraintSize:CGSizeMake(kVIEW_W(self), kVIEW_H(self))];
            _loadingLabel.text = LUCLoadViewStateNoMoreValue;
            [_loadingView stopAnimating];
            self.isComplete = YES;
            self.isLoading = NO;
            break;
        default:
            break;
    }
    _loadingLabel.frame = CGRectMake((kVIEW_W(self)-sizeLoadLabel.width)/2, (kVIEW_H(self)-sizeLoadLabel.height)/2, sizeLoadLabel.width, sizeLoadLabel.height);
    CGSize size = [_loadingView sizeThatFits:CGSizeZero];
    _loadingView.frame = CGRectMake(kVIEW_TX(_loadingLabel)-size.width-3, (kVIEW_H(self)-size.height)/2, size.width, size.height);
}

- (void)setFooterBackgroundColor:(UIColor *)bgColor
{
    _bgcolor = bgColor;
    [self setBackgroundColor:bgColor];
}
- (void)setFooterLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    _loadingLabel.textColor = _labelColor;
}

- (void)setFooterIndicatoerStyle:(UIActivityIndicatorViewStyle )style
{
    _loadingView.activityIndicatorViewStyle = style;
}

//计算text size
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize
{
    if (!string) {
        return CGSizeZero;
    }
    CGSize stringSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0) {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        CGRect stringRect = [string boundingRectWithSize:constraintSize options:options attributes:attributes context:NULL];
        stringSize = stringRect.size;
    } else {
        stringSize = [string sizeWithFont:font constrainedToSize:constraintSize];
        stringSize.height += font.lineHeight;
    }
    return stringSize;
}


@end
