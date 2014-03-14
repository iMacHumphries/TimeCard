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
@interface CreateEmployeeViewController : UIViewController<UITextFieldDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
