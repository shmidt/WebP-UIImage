//
//  NEViewController.h
//  iOS WebP Alpha Example
//
//  Created by Gabrielle on 3/16/13.
//  Copyright (c) 2013 Nyteshade Enterprises. All rights reserved.
//
// Modified (encoding added) by Dmitry Shmidt, mail@shmidtlab.com

#import <UIKit/UIKit.h>
#import "UIImage+WebP.h"

@interface NEViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIImageView *topLayer;

@end
