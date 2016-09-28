//
//  AnimateNetworkImageNode.m
//  POICharacterList
//
//  Created by Gocy on 16/9/24.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "AnimateNetworkImageNode.h"

@implementation AnimateNetworkImageNode


-(void)animateLayoutTransition:(id<ASContextTransitioning>)context{
    //    if (_show) {
    CGFloat from = _show ? 0:1;
    CGFloat to = _show ? 1:0;
    
    self.alpha = from;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = to;
    } completion:^(BOOL finished) {
        
        [context completeTransition:finished];
    }];
   

}


@end
