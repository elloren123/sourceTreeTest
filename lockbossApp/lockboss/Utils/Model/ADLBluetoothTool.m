//
//  ADLBluetoothTool.m
//  ADEL-APP
//
//  Created by bailun91 on 2018/7/26.
//

#import "ADLBluetoothTool.h"
#import "BabyBluetooth.h"

#import <NETLockAPI/NETLockAPI.h>  //TODO

#import "ADLToast.h"

#define channelOnPeropheralView @"ADLBluetoothToo"
@interface ADLBluetoothTool ()<CBPeripheralManagerDelegate>{
   
    BabyBluetooth *baby;
}

@property (nonatomic, strong) CBPeripheral *currPeripheral;
@property (nonatomic,strong) CBPeripheralManager *manager;

@end
@implementation ADLBluetoothTool


#pragma mark  - 蓝牙开锁
- (void)BLEOpendoor{
    

    // 断开连接
    [baby cancelAllPeripheralsConnection];
    
    
    baby = [BabyBluetooth shareBabyBluetooth];
     self.manager=[[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    
    [self babyDelegate];
    baby.channel(channelOnPeropheralView).then.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics().begin();
    
//    //30秒后停止扫描
   //   baby.scanForPeripherals().stop(30);
    

//    WS(ws);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //停止扫描
        [self->baby cancelScan];
        //蓝牙开锁停止通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELMsgRemindOpenLockNotification" object:nil userInfo:nil];
        
    });
}
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
        {
           // NSLog(@"蓝牙开启且可用");
        }
            break;
        default:
            //蓝牙开锁停止通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELMsgRemindOpenLockNotification" object:nil userInfo:nil];
            [ADLToast showMessage:@"设备打开失败,请检查蓝牙设备是否开启" duration:3];
            break;
    }
}
#pragma mark  - 蓝牙代理
- (void)babyDelegate{

    WS(weakSelf);
   //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripheralsAtChannel:channelOnPeropheralView filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
       
        if ([peripheralName isEqualToString:weakSelf.BLEName] ) {
      
            return YES;
        }else{
            return NO;
        }
        
    }];
    
    //设置连接设备的过滤器
    [baby setFilterOnConnectToPeripheralsAtChannel:channelOnPeropheralView filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString * advName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
        NSString * pName = peripheralName;
        if ([weakSelf.BLEName isEqualToString:advName] ||[weakSelf.BLEName isEqualToString:pName]){
            return YES;
        }
        return NO;
    }];
    
    [baby setBlockOnDiscoverToPeripheralsAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
    }];
    
    
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [ADLToast showMessage:@"蓝牙连接成功" duration:3];
        weakSelf.currPeripheral = peripheral;
        [weakSelf cancelScan];
    }];
    
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        ADLLog(@"设备：%@--连接失败",peripheral.name);

        
    }];
    
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [weakSelf scan];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        
    }];
    
    
#pragma mark  想要接收蓝牙返回值,先在蓝牙代理发现外设服务的特征方法里面加上订阅蓝牙通知
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {

        [BLETool notification:peripheral enabled:YES]; //TODO
  
        
        //NSLog(@"serviceservice111:%@",service);

        if (service.peripheral.services.count == 3) {
            CBUUID *UUID = service.UUID;
            NSString *uuids = [UUID UUIDString];
            if ([uuids isEqualToString:@"FEF5"]) {
            [BLETool BLEOpendoorWithPeripheral:weakSelf.currPeripheral dataStr:weakSelf.mBLEKey]; //TODO
            }
        }else {
           [BLETool BLEOpendoorWithPeripheral:weakSelf.currPeripheral dataStr:weakSelf.mBLEKey]; //TODO
        }
        
         
    }];
    
    //接收蓝牙返回的数据
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){
        
        NSString * value =  [BLETool didRecvValueWithPeripheral:weakSelf.currPeripheral value:[weakSelf convertDataToHexStr:characteristic.value]];//TODO
//        NSString * value = @"";  //TODO
        if (value.length == 2) {
            if ([value isEqualToString:@"00"]) {
                //蓝牙开锁成功通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELOpenLockSuccessfulNotification" object:nil userInfo:nil];
                [ADLToast showMessage:@"开锁成功" duration:3];
                [weakSelf disConnectBLE];
                
            }else {
            //蓝牙开锁停止通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELMsgRemindOpenLockNotification" object:nil userInfo:nil];
                [ADLToast showMessage:@"开锁失败" duration:3];
                [weakSelf disConnectBLE];
                
            }
        }
    }];
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

#pragma mark  - 辅助类
- (void)disConnectBLE{
    //断开蓝牙连接
    [baby cancelPeripheralConnection:self.currPeripheral];
    //断开所有蓝牙连接
    [baby cancelAllPeripheralsConnection];
    //停止扫描
    [baby cancelScan];
}
//停止扫描
- (void)cancelScan{
    [baby cancelScan];
}
- (void)scan{
    baby.scanForPeripherals().and.channel(channelOnPeropheralView);
}
@end
