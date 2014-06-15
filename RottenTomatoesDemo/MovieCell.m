//
//  MovieCell.m
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/4/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "MovieCell.h"
#import "MovieDetailsViewController.h"
#import "MoviesViewController.h"

@implementation MovieCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  //  [super setSelected:selected animated:animated];
    if(selected){
        [self setBackgroundColor:[UIColor yellowColor]];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        [self setBackgroundColor:[UIColor whiteColor]];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    

}


@end
