//
//  AddEmployeeHoursViewController.m
//  Time Card
//
//  Created by Chris Mays on 8/12/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "AddEmployeeHoursViewController.h"
#import "DatabaseManager.h"
@interface AddEmployeeHoursViewController ()

@end

@implementation AddEmployeeHoursViewController
@synthesize StartDatePicker;
@synthesize EndDatePicker;
@synthesize currentEmployee;
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
    if([[StartDatePicker date] timeIntervalSince1970]< [[EndDatePicker date] timeIntervalSince1970] ){
        
        
        [[DatabaseManager sharedManager] insertTimeForEmployee:currentEmployee withStartTime:[StartDatePicker date] withEndTime:[EndDatePicker date]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Start Time must be before End Time" delegate:NULL cancelButtonTitle:@"OK!" otherButtonTitles: nil];
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
