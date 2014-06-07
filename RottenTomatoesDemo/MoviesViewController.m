//
//  MoviesViewController.m
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/4/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailsViewController.h"
#import <MBProgressHUD.h>
#import "Movie.h"

@interface MoviesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSArray *moviesArr;

@end

@implementation MoviesViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.dimBackground = YES;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    self.HUD.delegate = self;
    self.HUD.labelText = @"Loading..";
    [self.HUD show:TRUE];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id apiResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        NSMutableArray* mutableMovieList = [[ NSMutableArray alloc ] initWithCapacity: 5];
        for(id mv in [apiResponse valueForKey:@"movies"]){
            Movie* movieTemp = [[Movie alloc] initWithRottenTomatoesAPIResponse:mv];
            [mutableMovieList addObject: movieTemp];
        }
        self.moviesArr = [NSArray arrayWithArray:mutableMovieList];
        
        [self.moviesTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.moviesArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MovieCell";
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
       // cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Movie *currMovie = [self.moviesArr objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [currMovie title];
    cell.synopsisLabel.text = [currMovie synopsis];
    
    
    NSURL *url = [NSURL URLWithString:[currMovie thumbnail]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak MovieCell *weakCell = cell;
    
    [cell.posterImageView setImageWithURLRequest: request
                          placeholderImage:nil
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                              
                              weakCell.posterImageView.image = image;
                              [self.HUD hide:TRUE];

                          }
                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                              NSLog(@"Failed!");
                              [self.HUD hide:TRUE];

                          }
     ];
    
    //[cell.posterImageView setImageWithURL:url];
    
    //cell.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageData valueForKey:@"thumbnail"]]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"selected movie row index: %d" , indexPath.row);
    
    MovieDetailsViewController *movieDetailsController = [[MovieDetailsViewController alloc] init];
    
    Movie *selectedMovie = [self.moviesArr objectAtIndex:indexPath.row];
    
    [movieDetailsController setSelectedMovie:selectedMovie];
    
    [self.navigationController pushViewController:movieDetailsController animated:YES];

}

@end
