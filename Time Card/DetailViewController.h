//
//  DetailViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/16/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RemoveEmployeeViewController;
@interface DetailViewController : UIViewController{
    RemoveEmployeeViewController *remEmployeeViewController;
    NSString *pin;
    NSString *name;
    
}
@property (nonatomic,retain)RemoveEmployeeViewController *remEmployeeViewController;
@property (nonatomic) int detailIndex;
@end
