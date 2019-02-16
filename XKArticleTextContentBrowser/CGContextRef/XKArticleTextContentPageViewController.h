//
//  XKArticleTextContentPageViewController.h
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/16.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKArticleTextContentPageViewController : UIViewController
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)CGPDFDocumentRef pdfDocumentRef;
@property (nonatomic,copy)void(^onArticleTextContentPageNumBlock) (NSInteger page);

- (void)reloadDatas;
@end

NS_ASSUME_NONNULL_END
