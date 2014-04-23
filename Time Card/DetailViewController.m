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
#define daySelect 0
#define monthSelect 1
#define yearSelect 2
#define allSelect 3

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
@synthesize dayButton,yearButton,monthButton,allButton;
@synthesize rightLabel;

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
           // NSLog(@"totalSeconds Worked is %f %f",[a.timeInitiated doubleValue],[a.employeeOut.timeInitiated doubleValue]);
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
   
    

    [self configureTableViewForButtonSelected];
    
    
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
-(NSString *)getMonthForSeconds:(NSTimeInterval *)seconds{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone systemTimeZone];
    format.locale=[NSLocale systemLocale];
    [format setDateFormat:@"MM"];

    return [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:*seconds]];
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

- (IBAction)dayButton:(UIButton *)sender {
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];
}

- (IBAction)monthButton:(UIButton *)sender {
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];

}

- (IBAction)yearButton:(UIButton *)sender {
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];

}

- (IBAction)allButton:(UIButton *)sender {
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];

}

-(void)configureSelectedButtonWithTheTag:(int)tag{
    UIImage *filled = [UIImage imageNamed:@"filledIndicator"];
    [self setAllButtonsToNotSelected];
    [self setSelectedIndex:tag];
    
    if (tag == 0){
        [dayButton setBackgroundImage:filled forState:UIControlStateNormal];
    }
    else if (tag == 1){
        [monthButton setBackgroundImage:filled forState:UIControlStateNormal];
    }
    else if (tag ==2){
        [yearButton setBackgroundImage:filled forState:UIControlStateNormal];
    }
    else if (tag ==3){
        [allButton setBackgroundImage:filled forState:UIControlStateNormal];
    }
    
}
-(void)setAllButtonsToNotSelected{
    UIImage *blank = [UIImage imageNamed:@"blankIndicator"];
    [dayButton setBackgroundImage:blank forState:UIControlStateNormal];
    [monthButton setBackgroundImage:blank forState:UIControlStateNormal];
    [yearButton setBackgroundImage:blank forState:UIControlStateNormal];
    [allButton setBackgroundImage:blank forState:UIControlStateNormal];
}

-(void)setSelectedIndex:(int)tag{
    selectedButtonIndex =tag;
}
-(int)getSelectedButtonIndex{
    return selectedButtonIndex;
}
-(void)configureTableViewForButtonSelected{
     clockedInDate = [[NSMutableArray alloc] init];
    int i = [self getSelectedButtonIndex];
   
    if (i == daySelect){
        rightLabel.text = @"Days";
        [self changeTableToDay];
    }
    else if (i == monthSelect){
        rightLabel.text = @"Months";
        [self changeTableToMonth];
        
    }
    else if (i == yearSelect){
        rightLabel.text = @"Years";
        [self changeTableToYear];
        
    }
    else if (i == allSelect){
        rightLabel.text = @"ClockINS / Clock OUTS";
        NSString *test = @"                                ClockINs and CLockOuts                           Hours between clock out and clock ins";
        [clockedInDate addObject:test];
    }
    
    
    [tableView reloadData];
}
-(void)changeTableToDay{
    
    
    
     NSSet *hours=currentEmployee.employeesToAction;
    NSMutableArray *previousDates = [[NSMutableArray alloc]init];
     NSMutableArray *previousTimes = [[NSMutableArray alloc]init];
    double totalSecondsWorkedThatDay = 0;
    int index = 0;
    
    for(EmployeeAction *a in hours){
        double d = [a.timeInitiated doubleValue];
        NSTimeInterval *day = &d;
        NSString *theDay = [self getDay:day];
        
        NSString *year = [NSString stringWithFormat:@"%@", a.year];
        totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
      
        NSString *theDate = [NSString stringWithFormat:@"                                         %@/%@/%@                                                               ",[self getMonthForSeconds:day],theDay,year];
        
         NSString *dayHours = [NSString stringWithFormat:@"%f hours",totalSecondsWorkedThatDay/(60*60)];
        
        if ([previousDates count] >0 && [clockedInDate count] >0){
            
            NSLog(@"THE PREV DATE : %@ : THE COMPARE DATE %@",[previousDates objectAtIndex:(index -1)], theDate);
            if ([[previousDates objectAtIndex:(index -1)] isEqualToString:theDate]){
                 [clockedInDate removeLastObject];
                totalSecondsWorkedThatDay = totalSecondsWorkedThatDay + [[previousTimes objectAtIndex:(index -1 )] doubleValue];
            }
           
        }
       
        [previousDates addObject:theDate];
        [previousTimes addObject:[NSNumber numberWithDouble:totalSecondsWorkedThatDay]];
        theDate = [theDate stringByAppendingString:dayHours];
        [clockedInDate addObject:theDate];
        
         index ++;
        }
    
            
    
    
    
    
    }

