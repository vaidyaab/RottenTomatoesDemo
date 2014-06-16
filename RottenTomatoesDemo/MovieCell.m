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
#import "UIImageView+AFNetworking.h"

@interface MovieCell ()
    @property (strong, nonatomic) IBOutlet UIImageView *posterImageView;
    @property (strong, nonatomic) IBOutlet UILabel *titleLabel;
    @property (strong, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation MovieCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id) initWithMovie:(Movie*) selectedMovie progressBar:(MBProgressHUD*) progressBarParam {
    
    self = [super init];
    
    self.titleLabel.text = [selectedMovie title];
    self.synopsisLabel.text = [selectedMovie synopsis];
    
    if(selectedMovie.cachedThumbnail){
        
        NSLog(@"loading from memory");
        [self.posterImageView setImage:[UIImage imageWithData:selectedMovie.cachedThumbnail]];
        
    }else{
        
        NSURL *url = [NSURL URLWithString:[selectedMovie thumbnail]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
        [request setHTTPShouldHandleCookies:NO];
        [request setHTTPShouldUsePipelining:YES];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        __weak MovieCell *weakCell = self;
        [self.posterImageView setImageWithURLRequest: request
                                    placeholderImage:nil
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 
                                                 CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
                                                 NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
                                                 [selectedMovie setCachedThumbnail:data];
                                                 
                                                 weakCell.posterImageView.image = image;
                                                 
                                                 weakCell.posterImageView.alpha = 0;
                                                 [UIView beginAnimations:@"fade in" context:nil];
                                                 [UIView setAnimationDuration:2.0];
                                                 weakCell.posterImageView.alpha = 1;
                                                 [UIView commitAnimations];
                                                 
                                                 [progressBarParam hide:TRUE];
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 
                                                 [progressBarParam hide:TRUE];
                                                 
                                             }
         ];
    }
    
    

    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  //  [super setSelected:selected animated:animated];
    if(selected){
        [self setBackgroundColor:[UIColor colorWithRed:192/255.0f green:209/255.0f blue:229/255.0f alpha:1.0f]];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else{
        [self setBackgroundColor:[UIColor whiteColor]];
        self.accessoryType = UITableViewCellAccessoryNone;

    }
    

}


@end
