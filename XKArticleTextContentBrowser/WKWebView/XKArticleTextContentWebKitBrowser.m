//
//  XKArticleTextContentWebBrowser.m
//  XKarticleTextContentWebKitBrowser
//
//  Created by ALLen、 LAS on 2019/2/15.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKArticleTextContentWebKitBrowser.h"
#import <WebKit/WebKit.h>

@interface XKArticleTextContentWebKitBrowser ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic,assign)BOOL isLandscape; //横屏
@property (nonatomic,strong)NSString * fileName;
@property (nonatomic,strong)WKWebView * webView;
@property (nonatomic,strong)MBProgressHUD * progressHUD;
@property (nonatomic,weak)UIViewController * superViewController;
@end

@implementation XKArticleTextContentWebKitBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.webView];
        [self addSubview:self.progressHUD];
        
        WeakSelf(ws);
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws);
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentWebKitBrowser:didDisplayOrientation:)]) {
                [self.delegate articleTextContentWebKitBrowser:self didDisplayOrientation:1];
            }
            [self.webView reload];
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentWebKitBrowser:didDisplayOrientation:)]) {
                [self.delegate articleTextContentWebKitBrowser:self didDisplayOrientation:2];
            }
            [self.webView reload];
        };
    }
}

//加载数据
- (void)reloadDatas:(NSString*)fileUrl{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!fileUrl.length) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentWebKitBrowser:didFinishLoadDataWithError:)]) {
                [self.delegate articleTextContentWebKitBrowser:self didFinishLoadDataWithError:YES];
            }
        }
        else{
            //文件名
            self.fileName = [XKFileDownloader createFileNameWithURL:fileUrl fileType:@"pdf"];
            
            if ([XKFileDownloader fileCacheExist:self.fileName]) {
                [self reloadfiles];
            }
            else{
                WeakSelf(ws);
                [self.progressHUD showAnimated:YES];
                [XKFileDownloader ResumeDownload:fileUrl fileName:self.fileName progress:^(NSProgress * _Nullable progress) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ws.progressHUD.progress = progress.completedUnitCount/progress.totalUnitCount;
                    });
                    
                } success:^(NSString * _Nullable filePath) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ws.progressHUD hideAnimated:YES];
                        [self reloadfiles];
                    
                    });
                    
                } failure:^(NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"文件下载失败,请稍后重试");
                        [ws.progressHUD hideAnimated:YES];
                        if (ws.delegate && [ws.delegate respondsToSelector:@selector(articleTextContentWebKitBrowser:didFinishLoadDataWithError:)]) {
                            [ws.delegate articleTextContentWebKitBrowser:self didFinishLoadDataWithError:YES];
                        }
                    });
                    
                }];
            }
        }

    });
}

//加载文件
- (void)reloadfiles{
    if (@available(iOS 9.0, *)) {
        [self.webView loadFileURL:[NSURL fileURLWithPath:[XKFileDownloader fileCacheDirPath:self.fileName]] allowingReadAccessToURL:[NSURL fileURLWithPath:[XKFileDownloader fileCacheDirPath:self.fileName]]];
    }
    else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[XKFileDownloader fileCacheDirPath:self.fileName]]]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentWebKitBrowser:didFinishLoadDataWithError:)]) {
        [self.delegate articleTextContentWebKitBrowser:self didFinishLoadDataWithError:NO];
    }
}

//滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if (distanceFromBottom < height) {
        NSLog(@"到底部了");
        if (self.delegate && [self.delegate respondsToSelector:@selector(articleContentWebKitBrowserDidScrollToBottom:)]) {
            [self.delegate articleContentWebKitBrowserDidScrollToBottom:self];
        }
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentWebKitBrowser:didFinishLoadDataWithError:)]) {
        [self.delegate articleTextContentWebKitBrowser:self didFinishLoadDataWithError:YES];
    }
}

#pragma mark - 懒加载
- (WKWebView*)webView{
    if (!_webView) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (MBProgressHUD*)progressHUD{
    if (!_progressHUD){
        _progressHUD = [[MBProgressHUD alloc] initWithFrame:self.bounds];
        _progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return _progressHUD;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
