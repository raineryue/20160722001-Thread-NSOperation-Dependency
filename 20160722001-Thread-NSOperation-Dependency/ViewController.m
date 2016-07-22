//
//  ViewController.m
//  20160722001-Thread-NSOperation-Dependency
//
//  Created by Rainer on 16/7/22.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 创建一个队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    // 创建任务
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download1 in %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download2 in %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download3 in %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *blockOperation4 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"download4.%zd in %@", i, [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *blockOperation5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download5 in %@", [NSThread currentThread]);
    }];
    
    // 设置某个任务完成后的操作
    blockOperation5.completionBlock = ^{
        NSLog(@"blockOperation5执行完毕后会在异步线程[%@]中执行这里的代码", [NSThread currentThread]);
    };
    
    // 设置依赖：这里是2，3依赖1，意思是2和3必须等到1执行完才可执行
    [blockOperation2 addDependency:blockOperation1];
    [blockOperation3 addDependency:blockOperation1];
    // 这里是1依赖4，意思是1必须等到4里面的所有任务执行完才可执行
    [blockOperation1 addDependency:blockOperation4];
    
    // 将任务添加到队列中
    [operationQueue addOperation:blockOperation1];
    [operationQueue addOperation:blockOperation2];
    [operationQueue addOperation:blockOperation3];
    [operationQueue addOperation:blockOperation4];
    [operationQueue addOperation:blockOperation5];
}

@end
