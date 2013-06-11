//
//  CustomSegmentViewController.m
//  True-X
//
//  Created by Dao Nguyen on 5/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "CustomSegmentViewController.h"

@interface CustomSegmentViewController () {

    __weak IBOutlet UIImageView *menuBGImageView;
    __weak IBOutlet UIButton *btn_PhongDo;
    __weak IBOutlet UIButton *btn_DangCap;
    __weak IBOutlet UIButton *btn_ChuyenBenLe;
    __weak IBOutlet UIButton *btn_TuVan;
    
    UIButton *currentButton;
    int currentIndex;
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
    if (IS_IPAD) {
        [menuBGImageView setImage:[UIImage imageNamed:@"menu1_ipad.png"]];
    }
    else {
        [menuBGImageView setImage:[UIImage imageNamed:@"menu_1.png"]];
    }
    currentButton = btn_PhongDo;
    currentIndex = 0;
    [self.delegate customSegment:self didSelectIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectIndex:(int)index {
    
    switch (index) {
        case 0:
            [self setActiveTab:btn_PhongDo];
            break;
        case 1:
            [self setActiveTab:btn_DangCap];
            break;
        case 2:
            [self setActiveTab:btn_ChuyenBenLe];
            break;
        case 3:
            [self setActiveTab:btn_TuVan];
            break;
        default:
            break;
    }
}

- (int)getCurrentIndex {
    
    return currentIndex;
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
        if (IS_IPAD) {
            [menuBGImageView setImage:[UIImage imageNamed:@"menu1_ipad.png"]];
        }
        else {
            [menuBGImageView setImage:[UIImage imageNamed:@"menu_1.png"]];
        }
        currentButton = btn_PhongDo;
        currentIndex = 0;
        [self.delegate customSegment:self didSelectIndex:0];
    }
    else if (sender == btn_DangCap) {
        if (IS_IPAD) {
            [menuBGImageView setImage:[UIImage imageNamed:@"menu2_ipad.png"]];
        }
        else {
            [menuBGImageView setImage:[UIImage imageNamed:@"menu_2.png"]];
        }
        currentButton = btn_DangCap;
        currentIndex = 1;
        [self.delegate customSegment:self didSelectIndex:1];
    }
    else if (sender == btn_ChuyenBenLe) {
        if (IS_IPAD) {
            [menuBGImageView setImage:[UIImage imageNamed:@"menu3_ipad.png"]];
        }
        else {
            [menuBGImageView setImage:[UIImage imageNamed:@"menu_3.png"]];
        }
        currentButton = btn_ChuyenBenLe;
        currentIndex = 2;
        [self.delegate customSegment:self didSelectIndex:2];
    }
    else if (sender == btn_TuVan) {
        if (IS_IPAD) {
            [menuBGImageView setImage:[UIImage imageNamed:@"menu4_ipad.png"]];
        }
        else {
            [menuBGImageView setImage:[UIImage imageNamed:@"menu_4.png"]];
        }
        currentButton = btn_TuVan;
        currentIndex = 3;
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
    menuBGImageView = nil;
    [super viewDidUnload];
}
@end
