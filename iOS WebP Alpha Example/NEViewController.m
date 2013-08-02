//
//  NEViewController.m
//  iOS WebP Alpha Example
//
//  Created by Gabrielle on 3/16/13.
//  Copyright (c) 2013 Nyteshade Enterprises. All rights reserved.
//
// Modified (encoding added) by Dmitry Shmidt, mail@shmidtlab.com

#import "NEViewController.h"
#import "UIImage+WebP.h"

@implementation NEViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Load the webp image for the background. Image comes from
  // http://wallpapersget.com/art-wallpaper-stores-water-best-ofthe-week-albums
  //
    _background.image = [UIImage imageWithWebPAtPath:@"background0.webp"];
  
  // Load the webp image for the top layer. Image comes from
  // http://www.officialpsds.com/Rusty-Sign-PSD19143.html
  //
  _topLayer.image = [UIImage imageWithWebPAtPath:@"layer0.webp"];  
}
- (void)viewDidAppear:(BOOL)animated{
    UIImage *tmpImage = [UIImage imageNamed:@"background0"];
    [tmpImage writeWebPToDocumentsWithFileName:@"background1" quality:100];
    [tmpImage writeWebPLosslessToDocumentsWithFileName:@"background2"];

//    NSString *webpPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/background0.webp"]];
//    NSData *imgData = [tmpImage dataWebPWithQuality:100];
//    [imgData writeToFile:webpPath atomically:YES];

}

@end
