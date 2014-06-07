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

@interface MoviesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *moviesTableView;
@property MBProgressHUD *HUD;


@end

@implementation MoviesViewController

NSArray *moviesArr;

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

        moviesArr = apiResponse[@"movies"];
        
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
    return [moviesArr count];
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
    
    cell.titleLabel.text = [[moviesArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.synopsisLabel.text = [[moviesArr objectAtIndex:indexPath.row] valueForKey:@"synopsis"];
    
    NSDictionary *imageData = [[moviesArr objectAtIndex:indexPath.row] valueForKey:@"posters"];
    
    
    NSURL *url = [NSURL URLWithString:[imageData valueForKey:@"thumbnail"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak MovieCell *weakCell = cell;
    
    [cell.posterImageView setImageWithURLRequest: request
                          placeholderImage:nil
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                NSLog(@"success!");
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
    
    NSLog(@"selected movie row index: %d" , indexPath.row);
    
    MovieDetailsViewController *movieDetailsController = [[MovieDetailsViewController alloc] init];
    NSString* title = [[moviesArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:title forKey:@"MOVIE_TITLE"];
    [defaults synchronize];
    
    [self.navigationController pushViewController:movieDetailsController animated:YES];

}

@end
