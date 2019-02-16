//
//  XKArticleTextContentQuickLookBrowser.m
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/15.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "XKArticleTextContentQuickLookBrowser.h"
#import <QuickLook/QuickLook.h>

@interface XKArticleTextContentQuickLookBrowser ()<QLPreviewControllerDataSource>
@property (nonatomic,assign)BOOL isLandscape; //横屏
@property (nonatomic,strong)NSString * fileName;
@property (nonatomic,weak)UIViewController * superViewController;
@property (nonatomic,strong)MBProgressHUD * progressHUD;
@property (nonatomic,strong)QLPreviewController * previewController;
@end

@implementation XKArticleTextContentQuickLookBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.previewController.view];
        [self addSubview:self.progressHUD];
        
        WeakSelf(ws);
        [self.previewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
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
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) [viewController addChildViewController:self.previewController];
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
            [self.previewController reloadData];
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
            [self.previewController reloadData];
        };
    }
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
                [self.previewController reloadData];
                if (self.delegate && [self.delegate respondsToSelector:@selector(articleTextContentBrowser:didFinishLoadData:)]) {
                    [self.delegate articleTextContentBrowser:self didFinishLoadData:NO];
                }
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
                        [ws.previewController reloadData];
                        if (ws.delegate && [ws.delegate respondsToSelector:@selector(articleTextContentBrowser:didFinishLoadData:)]) {
                            [ws.delegate articleTextContentBrowser:self didFinishLoadData:NO];
                        }
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

#pragma mark - QLPreviewControllerDelegate

//文件个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

//要加载显示的文件
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return  [XKFileDownloader fileCacheExist:_fileName] ? [NSURL fileURLWithPath:[XKFileDownloader fileCacheDirPath:_fileName]] : nil;
}

#pragma mark - 懒加载
- (QLPreviewController*)previewController{
    if (!_previewController) {
        _previewController = [QLPreviewController new];
        _previewController.view.frame = self.bounds;
        _previewController.dataSource = self;
    }
    return _previewController;
}

- (MBProgressHUD*)progressHUD{
    if (!_progressHUD){
        _progressHUD = [[MBProgressHUD alloc] initWithFrame:self.bounds];
        _progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return _progressHUD;
}

- (void)dealloc{
    _previewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
