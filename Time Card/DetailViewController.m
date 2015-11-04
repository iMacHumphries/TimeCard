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
#import "AppDelegate.h"

#define daySelect 0
#define monthSelect 1
#define yearSelect 2
#define allSelect 3
#define paySelect 4

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
@synthesize dayButton,yearButton,monthButton,allButton,payPeriodButton;
@synthesize leftLabel;
@synthesize clockedInDate;
@synthesize audioPlayer;
@synthesize employActionArray;

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
-(NSString *)getHours:(NSTimeInterval *)seconds{
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:*seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    return resultString;
}
- (void)viewDidLoad
{
    employActionArray = [[NSMutableArray alloc]init];
    NSSet *hours=currentEmployee.employeesToAction;
    for(EmployeeActionOut *a in hours){
        
        [employActionArray addObject:a];
    }
  
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self configureTableViewForButtonSelected];
    
    nameLabel.text = [NSString stringWithFormat:@"Name: %@", currentEmployee.name];
    pinLabel.text = [NSString stringWithFormat:@"Pin: %@", currentEmployee.pin];
    navBar.title = [NSString stringWithFormat:@"Managing %@",currentEmployee.name];
    hoursWorkedLabel.text=[NSString stringWithFormat:@"Total Hours Worked: %d", [self getTotalHoursForLiveTime]];
    
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
- (void)tableView:(UITableView *)tableview commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self removeEmployeeDataAtRow:indexPath.row :indexPath];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
-(void)removeEmployeeDataAtRow:(int)theRow :(NSIndexPath *)indexpat{
    NSLog(@"trying to remove employee");
    
    //1. Get the in and out date + time of the current row....
    
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexpat];
    NSString *inAndOutString = currentCell.textLabel.text;
    inAndOutString = [inAndOutString stringByReplacingOccurrencesOfString:@"  " withString:@""];
    inAndOutString = [inAndOutString stringByReplacingOccurrencesOfString:@"IN:" withString:@""];
    inAndOutString = [inAndOutString stringByReplacingOccurrencesOfString:@"OUT:" withString:@""];
    NSArray *savedInOutArray = [inAndOutString componentsSeparatedByString:@" "];
     NSLog(@"here: %@",savedInOutArray);
   
    NSString *savedInString = [NSString stringWithFormat:@"%@",[savedInOutArray objectAtIndex:1]];
     NSString *savedOutString = [NSString stringWithFormat:@"%@",[savedInOutArray objectAtIndex:3]];
       // NSLog(@"checking: %@ and : %@ ",savedInString,savedOutString);
       
    

    //2. compare that in and out date + time to every employee action (converted to string format)
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"EmployeeAction" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
     for (EmployeeAction *info in fetchedObjects) {
         
         double d = [info.timeInitiated doubleValue];
         NSTimeInterval *day = &d;
         NSString *theDay = [self getDay:day];
         NSString *theYear = [info.year stringValue];
         NSString *theMonth = [self getMonthForSeconds:day];
          NSString *timeIn =[self getHours:day];
         NSString *compareInString = [NSString stringWithFormat:@"%@/%@/%@%@",theMonth,theDay,theYear,timeIn];
         compareInString = [compareInString stringByReplacingOccurrencesOfString:@" AM" withString:@""];
         compareInString = [compareInString stringByReplacingOccurrencesOfString:@" PM" withString:@""];
       
         d = [info.employeeOut.timeInitiated doubleValue];
         day = &d;
         theDay = [self getDay:day];
         theYear = [info.employeeOut.year stringValue];
         theMonth = [self getMonthForSeconds:day];
         NSString *timeOut =[self getHours:&d];
         
         NSString *compareOutString = [NSString stringWithFormat:@"%@/%@/%@%@",theMonth,theDay,theYear,timeOut];
         compareOutString = [compareOutString stringByReplacingOccurrencesOfString:@" AM" withString:@""];
         compareOutString = [compareOutString stringByReplacingOccurrencesOfString:@" PM" withString:@""];
         
         

         if ([compareInString isEqualToString:savedInString] && [compareOutString isEqualToString:savedOutString]){
             NSLog(@"%@",info);
             [context deleteObject:[info valueForKey:@"employeeOut"]];
              [context deleteObject:info];
             [context save:&error];
         }
     }

    [clockedInDate removeObjectAtIndex:theRow];
    
    [tableView deleteRowsAtIndexPaths:@[indexpat] withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView reloadData];
    
}


- (IBAction)dayButton:(UIButton *)sender {
    [self defaultSound];
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];
}

- (IBAction)monthButton:(UIButton *)sender {
    [self defaultSound];
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];

}

