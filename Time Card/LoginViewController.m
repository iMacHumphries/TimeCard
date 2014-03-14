//
//  LoginViewController.m
//  Time Card
//
//  Created by Benjamin Humphries on 3/13/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize pinArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           }
    return self;
}

- (void)viewDidLoad
{
    pinArray = [[NSMutableArray alloc]init];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addPinToArray:(NSInteger)pinNumber{
    NSString *string =[NSString stringWithFormat:@"%i",pinNumber];
    [pinArray addObject:string];
    NSLog(@"pin : %@",pinArray);
}
-(void)removeLastPinFromArray{
    [pinArray removeLastObject];
     NSLog(@"pin : %@",pinArray);
}

- (IBAction)pinButton:(UIButton *)sender {
    [self addPinToArray:sender.tag];
}
- (IBAction)deleteButton:(UIButton *)sender {
    [self removeLastPinFromArray];
}
@end
