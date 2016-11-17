//
//  CharacterDetailNode.m
//  POICharacterList
//
//  Created by Gocy on 16/9/22.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "CharacterDetailNode.h"
#import "CharacterInfo.h"
#import "PhotoCellNode.h"

@interface CharacterDetailNode () <ASPagerDelegate ,ASPagerDataSource>

@property (nonatomic ,strong) CharacterInfo *info;
@property (nonatomic ,strong) ASPagerNode *photoPagerNode;
@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation CharacterDetailNode

-(instancetype)initWithInfo:(CharacterInfo *)info{
    if (self = [super init]) {
        _info = info;
        self.backgroundColor = [UIColor whiteColor];
        _photoPagerNode = [ASPagerNode new];
        _photoPagerNode.delegate = self;
        _photoPagerNode.dataSource = self;
        _photoPagerNode.backgroundColor = [UIColor blackColor];
        _photoPagerNode.userInteractionEnabled = NO;
        [self addSubnode:_photoPagerNode];
    }
    
    return self;
}


-(void)dealloc{
//    NSLog(@"Character Detail Dealloc");
}


#pragma mark - Layout

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    
    _photoPagerNode.position = CGPointMake(0, 0);
    
    ASRelativeDimension width = ASRelativeDimensionMake(ASRelativeDimensionTypePoints, 1);
    ASRelativeDimension height = ASRelativeDimensionMake(ASRelativeDimensionTypePoints, 0.32);
    
    ASRelativeSize size = ASRelativeSizeMake(width, height);
    
    _photoPagerNode.sizeRange = ASRelativeSizeRangeMake(size, size);
    
    ASStaticLayoutSpec *sLayout = [ASStaticLayoutSpec staticLayoutSpecWithChildren:@[_photoPagerNode]];
    
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(66, 0, 0, 0) child:sLayout];
}


#pragma mark - ASPagerNode Delegate

-(NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode{
    return 3;
}

-(ASCellNodeBlock)pagerNode:(ASPagerNode *)pagerNode nodeBlockAtIndex:(NSInteger)index{
    __weak typeof(self) wself = self;
    return ^PhotoCellNode *{
        PhotoCellNode *node = [[PhotoCellNode alloc] initWithPhotoUrl:wself.info.photoUrl];
        return node;
    };
}

#pragma mark - ASPagerNode Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - Instance Method
-(void)startCycling{
    [self stopCycling];
    __weak typeof(self) wself = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [wself.photoPagerNode scrollToPageAtIndex:(wself.photoPagerNode.currentPageIndex + 1) % 3 animated:YES];
    }];
}

-(void)stopCycling{
    [_timer invalidate];
    _timer = nil;
}



#pragma mark - Helpers



@end
