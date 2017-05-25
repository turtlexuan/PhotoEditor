//
//  ViewController.m
//  PhotoEditor
//
//  Created by 劉仲軒 on 2017/5/24.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUp];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUp {
    
    [self.addPhotoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    [self.addPhotoButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.addPhotoButton addTarget:self action:@selector(choosePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addPhotoButton.layer.cornerRadius = self.addPhotoButton.frame.size.width / 2;
    
}

- (void)choosePhotoAction:(UIButton *)sender {
    
    UIAlertController *alertController = [[UIAlertController alloc] init];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.allowsEditing = NO;
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
        
        
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"From Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.allowsEditing = NO;
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];

        
    }];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:self.addPhotoButton.currentBackgroundImage];
        cropController.delegate = self;
        
        [self presentViewController:cropController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.addPhotoButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.addPhotoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    if (self.addPhotoButton.currentBackgroundImage == nil) {
        
        [alertController addAction:cameraAction];
        [alertController addAction:photoAction];
        [alertController addAction:cancelAction];
        
    } else {
        
        [alertController addAction:cameraAction];
        [alertController addAction:photoAction];
        [alertController addAction:editAction];
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];

    }
    
    [self presentViewController:alertController animated:true completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
    cropController.delegate = self;
    
    [picker pushViewController:cropController animated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    
    [self.addPhotoButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.addPhotoButton setTitle:nil forState:UIControlStateNormal];
    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
