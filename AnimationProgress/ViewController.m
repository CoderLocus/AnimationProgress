//
//  ViewController.m
//  AnimationProgress
//
//  Created by 井庆林 on 16/4/5.
//  Copyright © 2016年 unfae. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) CGFloat animationAngle;
@property (nonatomic, assign) CGFloat animationProgress;
@property (nonatomic, strong) ProgressView *progressView;

@property (nonatomic, assign) CGFloat progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.progressView = [[ProgressView alloc] init];
    self.progressView.frame = CGRectMake((windowWidth - 190) / 2, 100, 190, 190);
    self.progressView.progress = arc4random() % 100;
    [self.view addSubview:self.progressView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, CGRectGetMaxY(self.progressView.frame), windowWidth, 17);
    label.text = @"进度指示器";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.progressView addGestureRecognizer:tgr];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    self.progress = arc4random() % 100;
    
    [self startAnimation];
}

- (void)startAnimation {
    [self.animationTimer invalidate];
    self.animationTimer = [NSTimer timerWithTimeInterval:0.03 target:self selector:@selector(annimation) userInfo:nil repeats: YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
    
    self.animationAngle = 0;
}

- (void)annimation {
    self.animationProgress = self.progress * (self.animationAngle / 360.0);
    self.progressView.progress = self.animationProgress;
    
    if (self.animationAngle >= 360) {
        self.animationAngle = 0;
        [self.animationTimer invalidate];
    } else {
        self.animationAngle += 10;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
