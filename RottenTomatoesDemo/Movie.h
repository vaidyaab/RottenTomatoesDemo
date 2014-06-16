//
//  Movie.h
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/6/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property NSString *title;
@property NSString *thumbnail;
@property NSString *poster;
@property NSString *synopsis;
@property NSData *cachedThumbnail;

-(id) initWithRottenTomatoesAPIResponse: (NSDictionary*) data;

@end
