# Herow

A flutter plugin for the [Herow SDK](https://www.connecthings.com/developers/), a location based SDK related to the [Herow Platform](https://my.herow.io)

## Getting Started

Follow the [Android Quickstart](https://docs.connecthings.com/4.6/android/5-minutes-quickstart.html) and the [iOs Quickstart](https://docs.connecthings.com/4.6/ios/5-minutes-quickstart.html)

### Android

**Warning**: On Android when extended the Application class, you must use the **FlutterApplication** and not the default android Application

```java
public class FlutterApp extends FlutterApplication
```

### iOS

If you meet a compilation error about the Flutter.framework duplicated, click on Runner, select **Targets>Runner>Build Phases**.

Next click on **Embed Frameworks** and remove the **Flutter framework**.

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

**Warning**: Untill the call to the **Herow.allOptinsAreUpdated();** method, the SDK won't transmit the data collected the platform.


## In App Actions

In App Actions are events triggered when the user enter or exit from a place (a geofence zone or beacon configured on the [Herow Platform](https://my.herow.io))

These events allow you to realize action depending of the informations associated to the place.

For example, your application UI can be updated when your user is detected inside an airport or inside in a pub.

You can find out more about this by reading our [In-App actions tutorial](in-app-action-process.html).

Your application can be notified about In App Action events, registering to the In App Action Stream

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
