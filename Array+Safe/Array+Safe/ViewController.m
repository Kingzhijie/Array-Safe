//
//  ViewController.m
//  Array+Safe
//
//  Created by mbApple on 2017/11/3.
//  Copyright © 2017年 mbApple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //runtime 防止数组越界, 产生崩溃
    
    //1. 工具提供方法, 解决一下 NSArray 和 NSMutableArray 处理错误 导致的越界,
    
    NSArray * array = @[@"1"];
    [array objectAtIndex:10];  //此处取下标为10的元素, 导致越界
    
    NSMutableArray * dataArray = [NSMutableArray array];
    [dataArray addObject:@"12"];
    
    [dataArray objectAtIndex:10];//越界
    [dataArray insertObject:@"wang" atIndex:10]; //越界
    [dataArray setObject:@"hh" atIndexedSubscript:20]; //越界
    [dataArray removeObjectAtIndex:10]; //越界
    [dataArray removeObjectsInRange:NSMakeRange(2, 3)]; //越界
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
