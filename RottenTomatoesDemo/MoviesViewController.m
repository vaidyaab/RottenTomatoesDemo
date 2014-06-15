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
@property (strong, nonatomic) MBProgressHUD *progressBar;
@property (strong, nonatomic) NSArray *moviesArr;
@property (strong, nonatomic) NSArray *searchResultsArr;
@property (strong, nonatomic) IBOutlet UILabel *networkCheckLabel;
@property (strong, nonatomic) NSString* apiEndPoint;

@end

@implementation MoviesViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (id) initWithRTURL:(NSString*) apiEndPointParam title:(NSString*) titleParam {
    
    self = [super init];
    self.apiEndPoint = apiEndPointParam;
    self.title = titleParam;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startReachabilityThread];
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    
    [self loadDataFromRottenTomatoesAPI];
    
    [self addRefreshControlToMoviesTable];
    
    
}

-(void) startReachabilityThread {
    
    self.networkCheckLabel.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.yahoo.com"];
    
    [reach startNotifier];
}

-(void) addRefreshControlToMoviesTable {
    
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.moviesTableView];
    refreshControl.tintColor = [UIColor grayColor];
    
    [refreshControl addTarget:self action:@selector(refreshTableViewHandler:) forControlEvents:UIControlEventValueChanged];
}

- (void) refreshTableViewHandler:(ODRefreshControl*) refreshControl {
    
    [self loadDataFromRottenTomatoesAPI];
    [refreshControl endRefreshing];
}

-(void) loadDataFromRottenTomatoesAPI {
    
    //NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *docsDir = [dirPaths objectAtIndex:0];
    //NSLog(@"docsDir here: %@", docsDir);
    
    [self addProgressBar];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.apiEndPoint]];
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
                [self.progressBar hide:TRUE];
                self.networkCheckLabel.hidden = NO;
            }
        }
        
    }];
    
    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
}

- (void) addProgressBar {
    
    self.progressBar = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressBar];
    self.progressBar.dimBackground = YES;
    self.progressBar.delegate = self;
    self.progressBar.labelText = @"Loading..";
    [self.progressBar show:TRUE];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120.0;
    
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.title contains[cd] %@",
                                    searchText];
    
    self.searchResultsArr = [self.moviesArr filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResultsArr count];
        
    } else {
        return [self.moviesArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    Movie* currMovie;
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        
        currMovie = [self.searchResultsArr objectAtIndex:indexPath.row];
        
    }else{
        currMovie = [self.moviesArr objectAtIndex:indexPath.row];
    }
    
    cell = [cell initWithMovie:currMovie progressBar:self.progressBar];
    
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Movie *selectedMovie = [self.moviesArr objectAtIndex:indexPath.row];
    MovieDetailsViewController *movieDetailsController = [[MovieDetailsViewController alloc] init];
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
