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
@synthesize tableView;

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
   
   // NSLog(@"%f", (double)totalSecondsWorked/(60*60));
    return (double)totalSecondsWorked/(60*60);
}
-(int)getTotalHoursForLiveTime{
    double totalSeconds = 0.0;
    NSSet *hours =currentEmployee.employeesToAction;
    for (EmployeeAction *a in hours){
        totalSeconds +=[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
    }
   return (double)totalSeconds /(60*60);
}

-(NSString *)getDay:(NSTimeInterval *)seconds{
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"dd"];
    NSString *weekDay =  [theDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:*seconds]];
    return weekDay;
}
- (void)viewDidLoad
{
   

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    clockedInDate = [[NSMutableArray alloc] init];
    NSSet *hours=currentEmployee.employeesToAction;

    for(EmployeeAction *a in hours){
    
        NSString *month = [NSString stringWithFormat:@"%@",a.month];
        NSArray * mon = [month componentsSeparatedByString:@"h"];
        if (mon != nil){
            month = [mon objectAtIndex:1];
        }
        
        double d = [a.timeInitiated doubleValue];
        NSTimeInterval *day = &d;
        
        NSString *year = [NSString stringWithFormat:@"%@", a.year];
          double totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
        NSString *dayHours = [NSString stringWithFormat:@"%f hours",totalSecondsWorkedThatDay/(60*60)];
        NSString *theDate = [NSString stringWithFormat:@"%@/%@/%@                                                         %@",month,[self getDay:day],year,dayHours];
        
         [clockedInDate addObject:theDate];
        
        
            }
    
    for (EmployeeActionOut *a in hours){
        NSString *month = [NSString stringWithFormat:@"%@",a.month];
        NSArray * mon = [month componentsSeparatedByString:@"h"];
        if (mon != nil){
            month = [mon objectAtIndex:1];
        }
        
        double d = [a.timeInitiated doubleValue];
        NSTimeInterval *day = &d;
        
        NSString *year = [NSString stringWithFormat:@"%@", a.year];

        NSString *theDate = [NSString stringWithFormat:@"%@/%@/%@",month,[self getDay:day],year];
        
        [clockedOutDates addObject:theDate];

    }
    
    
    
    nameLabel.text = [NSString stringWithFormat:@"Name: %@", currentEmployee.name];
    pinLabel.text = [NSString stringWithFormat:@"Pin: %@", currentEmployee.pin];
    navBar.title = [NSString stringWithFormat:@"Managing %@",currentEmployee.name];
    hoursWorkedLabel.text=[NSString stringWithFormat:@"Total Hours Worked: %d", [self getTotalHoursWorkedForThisMonth]];
    

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

//TableVIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // I Need an array with clocked ins and an array with clocked outs for the employees
    return [clockedInDate count];
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [clockedInDate objectAtIndex:indexPath.row];

    return cell;
}

@end
