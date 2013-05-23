//
//  CustomSegmentViewController.m
//  True-X
//
//  Created by Dao Nguyen on 5/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "CustomSegmentViewController.h"

@interface CustomSegmentViewController () {

    __weak IBOutlet UIButton *btn_PhongDo;
    __weak IBOutlet UIButton *btn_DangCap;
    __weak IBOutlet UIButton *btn_ChuyenBenLe;
    __weak IBOutlet UIButton *btn_TuVan;
    
    UIButton *currentButton;
}

@end

@implementation CustomSegmentViewController

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
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [btn_PhongDo setImage:[UIImage imageNamed:@"bt_phongdo_selected.png"] forState:UIControlStateNormal];
    currentButton = btn_PhongDo;
    [self.delegate customSegment:self didSelectIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickChangeTab:(id)sender {
    
    if (currentButton != sender) {
        
        [self setActiveTab:sender];
    }
}

- (void)setActiveTab:(id)sender
{
    [btn_PhongDo setImage:nil forState:UIControlStateNormal];
    [btn_DangCap setImage:nil forState:UIControlStateNormal];
    [btn_ChuyenBenLe setImage:nil forState:UIControlStateNormal];
    [btn_TuVan setImage:nil forState:UIControlStateNormal];

    if (sender == btn_PhongDo) {
        [btn_PhongDo setImage:[UIImage imageNamed:@"bt_phongdo_selected.png"] forState:UIControlStateNormal];
        currentButton = btn_PhongDo;
        [self.delegate customSegment:self didSelectIndex:0];
    }
    else if (sender == btn_DangCap) {
        [btn_DangCap setImage:[UIImage imageNamed:@"bt_dangcap_selected.png"] forState:UIControlStateNormal];
        currentButton = btn_DangCap;
        [self.delegate customSegment:self didSelectIndex:1];
    }
    else if (sender == btn_ChuyenBenLe) {
        [btn_ChuyenBenLe setImage:[UIImage imageNamed:@"bt_chuyenbenle_selected.png"] forState:UIControlStateNormal];
        currentButton = btn_ChuyenBenLe;
        [self.delegate customSegment:self didSelectIndex:2];
    }
    else if (sender == btn_TuVan) {
        [btn_TuVan setImage:[UIImage imageNamed:@"bt_tuvan_selected.png"] forState:UIControlStateNormal];
        currentButton = btn_TuVan;
        [self.delegate customSegment:self didSelectIndex:3];
    }
    else {
        
    }
}

- (void)viewDidUnload {
    btn_PhongDo = nil;
    btn_DangCap = nil;
    btn_ChuyenBenLe = nil;
    btn_TuVan = nil;
    [super viewDidUnload];
}
@end
