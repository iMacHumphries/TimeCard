//
//  LoginViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/13/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController{
    NSMutableArray *pinArray;
}
- (IBAction)pinButton:(UIButton *)sender;
- (IBAction)deleteButton:(UIButton *)sender;
@property (retain,nonatomic) NSMutableArray *pinArray;



@end
