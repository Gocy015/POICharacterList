//
//  PhotoCellNode.m
//  POICharacterList
//
//  Created by Gocy on 16/9/23.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "PhotoCellNode.h"


@interface PhotoCellNode () <ASNetworkImageNodeDelegate>

@property (nonatomic ,strong) ASNetworkImageNode *photoNode;

@end

@implementation PhotoCellNode

-(instancetype)initWithPhotoUrl:(NSString *)url{
    if (self = [super init]) {
        _photoNode = [ASNetworkImageNode new];
        _photoNode.URL = [NSURL URLWithString:url];
        _photoNode.backgroundColor = [UIColor darkGrayColor];
        
        _photoNode.delegate = self;
        [self addSubnode:_photoNode];
    }
    
    return self;
}

//- (ASLayout *)calculateLayoutThatFits:(ASSizeRange)constrainedSize
//{
//    return [ASLayout layoutWithLayoutableObject:self constrainedSizeRange:constrainedSize size:constrainedSize.max];
//}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
//    NSLog(@"Layout : %@ , image : %@",_photoNode ,_photoNode.image);
    
    ASLayoutSpec *child = [ASLayoutSpec new];
    child.flexGrow = YES;
    if (_photoNode.image) {
        
        ASRatioLayoutSpec *ratio = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:_photoNode.image.size.height/_photoNode.image.size.width child:_photoNode];
        
        ratio.flexGrow = ratio.flexShrink = YES;
        
        child = ratio;
    }
    
    ASCenterLayoutSpec *center = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:child];
    
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:center];
    
}

//-(ASLayout *)calculateLayoutThatFits:(ASSizeRange)constrainedSize{
//    ASLayout *photoLayout = [_photoNode calculateLayoutThatFits:constrainedSize];
//    
//    return [ASLayout layoutWithLayoutableObject:self
//                           constrainedSizeRange:constrainedSize
//                                           size:constrainedSize.max
//                                     sublayouts:@[photoLayout]];
//}



#pragma mark - ASNetworkImageNode Delegate
-(void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image{
//    imageNode.image = image; 
    
    [self setNeedsLayout];
}

-(void)imageNodeDidFinishDecoding:(ASNetworkImageNode *)imageNode{
//    NSLog(@"FinishDecoding");
}
@end
