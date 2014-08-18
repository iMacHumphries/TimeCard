//
//  ViewPayPeriodsViewController.m
//  Time Card
//
//  Created by Chris Mays on 8/12/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "ViewPayPeriodsViewController.h"
#import "DatabaseManager.h"
#import "DetailPayPeriodViewController.h"
@interface ViewPayPeriodsViewController ()

@end

@implementation ViewPayPeriodsViewController

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
    payPeriodsTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width) style:UITableViewStylePlain];
    payPeriodsTable.delegate=self;
    payPeriodsTable.dataSource=self;
    payperiodsArray=[[DatabaseManager sharedManager] getPayPeriods];
    [self.view addSubview:payPeriodsTable];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    payperiodsArray=[[DatabaseManager sharedManager] getPayPeriods];
    [payPeriodsTable reloadData];
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [payperiodsArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"Pay Period %@-%@  ID:%lld",[self getFormattedDateForLong:[[[payperiodsArray objectAtIndex:indexPath.row] objectForKey:@"StartTime"] longLongValue]],[self getFormattedDateForLong:[[[payperiodsArray objectAtIndex:indexPath.row] objectForKey:@"EndTime"] longLongValue]],[[[payperiodsArray objectAtIndex:indexPath.row] objectForKey:@"ID"] longLongValue]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected");
    NSMutableDictionary *object=[[NSMutableDictionary alloc] init];
    [object setObject:[[payperiodsArray objectAtIndex:indexPath.row] objectForKey:@"StartTime"] forKey:@"StartTime"];
    [object setObject:[[payperiodsArray objectAtIndex:indexPath.row] objectForKey:@"EndTime"] forKey:@"EndTime"];
    [self performSegueWithIdentifier:@"PayPeriodsToDetail" sender:object];
}
-(NSString *)getFormattedDateForLong:(long long)time{
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [NSDateFormatter localizedStringFromDate:theDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    
}
-(NSDate *)getDateForLong:(long long)time{
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [myDateFormatter setTimeStyle: NSDateFormatterLongStyle];
    NSDate * dateFromString = [myDateFormatter dateFromString:[NSDateFormatter localizedStringFromDate:theDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle]];
    return dateFromString;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PayPeriodsToDetail"]){

        DetailPayPeriodViewController *detail = [segue destinationViewController];
        detail.timePeriods=sender;
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableview commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"commit");
        NSLog(@"selected");
        [[DatabaseManager sharedManager] deletePayPeriodWithWithID:[[[payperiodsArray objectAtIndex:indexPath.row] objectForKey:@"ID"] longLongValue]];
         payperiodsArray=[[DatabaseManager sharedManager] getPayPeriods];
        [payPeriodsTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
