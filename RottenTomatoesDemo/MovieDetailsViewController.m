//
//  MovieDetailsViewController.m
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/5/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController ()


@end

@implementation MovieDetailsViewController

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
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.movieTitleLabel.text = [defaults objectForKey:@"MOVIE_TITLE"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
