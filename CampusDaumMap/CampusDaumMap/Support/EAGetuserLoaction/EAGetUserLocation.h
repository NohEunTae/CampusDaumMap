//
//  EAGetUserLoaction.h
//  EasyToOrder
//
//  Created by user on 2018. 5. 31..
//  Copyright © 2018년 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EALocationModel, CLLocation;

@protocol EAGetUserLocationProtocol

- (void)getCurrentUserLocationWithCurrentLocation:(CLLocation *) location;

@end

@interface EAGetUserLocation : NSObject

@property (nonatomic, strong) id<EAGetUserLocationProtocol> delegate;

@end

