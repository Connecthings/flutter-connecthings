#import "HerowPlugin.h"
#import <herow/herow-Swift.h>

@implementation HerowPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHerowPlugin registerWithRegistrar:registrar];
}
@end
