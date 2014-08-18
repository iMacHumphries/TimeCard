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
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface CreateEmployeeViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>{
    NSString *pin;
    NSString *name;
     AVAudioPlayer* audioPlayer;
}
- (IBAction)cancelButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain,nonatomic) AVAudioPlayer* audioPlayer;
@property (weak, nonatomic) IBOutlet UITextField *wageTextField;

@end
