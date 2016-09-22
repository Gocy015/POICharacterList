//
//  CharacterDetailNode.m
//  POICharacterList
//
//  Created by Gocy on 16/9/22.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "CharacterDetailNode.h"

@implementation CharacterDetailNode

-(instancetype)initWithInfo:(CharacterInfo *)info{
    if (self = [super init]) {
        self.backgroundColor = [UIColor orangeColor];
    }
    
    return self;
}

@end
