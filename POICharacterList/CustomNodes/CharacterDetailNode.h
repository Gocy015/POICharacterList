//
//  CharacterDetailNode.h
//  POICharacterList
//
//  Created by Gocy on 16/9/22.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CharacterInfo;

@interface CharacterDetailNode : ASDisplayNode


-(instancetype)initWithInfo:(CharacterInfo *)info;

@end
