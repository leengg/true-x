//
//  ProductDetailViewController.m
//  True-X
//
//  Created by InfoNam on 5/14/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailPageViewController.h"
#import "ProductDetailPage2ViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

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
    ProductDetailPage2ViewController *productDetailPageVC = [[ProductDetailPage2ViewController alloc] initWithNibName:@"ProductDetailPage" bundle:nil];
    [self.view addSubview:productDetailPageVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swipeLeft:(id)sender {
    
    NSLog(@"Swipe Left: %@", [sender description]);
}

- (IBAction)swipeRight:(id)sender {
    
    NSLog(@"Swipe Right: %@", [sender description]);
}
@end
