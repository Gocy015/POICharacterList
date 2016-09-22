//
//  InfoCellNode.h
//  POICharacterList
//
//  Created by Gocy on 16/9/21.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CharacterInfo;
@class InfoCellNode;

@protocol CellExpandDelegate

-(void)cellNode:(InfoCellNode *)cellNode didExpand:(BOOL)expand;

@end

@interface InfoCellNode : ASCellNode

-(instancetype)initWithCharacterInfo:(CharacterInfo *)info;


@property (nonatomic ,weak) id <CellExpandDelegate> delegate;

@end
