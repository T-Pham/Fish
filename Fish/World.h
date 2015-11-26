//
//  World.h
//  Fish
//
//  Created by Thanh Pham on 11/26/15.
//  Copyright © 2015 Thanh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feeder.h"

@class Lake;
@class FoodPackage;
@class FishSpecies;
@class Fish;

@interface World : NSObject

@property (nonatomic, readonly) id<Feeder> feeder;
@property (nonatomic, readonly) Lake *lake;
@property (nonatomic, readonly) FoodPackage *foodPackage;
@property (nonatomic, readonly) NSArray *fishSpeciesList;
@property (nonatomic, readonly) NSArray *fishList;

@end
