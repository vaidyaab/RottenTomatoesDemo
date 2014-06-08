//
//  MovieDetailsViewController.m
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/5/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"

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
    
    self.movieTitleLabel.text =  [self.selectedMovie title];
    self.movieSynopsisLabel.text = [self.selectedMovie synopsis];
    //NSLog(@"poster URL for: %@ is -> %@",[self.selectedMovie title],[self.selectedMovie poster]);
    NSURL *url = [NSURL URLWithString:[self.selectedMovie poster]];
    [self.moviePosterImageView setImageWithURL:url];
    self.title = [self.selectedMovie title];
    //self.movieSynopsisScrollView.contentSize =CGSizeMake(320, 700);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.movieSynopsisScrollView layoutIfNeeded];
    self.movieSynopsisScrollView.contentSize = self.contentView.bounds.size;
    
}

@end
