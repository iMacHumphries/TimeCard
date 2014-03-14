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
@synthesize indicator1,indicator2,indicator3,indicator4;
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
    if ([pinArray count] == 4){
        [self checkEmployeePin];
    }
    NSLog(@"pin : %@",pinArray);
}
-(void)removeLastPinFromArray{
    [pinArray removeLastObject];
     NSLog(@"pin : %@",pinArray);
}

- (IBAction)pinButton:(UIButton *)sender {
    [self addPinToArray:sender.tag];
    [self changeIndicators];
}
- (IBAction)deleteButton:(UIButton *)sender {
    [self removeLastPinFromArray];
    [self changeIndicators];
}
-(void)checkEmployeePin{
    
}
-(void)changeIndicators{
    
    if ([pinArray count]== 0) {
        [indicator1 setImage:[UIImage imageNamed:@"blankIndicator"]];
        [indicator2 setImage:[UIImage imageNamed:@"blankIndicator"]];
        [indicator3 setImage:[UIImage imageNamed:@"blankIndicator"]];
        [indicator4 setImage:[UIImage imageNamed:@"blankIndicator"]];
    }
   else if ([pinArray count]== 1) {
        [indicator1 setImage:[UIImage imageNamed:@"filledIndicator"]];
        [indicator2 setImage:[UIImage imageNamed:@"blankIndicator"]];
        [indicator3 setImage:[UIImage imageNamed:@"blankIndicator"]];
        [indicator4 setImage:[UIImage imageNamed:@"blankIndicator"]];
    }
   else if ([pinArray count]== 2) {
       [indicator1 setImage:[UIImage imageNamed:@"filledIndicator"]];
       [indicator2 setImage:[UIImage imageNamed:@"filledIndicator"]];
       [indicator3 setImage:[UIImage imageNamed:@"blankIndicator"]];
       [indicator4 setImage:[UIImage imageNamed:@"blankIndicator"]];
       
   }
   else if ([pinArray count]== 3) {
       [indicator1 setImage:[UIImage imageNamed:@"filledIndicator"]];
       [indicator2 setImage:[UIImage imageNamed:@"filledIndicator"]];
       [indicator3 setImage:[UIImage imageNamed:@"filledIndicator"]];
       [indicator4 setImage:[UIImage imageNamed:@"blankIndicator"]];
       
   }

   else if ([pinArray count]== 4) {
       [indicator1 setImage:[UIImage imageNamed:@"filledIndicator"]];
       [indicator2 setImage:[UIImage imageNamed:@"filledIndicator"]];
       [indicator3 setImage:[UIImage imageNamed:@"filledIndicator"]];
       [indicator4 setImage:[UIImage imageNamed:@"filledIndicator"]];
       
   }

    

    
}
@end
