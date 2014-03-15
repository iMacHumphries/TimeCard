//
//  MainMenuViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Employees.h"
#import "EmployeeAction.h"
#import "EmployeeActionOut.h"
@interface MainMenuViewController : UIViewController{
    NSArray *praise;
}

@property (nonatomic, retain) Employees *employee;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLoginLabel;
@property (weak, nonatomic) IBOutlet UIButton *clockInOutButton;

- (IBAction)clockInOutButton:(UIButton *)sender;
@end
