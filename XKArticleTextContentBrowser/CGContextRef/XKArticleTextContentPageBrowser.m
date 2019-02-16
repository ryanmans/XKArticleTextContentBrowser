//
//  XKArticleTextContentPageBrowser.m
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/16.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKArticleTextContentPageBrowser.h"
#import "XKArticleTextContentPageViewController.h"

@interface XKArticleTextContentPageBrowser ()<UIPageViewControllerDataSource>
@property (nonatomic,assign)BOOL isLandscape; //横屏
@property (nonatomic,strong)NSString * fileName;
@property (nonatomic,strong)NSMutableArray * controllerArrs;
@property (nonatomic,weak)UIViewController * superViewController;
@property (nonatomic,strong)UIPageViewController * previewController;
@property (nonatomic,strong)MBProgressHUD * progressHUD;
@property (nonatomic,strong)UILabel * pageLabel;
@property (nonatomic,strong)UIView * pageView;
@end


@implementation XKArticleTextContentPageBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.previewController.view];
        [self addSubview:self.pageView];
        [self.pageView addSubview:self.pageLabel];
        [self addSubview:self.progressHUD];
        
        WeakSelf(ws);
        [self.previewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws);
        }];
        
        [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws).offset(16);
            make.top.equalTo(ws).offset(30);
            make.height.mas_equalTo(36);
        }];
        
        [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.pageView).offset(12);
            make.top.equalTo(ws.pageView);
            make.height.equalTo(ws.pageView);
            make.right.equalTo(ws.pageView).offset(-12);
        }];
        
        [self.progressHUD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws);
        }];
        
        [self layoutIfNeeded];
        
        //设置监听设备旋转的通知
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChangeEvent:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

//展现内容文章
- (void)showTrainArticleBrowserIn:(UIViewController*)viewController{
    if (viewController) {
        _superViewController = viewController;
        [viewController.view addSubview:self];
    }
}

//监听设备旋转的通知
- (void)onDeviceOrientationDidChangeEvent:(NSNotification*)noti{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    //竖屏
    if (orientation == UIDeviceOrientationPortrait) [self onDeviceOrientationPortraitEvent];
    else if (orientation == UIDeviceOrientationLandscapeLeft)[self onDeviceOrientationLandscapeLeftEvent]; //横屏
}

//竖屏
- (void)onDeviceOrientationPortraitEvent{
    if(_isLandscape && _superViewController){
        if (_superViewController.navigationController.visibleViewController == _superViewController) {
            _isLandscape = NO;
            if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            [_superViewController.navigationController setNavigationBarHidden:NO animated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentBrowser:didDisplayOrientation:)]) {
                [self.delegate articleTextContentBrowser:self didDisplayOrientation:1];
            }
        };
    }
}

//横屏
- (void)onDeviceOrientationLandscapeLeftEvent{
    if(!_isLandscape && _superViewController){
        if (_superViewController.navigationController.visibleViewController == _superViewController) {
            _isLandscape = YES;
            if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [_superViewController.navigationController setNavigationBarHidden:YES animated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentBrowser:didDisplayOrientation:)]) {
                [self.delegate articleTextContentBrowser:self didDisplayOrientation:2];
            }
        };
    }
}

//横竖屏大小调整
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self reloadDisplayControllers];
}

//加载数据
- (void)reloadDatas:(NSString*)fileUrl{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!fileUrl.length) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentBrowser:didFinishLoadData:)]) {
                [self.delegate articleTextContentBrowser:self didFinishLoadData:YES];
            }
        }
        else{
            
            //文件名
            self.fileName = [XKFileDownloader createFileNameWithURL:fileUrl fileType:@"pdf"];
            if ([XKFileDownloader fileCacheExist:self.fileName]) {
                [self showTrainArticleData];

            }else{
                WeakSelf(ws);
                [self.progressHUD showAnimated:YES];
                [XKFileDownloader ResumeDownload:fileUrl fileName:self.fileName progress:^(NSProgress * _Nullable progress) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ws.progressHUD.progress = progress.completedUnitCount/progress.totalUnitCount;
                    });
                    
                } success:^(NSString * _Nullable filePath) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ws.progressHUD hideAnimated:YES];
                        [ws showTrainArticleData];
                    });
                    
                } failure:^(NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"文件下载失败,请稍后重试");
                        [ws.progressHUD hideAnimated:YES];
                        if (ws.delegate && [ws.delegate respondsToSelector:@selector(articleTextContentBrowser:didFinishLoadData:)]) {
                            [ws.delegate articleTextContentBrowser:self didFinishLoadData:YES];
                        }
                    });
                    
                }];
            }
        }
        
    });
}

