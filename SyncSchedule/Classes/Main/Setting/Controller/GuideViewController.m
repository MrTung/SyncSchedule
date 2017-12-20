//
//  GuideViewController.m
//  SyncSchedule
//
//  Created by greatstar on 2017/5/15.
//  Copyright © 2017年 greatstar. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:web];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://article.toolmall.com/help/SyncSchedule.htm"]]];
}


@end
