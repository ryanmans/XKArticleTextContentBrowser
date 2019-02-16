//
//  ViewController.m
//  XKArticleTextContentBrowser
//
//  Created by ALLen、 LAS on 2019/2/14.
//  Copyright © 2019年 ALLen、 LAS. All rights reserved.
//

#import "ViewController.h"
#import "XKArticleTextContentWebViewController.h"
#import "XKArticleTextContentQuickLookViewController.h"
#import "XKArticleTextContentPagePdfViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    WeakSelf(ws);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    
    [self.view layoutIfNeeded];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentity = @"UITableViewCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentity];
    }
    
    if (indexPath.row == 0)cell.textLabel.text = @"webKit加载";
    else if (indexPath.row == 1) cell.textLabel.text = @"QuickLook加载";
    else if (indexPath.row == 2) cell.textLabel.text = @"CGContextRef加载";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) [self.navigationController pushViewController:[XKArticleTextContentWebViewController new] animated:YES];
    else if (indexPath.row == 1) [self.navigationController pushViewController:[XKArticleTextContentQuickLookViewController new] animated:YES];
    else if (indexPath.row == 2) [self.navigationController pushViewController:[XKArticleTextContentPagePdfViewController new] animated:YES];

}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
