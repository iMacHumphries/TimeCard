//
//  DetailViewController.m
//  Time Card
//
//  Created by Benjamin Humphries on 3/16/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

/*
 This viewController should have 
 Employee name
 Employee pin
 Clockin and out times 
 maybe a way to change pin number??
 */

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize detailIndex;
@synthesize navBar;
@synthesize name,pin;
@synthesize nameLabel;
@synthesize pinLabel;
@synthesize hoursWorkedLabel;
@synthesize currentEmployee;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(int)getTotalHoursWorkedForThisMonth{
    double totalSecondsWorked = 0.0;
    NSSet *hours=currentEmployee.employeesToAction;
    for(EmployeeAction *a in hours){
        if(a.employeeOut!=NULL && (a.archived==NULL || [a.archived boolValue]==false)){
            totalSecondsWorked+=[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
            NSLog(@"totalSeconds Worked is %f %f",[a.timeInitiated doubleValue],[a.employeeOut.timeInitiated doubleValue]);
        }
    }
    NSLog(@"%f", totalSecondsWorked);
    NSLog(@"%d", (int)totalSecondsWorked/(60*60));
    return (int)totalSecondsWorked/(60*60);
}
- (void)viewDidLoad
{
    

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"View will appear");
    nameLabel.text = [NSString stringWithFormat:@"Name: %@", currentEmployee.name];
    pinLabel.text = [NSString stringWithFormat:@"Pin: %@", currentEmployee.pin];
    navBar.title = [NSString stringWithFormat:@"Managing %@",currentEmployee.name];
    hoursWorkedLabel.text=[NSString stringWithFormat:@"Hours Worked: %d", [self getTotalHoursWorkedForThisMonth]];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setDetailIndex:(NSInteger)ndex{
    
    detailIndex =ndex;
}

-(NSString *)getCurrentMonth{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone systemTimeZone];
    format.locale=[NSLocale systemLocale];
    [format setDateFormat:@"MMM"];
    
    return [format stringFromDate:[NSDate date]];
}
-(NSNumber *)getCurrentYear{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone systemTimeZone];
    format.locale=[NSLocale systemLocale];
    [format setDateFormat:@"yyyy"];
    
    return [NSNumber numberWithInt:[[format stringFromDate:[NSDate date]] intValue]];
}
@end
