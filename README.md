# Herow

A flutter plugin for the [Herow SDK](https://www.connecthings.com/developers/), a location based SDK related to the [Herow Platform](https://my.herow.io)

## Getting Started

The Connecthings Flutter plugin allows you to access to the GDPR methods and In-App actions methods from the Dart code.

Nevertheless, the configuration of the SDK must still be done at the android and iOS app level.

A [Flutter application](https://github.com/Connecthings/flutter-connecthings) is available on github to show you a concrete implementation.

You just have to clone the plugin repository [https://github.com/Connecthings/flutter-connecthings](https://github.com/Connecthings/flutter-connecthings), and open it with an android studio configured for flutter.

## Add the plugin to your project

* Open the **pubspec.yaml**
* add to the dependencies section

```yaml
Herow:0.0.3
```

## Initialize the SDK

Follow the [iOS](https://docs.connecthings.com/4.6/ios/5-minutes-quickstart.html) and [Android](https://docs.connecthings.com/4.6/android/5-minutes-quickstart.html) 5-minutes quickstart to initialize the SDK
at the native app level.

### Android

Before following the previous tutorial. You need to open the application build.gradle and change two things :
- The minSdkVersion need to be at least 19 because the SDK doesn't support lower version
- You need to add the herow dependency to your application, to be able to initialize the SDK. 

```
implementation "com.connecthings.herow:herow-detection:4.7-TM-beta_7"
```

>**Warning:**
> 
> On Android, when you extend the default application you must use the **FlutterApplication** and not the default Application
> 
> ` public class FlutterApp extends FlutterApplication `

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
> 2- Add Herow Specs repository with the following commands
> 
> `pod repo add herow-pub-specs https://forge.herow.io/pub/Specs master`
> 
> 3- Redo your pod install command
> 
> `pod install`

## Being compliant with GDPR

The following methods allow your application to be compliant to GDPR.

You can find out more about this by reading our [GDPR tutorial](being-compliant-with-gdpr.html).

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

In App Actions are events triggered when the user enter or exit from a place (a geofence zone or beacon configured on the [Herow Platform](https://my.herow.io))

These events allow you to realize action depending on the information associated with the place.

For example, your application UI can be updated when your user is detected inside an airport or inside in a pub.

You can find out more about this by reading our [In-App actions tutorial](in-app-action-process.html).

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
