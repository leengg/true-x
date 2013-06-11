//
//  UIRotationNavigationController.m
//  True-X
//
//  Created by InfoNam on 6/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "UIRotationNavigationController.h"

@interface UIRotationNavigationController ()

@end

@implementation UIRotationNavigationController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [[UIRotationManager sharedInstance] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[UIRotationManager sharedInstance] supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [[UIRotationManager sharedInstance] shouldAutorotate];
}

@end
