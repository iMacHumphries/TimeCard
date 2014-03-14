//
//  LoginViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/13/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Employees.h"
#import "EmployeeAction.h"
@interface LoginViewController : UIViewController{
    NSMutableArray *pinArray;
}
- (IBAction)pinButton:(UIButton *)sender;
- (IBAction)deleteButton:(UIButton *)sender;
@property (retain,nonatomic) NSMutableArray *pinArray;
@property (weak, nonatomic) IBOutlet UIImageView *indicator1;
@property (weak, nonatomic) IBOutlet UIImageView *indicator2;
@property (weak, nonatomic) IBOutlet UIImageView *indicator3;
@property (weak, nonatomic) IBOutlet UIImageView *indicator4;



@end
