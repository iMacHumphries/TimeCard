//
//  AddPayPeriodViewController.m
//  Time Card
//
//  Created by Chris Mays on 8/12/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "AddPayPeriodViewController.h"
#import "DatabaseManager.h"
@interface AddPayPeriodViewController ()

@end

@implementation AddPayPeriodViewController
@synthesize startDatePicker;
@synthesize endDatePicker;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(doneButtonPressed)];
    self.navigationItem.rightBarButtonItem=flipButton;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)doneButtonPressed{
    if([[startDatePicker date] timeIntervalSince1970]< [[endDatePicker date] timeIntervalSince1970] ){
        
    
        [[DatabaseManager sharedManager] insertPayPeriodWithStartDate:[startDatePicker date] endDate:[endDatePicker date]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Start Time must be before end time" delegate:NULL cancelButtonTitle:@"OK!" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
