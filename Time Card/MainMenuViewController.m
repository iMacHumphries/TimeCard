//
//  MainMenuViewController.m
//  Time Card
//
//  Created by Benjamin Humphries on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize employee;
@synthesize welcomeLabel;
@synthesize lastLoginLabel;
@synthesize clockInOutButton;

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
    NSLog(@"%@", employee.name);
    welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@",employee.name];
    lastLoginLabel.text = [self getSatus];
    
    if ([self clockedIn]){
        //clockInOutButton.titleLabel.text = @"Clock Out";
        [clockInOutButton setTitle:@"Clock Out" forState:UIControlStateNormal];
    }
    else {
        //clockInOutButton.titleLabel.text = @"Clock In";
        [clockInOutButton setTitle:@"Clock In" forState:UIControlStateNormal];

    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)getSatus{
    if([self clockedIn]){
        return @"Clocked in @ ";
    }else{
        return @"Clocked out @ ";

    }
}
-(BOOL)clockedIn{
    if([employee.employeesToAction count]==0){
        return false;
    }
    for(EmployeeAction *action in employee.employeesToAction) {
        NSLog(@"%@", action.timeInitiated);
    }
    return true;
}
- (IBAction)clockInOutButton:(UIButton *)sender {
    
}



@end
