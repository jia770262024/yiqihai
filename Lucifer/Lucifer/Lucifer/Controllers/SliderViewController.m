//
//  SliderViewController.m
//  SliderTabbar
//
//  Created by wallstreetcn on 14-3-20.
//  Copyright (c) 2014年 wallstreetcn. All rights reserved.
//
#import "LucConstant.h"
#define kTagBgView     200
#define kTagLb         1000
#define kTagButton     2000
#define kTagContentView     3000
#define kTopSegmentBarHeight 37
#define kIndictorHeight 3
#define kTitleFont [UIFont boldSystemFontOfSize:20.0f]
#define kTopSegmentBGColor [UIColor whiteColor]
#define kTitleColorN [UIColor blackColor]
#define kTitleColorH [UIColor colorWithRed:178.0/255.0 green:203.0/255.0 blue:57.0/255.0 alpha:0.75]
#define kIndicatorColor [UIColor colorWithRed:178.0/255.0 green:203.0/255.0 blue:57.0/255.0 alpha:0.75]
#define kSpace 30.0f
#define kbgcolor kColourWithRGB(206, 206, 204)
#pragma mark - custom button

#import "SliderViewController.h"

@interface SliderViewController ()
{
    UIView *_titleView;
    UIScrollView *_contentScroll;
    NSMutableArray *_titleArray;
    int _selectedIndex;
    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeRight;
    UIImageView *_topBar;
}
@end

@implementation SliderViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadModels];
    [self drawSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLeftButton:(UIButton *)leftButton
{
    _leftButton = leftButton;
    _leftButton.frame = CGRectMake(10, 20, 80, kVIEW_H(_topBar)-20);
    [_topBar addSubview:_leftButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self doViewAppear:_selectedIndex];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self doViewDisappear:_selectedIndex];
}
#pragma mark - init methods
//数据源初始化
- (void)loadModels
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleArrayForViewPager:)])
    {
        if ([self.dataSource titleArrayForViewPager:self])
        {
            if (!_titleArray) {
                _titleArray = [[NSMutableArray alloc]init];
            }
            [_titleArray removeAllObjects];
            [_titleArray addObjectsFromArray:[self.dataSource titleArrayForViewPager:self]];
        }
    }
}

//初始化UI界面
- (void)drawSubviews
{
    _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    CGRect topbarRect = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(frameForTopbar)])
    {
        topbarRect = [self.dataSource frameForTopbar];
    }
    _topBar = [[UIImageView alloc]initWithFrame:topbarRect];
    UIColor *tit = kColourWithRGB(28, 30, 35);
    _topBar.backgroundColor = tit;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(30, kVIEW_H(_topBar)-2, kVIEW_W(_topBar)-60, 1)];
    line.tag = 56;
    line.backgroundColor = kbgcolor;
    [_topBar addSubview:line];
    [self.view addSubview:_topBar];
    [self resetTopBar];
    CGRect contentRect = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(frameForContentView)])
    {
        contentRect = [self.dataSource frameForContentView];
    }
    _contentScroll = [[UIScrollView alloc] initWithFrame:contentRect];
    _contentScroll.pagingEnabled = YES;
    _contentScroll.delegate = self;
    _contentScroll.backgroundColor = kCLEARCOLOR;
    [self.view addSubview:_contentScroll];
    for (int i = 0; i < [_titleArray count]; i++)
    {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(viewPager:viewForTabAtIndex:)])
        {
            UIView *view = [self.dataSource viewPager:self viewForTabAtIndex:i];
            if (!view)
            {
                view = [[UIView alloc]init];
            }
            view.tag = i + kTagContentView;
            view.frame = CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, kVIEW_H(_contentScroll));
            [_contentScroll addSubview:view];
        }
        else
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, kVIEW_H(_contentScroll))];
            view.tag = i + kTagContentView;
            [_contentScroll addSubview:view];
        }
    }
    _contentScroll.contentSize = CGSizeMake(kSCREEN_WIDTH*[_titleArray count], _contentScroll.frame.size.height);
    _contentScroll.showsHorizontalScrollIndicator = NO;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int i = scrollView.contentOffset.x/kSCREEN_WIDTH;
    if (i != _selectedIndex)
    {
        [self doViewDisappear:_selectedIndex];
        _selectedIndex = i;
        [self doViewAppear:_selectedIndex];
        [self resetTopBar];
    }
}


