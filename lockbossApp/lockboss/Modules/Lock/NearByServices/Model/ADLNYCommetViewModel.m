//
//  ADLNYCommetViewModel.m
//  lockboss
//
//  Created by bailun91 on 2019/10/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNYCommetViewModel.h"

@implementation ADLNYCommetViewModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_userHeadImgUrl    forKey:@"userHeadImgUrl"];
    [aCoder encodeObject:_userName          forKey:@"userName"];
    [aCoder encodeObject:_cmtDate           forKey:@"cmtDate"];
    [aCoder encodeObject:_cmtScore          forKey:@"cmtScore"];
    [aCoder encodeObject:_userMsg           forKey:@"userMsg"];
    [aCoder encodeObject:_cmtImgUrl         forKey:@"cmtImgUrl"];
    [aCoder encodeObject:_replyMsg          forKey:@"replyMsg"];
    [aCoder encodeObject:@(_anonymousFlag)  forKey:@"anonymousFlag"];
    [aCoder encodeObject:@(_userMsgHeight)  forKey:@"userMsgHeight"];
    [aCoder encodeObject:@(_cmtImgHeight)   forKey:@"cmtImgHeight"];
    [aCoder encodeObject:@(_replyHeight)    forKey:@"replyHeight"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _userHeadImgUrl = [aDecoder decodeObjectForKey:@"userHeadImgUrl"];
        _userName       = [aDecoder decodeObjectForKey:@"userName"];
        _cmtDate        = [aDecoder decodeObjectForKey:@"cmtDate"];
        _cmtScore       = [aDecoder decodeObjectForKey:@"cmtScore"];
        _userMsg        = [aDecoder decodeObjectForKey:@"userMsg"];
        _cmtImgUrl      = [aDecoder decodeObjectForKey:@"cmtImgUrl"];
        _replyMsg       = [aDecoder decodeObjectForKey:@"replyMsg"];
        _anonymousFlag  = [[aDecoder decodeObjectForKey:@"anonymousFlag"] intValue];
        _userMsgHeight  = [[aDecoder decodeObjectForKey:@"userMsgHeight"] floatValue];
        _cmtImgHeight   = [[aDecoder decodeObjectForKey:@"cmtImgHeight"] floatValue];
        _replyHeight    = [[aDecoder decodeObjectForKey:@"replyHeight"] floatValue];
    }
    return self;
}

@end