//展现内容
- (void)showTrainArticleData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //文件解析
        CFURLRef pdfURL = (__bridge_retained CFURLRef)[NSURL fileURLWithPath:[XKFileDownloader fileCacheDirPath:self.fileName]];
        CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        CFRelease(pdfURL);
        NSInteger total = CGPDFDocumentGetNumberOfPages(pdfDocument);
        self.controllerArrs = [NSMutableArray array];

        WeakSelf(ws);
        @synchronized (self.controllerArrs) {
            if (total > 0) {
                for (NSInteger index = 0 ; index < total; index ++) {
                    XKArticleTextContentPageViewController * vc = [XKArticleTextContentPageViewController new];
                    vc.page = index + 1;
                    vc.pdfDocumentRef = pdfDocument;
                    vc.onArticleTextContentPageNumBlock = ^(NSInteger page) {
                        [ws scrollPageViewControllerAtIndex:page];
                    };
                    [self.controllerArrs addObject:vc];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadDisplayControllers];
                    [self.previewController setViewControllers:@[self.controllerArrs.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                    if (ws.delegate && [ws.delegate respondsToSelector:@selector(articleTextContentBrowser:didFinishLoadData:)]) {
                        [ws.delegate articleTextContentBrowser:self didFinishLoadData:NO];
                    }
                });
            }
        }
    });
}

//重载显示的控制器
- (void)reloadDisplayControllers{
    [self.controllerArrs enumerateObjectsUsingBlock:^(XKArticleTextContentPageViewController*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = self.bounds;
        [obj reloadDatas];
    }];
}

#pragma mark - UIPageViewControllerDataSource
//获取页面
- (UIViewController*)pageViewControllerAtIndex:(NSInteger)index{
    return [self.controllerArrs objectAtIndex:index];;
}

//滚动页面
- (void)scrollPageViewControllerAtIndex:(NSInteger)index{
    self.pageView.hidden = NO;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %ld",(unsigned long)index,(unsigned long)self.controllerArrs.count];
    if (index == self.controllerArrs.count) {
        NSLog(@"阅读完成", nil);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentBrowser:scrollToContentViewAtIndex:scrollCompleted:)]) {
        [self.delegate articleTextContentBrowser:self scrollToContentViewAtIndex:index scrollCompleted:index == self.controllerArrs.count];
    }
}

//翻到上一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [_controllerArrs indexOfObject:viewController];
    if (index == 0) return nil;
    index --;
    return [self pageViewControllerAtIndex:index];
}

//翻到下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [_controllerArrs indexOfObject:viewController];
    if (index == _controllerArrs.count - 1) return nil;
    index ++;
    return [self pageViewControllerAtIndex:index];
}

#pragma mark -懒加载
- (UIPageViewController *)previewController{
    if (!_previewController) {
        _previewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                             navigationOrientation:UIPageViewControllerNavigationOrientationVertical
                                                                           options:@{UIPageViewControllerOptionInterPageSpacingKey:@(UIPageViewControllerSpineLocationMin)}];
        _previewController.dataSource = self;
    }
    return _previewController;
}

- (UIView *)pageView{
    if (!_pageView) {
        _pageView = [UIView new];
        _pageView.hidden = YES;
        _pageView.layer.masksToBounds = YES;
        _pageView.layer.cornerRadius = 6;
        _pageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _pageView;
}

- (UILabel *)pageLabel{
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.font = [UIFont boldSystemFontOfSize:14];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageLabel;
}

- (MBProgressHUD*)progressHUD{
    if (!_progressHUD){
        _progressHUD = [[MBProgressHUD alloc] initWithFrame:self.bounds];
        _progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return _progressHUD;
}

@end
