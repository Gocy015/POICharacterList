//
//  ViewController.m
//  POICharacterList
//
//  Created by Gocy on 16/9/21.
//  Copyright © 2016年 Gocy. All rights reserved.
//

#import "ViewController.h"
#import "AsyncDisplayKit.h"
#import "InfoCellNode.h"
#import "CharacterInfo.h"

@interface ViewController () <ASTableDelegate , ASTableViewDataSource>

@property (nonatomic ,strong) ASTableNode *tableNode;
@property (nonatomic ,strong) NSArray <CharacterInfo *>*characters;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Person of Interest";
    
    [self generateData];
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    
    [self.view addSubnode:_tableNode];
    
}

-(void)viewDidLayoutSubviews{
    _tableNode.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
}


#pragma mark - ASTableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.characters.count;
}

-(ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) wself = self;
    
    return ^ASCellNode *{
        InfoCellNode *node = [[InfoCellNode alloc] initWithCharacterInfo:wself.characters[indexPath.row]];
        
        return node;
    };
}


#pragma mark - ASTableDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

-(void)generateData{
    CharacterInfo *john = [CharacterInfo infoWithRole:@"John Reese" actor:@"Jim Caviezel" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/John.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/JohnPhoto.jpg"];
    
    CharacterInfo *harold = [CharacterInfo infoWithRole:@"Harold Finch" actor:@"Michael Emerson" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Harold.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/HaroldPhoto.png"];
    
    CharacterInfo *root = [CharacterInfo infoWithRole:@"Root(Samantha Groves)" actor:@"Amy Acker" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Root.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/RootPhoto.png"];
    
    CharacterInfo *fusco = [CharacterInfo infoWithRole:@"Lionel P.Fusco" actor:@"Kevin Chapman" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Fusco.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/FuscoPhoto.png"];
    
    CharacterInfo *shaw = [CharacterInfo infoWithRole:@"Sameen Shaw" actor:@"Sarah Shahi" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Shaw.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/ShawPhoto.jpg"];
    
    CharacterInfo *bear = [CharacterInfo infoWithRole:@"Bear" actor:@"Graubaer's Boker(2nd and 3rd season)" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Bear.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/BearPhoto.png"];
    
    self.characters = @[harold,john,root,fusco,shaw,bear];
}

@end
