//
//  ORSubredditNetworkModel.h
//  GIFs
//
//  Created by orta therox on 12/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORGIFSource.h"

@interface ORSubredditNetworkModel : NSObject <ORGIFSource>

- (void)setSubreddit:(NSString *)subreddit;

@end
