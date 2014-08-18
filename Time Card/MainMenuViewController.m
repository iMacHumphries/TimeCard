//
//  MainMenuViewController.m
//  Time Card
//
//  Created by Benjamin Humphries on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "MainMenuViewController.h"
#import "DatabaseManager.h"
@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize employee;
@synthesize welcomeLabel;
@synthesize lastLoginLabel;
@synthesize clockInOutButton;
@synthesize addEmployeeButton;
@synthesize manageEmployees;
@synthesize emailTimeSheetButton;
@synthesize audioPlayer;

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
    NSDate *Date=[self getDateFor8AM];
    NSLog(@"date is %@", Date);
    if([self dateBeforeEightAM:[NSDate date]]){
        NSLog(@"date is before %@", [self getDateFor8AM]);
    }
    
    praise = [[NSArray alloc] initWithObjects:@"Awesome",@"Fantastic",@"Great",@"Ok",@"Sweet",@"Have A Great Day!", nil];
    welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@",[employee getName]];
    lastLoginLabel.text = [NSString stringWithFormat:@"Last %@",[self getSatus]];
    
    if ([[DatabaseManager sharedManager] isCheckedIn:employee]){
        [clockInOutButton setTitle:@"Clock Out" forState:UIControlStateNormal];
    }
    else {
        [clockInOutButton setTitle:@"Clock In" forState:UIControlStateNormal];

    }
    if([employee isAdmin]==TRUE){
        manageEmployees.hidden=false;
        addEmployeeButton.hidden=false;
        emailTimeSheetButton.hidden=false;
    }
    NSLog(@"Start");
    //[[DatabaseManager sharedManager] insertPayPeriodWithStartDate:[[NSDate date] dateByAddingTimeInterval:-((30*24)*60*60)]  endDate:[NSDate date]];
    NSLog(@"End");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)getSatus{
    NSMutableDictionary *data=[[DatabaseManager sharedManager] getLastKnownActionForEmployee:employee];
    if(data==NULL){
        return @"No Actions";
    }
    if([[data objectForKey:@"LastAction"] isEqualToString:@"ClockedIn"]){
        return [NSString stringWithFormat:@"Clocked in @ %@ ",[self getFormattedDateForLong:[[data objectForKey:@"LastTime"] longLongValue]]];
    }else{
        return [NSString stringWithFormat:@"Clocked out @ %@ " , [self getFormattedDateForLong:[[data objectForKey:@"LastTime"] longLongValue]]];
    }
}
-(EmployeeAction *)getLastIn{
   /* if([employee.employeesToAction count]==0){
        return NULL;
    }
    EmployeeAction *currentAction;
    NSLog(@"Count is %d", [employee.employeesToAction count]);
    for(EmployeeAction *action in employee.employeesToAction) {
        if(currentAction==NULL){
            NSLog(@"Current action is null %@", action.timeInitiated);
            currentAction=action;
        }else{
            if([currentAction.timeInitiated doubleValue]<[action.timeInitiated doubleValue]){
               // NSLog(@"Current action is less than before:%@ After:%@",currentAction.timeInitiated ,action.timeInitiated);

                currentAction=action;
            }
        }
    }
   // NSLog(@"Found this %@ found time out %@", currentAction.timeInitiated, currentAction.employeeOut.timeInitiated);
    */
    return NULL;
}

-(NSString *)getFormattedDateForLong:(long long)time{
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [NSDateFormatter localizedStringFromDate:theDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle];

}
-(BOOL)clockedIn{
    return [[DatabaseManager sharedManager] isCheckedIn:employee];
}
- (IBAction)addEmployeeButton:(UIButton *)sender {
    //Admin Only
    [self defaultSound];
    [self performSegueWithIdentifier:@"ViewPayPeriods" sender:sender];
    
}
- (IBAction)cancelButton:(UIButton *)sender {
   // [self dismissViewControllerAnimated:YES completion:nil];
    [self defaultSound];
     [self performSegueWithIdentifier:@"backToLogin" sender:nil];
}

- (IBAction)emailButton:(UIButton *)sender {
    [self defaultSound];
    [self email];
}

