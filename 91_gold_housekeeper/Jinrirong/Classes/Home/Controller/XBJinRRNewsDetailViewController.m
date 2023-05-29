//
//  XBJinRRNewsDetailViewController.m
//  Jinrirong
//
//  Created by 刘飞 on 2018/6/7.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "XBJinRRNewsDetailViewController.h"
#import <WebKit/WebKit.h>

@interface XBJinRRNewsDetailViewController ()<WKNavigationDelegate>
{
    WKWebView *webView;
}
@end

@implementation XBJinRRNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavWithTitle:self.tModel.Title isShowBack:YES];
    self.view.backgroundColor = WhiteColor;
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    webView.navigationDelegate = self;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];
    [self getDetail];
}

//-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    [self.view showLoadMessageAtCenter:@"努力加载中..."];
//}
//-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    [self.view showLoadMessageAtCenter:@"努力加载中..."];
//}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.view hide];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.view hide];
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.view hide];
}
- (void )getDetail{
    WS(bself);
    [self.view showLoadMessageAtCenter:@"努力加载中..."];
    [XBJinRRNetworkApiManager getnoticeWithID:self.tModel.ID Block:^(id data) {
        if (rusultIsCorrect) {
            NSDictionary *dic = data[@"data"];
            NSString *contentStr = [NSString stringWithFormat:@"%@",dic[@"Contents"]];
            //            NSRange startRange = [contentStr rangeOfString:@"<p>"];
            //            NSRange endRange = [contentStr rangeOfString:@"</p>"];
            //            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            //            NSString *result = [contentStr substringWithRange:range];
            
            [self->webView loadHTMLString:[LLUtils reSizeImageWithHTML:contentStr] baseURL:nil];
        }else{
            [bself.view hide];
        }
    } fail:^(NSError *errorString) {
        [bself.view hide];
        [Dialog toastCenter:@"网络错误"];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
