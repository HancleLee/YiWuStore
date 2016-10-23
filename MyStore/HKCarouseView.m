//
//  HKCarouseView.m
//  MyStore
//
//  Created by Hancle on 16/7/6.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "HKCarouseView.h"
#import "iCarousel.h"

#define kCorouselTime 5

@interface HKCarouseView () <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) iCarousel *carouselView;
@property (nonatomic, strong) UIPageControl *pageCtr;
@property (nonatomic, strong) NSArray *images;  // 轮播图数组
@property (nonatomic, strong) NSTimer *timer;   // 定时器

@end

@implementation HKCarouseView
#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

+ (instancetype)carouseViewWith:(CGRect)frame images:(NSArray *)images {
    HKCarouseView *view = [[HKCarouseView alloc] initWithFrame:frame];
    if (view) {
        view.images = images;
        [view creatUI];
        [view setupTimer];
    }
    return view;
}

#pragma mark - 
/**
 *  创建UI
 */
- (void)creatUI {
    self.carouselView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
    self.carouselView.type = iCarouselTypeRotary;
    self.carouselView.delegate = self;
    self.carouselView.dataSource = self;
    self.carouselView.clipsToBounds = YES;
    self.carouselView.pagingEnabled = YES;
    [self addSubview:self.carouselView];
    
    [self addPageCtr];
}

- (void)addPageCtr {
    self.pageCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.carouselView.frame.size.height - 20, ScreenWidth, 10)];
    self.pageCtr.backgroundColor = ClearColor;
    self.pageCtr.numberOfPages = self.images.count;
    self.pageCtr.userInteractionEnabled = NO;
    self.pageCtr.currentPageIndicatorTintColor = RGBColor(242, 54, 76);
    self.pageCtr.pageIndicatorTintColor = WhiteColor;
    [self addSubview:self.pageCtr];
}

/**
 *  设置timer
 */
- (void)setupTimer {
    [self deleteTimer];
    self.timer = [NSTimer timerWithTimeInterval:kCorouselTime target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

/**
 *   删除timer
 */
- (void)deleteTimer {
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  timer通知事件
 */
- (void)timerChanged {
    if (self.images.count > 0) {
        NSInteger page = (self.pageCtr.currentPage + 1) % self.images.count;
        self.pageCtr.currentPage = page;
        [self pageChanged:self.pageCtr];
    }
}

/**
 *  切换图片
 *
 *  @param pageCtrol page控制器
 */
- (void)pageChanged:(UIPageControl *)pageCtrol {
    [self.carouselView scrollToItemAtIndex:pageCtrol.currentPage animated:YES];
}

#pragma mark - iCarouselDataSource/iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.images.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, carousel.frame.size.height)];
        if (index < _images.count) {
            id item = _images[index];
            if ([item isKindOfClass:[NSString class]]) {
                [(UIImageView *)view sd_setImageWithURL:[NSURL URLWithString:item]];
            }else if([item isKindOfClass:[UIImage class]]) {
                [(UIImageView *)view setImage:item];
            }else if ([item isKindOfClass:[NSURL class]]) {
                [(UIImageView *)view sd_setImageWithURL:item];
            }
        }
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionSpacing) {
        return value * 1.1;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if (index < _images.count) {
//        id item = _images[index];
//        if ([item isKindOfClass:[NSString class]]) {
////            [self.delegate selectedAdViewAt:index url:item];
//        }
        if ([self.delegate respondsToSelector:@selector(selectedAdViewAtIndex:view:)]) {
            [self.delegate selectedAdViewAtIndex:index view:self];
        }
    }
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel {
    
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate  {
    
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel {
    self.pageCtr.currentPage = carousel.currentItemIndex;
    [self setupTimer];
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    [self deleteTimer];
}

@end
