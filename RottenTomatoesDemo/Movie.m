//
//  Movie.m
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/6/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(id) initWithRottenTomatoesAPIResponse: (NSDictionary*) data{
    self = [super init];
    if (self) {
        
        self.title =  [data valueForKey:@"title"];
        self.synopsis = [data valueForKey:@"synopsis"];
        self.thumbnail = [[data valueForKey:@"posters"] valueForKey:@"thumbnail"];
        self.poster = [[data valueForKey:@"posters"] valueForKey:@"original"];
        
    }
    return self;
}

@end
