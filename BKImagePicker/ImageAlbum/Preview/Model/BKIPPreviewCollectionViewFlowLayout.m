//
//  BKIPPreviewCollectionViewFlowLayout.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/30.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPPreviewCollectionViewFlowLayout.h"
#import "BKImagePickerHeader.h"

@implementation BKIPPreviewCollectionViewFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(BKIP_SCREENW + BKExampleImagesSpacing*2, BKIP_SCREENH);
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake((BKIP_SCREENW + BKExampleImagesSpacing*2) * _allImageCount, BKIP_SCREENH);
}

@end
