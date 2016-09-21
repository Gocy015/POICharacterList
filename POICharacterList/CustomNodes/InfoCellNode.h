//
//  InfoCellNode.h
//  POICharacterList
//
//  Created by Gocy on 16/9/21.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CharacterInfo;

@interface InfoCellNode : ASCellNode

-(instancetype)initWithCharacterInfo:(CharacterInfo *)info;

@end
