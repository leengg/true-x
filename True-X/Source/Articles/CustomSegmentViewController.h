//
//  CustomSegmentViewController.h
//  True-X
//
//  Created by Dao Nguyen on 5/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSegmentViewController;

@protocol CustomSegmentDelegate <NSObject>

@required
- (void)customSegment:(CustomSegmentViewController *)customSegmentVC didSelectIndex:(int)index;

@end


@interface CustomSegmentViewController : UIViewController

@property (nonatomic, weak) id <CustomSegmentDelegate> delegate;

- (void)selectIndex:(int)index;
- (int)getCurrentIndex;

@end
