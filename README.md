# HEROW

A flutter plugin for the [HEROW SDK](https://herow.io/developers/), a location based SDK related to the [HEROW Platform](https://my.herow.io)

## Getting Started

The Connecthings Flutter plugin allows you to access to the GDPR methods and In-App actions methods from the Dart code.

Nevertheless, the configuration of the SDK must still be done at the android and iOS app level.

A [Flutter application](https://github.com/herowio/herow-bridge-flutter) is available on github to show you a concrete implementation.

You just have to clone the plugin repository [https://github.com/herowio/herow-bridge-flutter](https://github.com/herowio/herow-bridge-flutter), and open it with an android studio configured for flutter.

## Add the plugin to your project

* Open the **pubspec.yaml**
* add to the dependencies section

```yaml
herow:0.0.30
```

## Initialize the SDK

Follow the [iOS](https://docs.herow.io/sdk/6.2/ios/5-minutes-quickstart.html) and [Android](https://docs.herow.io/sdk/6.2/android/5-minutes-quickstart.html) 5-minutes quickstart to initialize the SDK
at the native app level.

### Android

Before following the previous tutorial. You need to open the application build.gradle and change two things :
- The minSdkVersion need to be at least 19 because the SDK doesn't support lower version
- You need to add the HEROW dependency to your application, to be able to initialize the SDK.

```
implementation "com.connecthings.herow:herow-detection:6.3.0![](data:image/jpeg;base64,IyMgMC4wLjI1CgoqIFVwZGF0ZSBTREsgdmVyc2lvbnMuCiogRml4IHBsdWdpbiBzcGVjcyAKCiMjIDAuMC4yNAoKKiBBZGp1c3Qgc2FtcGxlIHByb2plY3QgZm9yIGlPUy4KCiMjIDAuMC4yMwoKKiBVcGRhdGUgdmVyc2lvbnMgZm9yIGlPUyBhbmQgQW5kcm9pZC4KCiMjIDAuMC4yMgoKKiBTeW5jcmhvbml6ZSBpbW1lZGlhdGx5IGFmdGVyIG9wdGlucyBhcmUgZ2l2ZW4uCgojIyAwLjAuMjEKCiogVXBkYXRlIGRvY3VtZW50YXRpb24uCgojIyAwLjAuMjAKCiogTWlub3IgZml4ZXMgb24gc2FtcGxlIHByb2plY3QuCgojIyAwLjAuMTkKCiogVXBkYXRlIHZlcnNpb24gZm9yIEFuZHJvaWQgJiBpT1MKCiMjIDAuMC4xOAoKKiBNaW5vciBmaXhlcyBvbiBzYW1wbGUgcHJvamVjdC4KCiMjIDAuMC4xNwoKKiBVcGRhdGUgdmVyc2lvbiBmb3IgQW5kcm9pZCAmIGlPUwoKIyMgMC4wLjE2CgoqIFVwZGF0ZSBiZXRhIHZlcnNpb24gZm9yIEFuZHJvaWQgJiBpT1MKCiMjIDAuMC4xNQoKKiBVcGRhdGUgYmV0YSB2ZXJzaW9uIGZvciBBbmRyb2lkICYgaU9TCgojIyAwLjAuMTQKCiogVXBkYXRlIGJldGEgdmVyc2lvbiBmb3IgQW5kcm9pZCAmIGlPUwoKIyMgMC4wLjEzCgoqIFVwZGF0ZSBiZXRhIHZlcnNpb24gZm9yIEFuZHJvaWQgJiBpT1MKCiMjIDAuMC4xMgoKKiBVcGRhdGUgYmV0YSB2ZXJzaW9uCgojIyAwLjAuMTEKCiogRml4IHNldEFwcEdyb3VwTmFtZSBpbXBsZW1lbnRhdGlvbi4KCiMjIDAuMC4xMAoKKiBVcGRhdGUgYmV0YSB2ZXJzaW9uCgojIyAwLjAuOQoKKiBGaXggaU9TIHB1c2ggd2hlbiB0ZXN0aW5nIHdpdGggQVBOUyBzYW5kYm94IG1vZGUuCgojIyAwLjAuOAoKKiBVcGRhdGUgZG9jCgojIyAwLjAuNwoKKiBtaW5vciBmaXhlcyBmb3IgaU9TIHZlcnNpb24KCiMjIDAuMC42CgoqIGFkZCBwdXNoIGFuZCBjdXN0b21JRCBmZWF0dXJlcwoqIFVwZGF0ZSBkb2MKCiMjIDAuMC41CgoqIFVwZGF0ZSBkb2MgCgojIyAwLjAuNAoKKiBNaW5vciBmaXggZm9yIGFjdGlvbnMKCiMjIDAuMC4zCgoqIE1pbm9yIGFkanVzdG1lbnRzCgojIyAwLjAuMgoKKiBCZXRhIG9mIEhlcm93IFNESwoKIyMgMC4wLjEKCiogSW5pdGlhbCB2ZXJzaW9uCg==)"
```

>**Warning:**
>
> On Android, when you extend the default application you must use the **FlutterApplication** and not the default Application
>
> ```java
> public class FlutterApp extends FlutterApplication
> ```

### iOS

First thing to do is to update the Podfile sources, you can add at the beginning of the file the following URLs:
- source 'https://github.com/CocoaPods/Specs.git'
- source 'https://forge.herow.io/pub/Specs'

Then, you also need to set the minimum platform support to 9 :

```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://forge.herow.io/pub/Specs'

platform :ios, '9.0'
```


You're ready to follow the iOS tutorial.

If you meet a compilation error about the Flutter.framework duplicated, click on Runner, select **Targets>Runner>Build Phases**.

Next click on **Embed Frameworks** and remove the **Flutter framework**.


>**Note:**
>
> On iOS, if you are using cocoapods 1.7.x or higher version, and you encounter an error when runinng `pod install` command, you will need to follow these steps:
>
> 1- Clean your cocoapods cache
>
> `rm -Rf ~/.cocoapods/repos/`
>
> `rm -Rf Pods Podfile.lock`
>
> 2- Add HEROW Specs repository with the following commands
>
> `pod repo add herow-pub-specs https://forge.herow.io/pub/Specs master`
>
> 3- Redo your pod install command
>
> `pod install`

## Launch and stop ClickAndCollect
You have dart Method to launch clickAndCollect:
```dart
 // ios and android clickAndCollect
 Herow.launchClickAndCollect();
 Herow.stopClickAndCollect();


 ```
## Being compliant with GDPR

The following methods allow your application to be compliant to GDPR.

You can find out more about this by reading our GDPR tutorial for [iOS](https://docs.herow.io/sdk/6.2/ios/being-compliant-with-gdpr.html) and [Android](https://docs.herow.io/sdk/6.2/android/being-compliant-with-gdpr.html).

```dart
try {
//To test if your application has already asked to the user the optins
if (await Herow.optinsNeverAsked) {
//Update the optin
Herow.updateOptin(OPTIN_TYPE.USER_DATA, true);
//Notify the sdk that there is no more optin to update
Herow.allOptinsAreUpdated();
}
//To the the status of a given optin
optinUserDataStatus = await Herow.isOptinAuthorized(OPTIN_TYPE.USER_DATA);
} on PlatformException {

}
```
>**Warning:**
>
> Untill the call to the **Herow.allOptinsAreUpdated()** method, the SDK won't transmit any collected data to the platform.

## The In-App actions

In App Actions are events triggered when the user enter or exit from a place (a geofence configured on the [HEROW Platform](https://my.herow.io))

These events allow you to realize action depending on the information associated with the place.

For example, your application UI can be updated when your user is detected inside an airport or inside in a pub.

You can find out more about this by reading our In-App actions tutorial for [iOS](https://docs.herow.io/sdk/6.2/ios/in-app-action-process.html) and [Android](https://docs.herow.io/sdk/6.2/android/in-app-action-process.html).

Your application can be notified about In App Action events, registering to the In App Action Stream.

```dart
Herow herow = Herow();
herow.inAppActionEvents.listen((data) {
//Status allow to determine if it is a "CREATION" or "REMOVE"
print("data is data:" + data.status.toString());
print("data is data:" + data.id);
print("data is data:" + data.title);
print("data is data:" + data.description);
print("data is data:" + data.tag);
}, onDone: () {
print("done is done");
}, onError: (error) {
print("error is error");
});
```

## Setting custom user ID

The following method allow you to set a custom user ID.

```dart
Herow.setCustomId("customUserIdentifier");
```
