//
//  MainMenuViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employees.h"
#import "EmployeeAction.h"
@interface MainMenuViewController : UIViewController{
}

@property (nonatomic, retain) Employees *employee;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLoginLabel;
@property (weak, nonatomic) IBOutlet UIButton *clockInOutButton;

- (IBAction)clockInOutButton:(UIButton *)sender;
@end
