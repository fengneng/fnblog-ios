//
//  CDPhotoNewsVM.m
//  CheatDictionary
//
//  Created by zzy on 2018/8/21.
//  Copyright © 2018年 朱正毅. All rights reserved.
//

#import "CDPhotoNewsVM.h"
#import "CDPhotoFlowNewsModel.h"
#import "CDSectionModel.h"

@implementation CDPhotoNewsVM

- (void)loadData {
    
    [CDApiClient GET:@"photo_flow" success:^(NSDictionary *data) {
        
        [self _parseData:data];
        if (self.completeLoadDataBlock) {
            self.completeLoadDataBlock(YES);
        }
        
    } failure:^(NSInteger code, NSString *message) {
        if (!self.objects.count) {
            NSString *jPath = [[NSBundle mainBundle] pathForResource:@"photo_flow" ofType:@"json"];
            NSDictionary *jDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jPath] options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *data = [jDic objectForKey:@"data"];
            
            [self _parseData:data];
            if (self.completeLoadDataBlock) {
                self.completeLoadDataBlock(YES);
            }
            return;
        }
        if (self.completeLoadDataBlock) {
            self.completeLoadDataBlock(NO);
        }
    }];
}

- (void)_parseData:(NSDictionary *)data {
    NSArray *items = [data objectForKey:@"items"];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (NSDictionary *item in items) {
        CDSectionModel *sectionModel = [CDSectionModel new];
        CDShowMoreHeaderModel *header = [CDShowMoreHeaderModel new];
        header.title = item[@"title"];
        sectionModel.headerModel = header;
        sectionModel.objects = [NSMutableArray array];
        NSArray *channels = item[@"items"];
        for (NSDictionary *channel in channels) {
            CDPhotoFlowNewsModel *channelModel = [CDPhotoFlowNewsModel modelWithJSON:channel];
            [sectionModel.objects addObject:channelModel];
        }
        [mutableArray addObject:sectionModel];
    }
    
    self.objects = mutableArray;
}


@end
