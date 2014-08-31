//
//  ORSubredditNetworkModel.m
//  GIFs
//
//  Created by orta therox on 12/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ORSubredditNetworkModel.h"
#import <AFNetworking/AFNetworking.h>
#import "GIF.h"
#import "GIF+RedditDictionary.h"

@interface ORSubredditNetworkModel()
@property (nonatomic, copy, readonly) NSString *address;
@property (nonatomic, copy, readonly) NSArray *gifs;
@property (nonatomic, copy, readonly) NSString *token;

@property (nonatomic, assign, readonly) BOOL downloading;

@end

@implementation ORSubredditNetworkModel

- (void)setSubreddit:(NSString *)subreddit
{
    _address = [NSString stringWithFormat:@"http://www.reddit.com/%@.json", subreddit];
    _gifs = @[];
    _token = nil;
    _downloading = NO;
}

- (void)getNextGIFs:(void (^)(NSArray *newGIFs, NSError *error))completion
{
    if (_downloading) return;
    
    NSString *address = self.address;
    if (self.token && (id)self.token != [NSNull null]) {
        address = [address stringByAppendingFormat:@"?after=%@", self.token];
    }

    if (!self || !address) return;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:address parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        _token = JSON[@"data"][@"after"];
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
        NSLog(@"Error: %@", error);
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
