//
//  InfoCellNode.m
//  POICharacterList
//
//  Created by Gocy on 16/9/21.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "InfoCellNode.h"
#import "CharacterInfo.h"
#import "AnimateNetworkImageNode.h"


#define USE_SET_NEEDS_DISPLAY YES

@interface InfoCellNode () <ASNetworkImageNodeDelegate>

@property (nonatomic ,strong) ASNetworkImageNode *headerNode;
@property (nonatomic ,strong) AnimateNetworkImageNode *photoNode;
@property (nonatomic ,strong) ASTextNode *roleNode;
@property (nonatomic ,strong) ASTextNode *asNode;
@property (nonatomic ,strong) ASTextNode *actorNode;
@property (nonatomic ,strong) ASButtonNode *detailNode;

@property (nonatomic ,strong) CharacterInfo *info;

@property (nonatomic) BOOL show;


@end

@implementation InfoCellNode


#pragma mark - Life Cycle
-(instancetype)initWithCharacterInfo:(CharacterInfo *)info{
    if (self = [super init]) {
        
        _show = NO;
        
        _info = info;
        
        _headerNode = [ASNetworkImageNode new];
        _headerNode.delegate = self;
        _headerNode.defaultImage = [self placeholderImage];
        _headerNode.imageModificationBlock = ^UIImage *(UIImage *originalImg){
            UIGraphicsBeginImageContext(originalImg.size);
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, originalImg.size.width, originalImg.size.height) cornerRadius:MIN(originalImg.size.width,originalImg.size.height)/2];
            
            [path addClip];
            
            [originalImg drawInRect:CGRectMake(0, 0, originalImg.size.width, originalImg.size.height)];
            
            UIImage *refinedImg = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return refinedImg;
        };
        
        [self addSubnode:_headerNode];
        
        _photoNode = [AnimateNetworkImageNode new];
        _photoNode.delegate = self;
        _photoNode.backgroundColor = [UIColor clearColor];
//        _photoNode.defaultImage = [self placeholderImage];
        _photoNode.imageModificationBlock = ^UIImage *(UIImage *originalImg){
            UIGraphicsBeginImageContext(originalImg.size);
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, originalImg.size.width, originalImg.size.height) cornerRadius:16];
            
            [path addClip];
            
            [originalImg drawInRect:CGRectMake(0, 0, originalImg.size.width, originalImg.size.height)];
            
            UIImage *refinedImg = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return refinedImg;
        };
        
        [self addSubnode:_photoNode];
        
        _detailNode = [ASButtonNode new];
        [_detailNode setAttributedTitle:[[NSAttributedString alloc] initWithString:@"View Photo" attributes:[self buttonNormalAttributes]] forState:ASControlStateNormal];
        _detailNode.hitTestSlop = UIEdgeInsetsMake(-6, -6, -6, -6);
        
        [_detailNode addTarget:self action:@selector(showPhoto) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_detailNode];
        
        _actorNode = [ASTextNode new];
        _actorNode.attributedText = [[NSAttributedString alloc] initWithString:info.actor attributes:[self actorAttributes]];
        [self addSubnode:_actorNode];
        
        
        _asNode = [ASTextNode new];
        _asNode.attributedText = [[NSAttributedString alloc] initWithString:@"as" attributes:[self asAttributes]];
        [self addSubnode:_asNode];
        
        _roleNode = [ASTextNode new];
        _roleNode.attributedText = [[NSAttributedString alloc] initWithString:info.role attributes:[self roleAttributes]];
        [self addSubnode:_roleNode];
        
        
        
    }
    
    return self;
}


-(void)didLoad{
    [super didLoad];
}

-(void)loadStateDidChange:(BOOL)inLoadState{
    
//    NSLog(@"In Load State");
    
    [super loadStateDidChange:inLoadState];
    
    if (inLoadState) {
        _headerNode.URL = [NSURL URLWithString:_info.thumbnailUrl];
    }
}



#pragma mark - Layout

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
//    NSLog(@"constraintSize.max : %@" ,NSStringFromCGSize(constrainedSize.max));
//    NSLog(@"constraintSize.min : %@" ,NSStringFromCGSize(constrainedSize.min));
    
    NSMutableArray *leftItems = [NSMutableArray new];
    _headerNode.preferredFrameSize = CGSizeMake(60, 60);
    
    [leftItems addObject:_headerNode];
    
    if ([_info.photoUrl length] > 0) {
        [leftItems addObject:_detailNode];
    }

    NSMutableArray *rightItems = [NSMutableArray new];
    
    _actorNode.flexShrink = YES;
    _actorNode.maximumNumberOfLines = 1;
    _actorNode.truncationMode = NSLineBreakByTruncatingMiddle;
    
    ASStackLayoutSpec *actorStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                            spacing:6
                                                                     justifyContent:ASStackLayoutJustifyContentEnd
                                                                         alignItems:ASStackLayoutAlignItemsCenter
                                                                           children:@[_actorNode,_asNode]];
    
    ASStackLayoutSpec *infoStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:2
                                                                    justifyContent:ASStackLayoutJustifyContentCenter
                                                                        alignItems:ASStackLayoutAlignItemsEnd
                                                                          children:@[actorStack,_roleNode]];
    
    infoStack.spacingBefore = 20;
    infoStack.spacingAfter = 6;
    
    [rightItems addObject:infoStack];
    
    if(_photoNode.image && _show){
        ASRatioLayoutSpec *photoRatio = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:_photoNode.image.size.height / _photoNode.image.size.width child:_photoNode];
        photoRatio.alignSelf = ASStackLayoutAlignSelfCenter;
        [rightItems addObject:photoRatio];
        
    }
    
    
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:6
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:leftItems];
    
