//
//  ORGiphyNetworkModel.m
//  Pods
//
//  Created by Orta on 8/30/14.
//
//

#import "ORGiphyNetworkModel.h"
#import <AFNetworking/AFNetworking.h>
#import "GIF.h"

@interface ORGiphyNetworkModel()
@property (nonatomic, copy, readonly) NSString *query;
@property (nonatomic, copy, readonly) NSArray *gifs;
@property (nonatomic, assign, readonly) NSInteger page;

@property (nonatomic, assign, readonly) BOOL downloading;
@property (nonatomic, assign, readonly) BOOL completed;

@end

@implementation ORGiphyNetworkModel 

- (void)setQuery:(NSString *)query
{
    _query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    _gifs = @[];
    _page = 0;
    _downloading = NO;
    _completed = NO;
}

static NSInteger GiphyDownloadCount = 15;

- (void)getNextGIFs:(void (^)(NSArray *newGIFs, NSError *error))completion
{
    if (_downloading) return;
    NSParameterAssert(self.query);
    
    NSString *address = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q=%@&offset=%@&limit=%@&api_key=%@", self.query, @(self.page), @(GiphyDownloadCount), self.APIKey];
    
    if (!self || !address || self.completed) return;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:address parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSArray *gifs = JSON[@"data"];
        NSMutableArray *mutableGIFs = [NSMutableArray array];
        
        for (NSDictionary *dictionary in gifs) {
            
            GIF *gif = [[GIF alloc] initWithDownloadURL:dictionary[@"images"][@"original"][@"url"]
                                              thumbnail:dictionary[@"images"][@"downsized_still"][@"url"]
                                                 source:dictionary[@"url"]
                                            sourceTitle:@"Giphy"];
            
            if (gif) { [mutableGIFs addObject:gif]; }
        }
        
        _gifs = [self.gifs arrayByAddingObjectsFromArray:mutableGIFs];
        _downloading = NO;
        _completed = mutableGIFs.count > GiphyDownloadCount;
        _page += GiphyDownloadCount;
        
        if (completion) completion(mutableGIFs, nil);
        
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
