//
//  HYSquareIndicatorView.m
//  HYSquareIndicator
//
//  Created by heyang on 16/3/14.
//  Copyright © 2016年 com.heyang. All rights reserved.
//

#define AnimationTime   0.2
#define SizeScale 0.1
#define kDotSize                CGSizeMake(0.4 * _bgGiew.frame.size.width, 0.4 * _bgGiew.frame.size.height)
#define LeftTopPosition         (CGPointMake(0, 0))
#define LeftTBottomPosition     (CGPointMake(0, 0.6 * _bgGiew.frame.size.height))
#define RightBottomPosition     (CGPointMake(0.6 * _bgGiew.frame.size.width, 0.6 * _bgGiew.frame.size.height))
#define RightTopPosition        (CGPointMake(0.6 * _bgGiew.frame.size.width, 0))
#define kDotColor               [UIColor colorWithRed:200/255.0 green:206/255.0 blue:221/255.0 alpha:1.0]

#import "HYSquareIndicatorView.h"

@interface HYSquareIndicatorView ()
@property (strong, nonatomic) UIView *dotView0,*dotView1,*dotView2;
@property (strong, nonatomic) NSArray *dotViews;
@property (assign, nonatomic) NSInteger dotIndex;
@property (strong, nonatomic) NSTimer *timer;
@property (strong,nonatomic) UIView *bgGiew;
/** color*/
@property (nonatomic,strong) NSArray *colors;
@end


@implementation HYSquareIndicatorView

/** once*/
+(HYSquareIndicatorView *)sharedManager
{
    static dispatch_once_t once;
    
    static HYSquareIndicatorView *sharedManager = nil;
    //dispatch_once函数的作用是在整个应用程序生命周期中只执行一次代码块的内容,而且还是线程同步的
    dispatch_once(&once,^{
        
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}


/** hiden*/
+ (void)dismiss{
    [[HYSquareIndicatorView sharedManager]showView:NO];
}

/** show*/
+(void)show
{
  [[UIApplication sharedApplication].keyWindow addSubview:[HYSquareIndicatorView sharedManager]] ;
    [[HYSquareIndicatorView sharedManager]showView:YES];
}

/** init*/
-(instancetype)init
{
    if(self = [super init]){
        
        /** background setting*/
        self.backgroundColor        = [UIColor clearColor];
        self.clipsToBounds          = YES;
        self.userInteractionEnabled = NO;
        self.frame                  = [UIApplication sharedApplication].keyWindow.frame;
       
        [self initView];
        
    }
    return self;
}

/** setting*/
- (void)initView
{
    
    /** set color */
    _colors                     = @[[UIColor colorWithRed:0 green:191/255.0 blue:255/255.0 alpha:1],[UIColor colorWithRed:44/255.0 green:66/255.0 blue:117/255.0 alpha:1],[UIColor colorWithRed:160/255.0 green:32/255.0 blue:240/255.0 alpha:1]];
    
    CGSize bounds               = [UIScreen mainScreen].bounds.size;
    
    _bgGiew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds.width * SizeScale, bounds.width * SizeScale)];
    _bgGiew.center                = [UIApplication sharedApplication].keyWindow.center;
    
    /** creat view*/
    _dotView0                 = [[UIView alloc]initWithFrame:(CGRect){CGPointMake(0.6 * _bgGiew.frame.size.width, 0.6 * _bgGiew.frame.size.height), kDotSize}];
    _dotView0.backgroundColor = _colors[0];
    [_bgGiew addSubview:_dotView0];

    _dotView1                 = [[UIView alloc]initWithFrame:(CGRect){CGPointMake(0, 0.6 * _bgGiew.frame.size.height), kDotSize}];
    _dotView1.backgroundColor = _colors[1];;
    [_bgGiew addSubview:_dotView1];

    _dotView2                 = [[UIView alloc]initWithFrame:(CGRect){LeftTopPosition, kDotSize}];
    _dotView2.backgroundColor = _colors[2];
    [_bgGiew addSubview:_dotView2];
    
    
    [self addSubview:_bgGiew];

    /** add array*/
    _dotViews                 = @[_dotView0, _dotView1, _dotView2];
    
    /** idx*/
    _dotIndex                 = 0;

    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bgGiew.frame.origin.x, CGRectGetMaxY(_bgGiew.frame)+ 5, self.frame.size.width, 20)];
    textLabel.text = @"加载中...";
    textLabel.textColor =[ UIColor darkGrayColor];
    textLabel.font = [UIFont systemFontOfSize:11.0];
    [self addSubview:textLabel];
    
}

/** repeat*/
-(void)showView:(BOOL)show
{
    if (show) {
        if (!_timer) {
            _timer=[NSTimer scheduledTimerWithTimeInterval:AnimationTime target:self selector:@selector(beginAnimation) userInfo:nil repeats:YES];
        }
    }
    else{
        [_timer invalidate];
        _timer = nil;
        [self removeFromSuperview ];
    }
}

/** start timer*/
-(void)beginAnimation
{
    [UIView animateWithDuration:AnimationTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        UIView *dotView = _dotViews[_dotIndex];
        [self moveDotViewToNextPosition:dotView];
        
        _dotIndex ++;
        _dotIndex = _dotIndex > 2 ? 0 : _dotIndex;
        
    } completion:nil];
}

/** move*/
-(void)moveDotViewToNextPosition:(UIView*)dotView
{
    if (CGPointEqualToPoint(dotView.frame.origin, LeftTopPosition)) {
        dotView.frame = (CGRect){LeftTBottomPosition, dotView.frame.size};
    }
    else if (CGPointEqualToPoint(dotView.frame.origin, LeftTBottomPosition)) {
        dotView.frame = (CGRect){RightBottomPosition, dotView.frame.size};
    }
    else if (CGPointEqualToPoint(dotView.frame.origin, RightBottomPosition)) {
        dotView.frame = (CGRect){RightTopPosition, dotView.frame.size};
    }
    else if (CGPointEqualToPoint(dotView.frame.origin, RightTopPosition)) {
        dotView.frame = (CGRect){LeftTopPosition, dotView.frame.size};
    }
}


@end
