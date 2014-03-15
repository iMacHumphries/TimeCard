//
//  CreateEmployeeViewController.m
//  Time Card
//
//  Created by Benjamin Humphries on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "CreateEmployeeViewController.h"
#import "MainMenuViewController.h"

@interface CreateEmployeeViewController ()

@end

@implementation CreateEmployeeViewController
@synthesize nameTextField;

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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Adding Employee" message:[NSString stringWithFormat:@"Adding employee with the name %@.",textField.text] delegate:self cancelButtonTitle:@"No wait!" otherButtonTitles:@"Add Employee", nil];
    alert.delegate = self;
    [alert show];
    
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Add Employee"]){
        [self performSegueWithIdentifier:@"createToMain" sender:NULL];
        
            }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"sequeu is happening");
    MainMenuViewController *controller = segue.destinationViewController;
    controller.employee=(Employees *)sender;
}
- (IBAction)cancelButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"createToMain" sender:nil];
}
-(NSString *)generateUniquePinNumber{
    int x1 = arc4random()%10;
    int x2 = arc4random()%10;
    int x3 = arc4random()%10;
    int x4 = arc4random()%10;
    
    
    pin = [NSString stringWithFormat:@"%i%i%i%i",x1,x2,x3,x4];
    [self checkPin:pin];

    return pin;
}
-(void)checkPin:(NSString *)checkPin {

    if ([pin isEqualToString:nil]){  //if pin == to another pin
        [self generateUniquePinNumber];
    }

}
@end
