//
//  MovieCell.h
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/4/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import <MBProgressHUD.h>

@interface MovieCell : UITableViewCell
- (id) initWithMovie: (Movie*) selectedMovie progressBar:(MBProgressHUD*) progressBarParam;
@end
