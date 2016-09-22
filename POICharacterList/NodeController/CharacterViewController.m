//
//  CharacterViewController.m
//  POICharacterList
//
//  Created by Gocy on 16/9/22.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "CharacterViewController.h"
#import "CharacterInfo.h"
#import "CharacterDetailNode.h"

@interface CharacterViewController ()


@end

@implementation CharacterViewController


#pragma mark - Life Cycle

-(instancetype)initWithInfo:(CharacterInfo *)info{
    self = [super initWithNode:[[CharacterDetailNode alloc] initWithInfo:info]];
    
    self.title = [NSString stringWithFormat:@"%@",info.role];
     
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
