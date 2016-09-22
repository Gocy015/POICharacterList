//
//  InfoCellNode.m
//  POICharacterList
//
//  Created by Gocy on 16/9/21.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "InfoCellNode.h"
#import "CharacterInfo.h" 

@interface InfoCellNode () <ASNetworkImageNodeDelegate>

@property (nonatomic ,strong) ASNetworkImageNode *headerNode;
@property (nonatomic ,strong) ASNetworkImageNode *photoNode;
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
        
        _photoNode = [ASNetworkImageNode new];
        _photoNode.delegate = self;
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
        _detailNode.contentEdgeInsets = UIEdgeInsetsMake(-16, -16, -16, -16);
        
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
    _headerNode.alignSelf = ASStackLayoutAlignSelfStart;
    
    _headerNode.preferredFrameSize = CGSizeMake(60, 60);
    
    
    
    
    [leftItems addObject:_headerNode];
    
    if ([_info.photoUrl length] > 0) {
        [leftItems addObject:_detailNode];
    }
    
    [_roleNode measure:constrainedSize.max];
    [_actorNode measure:constrainedSize.max];
    
    
    NSMutableArray *rightItems = [NSMutableArray new];
    
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
    leftStack.alignSelf = ASStackLayoutAlignSelfStart;
    
    
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

#pragma mark - ASNetworkImageNode Delegate

-(void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image{

    [self setNeedsLayout];
}


#pragma mark - Actions

-(void)showPhoto{
//    NSLog(@"Show Detail");
    _show = !_show;
    _photoNode.hidden = !_show;
    NSString *title = _show ? @"Hide Photo" : @"View Photo";
    
    [_detailNode setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:[self buttonNormalAttributes]] forState:ASControlStateNormal];

    
    if (!_photoNode.URL && [_info.photoUrl length]) {
        _photoNode.URL = [NSURL URLWithString:_info.photoUrl];
    }else{
        [self setNeedsLayout];
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
    
    return @{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.6],NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightLight],NSParagraphStyleAttributeName:style};
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
