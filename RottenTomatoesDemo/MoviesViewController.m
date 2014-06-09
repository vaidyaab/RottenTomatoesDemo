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
#import "Reachability/Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import <ODRefreshControl/ODRefreshControl.h>


@interface MoviesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSArray *moviesArr;
@property (strong, nonatomic) IBOutlet UILabel *networkCheckLabel;

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
    
    self.networkCheckLabel.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.yahoo.com"];
    
    [reach startNotifier];
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    
    [self loadDataFromRottenTomatoesAPI];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.moviesTableView];
    refreshControl.tintColor = [UIColor grayColor];
    
    [refreshControl addTarget:self action:@selector(refreshTableViewHandler:) forControlEvents:UIControlEventValueChanged];
    
}

- (void) refreshTableViewHandler:(ODRefreshControl*) refreshControl {
    
    [self loadDataFromRottenTomatoesAPI];
    [refreshControl endRefreshing];
}

-(void) loadDataFromRottenTomatoesAPI {
    
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    [self addProgressBar];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        if(data){
            
            id apiResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSMutableArray* mutableMovieList = [[ NSMutableArray alloc ] initWithCapacity: 5];
            for(id mv in [apiResponse valueForKey:@"movies"]){
                Movie* movieTemp = [[Movie alloc] initWithRottenTomatoesAPIResponse:mv];
                [mutableMovieList addObject: movieTemp];
            }
            self.moviesArr = [NSArray arrayWithArray:mutableMovieList];
            
            if(self.networkCheckLabel.hidden == NO){
                self.networkCheckLabel.hidden = YES;
            }
            
            [self.moviesTableView reloadData];
            
        }else{
            
            if(connectionError){
                
                self.networkCheckLabel.text = @"⚠︎ Network Error!";
                [self.HUD hide:TRUE];
                
                self.networkCheckLabel.hidden = NO;
            }
        }
        
    }];
}

- (void) addProgressBar {
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.dimBackground = YES;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    self.HUD.delegate = self;
    self.HUD.labelText = @"Loading..";
    [self.HUD show:TRUE];
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
        //cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Movie *currMovie = [self.moviesArr objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [currMovie title];
//   cell.titleLabel.text = @"The Hobbit: The Desolation Of Smaug";
    cell.synopsisLabel.text = [currMovie synopsis];
//    cell.synopsisLabel.text = @"The second in a trilogy of films adapting the enduringly popular masterpiece The Hobbit, by J.R.R. Tolkien, The Hobbit: The Desolation of Smaug continues the adventure of the title character Bilbo Baggins (Martin Freeman) as he journeys with the Wizard Gandalf (Ian McKellan) and thirteen Dwarves, led by Thorin Oakenshield (Richard Armitage) on an epic quest to reclaim the lost Dwarf Kingdom of Erebor.(c) WB.";
//    
//    
    NSURL *url = [NSURL URLWithString:[currMovie thumbnail]];
   // NSURL *url = [NSURL URLWithString:@"http://content6.flixster.com/movie/11/17/69/11176940_mob.jpg"];
    
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
    
    //Movie *selectedMovie = [[Movie alloc] init];
    //[selectedMovie setTitle:@"The Hobbit: The Desolation Of smaug"];
    //[selectedMovie setSynopsis:@"The second in a trilogy of films adapting the enduringly popular masterpiece The Hobbit, by J.R.R. Tolkien, The Hobbit: The Desolation of Smaug continues the adventure of the title character Bilbo Baggins (Martin Freeman) as he journeys with the Wizard Gandalf (Ian McKellan) and thirteen Dwarves, led by Thorin Oakenshield (Richard Armitage) on an epic quest to reclaim the lost Dwarf Kingdom of Erebor.(c) WB. THis is some more dummy text just trying to make it scroll 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890"];
    //[selectedMovie setPoster:@"http://content6.flixster.com/movie/11/17/69/11176940_ori.jpg"];
    
    
    [movieDetailsController setSelectedMovie:selectedMovie];
    
    [self.navigationController pushViewController:movieDetailsController animated:YES];

}

- (void) reachabilityChanged:(NSNotification *)note {
    
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self getReachabilityStatus: curReach];
}

- (BOOL) getReachabilityStatus:(Reachability *) reach {
    
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable: {
            self.networkAvailable = NO;
            break;
        }
            
        case ReachableViaWWAN: {
            self.networkAvailable = YES;
            break;
        }
        case ReachableViaWiFi: {
            self.networkAvailable = YES;
            break;
        }
    }
    
    return self.networkAvailable;
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


@end
