//
//  CreateEmployeeViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeAction.h"
#import "Employee.h"
@interface CreateEmployeeViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    NSString *pin;
    NSString *name;
}
- (IBAction)cancelButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
