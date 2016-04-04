//
//  LaunchViewController.m
//  EmoTrain
//
//  Created by Christina Tsangouri on 3/23/16.
//  Copyright © 2016 Christina Tsangouri. All rights reserved.
//

#import "LaunchView.h"

@interface LaunchView ()

@end



@implementation LaunchView


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.LaunchImage setImage:[UIImage imageNamed:@"launchscreen.jpg"]];
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
