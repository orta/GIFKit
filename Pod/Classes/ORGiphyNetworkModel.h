//
//  ORGiphyNetworkModel.h
//  Pods
//
//  Created by Orta on 8/30/14.
//
//

#import <Foundation/Foundation.h>
#import "ORGIFSource.h"

@interface ORGiphyNetworkModel : NSObject <ORGIFSource>

- (void)setQuery:(NSString *)query;
@property (nonatomic, copy, readwrite) NSString *APIKey;

@end
