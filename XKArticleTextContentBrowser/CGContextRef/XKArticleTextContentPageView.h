//
//  XKArticleTextContentPageView.h
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/16.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKArticleTextContentPageView : UIView
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)CGPDFDocumentRef pdfDocumentRef;
@end

NS_ASSUME_NONNULL_END
