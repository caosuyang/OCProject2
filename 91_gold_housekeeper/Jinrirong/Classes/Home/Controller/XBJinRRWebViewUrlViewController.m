//
//  XBJinRRWebViewUrlViewController.m
//  Jinrirong
//
//  Created by ahxb on 2018/9/19.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "XBJinRRWebViewUrlViewController.h"

@interface XBJinRRWebViewUrlViewController ()<UIWebViewDelegate>
{
    double webViewHeight;
}
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation XBJinRRWebViewUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    [self getfindDetail];
}

-(void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    [self setNavWithTitle:_titleName isShowBack:YES];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView =[[UIWebView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT , SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(0);
            make.left.right.bottom.mas_offset(0);
        }];
        
        
    }
    
    return _webView;
}
- (void)getfindDetail{
    WS(bself);
    
    [bself.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    
//    [bself.webView loadHTMLString:_Controlents baseURL:nil];
    
    
    
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//
//{
//
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
//
//    [webView stringByEvaluatingJavaScriptFromString:meta];
//
//}
@end