-(void)changeTableToMonth{
 NSSet *hours=currentEmployee.employeesToAction;
    double totalSecondsWorkedThatDay;
    NSMutableArray *prevMonthYear = [[NSMutableArray alloc] init];
    NSMutableArray *previousTimes = [[NSMutableArray alloc]init];
    int index = 0;
    
     for(EmployeeAction *a in hours){
         double d = [a.timeInitiated doubleValue];
         NSTimeInterval *day = &d;
         NSString *theDay = [self getDay:day];
         
         NSString *year = [NSString stringWithFormat:@"%@", a.year];
         totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
         
         NSString *theMonth = [self getMonthForSeconds:day];
         
         NSString *monthYear  = [NSString stringWithFormat:@"%@/%@",theMonth,year];
         
           NSString *theDate = [NSString stringWithFormat:@"                                         %@/%@/%@                                                               ",theMonth,theDay,year];
          NSString *dayHours = [NSString stringWithFormat:@"%f hours",totalSecondsWorkedThatDay/(60*60)];
         
         if ([prevMonthYear count] >0 && [clockedInDate count] >0){
             
            if ([[prevMonthYear objectAtIndex:(index -1)] isEqualToString:monthYear]){
                 [clockedInDate removeLastObject];
                 totalSecondsWorkedThatDay = totalSecondsWorkedThatDay + [[previousTimes objectAtIndex:(index -1 )] doubleValue];
             }
             
         }
         
         [prevMonthYear addObject:monthYear];
         [previousTimes addObject:[NSNumber numberWithDouble:totalSecondsWorkedThatDay]];
         theDate = [theDate stringByAppendingString:dayHours];
         [clockedInDate addObject:theDate];

         
         index ++;
            }
    
}
-(void)changeTableToYear{
    
    NSSet *hours=currentEmployee.employeesToAction;
    double totalSecondsWorkedThatDay;
    NSMutableArray *prevYear = [[NSMutableArray alloc] init];
    NSMutableArray *previousTimes = [[NSMutableArray alloc]init];
    int index = 0;
    
    for(EmployeeAction *a in hours){
        double d = [a.timeInitiated doubleValue];
        NSTimeInterval *day = &d;
        NSString *theDay = [self getDay:day];
        
        NSString *year = [NSString stringWithFormat:@"%@", a.year];
        totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
        
        NSString *theMonth = [self getMonthForSeconds:day];
        
        NSString *theDate = [NSString stringWithFormat:@"                                         %@/%@/%@                                                               ",theMonth,theDay,year];
        NSString *dayHours = [NSString stringWithFormat:@"%f hours",totalSecondsWorkedThatDay/(60*60)];

        if ([prevYear count] >0 && [clockedInDate count] >0){
            
            if ([[prevYear objectAtIndex:(index -1)] isEqualToString:year]){
                [clockedInDate removeLastObject];
                totalSecondsWorkedThatDay = totalSecondsWorkedThatDay + [[previousTimes objectAtIndex:(index -1 )] doubleValue];
            }
            
        }
    
        
        [prevYear addObject:year];
        [previousTimes addObject:[NSNumber numberWithDouble:totalSecondsWorkedThatDay]];
        theDate = [theDate stringByAppendingString:dayHours];
        [clockedInDate addObject:theDate];
        index ++;
    }

    
    
    
}

@end
