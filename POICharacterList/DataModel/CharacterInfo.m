//
//  CharacterInfo.m
//  POICharacterList
//
//  Created by Gocy on 16/9/21.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "CharacterInfo.h"

@implementation CharacterInfo

+(instancetype)infoWithRole:(NSString *)role actor:(NSString *)actor thumbnail:(NSString *)url photo:(NSString *)purl{
    CharacterInfo *info = [CharacterInfo new];
    info.role = role;
    info.actor = actor;
    info.thumbnailUrl = url;
    info.photoUrl = purl;

    return info;
}

@end
