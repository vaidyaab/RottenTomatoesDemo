//
//  MovieDetailsViewController.h
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/5/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (strong, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *movieSynopsisScrollView;
@property (strong, nonatomic) Movie *selectedMovie;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end
