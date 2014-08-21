//
//  ORRedditSearchNetworkModel.m
//  GIFs
//
//  Created by orta therox on 13/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ORRedditSearchNetworkModel.h"
#import <AFNetworking/AFNetworking.h>
#import "GIF.h"
#import "GIF+RedditDictionary.h"

@interface ORRedditSearchNetworkModel ()

@property (nonatomic, copy, readonly) NSArray *gifs;
@property (nonatomic, copy, readonly) NSString *query;
@property (nonatomic, copy, readonly) NSString *redditToken;
@property (nonatomic, assign, readonly) BOOL downloading;

@end

@implementation ORRedditSearchNetworkModel

- (void)setSearchQuery:(NSString *)query
{
    _query = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    _gifs = @[];
    _redditToken = nil;
    _downloading = NO;
}

- (void)getNextGIFs:(void (^)(NSArray *newGIFs, NSError *error))completion
{
    if (self.downloading) return;

    NSString *address = nil;
    NSString *restrictResults = (self.filterResults) ? @"" : @"&restrict_sr=off";
    NSString *redditToken = self.redditToken;
    NSString *token = [redditToken isKindOfClass:[NSString class]] ? [@"&after=" stringByAppendingString:self.redditToken] : @"";
    address = [NSString stringWithFormat:@"http://www.reddit.com/search.json?q=%@+url:*.gif&sort=relevance&t=all%@&count=25%@", _query, restrictResults, token];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:address parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {

        _redditToken = JSON[@"data"][@"after"];
        NSArray *messages = JSON[@"data"][@"children"];
        NSMutableArray *mutableGifs = [NSMutableArray array];

        for (NSDictionary *dictionary in messages) {
            GIF *gif = [[GIF alloc] initWithRedditDictionary:dictionary];
            if (gif) { [mutableGifs addObject:gif]; }
        }
        
        _gifs = [self.gifs arrayByAddingObjectsFromArray:mutableGifs];
        _downloading = NO;
        
        if (completion) completion(mutableGifs, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _downloading = NO;
        if (completion) completion(nil, error);
    }];

    _downloading = YES;
}

- (NSInteger)numberOfGifs
{
    return self.gifs.count;
}

- (GIF *)gifAtIndex:(NSInteger)index
{
    return self.gifs[index];
}

@end
