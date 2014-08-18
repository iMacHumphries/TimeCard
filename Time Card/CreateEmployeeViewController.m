//
//  CreateEmployeeViewController.m
//  Time Card
//
//  Created by Benjamin Humphries on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "CreateEmployeeViewController.h"
#import "MainMenuViewController.h"
#import "DatabaseManager.h"
@interface CreateEmployeeViewController ()

@end

@implementation CreateEmployeeViewController
@synthesize nameTextField;
@synthesize wageTextField;
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
    nameTextField.delegate = self;
    wageTextField.delegate=self;
    [self generateUniquePinNumber];
    [nameTextField becomeFirstResponder];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Adding Employee" message:[NSString stringWithFormat:@"Adding employee with the name %@. And wage %@",nameTextField.text,wageTextField.text] delegate:self cancelButtonTitle:@"No wait!" otherButtonTitles:@"Add Employee", nil];
    alert.delegate = self;
    [alert show];
    
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Add Employee"]){
        /*
         
         
         */
        Employee *added=[[DatabaseManager sharedManager] insertEmployee:nameTextField.text hourlyWageInCents:(int)([wageTextField.text floatValue]*100) admin:0];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Succes" message:[NSString stringWithFormat:@"Employee Successfully added with pin %@. They will get paid %d cents an hour", [added getPin], [added getCentEarned]] delegate:NULL cancelButtonTitle:@"OK!" otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
        
            }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"sequeu is happening");
    MainMenuViewController *controller = segue.destinationViewController;
    controller.employee=(Employees *)sender;
}
- (IBAction)cancelButton:(UIButton *)sender {
    [self defaultSound];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSString *)generateUniquePinNumber{
    bool unique=false;
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

    while(unique==false){
        int x1 = arc4random()%10;
        int x2 = arc4random()%10;
        int x3 = arc4random()%10;
        int x4 = arc4random()%10;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Employees" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        pin = [NSString stringWithFormat:@"%i%i%i%i",x1,x2,x3,x4];

        NSPredicate *pred=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"pin like '%@'", pin]];
        [fetchRequest setPredicate:pred];
        NSError *error;

        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        unique=[fetchedObjects count]==0;
    
    }
    [self checkPin:pin];

    
    return pin;
}
-(void)checkPin:(NSString *)checkPin {

    if ([pin isEqualToString:nil]){  //if pin == to another pin
        [self generateUniquePinNumber];
    }

}
-(void)defaultSound{
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"click1"] ofType:@"wav"]] error:nil];
    [audioPlayer setDelegate:self];
    //[audioPlayer setVolume:0.9];
    
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}
@end
