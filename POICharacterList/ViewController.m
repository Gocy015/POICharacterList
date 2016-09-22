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
#import "CharacterViewController.h"

@interface ViewController () <ASTableDelegate , ASTableViewDataSource ,CellExpandDelegate>

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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
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
        node.delegate = wself;
        return node;
    };
    
}


#pragma mark - ASTableDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CharacterViewController *characterVC = [[CharacterViewController alloc] initWithInfo:self.characters[indexPath.row]];
    
    [self.navigationController pushViewController:characterVC animated:YES];
    
}

#pragma mark - CellExpandDelegate

-(void)cellNode:(InfoCellNode *)cellNode didExpand:(BOOL)expand{
    if (expand) {
        NSIndexPath *idx = [_tableNode.view indexPathForNode:cellNode];
        CGRect rect = [_tableNode.view rectForRowAtIndexPath:idx];
        if (!CGRectContainsRect(self.tableNode.bounds, rect)) {
            NSLog(@"Scroll %lu",idx.row);
            [self.tableNode invalidateCalculatedLayout];
            [self.tableNode.view scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
}

#pragma mark - Helpers

-(void)generateData{
    CharacterInfo *john = [CharacterInfo infoWithRole:@"John Reese" actor:@"Jim Caviezel" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/John.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/JohnPhoto.jpg"];
    
    CharacterInfo *harold = [CharacterInfo infoWithRole:@"Harold Finch" actor:@"Michael Emerson" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Harold.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/HaroldPhoto.png"];
    
    
    CharacterInfo *root = [CharacterInfo infoWithRole:@"Root(Samantha Groves)" actor:@"Amy Acker" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Root.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/RootPhoto.png"];
    
    CharacterInfo *carter = [CharacterInfo infoWithRole:@"Jocelyn Carter" actor:@"Taraji P. Henson" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Carter.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/CarterPhoto.jpg"];
    
    CharacterInfo *elias = [CharacterInfo infoWithRole:@"Carl G.Elias" actor:@"Enrico Colantoni" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Elias.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/EliasPhoto.png"];
    
    CharacterInfo *fusco = [CharacterInfo infoWithRole:@"Lionel P.Fusco" actor:@"Kevin Chapman" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Fusco.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/FuscoPhoto.png"];
    
    CharacterInfo *shaw = [CharacterInfo infoWithRole:@"Sameen Shaw" actor:@"Sarah Shahi" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Shaw.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/ShawPhoto.jpg"];
    
    CharacterInfo *bear = [CharacterInfo infoWithRole:@"Bear" actor:@"Graubaer's Boker(2nd and 3rd season)" thumbnail:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/Bear.png" photo:@"https://raw.githubusercontent.com/Gocy015/POIImages/master/BearPhoto.png"];
    
    self.characters = @[harold,john,root,fusco,carter,shaw,elias,bear];
}

@end
