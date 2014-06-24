//
//  LoginViewController.m
//  Time Card
//
//  Created by Benjamin Humphries on 3/13/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize pinArray;
@synthesize indicator1,indicator2,indicator3,indicator4;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           }
    return self;
}

- (void)viewDidLoad
{
    textFieldAlert = false;
    pinArray = [[NSMutableArray alloc]init];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addPinToArray:(NSInteger)pinNumber{
    NSString *string =[NSString stringWithFormat:@"%i",pinNumber];
    [pinArray addObject:string];
    if ([pinArray count] == 4){
    }
}
-(void)removeLastPinFromArray{
    [pinArray removeLastObject];
}

- (IBAction)pinButton:(UIButton *)sender {
    [self addPinToArray:sender.tag];
    [self changeIndicators];
}
- (IBAction)deleteButton:(UIButton *)sender {
    [self removeLastPinFromArray];
    [self changeIndicators];
}

- (IBAction)questionButton:(UIButton *)sender {
     textFieldAlert = false;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Forgot Pin Number?" message:@"Please ask Mrs. Mays for help! " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
   
}


-(void)checkEmployeePin{
    
    //if Correct pin
    [self performSegueWithIdentifier:@"mainMenu" sender:nil];
    
}
-(void)changeIndicators{
    UIImage *fill = [UIImage imageNamed:@"filledIndicator"];
    
    if ([pinArray count]== 0) {
        [self allIndicatorsBlank];
    }
   else if ([pinArray count]== 1) {
       [self allIndicatorsBlank];
        [indicator1 setImage:fill];
    }
   else if ([pinArray count]== 2) {
       [self allIndicatorsBlank];
       [indicator1 setImage:fill];
       [indicator2 setImage:fill];
       
       
   }
   else if ([pinArray count]== 3) {
       [self allIndicatorsBlank];
       [indicator1 setImage:fill];
       [indicator2 setImage:fill];
       [indicator3 setImage:fill];
       
   }

   else if ([pinArray count]== 4) {
       [indicator1 setImage:fill];
       [indicator2 setImage:fill];
       [indicator3 setImage:fill];
       [indicator4 setImage:fill];
       Employees *rightPin=[self checkPin];
       if(rightPin!=NULL){
           [self performSegueWithIdentifier:@"mainMenu" sender:rightPin];
       }else{
           [self clearArrayAndIndicators];
           [self shakeView:indicator1];
           [self shakeView:indicator2];
           [self shakeView:indicator3];
           [self shakeView:indicator4];
       }

         }

}
-(Employees *)checkPin{
    NSString *pinNumber=[pinArray componentsJoinedByString:@""];
    NSLog(@"String %@", pinNumber);
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError *error;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Employees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *pred=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"pin like '%@'", pinNumber]];
    [fetchRequest setPredicate:pred];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Employees *info in fetchedObjects) {
        return info;
           }
    
    return NULL;
    
}

-(void)allIndicatorsBlank{
    [indicator1 setImage:[UIImage imageNamed:@"blankIndicator"]];
    [indicator2 setImage:[UIImage imageNamed:@"blankIndicator"]];
    [indicator3 setImage:[UIImage imageNamed:@"blankIndicator"]];
    [indicator4 setImage:[UIImage imageNamed:@"blankIndicator"]];

}
-(void)clearArrayAndIndicators{
    [self allIndicatorsBlank];
    pinArray = [[NSMutableArray alloc] init];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MainMenuViewController *controller=segue.destinationViewController;
    controller.employee=(Employees *)sender;
}

-(void)shakeView:(UIImageView *)view {
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(view.center.x - 25,view.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(view.center.x + 25, view.center.y)]];
    [view.layer addAnimation:shake forKey:@"position"];
}

-(void)addPam{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Employees *employ = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Employees"
                                       inManagedObjectContext:context];
    
    employ.pin=@"1234";
    employ.name=@"Pam Mays";
    employ.admin=[NSNumber numberWithBool:TRUE];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    

   }
- (IBAction)admin:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TroubleShooting" message:@"Enter admin password:" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    textFieldAlert = true;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (textFieldAlert){
    if ( [[alertView textFieldAtIndex:0].text isEqualToString:@"1234"]){
        [self addPam];
    }
    }
}
@end
