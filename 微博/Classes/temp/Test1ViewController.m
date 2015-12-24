//
//  Test1ViewController.m
//  weobo
//
//  Created by mac on 15-7-9.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import "Test1ViewController.h"
#import "Test2ViewController.h"
@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    Test2ViewController * test2 = [[Test2ViewController alloc]init];
    test2.title = @"测试2控制器";
    [self.navigationController pushViewController:test2 animated:YES];
}

@end
