//
//  ViewController.m
//  0329图片轮播器
//
//  Created by LE on 14/12/29.
//  Copyright (c) 2014年 LE. All rights reserved.
//
#define imageCount 5
#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    
    //读取图片
    for (int i = 0;i < imageCount; i++) {
        CGFloat imageX = i * imageW;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_0%d",i + 1]];
        [self.scrollView addSubview:imageView];
    }
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(imageCount * imageW, imageH);
    //取消水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //设置分页
    self.scrollView.pagingEnabled = YES;
    //总页数
    self.pageControl.numberOfPages = imageCount;
    //定时器
    [self addTiemer];
    
}

/**
 *  添加定时器
 */
-(void) addTiemer{
   self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPicture) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
/**
 *  删除定时器
 */
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  下一张图片
 */
-(void) nextPicture{
    int pageNum = 0;
    //根据当前页码判断下一个页码
    if (self.pageControl.currentPage != imageCount - 1) {
        pageNum = self.pageControl.currentPage + 1;
    }
    //设置当前图片页码
    self.pageControl.currentPage = pageNum;
    //显示滚动显示下一个图片
    CGFloat offSetX = self.scrollView.frame.size.width * pageNum;
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}
/**
 *  开始拖动
 */
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

/**
 *  拖动结束
 */
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTiemer];
}

/**
 *  监听正在滚动的方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //图片滚动超过一半时，当前页码为下一页
    CGFloat offSetX = scrollView.contentOffset.x ;
    CGFloat scrollViewW = scrollView.frame.size.width;
    self.pageControl.currentPage = (offSetX + scrollViewW * 0.5) / scrollViewW;
}

@end