#pragma mark - private methods
//重置导航栏
- (void)resetTopBar
{
    for (UIView *view in _topBar.subviews) {
        if (view.tag == 56 || view == _leftButton) {
            
        } else {
            [view removeFromSuperview];
        }
    }
    if ([_titleArray objectAtIndex:_selectedIndex])
    {
        NSString *titleValue = [_titleArray objectAtIndex:_selectedIndex];
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kSCREEN_WIDTH, kVIEW_H(_topBar)-20)];
        titleView.backgroundColor = [UIColor clearColor];
        CGSize titleSize = [titleValue sizeWithFont:kTitleFont constrainedToSize:CGSizeMake(kVIEW_W(titleView), MAXFLOAT)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kVIEW_W(titleView)-titleSize.width)/2, 0, titleSize.width, kVIEW_H(titleView))];
        label.text = titleValue;
        label.font = kTitleFont;
        label.textColor = kColourWithRGB(114, 116, 118);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.shadowColor = [UIColor lightGrayColor];
        label.shadowOffset = CGSizeMake(0, 0.5);
        [titleView addSubview:label];
        [titleView addGestureRecognizer:_swipeRight];
        [titleView addGestureRecognizer:_swipeLeft];
        CGSize nomalSize = [@"天津贵金属交易所哈s" sizeWithFont:kTitleFont constrainedToSize:CGSizeMake(kVIEW_W(titleView), MAXFLOAT)];
        float buttonWidth = 44;
        if (_selectedIndex != 0) {
            UIButton *frontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            frontBtn.frame = CGRectMake((kVIEW_W(titleView)-nomalSize.width-2*buttonWidth)/2, 0, buttonWidth, kVIEW_H(titleView)-2);
            [frontBtn setImage:[UIImage imageNamed:@"navigate_left"] forState:UIControlStateNormal];
            frontBtn.showsTouchWhenHighlighted = YES;
            frontBtn.exclusiveTouch = YES;
            [frontBtn addTarget:self action:@selector(turnFront:) forControlEvents:UIControlEventTouchUpInside];
            [titleView addSubview:frontBtn];
        }
        if (_selectedIndex != _titleArray.count-1) {
            UIButton *nexnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nexnBtn.frame = CGRectMake(nomalSize.width+(kVIEW_W(titleView)-nomalSize.width)/2, 0, buttonWidth, kVIEW_H(titleView)-2);
//            [nexnBtn setBackgroundImage:[UIImage imageNamed:@"navigate_right"] forState:UIControlStateNormal];
            [nexnBtn setImage:[UIImage imageNamed:@"navigate_right"] forState:UIControlStateNormal];
            nexnBtn.showsTouchWhenHighlighted = YES;
            nexnBtn.exclusiveTouch = YES;
            [nexnBtn addTarget:self action:@selector(turnNext:) forControlEvents:UIControlEventTouchUpInside];
            [titleView addSubview:nexnBtn];
        }
        [_topBar addSubview:titleView];
        if (_leftButton) {
            [_topBar bringSubviewToFront:_leftButton];
        }
        _topBar.userInteractionEnabled = YES;
    }
}

//切换视图 （视图出现）
-(void)doViewAppear:(int)index
{
    UIView *view = [_contentScroll viewWithTag:index+kTagContentView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewPager:viewAppearAtIndex:forView:)]) {
        [self.delegate viewPager:self viewAppearAtIndex:index forView:view];
    }
}

//切换视图 （视图消失）
-(void)doViewDisappear:(int)index
{
    UIView *view = [_contentScroll viewWithTag:index+kTagContentView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewPager:viewDisappearAtIndex:forView:)]) {
        [self.delegate viewPager:self viewDisappearAtIndex:index forView:view];
    }
}

#pragma mark - action methods
//滑动手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        //左滑切换到下一条
        [self turnNext:nil];
    }
    else
    {
        //右划切换到上一条
        [self turnFront:nil];
    }
}

//切换到下一条
- (IBAction)turnNext:(id)sender
{
    if (_selectedIndex+1 < _titleArray.count)
    {
        [_contentScroll setContentOffset:CGPointMake((_selectedIndex+1)*kVIEW_W(_contentScroll), 0) animated:YES];
        [self doViewDisappear:_selectedIndex];
        _selectedIndex = _selectedIndex+1;
        [self doViewAppear:_selectedIndex];
        [self resetTopBar];
    }
}

//切换到上一条
- (IBAction)turnFront:(id)sender
{
    if (_selectedIndex-1 >= 0)
    {
        [_contentScroll setContentOffset:CGPointMake((_selectedIndex-1)*kVIEW_W(_contentScroll), 0) animated:YES];
        [self doViewDisappear:_selectedIndex];
        _selectedIndex = _selectedIndex-1;
        [self doViewAppear:_selectedIndex];
        [self resetTopBar];
    }
}

#pragma mark - public Methods
- (void)reloadDatas
{
    
}
@end