- (IBAction)yearButton:(UIButton *)sender {
    [self defaultSound];
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];

}

- (IBAction)allButton:(UIButton *)sender {
    [self defaultSound];
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];

}

- (IBAction)payPeriodButton:(UIButton *)sender {
    [self defaultSound];
    [self configureSelectedButtonWithTheTag:sender.tag];
    [self configureTableViewForButtonSelected];
}

- (IBAction)emailButton:(UIBarButtonItem *)sender {
    [self defaultSound];
    [self email];
    
}

- (IBAction)questionButton:(UIButton *)sender {

    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Problems?" message:[NSString stringWithFormat:@"If the hours are large negative numbers or the word ('null') is present, please ensure that the employee, %@, has been properly clocked out.",currentEmployee.name] delegate:self cancelButtonTitle:@"Thanks!" otherButtonTitles:nil, nil];
    [al show];
}

- (void)email{
    
    // save all table
    CGRect frame = self.tableView.frame;
    frame.size.height = self.tableView.contentSize.height;
    self.tableView.frame = frame;
    
    UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size, self.tableView.opaque, 0.0);
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(saveImage);
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:@"image.png"];
    [fileMan createFileAtPath:pdfFileName contents:imageData attributes:nil];
    
    
    NSLog(@"path %@", pdfFileName); 

    
    MFMailComposeViewController *mViewController = [[MFMailComposeViewController alloc] init];
    mViewController.mailComposeDelegate = self;
    [mViewController setSubject:@"TIME_CARD"];
    [mViewController setMessageBody:[NSString stringWithFormat:@"%@'s Work Hours",currentEmployee.name] isHTML:NO];
   
    [mViewController addAttachmentData:imageData mimeType:@"image/png" fileName:pdfFileName];
    
    [self presentViewController:mViewController animated:YES completion:^{
        
        
    }];
    
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self failSound];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            [self defaultSound];
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            [self failSound];
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [a show];
            break;
            
    }
    self.tableView.frame = CGRectMake(0, 251, 1024,446);
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    else if (tag ==4){
         [payPeriodButton setBackgroundImage:filled forState:UIControlStateNormal];
    }
    
}
-(void)setAllButtonsToNotSelected{
    UIImage *blank = [UIImage imageNamed:@"blankIndicator"];
    [dayButton setBackgroundImage:blank forState:UIControlStateNormal];
    [monthButton setBackgroundImage:blank forState:UIControlStateNormal];
    [yearButton setBackgroundImage:blank forState:UIControlStateNormal];
    [allButton setBackgroundImage:blank forState:UIControlStateNormal];
    [payPeriodButton setBackgroundImage:blank forState:UIControlStateNormal];
}
-(void)setSelectedIndex:(int)tag{
    selectedButtonIndex =tag;
}
-(int)getSelectedButtonIndex{
    return selectedButtonIndex;
}
-(void)configureTableViewForButtonSelected{
    clockedInDate = [[NSMutableArray alloc] init];
    [clockedInDate removeAllObjects];
    int i = [self getSelectedButtonIndex];
   
    if (i == daySelect){
        leftLabel.text = @"Days";
        [self changeTableToDay];
    }
    else if (i == monthSelect){
        leftLabel.text = @"Months";
        [self changeTableToMonth];
        
    }
    else if (i == yearSelect){
        leftLabel.text = @"Years";
        [self changeTableToYear];
        
    }
    else if (i == allSelect){
        leftLabel.text = @"ClockINS / Clock OUTS";
        [self changeToClockedInOut];
    }
    else if (i == paySelect){
        leftLabel.text = @"Pay Periods                  Start                            End";
        [self changeTableToPayPeriod];
    }
    
   
    [tableView reloadData];
}
-(void)changeTableToPayPeriod{
    NSSet *hours=currentEmployee.employeesToAction;
    double totalSecondsWorkedThatDay = 0;
    NSMutableArray *prevDateArray = [[NSMutableArray alloc]init];
    
    for(EmployeeAction *a in hours){
      
        double d = [a.timeInitiated doubleValue];
        NSTimeInterval *day = &d;
         NSString *theDay = [self getDay:day];
        NSString *year = [NSString stringWithFormat:@"%@", a.year];
        totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
        
        NSString *month = [self getMonthForSeconds:day];
        NSString *theDate = [NSString stringWithFormat:@"%@/%@/%@",month,theDay,year];
         for (int i = 0; i < [prevDateArray count]; i++){
           
             NSArray *split = [[prevDateArray objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            
             NSString *prevDate = [split objectAtIndex:0];
             split = [prevDate componentsSeparatedByString:@"/"];
             NSString *prevMonth = [split objectAtIndex:0];
              NSString *prevDay = [split objectAtIndex:1];
             NSString *prevYear = [split objectAtIndex:2];
             double prevHrs = [[split objectAtIndex:3] doubleValue];
             //1. is the date the exact same as another?
             //2. is the month = next month - (1 month back) and day less than 15?
             //3. is the month = next month (-11 months back) if so then the month was the 12th month and is the year = prevyear -1 year back?
             
            if (([month isEqualToString:prevMonth] && [theDay intValue]>=16 && [year isEqualToString:prevYear]) || ([month intValue] == [prevMonth intValue]-1 && [theDay intValue] <= 15) || ([month intValue]== [prevMonth intValue]+1  &&  [theDay intValue]>=16)|| ([month intValue] == [prevMonth intValue]-11  && [theDay intValue]<=15  && [year intValue] == [prevYear intValue]+1) || ([month isEqualToString:prevMonth] && [theDay isEqualToString:prevDay] && [year isEqualToString:prevYear])){
                NSLog(@"CALLEd");
                [prevDateArray removeObjectAtIndex:i];
                [clockedInDate removeObjectAtIndex:i];
                 totalSecondsWorkedThatDay += prevHrs * (60*60);
                 
             }
             
         }
       
        

        NSString *dayHours = [NSString stringWithFormat:@"/%f hours",totalSecondsWorkedThatDay/(60*60)];
        //ex payPeriod 1  (started) 03/16/2014  (ends)  04/15/2014
        NSString *nextMonth = [NSString stringWithFormat:@"0%i",[month intValue]+1];
        NSString *nextYear = [NSString stringWithFormat:@"%@",year];
        if ([month intValue] == 12){
            nextMonth = [NSString stringWithFormat:@"01"];
            nextYear = [NSString stringWithFormat:@"%i",[nextYear intValue]+1];
        }
       
       

       
        [prevDateArray addObject:[theDate stringByAppendingString:dayHours]];
         theDate = [NSString stringWithFormat:@"Pay Period %i                         %@/16/%@                         %@/15/%@",[prevDateArray count],month,year,nextMonth,nextYear];
        theDate = [theDate stringByAppendingString:[NSString stringWithFormat:@"                    %@",dayHours]];
        [clockedInDate addObject:theDate];
        
        [self sortArrayNumerically:clockedInDate];
        [self sortArrayNumerically:prevDateArray];
                   }
    
}
-(void)changeTableToDay{
     NSSet *hours=currentEmployee.employeesToAction;
    double totalSecondsWorkedThatDay = 0;
    for(EmployeeAction *a in hours){
        double d = [a.timeInitiated doubleValue];
        NSTimeInterval *day = &d;
        NSString *theDay = [self getDay:day];
        
        NSString *year = [NSString stringWithFormat:@"%@", a.year];
        totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
      
        NSString *month = [self getMonthForSeconds:day];
        NSString *theDate = [NSString stringWithFormat:@"                                         %@/%@/%@                                                               ",month,theDay,year];
        NSString *test =[NSString stringWithFormat:@"%@/%@/%@",month,theDay,year];
        
        for (int i = 0; i < [clockedInDate count]; i ++){
            
            NSArray *split = [[clockedInDate objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            NSString *compareDate = [split objectAtIndex:0];
            double lastHours = [[split objectAtIndex:1] doubleValue];
            if ([test isEqualToString:compareDate]){
                [clockedInDate removeObjectAtIndex:i];
                totalSecondsWorkedThatDay =totalSecondsWorkedThatDay +(lastHours * (60*60));
            }
        }
        NSString *dayHours = [NSString stringWithFormat:@"%f hours",totalSecondsWorkedThatDay/(60*60)];
        theDate = [theDate stringByAppendingString:dayHours];
    
       
        [clockedInDate addObject:theDate];
        [self sortArrayNumerically:clockedInDate];
       
        }
    
    }
-(void)changeTableToMonth{
 NSSet *hours=currentEmployee.employeesToAction;
    double totalSecondsWorkedThatDay;
     for(EmployeeAction *a in hours){
         
         double d = [a.timeInitiated doubleValue];
         NSTimeInterval *day = &d;

         NSString *year = [NSString stringWithFormat:@"%@", a.year];
         totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
         
         NSString *theMonth = [self getMonthForSeconds:day];
         
         NSString *monthYear  = [NSString stringWithFormat:@"                                            %@/%@                                                            ",theMonth,year];

         NSString *test =[NSString stringWithFormat:@"%@/%@",theMonth,year];
        
         for (int i = 0; i < [clockedInDate count]; i ++){
             
             NSArray *split = [[clockedInDate objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
             NSString *compareDate = [split objectAtIndex:0];
             double lastHours = [[split objectAtIndex:1] doubleValue];
             if ([test isEqualToString:compareDate]){
                 [clockedInDate removeObjectAtIndex:i];
                 totalSecondsWorkedThatDay =totalSecondsWorkedThatDay +(lastHours * (60*60));
             }
         }

         NSString *dayHours = [NSString stringWithFormat:@"%f hours",totalSecondsWorkedThatDay/(60*60)];
         monthYear = [monthYear stringByAppendingString:dayHours];
         [clockedInDate addObject:monthYear];
         [self sortArrayNumerically:clockedInDate];
        
            }
   
    
}
-(void)changeTableToYear{
    
    NSSet *hours=currentEmployee.employeesToAction;
    double totalSecondsWorkedThatDay;
    
    for(EmployeeAction *a in hours){
        NSString *year = [NSString stringWithFormat:@"                                            %@                                                             ", a.year];
        totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
        

        for (int i = 0; i < [clockedInDate count]; i ++){
            
            NSArray *split = [[clockedInDate objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            NSString *compareDate = [split objectAtIndex:0];
            double lastHours = [[split objectAtIndex:1] doubleValue];
            if ([[a.year stringValue] isEqualToString:compareDate]){
                [clockedInDate removeObjectAtIndex:i];
                totalSecondsWorkedThatDay =totalSecondsWorkedThatDay +(lastHours * (60*60));
            }
        }

    
        NSString *dayHours = [NSString stringWithFormat:@"%f hours",totalSecondsWorkedThatDay/(60*60)];
            year = [year stringByAppendingString:dayHours];
        [clockedInDate addObject:year];
        [self sortArrayNumerically:clockedInDate];
        
    }

    
    
    
}
-(void)changeToClockedInOut{
    NSSet *hours=currentEmployee.employeesToAction;
    NSMutableArray *ins= [[NSMutableArray alloc] init];
    NSMutableArray *outs= [[NSMutableArray alloc] init];
    NSMutableArray *prevInTimes= [[NSMutableArray alloc] init];
    NSMutableArray *prevOutTimes= [[NSMutableArray alloc] init];
    NSString *timeOut;
    NSString *timeIn;
    
    double totalSecondsWorkedThatDay;
   
    for(EmployeeAction *a in hours){
        double d = [a.timeInitiated doubleValue];
        NSTimeInterval *day = &d;
        NSString *theDay = [self getDay:day];
        NSString *theYear = [a.year stringValue];
        NSString *theMonth = [self getMonthForSeconds:day];
        timeIn =[self getHours:day];
        NSString *theInDate = [NSString stringWithFormat:@"                  IN:       %@/%@/%@  %@                ",theMonth,theDay,theYear,timeIn];
        [ins addObject:theInDate];
        totalSecondsWorkedThatDay =[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
        [prevInTimes addObject:[NSNumber numberWithDouble:totalSecondsWorkedThatDay]];

         d = [a.employeeOut.timeInitiated doubleValue];
        day = &d;
        theDay = [self getDay:day];
        theYear = [a.employeeOut.year stringValue];
        theMonth = [self getMonthForSeconds:day];
        timeOut =[self getHours:&d];
    
        NSString *theOutDate = [NSString stringWithFormat:@"OUT:       %@/%@/%@  %@       ",theMonth,theDay,theYear,timeOut];
        [outs addObject:theOutDate];
    
    }
  
    for (int i = 0; i <[outs count]; i++) {
        NSArray *times = [prevInTimes arrayByAddingObjectsFromArray:prevOutTimes];
        totalSecondsWorkedThatDay = [[times objectAtIndex:i] doubleValue];
        
        NSString *msg = [[ins objectAtIndex:i] stringByAppendingString:[outs objectAtIndex:i]];
        NSString *dayHours = [NSString stringWithFormat:@"                %f hours",totalSecondsWorkedThatDay/(60*60)];
        msg = [msg stringByAppendingString:dayHours];
        [clockedInDate addObject:msg];
        [self sortArrayNumerically:clockedInDate];
    }

}
-(void)sortArrayNumerically:(NSMutableArray *)array{
    [array sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:(NSNumericSearch)];
    }];
}
-(void)defaultSound{
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"click1"] ofType:@"wav"]] error:nil];
    [audioPlayer setDelegate:self];
    //[audioPlayer setVolume:0.9];
    
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}
-(void)failSound{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"error"] ofType:@"wav"]] error:nil];
    [audioPlayer setDelegate:self];
    [audioPlayer setVolume:0.09];
    
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}
@end
