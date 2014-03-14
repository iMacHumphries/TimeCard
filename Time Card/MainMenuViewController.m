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
    lastLoginLabel.text = [NSString stringWithFormat:@"Last Login: "];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)clockedIn{
    
    return true;
}
- (IBAction)clockInOutButton:(UIButton *)sender {
}
@end
