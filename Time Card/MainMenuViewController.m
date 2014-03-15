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
    if([self getLastIn]==NULL){
        return @"No Actions";
    }
    if([self clockedIn]){
        return [NSString stringWithFormat:@"Clocked in @ %@ " , [self getLastAction]];
    }else{
        return [NSString stringWithFormat:@"Clocked out @ %@", [self getLastAction]];

    }
}
-(EmployeeAction *)getLastIn{
    if([employee.employeesToAction count]==0){
        return NULL;
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
    
    return currentAction;
}
-(NSString *)getLastAction{
    EmployeeAction *lastIn=[self getLastIn];
    if (lastIn==NULL) {
        return @"Never";
    }
    if (lastIn.employeeOut!=NULL) {
        NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:[lastIn.employeeOut.timeInitiated doubleValue]];
        
        return [NSDateFormatter localizedStringFromDate:theDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle];
    }else{
        NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:[lastIn.timeInitiated doubleValue]];

    return [NSDateFormatter localizedStringFromDate:theDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle];
    }
}
-(BOOL)clockedIn{
    EmployeeAction *lastIn=[self getLastIn];
    if(lastIn==NULL){
        return false;
    }
 
    if(lastIn.employeeOut==NULL){
        return true;
    }else{
        return false;
    }
}
- (IBAction)clockInOutButton:(UIButton *)sender {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

   
    

    if([self clockedIn]){
      
        EmployeeActionOut *action = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"EmployeeActionOut"
                                     inManagedObjectContext:context];
        [action setValue:@"out" forKey:@"type"];
        [action setValue:@"March" forKey:@"month"];
        [action setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timeInitiated"];
        [[self getLastIn] setEmployeeOut:action];


    }else{
        EmployeeAction *action = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"EmployeeAction"
                                  inManagedObjectContext:context];
        [action setValue:@"in" forKey:@"type"];
        [action setValue:@"March" forKey:@"month"];
        [action setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timeInitiated"];
        [employee addEmployeesToActionObject:action];
    }
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    lastLoginLabel.text = [self getSatus];

    
}


-(NSString *)getRandomPraise{
    
    int i = arc4random()%[praise count];
    NSString *string = [praise objectAtIndex:i];
    return string;
}
@end