//    _headerNode.alignSelf = ASStackLayoutAlignSelfStart;

//    leftStack.alignSelf = ASStackLayoutAlignSelfStart;
    
    
    ASStackLayoutSpec *rightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                            spacing:8
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsEnd
                                                                           children:rightItems];
    
    
    rightStack.flexGrow = rightStack.flexShrink = YES;
    
    
    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                       spacing:10
                                                                justifyContent:ASStackLayoutJustifyContentStart
                                                                    alignItems:ASStackLayoutAlignItemsStart
                                                                      children:@[leftStack,rightStack]];
    
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(6, 10, 8, 10) child:stack];
    
}

-(void)layoutDidFinish{
    [super layoutDidFinish];
    
    [self.delegate cellNode:self didExpand:_show];
    
}


-(void)animateLayoutTransition:(id<ASContextTransitioning>)context{
    CGRect from = [context initialFrameForNode:_photoNode];
    CGRect to = [context finalFrameForNode:_photoNode];
    
    CGRect sfrom = [context initialFrameForNode:self];
    CGRect sto = [context finalFrameForNode:self];
    
//    if(_show){
////        _photoNode.frame = to;
//        _photoNode.alpha = 0;
////        _photoNode.frame = CGRectMake(to.origin.x, to.origin.y, to.size.width, 0);
//        _photoNode.frame = to;
//        [UIView animateWithDuration:1 animations:^{
////            _photoNode.frame = to;
//            _photoNode.alpha = 1;
//            [self setNeedsLayout];
//        } completion:^(BOOL finished) {
//            [context completeTransition:finished];
//        }];
//    }else{
//        //hide
//        
//        _photoNode.frame = from;
//        _photoNode.alpha = 1;
//        [UIView animateWithDuration:0.3 animations:^{
//            _photoNode.frame = CGRectMake(from.origin.x, from.origin.y, from.size.width, 0);
//            _photoNode.alpha = 0;
//            [self setNeedsLayout];
//        } completion:^(BOOL finished) {
//            _photoNode.frame = to;
//            [context completeTransition:finished];
//        }];
//    }
    
    for (ASDisplayNode *node in self.subnodes){
        if ([node isKindOfClass:[AnimateNetworkImageNode class]]) {
            node.frame = [context finalFrameForNode:node];
        }
    }
    
//    [UIView animateWithDuration:2 animations:^{
//        self.frame = sto;
////        [self setNeedsLayout];
//    } completion:^(BOOL finished) {
//        [context completeTransition:finished];
//    }];
    
}

#pragma mark - ASNetworkImageNode Delegate

-(void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image{
    
    if (USE_SET_NEEDS_DISPLAY) {
        
        [self setNeedsLayout];
    }else{
        
        [self transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _photoNode.show = YES;
        [_photoNode transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    });
    
}


#pragma mark - Actions

-(void)showPhoto{
//    NSLog(@"Show Detail");
    _show = !_show;
//    _photoNode.hidden = !_show;
    NSString *title = _show ? @"Hide Photo" : @"View Photo";
    
    [_detailNode setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:[self buttonNormalAttributes]] forState:ASControlStateNormal];

    
    if (!_photoNode.URL && [_info.photoUrl length]) {
        _photoNode.URL = [NSURL URLWithString:_info.photoUrl];
    }else{
        if (USE_SET_NEEDS_DISPLAY) {
            
            [self setNeedsLayout];
        }else{
            
            [self transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
        }

        _photoNode.show = _show;
        [_photoNode transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    }
    
}



#pragma mark - Helpers

-(UIImage *)placeholderImage{
    // [UIImage imageNamed:] is not thread safe;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"placeholder" ofType:@"png"];
    UIImage *img =  [UIImage imageWithContentsOfFile:path];
    return img;
}



-(NSDictionary *)actorAttributes{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentRight;
    
    return @{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.6],NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightLight],NSParagraphStyleAttributeName:style};
}

-(NSDictionary *)roleAttributes{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentRight;
    
    return @{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.8],NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium],NSParagraphStyleAttributeName:style};
}

-(NSDictionary *)asAttributes{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentRight;
    
    return @{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.6],NSFontAttributeName:[UIFont italicSystemFontOfSize:10],NSParagraphStyleAttributeName:style};
}

-(NSDictionary *)buttonNormalAttributes{
    
    return @{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.6],NSFontAttributeName:[UIFont systemFontOfSize:10 weight:UIFontWeightLight]};
}

@end
