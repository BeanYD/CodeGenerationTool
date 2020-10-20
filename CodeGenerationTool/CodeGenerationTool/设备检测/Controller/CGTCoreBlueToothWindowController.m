//
//  CGTCoreBlueToothWindowController.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/20.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTCoreBlueToothWindowController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>

@interface CGTCoreBlueToothWindowController ()<CBCentralManagerDelegate, CBPeripheralDelegate>

//手机设备
@property (nonatomic, strong) CBCentralManager *mCentral;
//外设设备
@property (nonatomic, strong) CBPeripheral *mPeripheral;
//特征值
@property (nonatomic, strong) CBCharacteristic *mCharacteristic;
//服务
@property (nonatomic, strong) CBService *mService;
//描述
@property (nonatomic, strong) CBDescriptor *mDescriptor;

@end

@implementation CGTCoreBlueToothWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self getBlueTooth];

}

#pragma mark - BlueTooth
- (void)getBlueTooth {
    CBCentralManager *mCentral = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    self.mCentral = mCentral;
}

//2、只要中心管理者初始化,就会触发此代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");
            //3、搜索外设
            [self.mCentral scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                              options:nil]; // dict,条件
        }
            break;
        default:
            break;
    }
}
//4、发现外设后调用的方法
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    NSLog(@"搜索到name==%@,identifier==%@",peripheral.name,peripheral.identifier);
    
    
    
    
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInMicrophone] mediaType:AVMediaTypeAudio position:AVCaptureDevicePositionUnspecified];
//    NSLog(@"%@", session.devices);
    
    for (AVCaptureDevice *device in session.devices) {
//        NSLog(@"device:%@", device);
        if ([device.localizedName isEqualToString:peripheral.name]) {
//            NSLog(@"");
        }
    }
    
    //(ABS(RSSI.integerValue) > 35)，RSSI表示信号强度
    //5、发现完之后就是进行连接
    if ([peripheral.name isEqualToString:@"iPhone-D"]) {
        self.mPeripheral = peripheral;
        self.mPeripheral.delegate = self;
        [self.mCentral connectPeripheral:peripheral options:nil];
    }
}

//6、中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    NSLog(@"%@==设备连接成功", peripheral.name);
    //7、外设发现服务,传nil代表不过滤
    [self.mPeripheral discoverServices:nil];
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"设备连接失败==%@", peripheral.name);
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"设备丢失连接==%@", peripheral.name);
}

//8、发现外设的服务后调用的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    // 是否获取失败
    if (error) {
        NSLog(@"备获取服务失败==%@", peripheral.name);
        return;
    }
    for (CBService *service in peripheral.services) {
        self.mService = service;
        NSLog(@"设备的服务==%@,UUID==%@,count==%lu",service,service.UUID,peripheral.services.count);
        //9、外设发现特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//10、从服务中发现外设特征的时候调用的代理方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *cha in service.characteristics) {
        //该特征值具有读写权限
        if(cha.properties & CBCharacteristicPropertyWrite && cha.properties & CBCharacteristicPropertyRead){
            self.mCharacteristic = cha;
        }
        NSLog(@"设备的服务==%@,服务对应的特征值==%@,UUID==%@,count==%lu",service,cha,cha.UUID,service.characteristics.count);
        //11、获取特征对应的描述 会回调didUpdateValueForDescriptor
        [peripheral discoverDescriptorsForCharacteristic:cha];
        //12、获取特征的值 会回调didUpdateValueForCharacteristic
        [peripheral readValueForCharacteristic:cha];
    }
    if(nil != self.mCharacteristic){
        //打开外设的通知，否则无法接受数据
        [peripheral setNotifyValue:YES forCharacteristic:self.mCharacteristic];
    }
}

//13、更新描述值的时候会调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"描述==%@",descriptor.description);
}

//14、更新特征值的时候调用，可以理解为获取蓝牙发回的数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
    NSLog(@"设备的特征值==%@,获取的数据==%@",characteristic,value);
    //这里可以在这里获取描述，由于项目没有用到描述，所以注释了
//    for (CBDescriptor *descriptor in characteristic.descriptors) {
//        self.mDescriptor = descriptor;
//        [peripheral readValueForDescriptor:descriptor];
//    }
}


//15、通知状态改变时调用
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if(error){
        NSLog(@"改变通知状态");
    }
}

//16、发现外设的特征的描述数组
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    // 在此处读取描述即可
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        self.mDescriptor = descriptor;
        NSLog(@"发现外设的特征descriptor==%@",descriptor);
    }
}

@end
