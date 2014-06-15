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
    NSURL *url = [NSURL URLWithString:[self.selectedMovie poster]];
    self.title = [self.selectedMovie title];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __weak MovieDetailsViewController* weakSelf = self;
    [self.moviePosterImageView setImageWithURLRequest: request
                                placeholderImage:nil
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             
                                    weakSelf.moviePosterImageView.image = image;
                                    weakSelf.moviePosterImageView.alpha = 0;
                                    [UIView beginAnimations:@"fade in" context:nil];
                                    [UIView setAnimationDuration:2.0];
                                    weakSelf.moviePosterImageView.alpha = 1;
                                    [UIView commitAnimations];
                                           
                                }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                             
                                }
     ];

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
