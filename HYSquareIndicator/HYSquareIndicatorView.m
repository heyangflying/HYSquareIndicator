//
//  HYSquareIndicatorView.m
//  HYSquareIndicator
//
//  Created by heyang on 16/3/14.
//  Copyright © 2016年 com.heyang. All rights reserved.
//

#define AnimationTime   0.2
#define SizeScale 0.1
#define VIEWSIZE                CGSizeMake(0.4 * _bgGiew.frame.size.width, 0.4 * _bgGiew.frame.size.height)
#define LEFTTOPLOCATION         (CGPointMake(0, 0))
#define LEFTBOTTOMLOCATION     (CGPointMake(0, 0.6 * _bgGiew.frame.size.height))
#define RIGHTBOTTOMLOCATION     (CGPointMake(0.6 * _bgGiew.frame.size.width, 0.6 * _bgGiew.frame.size.height))
#define RIGHTTOPLOCATION        (CGPointMake(0.6 * _bgGiew.frame.size.width, 0))
#define kDotColor               [UIColor colorWithRed:200/255.0 green:206/255.0 blue:221/255.0 alpha:1.0]

#import "HYSquareIndicatorView.h"

@interface HYSquareIndicatorView ()
@property (strong, nonatomic) UIView *view0,*view1,*view2;
@property (strong, nonatomic) NSArray *views;
@property (assign, nonatomic) NSInteger viewIndex;
@property (strong, nonatomic) NSTimer *timer;
@property (strong,nonatomic) UIView *bgGiew;
@property (strong,nonatomic) UILabel *textLabel;
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
    [[HYSquareIndicatorView sharedManager]startAnimation:NO];
}

/** show*/
+(void)show
{
  [[UIApplication sharedApplication].keyWindow addSubview:[HYSquareIndicatorView sharedManager]] ;
    [[HYSquareIndicatorView sharedManager]startAnimation:YES];
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
    
    /** bgView*/
    _bgGiew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds.width * SizeScale, bounds.width * SizeScale)];
    _bgGiew.center                = [UIApplication sharedApplication].keyWindow.center;
    
    /** creat view*/
    _view0                 = [[UIView alloc]initWithFrame:(CGRect){CGPointMake(0.6 * _bgGiew.frame.size.width, 0.6 * _bgGiew.frame.size.height), VIEWSIZE}];
    _view0.backgroundColor = _colors[0];
    [_bgGiew addSubview:_view0];

    _view1                 = [[UIView alloc]initWithFrame:(CGRect){CGPointMake(0, 0.6 * _bgGiew.frame.size.height), VIEWSIZE}];
    _view1.backgroundColor = _colors[1];;
    [_bgGiew addSubview:_view1];

    _view2                 = [[UIView alloc]initWithFrame:(CGRect){LEFTTOPLOCATION, VIEWSIZE}];
    _view2.backgroundColor = _colors[2];
    [_bgGiew addSubview:_view2];
    
    
    [self addSubview:_bgGiew];

    /** add array*/
    _views                 = @[_view0, _view1, _view2];
    
    /** idx*/
    _viewIndex                 = 0;

    
    /** loading...*/
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bgGiew.frame.origin.x, CGRectGetMaxY(_bgGiew.frame)+ 5, self.frame.size.width, 20)];
    _textLabel.text = @"加载中...";
    _textLabel.textColor =[ UIColor darkGrayColor];
    _textLabel.font = [UIFont systemFontOfSize:11.0];
    [self addSubview:_textLabel];
    
}

/** repeat*/
-(void)startAnimation:(BOOL)start
{
    if (start) {
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
    /** view animation*/
    [UIView animateWithDuration:AnimationTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
       
        /** get current View*/
        UIView *view = _views[_viewIndex];
        
        /** move next */
        [self moveViewToNextLocation:view];
        
        /** idx ++*/
        _viewIndex ++;
        
        /** 0 1 2 0 1 2 ...*/
        _viewIndex = _viewIndex > 2 ? 0 : _viewIndex;
        
    } completion:nil];
}

/** move*/
-(void)moveViewToNextLocation:(UIView*)view
{
    if (CGPointEqualToPoint(view.frame.origin, LEFTTOPLOCATION)) {
        view.frame = (CGRect){LEFTBOTTOMLOCATION, view.frame.size};
    }
    else if (CGPointEqualToPoint(view.frame.origin, LEFTBOTTOMLOCATION)) {
        view.frame = (CGRect){RIGHTBOTTOMLOCATION, view.frame.size};
    }
    else if (CGPointEqualToPoint(view.frame.origin, RIGHTBOTTOMLOCATION)) {
        view.frame = (CGRect){RIGHTTOPLOCATION, view.frame.size};
    }
    else if (CGPointEqualToPoint(view.frame.origin, RIGHTTOPLOCATION)) {
        view.frame = (CGRect){LEFTTOPLOCATION, view.frame.size};
    }
}


@end
