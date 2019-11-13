//
//  ADLDinnerModel.m
//  lockboss
//
//  Created by bailun91 on 2019/9/11.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDinnerModel.h"

@implementation ADLDinnerModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.goodId     forKey:@"goodId"];
    [aCoder encodeObject:self.ImgUrl     forKey:@"ImgUrl"];
    [aCoder encodeObject:self.dinnerName forKey:@"dinnerName"];
    [aCoder encodeObject:self.soldNumber forKey:@"soldNumber"];
    [aCoder encodeObject:self.leadString forKey:@"leadString"];
    [aCoder encodeObject:self.price      forKey:@"price"];
    [aCoder encodeObject:self.number     forKey:@"number"];
    [aCoder encodeObject:self.bigNumber forKey:@"bigNumber"];
    [aCoder encodeObject:self.midNumber forKey:@"midNumber"];
    [aCoder encodeObject:self.litNumber forKey:@"litNumber"];
    [aCoder encodeObject:self.skuList   forKey:@"skuList"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.goodId = [aDecoder decodeObjectForKey:@"goodId"];
        self.ImgUrl = [aDecoder decodeObjectForKey:@"ImgUrl"];
        self.dinnerName = [aDecoder decodeObjectForKey:@"dinnerName"];
        self.soldNumber = [aDecoder decodeObjectForKey:@"soldNumber"];
        self.leadString = [aDecoder decodeObjectForKey:@"leadString"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.number = [aDecoder decodeObjectForKey:@"number"];
        self.bigNumber = [aDecoder decodeObjectForKey:@"bigNumber"];
        self.midNumber = [aDecoder decodeObjectForKey:@"midNumber"];
        self.litNumber = [aDecoder decodeObjectForKey:@"litNumber"];
        self.skuList = [aDecoder decodeObjectForKey:@"skuList"];
    }
    return self;
}
@end
