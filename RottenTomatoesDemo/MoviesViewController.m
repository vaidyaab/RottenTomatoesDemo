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

@interface MoviesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *moviesTableView;



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
    
    cell.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageData valueForKey:@"thumbnail"]]]];

    
    return cell;
}

@end
