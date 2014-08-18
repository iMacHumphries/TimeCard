//
//  DetailPayPeriodViewController.m
//  Time Card
//
//  Created by Chris Mays on 8/12/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "DetailPayPeriodViewController.h"
#import "DatabaseManager.h"
@interface DetailPayPeriodViewController ()

@end

@implementation DetailPayPeriodViewController
@synthesize employeeInfo;
@synthesize timePeriods;
@synthesize NameLabel;
@synthesize PayLabel;
@synthesize HoursWorkedLabel;

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
    
    NSMutableArray *employeeArray=[[DatabaseManager sharedManager] getAllEmployees];
    employeeInfo=[[NSMutableArray alloc] init];
    for (int i=0; i<[employeeArray count]; i++) {
        [employeeInfo addObject:[[DatabaseManager sharedManager] getPayForEmployee:[employeeArray objectAtIndex:i] withStartDate:[[timePeriods objectForKey:@"StartTime"] longLongValue] endDate:[[timePeriods objectForKey:@"EndTime"] longLongValue]]];
    }
    
    payPeriodsTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0+220+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.height, self.view.frame.size.width-220-self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
    payPeriodsTable.delegate=self;
    payPeriodsTable.dataSource=self;
    [self.view addSubview:payPeriodsTable];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    NSMutableArray *employeeArray=[[DatabaseManager sharedManager] getAllEmployees];
    employeeInfo=[[NSMutableArray alloc] init];
    for (int i=0; i<[employeeArray count]; i++) {
        [employeeInfo addObject:[[DatabaseManager sharedManager] getPayForEmployee:[employeeArray objectAtIndex:i] withStartDate:[[timePeriods objectForKey:@"StartTime"] longLongValue] endDate:[[timePeriods objectForKey:@"EndTime"] longLongValue]]];
    }
    [payPeriodsTable reloadData];
}


-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [employeeInfo count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"Name:%@ \t\t Hours Worked:%d \t\t Minutes Worked %d \t\t Pay:$%.2f",[[employeeInfo objectAtIndex:indexPath.row] objectForKey:@"EmployeeName"], [[[employeeInfo objectAtIndex:indexPath.row] objectForKey:@"HoursWorked"] intValue],[[[employeeInfo objectAtIndex:indexPath.row] objectForKey:@"MinutesWorked"] intValue],[[[employeeInfo objectAtIndex:indexPath.row] objectForKey:@"DollarsEarned"] floatValue]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NameLabel.text=[NSString stringWithFormat:@"Name: %@",[[employeeInfo objectAtIndex:indexPath.row] objectForKey:@"EmployeeName"]];
    
    HoursWorkedLabel.text=[NSString stringWithFormat:@"Hours Worked:%d \t Minutes Worked %d",[[[employeeInfo objectAtIndex:indexPath.row] objectForKey:@"HoursWorked"] intValue],[[[employeeInfo objectAtIndex:indexPath.row] objectForKey:@"MinutesWorked"] intValue]];
    PayLabel.text=[NSString stringWithFormat: @"Pay:$%.2f",[[[employeeInfo objectAtIndex:indexPath.row] objectForKey:@"DollarsEarned"] floatValue]];
    
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
