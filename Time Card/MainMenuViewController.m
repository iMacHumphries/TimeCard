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
    praise = [[NSArray alloc] initWithObjects:@"Awesome",@"Fantastic",@"Great",@"Ok",@"Sweet", nil];
    welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@",employee.name];
    lastLoginLabel.text = [self getSatus];
    
    if ([self clockedIn]){
        [clockInOutButton setTitle:@"Clock Out" forState:UIControlStateNormal];
    }
    else {
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
    EmployeeAction *currentAction;
    for(EmployeeAction *action in employee.employeesToAction) {
        if(currentAction==NULL){
            currentAction=action;
        }else{
            if(currentAction.timeInitiated<action.timeInitiated){
                currentAction=action;
            }
        }
    }
    if([currentAction.type isEqualToString:@"in"]){
        return true;
    }else{
        return false;
    }
}
- (IBAction)clockInOutButton:(UIButton *)sender {
    NSString *clocked = [[clockInOutButton titleLabel]text];

    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Successfully %@",clocked] message:[NSString stringWithFormat:@"%@ was successfully %@ at time" ,employee.name,clocked] delegate:self cancelButtonTitle:[self getRandomPraise] otherButtonTitles:nil, nil];
    [alert show];
    
}


-(NSString *)getRandomPraise{
    
    int i = arc4random()%[praise count];
    NSString *string = [praise objectAtIndex:i];
    return string;
}
@end