- (IBAction)manageEmployeeButton:(UIButton *)sender {
    
    [self defaultSound];
       
}
- (IBAction)clockInOutButton:(UIButton *)sender {
   
    [self clockSound];
    
    BOOL error=false;

    if([self clockedIn]){
      
        if([[DatabaseManager sharedManager]clockOut:employee]){
            
        }else{
            error=true;
        }
        /*NSLog(@"Clocked out");
        if([[self getLastIn].timeInitiated intValue]>[[NSDate date] timeIntervalSince1970]){
            [context deleteObject:[self getLastIn]];
        }else{
        EmployeeActionOut *action = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"EmployeeActionOut"
                                     inManagedObjectContext:context];
        [action setValue:@"out" forKey:@"type"];
        [action setValue:[self getCurrentMonth] forKey:@"month"];
        [action setValue:[self getCurrentYear] forKey:@"year"];
        [action setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timeInitiated"];
        [[self getLastIn] setEmployeeOut:action];
        }*/
  
    
    }
    else{
        NSLog(@"Clocked in");
        if([[DatabaseManager sharedManager]clockIn:employee]){
            
        }else{
            error=true;
        }

       /* EmployeeAction *action = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"EmployeeAction"
                                  inManagedObjectContext:context];
        [action setValue:@"in" forKey:@"type"];
        [action setValue:[self getCurrentMonth] forKey:@"month"];
        [action setValue:[self getCurrentYear] forKey:@"year"];
        action.archived=[NSNumber numberWithBool:false];
        if([self dateBeforeEightAM:[NSDate date]]){
            [action setValue:[NSNumber numberWithDouble:[[self getDateFor8AM] timeIntervalSince1970]] forKey:@"timeInitiated"];

        }else{
            [action setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timeInitiated"];
            
        }*/
        //doclock in stuff here
    }
   
    lastLoginLabel.text = [self getSatus];
    
    if(error){
        
    }else{
        NSString *clocked = [[clockInOutButton titleLabel]text];
    
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Successfully %@",clocked] message:[NSString stringWithFormat:@"%@ was successfully %@",[employee getName],[self getSatus]] delegate:self cancelButtonTitle:[self getRandomPraise] otherButtonTitles:nil, nil];
        [alert show];
    
        [self performSegueWithIdentifier:@"backToLogin" sender:nil];
    }
}



-(BOOL)dateBeforeEightAM:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH"];
    
   
    
    NSString *dateString = [format stringFromDate:date];
    
    if([dateString intValue]<8){
        return true;
    }
    
    /*NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"MMM dd, yyyy"];
    
    NSDate *parsed = [inFormat dateFromString:dateString];
     */
    return false;
}
-(NSDate *)getDateFor8AM{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone systemTimeZone];
    format.locale=[NSLocale systemLocale];
    [format setDateFormat:@"L dd yyyy"];
    NSString *curDate=[format stringFromDate:[NSDate date]];
    
    [format setDateFormat:@"L dd yyyy HH"];
    NSLog(@"formatting this date %@", curDate);
    NSDate *parsed = [format dateFromString:[NSString stringWithFormat:@"%@ 08",curDate]];
    
   

    return parsed;

}
-(NSString *)getRandomPraise{
    
    int i = arc4random()%[praise count];
    NSString *string = [praise objectAtIndex:i];
    return string;
}
-(void)email{
    
    
    EmailMessage *em = [[EmailMessage alloc] init];

    MFMailComposeViewController *mViewController = [[MFMailComposeViewController alloc] init];
    mViewController.mailComposeDelegate = self;
    [mViewController setSubject:@"TIME_CARD"];
    [mViewController setMessageBody:[NSString stringWithFormat:@"%@",[em getMessage]] isHTML:NO];
    
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    NSString *dbDestination= [doumentDirectoryPath stringByAppendingPathComponent:@"timecardsv1.0.01.sqlite3"];
    [mViewController addAttachmentData:[NSData dataWithContentsOfFile:dbDestination] mimeType:@"file/sql" fileName:@"Backup.sql"];

    
    
    [self presentViewController:mViewController animated:YES completion:^{
        
       
    }];


     }
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [a show];
            break;
       
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
-(void)startNewPayPeriod{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeAction" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *pred=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"archived == 0"]];
    [fetchRequest setPredicate:pred];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:NULL];
    for (EmployeeAction *info in fetchedObjects) {
        info.archived=[NSNumber numberWithBool:TRUE];
        // NSManagedObject *details = [info valueForKey:@"details"];
        // NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
    }

}
-(void)clockSound{
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"unlock"] ofType:@"wav"]] error:nil];
    [audioPlayer setDelegate:self];
    //[audioPlayer setVolume:0.9];
    
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
}
-(void)defaultSound{
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"click1"] ofType:@"wav"]] error:nil];
    [audioPlayer setDelegate:self];
    //[audioPlayer setVolume:0.9];
    
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}
@end
