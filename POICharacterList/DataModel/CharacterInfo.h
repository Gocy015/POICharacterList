//
//  CharacterInfo.h
//  POICharacterList
//
//  Created by Gocy on 16/9/21.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterInfo : NSObject


+(instancetype)infoWithRole:(NSString *)role actor:(NSString *)actor thumbnail:(NSString *)url photo:(NSString *)purl;

@property (nonatomic ,copy) NSString *role;
@property (nonatomic ,copy) NSString *actor;
@property (nonatomic ,copy) NSString *thumbnailUrl;
@property (nonatomic ,copy) NSString *photoUrl;

@end
