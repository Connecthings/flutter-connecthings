package com.connecthings.flutter.herow;

import com.connecthings.connectplace.actions.inappaction.InAppActionListener;
import com.connecthings.connectplace.actions.inappaction.InAppActionStatusManagerListener;
import com.connecthings.connectplace.actions.inappaction.enums.InAppActionRemoveStatus;
import com.connecthings.connectplace.common.utils.Logger;
import com.connecthings.herow.HerowInitializer;
import com.connecthings.herow.detection.HerowDetectionManager;
import com.connecthings.herow.detection.bridge.HerowPlaceInAppAction;
import com.connecthings.herow.optin.OPTIN;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * HerowPlugin
 */
public class HerowPlugin implements MethodCallHandler, EventChannel.StreamHandler {
    private static final String TAG = "HerowPlugin";

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final HerowPlugin herowPlugin = new HerowPlugin(registrar);

        final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "connecthings.com/herow/optin");
        methodChannel.setMethodCallHandler(herowPlugin);

        final MethodChannel pushMethodChannel = new MethodChannel(registrar.messenger(), "connecthings.com/herow/push");
        pushMethodChannel.setMethodCallHandler(herowPlugin);

        final EventChannel eventChannel = new EventChannel(registrar.messenger(), "connecthings.com/herow/inAppActions");
        eventChannel.setStreamHandler(herowPlugin);
    }

    private final Registrar registrar;
    private final HerowInitializer herowInitializer;

    public HerowPlugin(Registrar registrar) {
        this.herowInitializer = HerowInitializer.getInstance();
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        Logger.d(TAG, "method: %s ", call.method);
        switch (call.method) {
            case "optinsNeverAsked":
                result.success(herowInitializer.optinsNeverAsked());
                break;
            case "updateOptin":
                if (proceedArguments(call, result, "type", "validate")) {
                    herowInitializer.updateOptin(OPTIN.valueOf((String) call.argument("type")), (boolean) call.argument("validate"));
                }
                break;
            case "allOptinsAreUpdated":
                herowInitializer.allOptinsAreUpdated();
                break;
            case "setCustomId":
                if (proceedArguments(call, result, "customId")) {
                    herowInitializer.setCustomId((String) call.argument("customId"));
                }
                break;
            case "removeCustomId":
                herowInitializer.removeCustomId();
                break;
            case "registerForRemoteNotifications":
                herowInitializer.registerForPush( (boolean) call.argument("automaticIntegration"));
                break;
            case "getPushID":
                herowInitializer.getPushId();
                break;
            case "isOptinAuthorized":
                if (proceedArguments(call, result, "type")) {
                    result.success(herowInitializer.isOptinAuthorized(OPTIN.valueOf((String) call.argument("type"))));
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private boolean proceedArguments(MethodCall call, Result result, String... keys) {
        if (call.arguments == null) {
            result.error("ARGUMENT_ERRROR", "Arguements is empty", null);
            return false;
        }
        for (String key : keys) {
            if (!call.hasArgument(key)) {
                result.error("ARGUMENT_ERRROR", "Key " + key + " is empty", null);
                return false;
            }
        }
        return true;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink eventSink) {
        Logger.d(TAG, "START listening in app action");
        HerowDetectionManager.getInstance().registerInAppActionListener(new ListenInAppAction(eventSink));
        Map<String, String> content = new HashMap<>();
    }

    @Override
    public void onCancel(Object arguments) {
        Logger.d(TAG, "STOP listening in app action");
        HerowDetectionManager.getInstance().unregisterInAppActionListener();
    }

    class ListenInAppAction implements InAppActionListener<HerowPlaceInAppAction> {

        private final EventChannel.EventSink eventSink;

        public ListenInAppAction(EventChannel.EventSink eventSink) {
            this.eventSink = eventSink;
        }

        @Override
        public boolean createInAppAction(HerowPlaceInAppAction herowPlaceInAppAction, InAppActionStatusManagerListener inAppActionStatusManagerListener) {
            Logger.d(TAG, "create in app action");
            Map<String, String> content = new HashMap();
            content.put("status", "CREATE");
            content.put("id", herowPlaceInAppAction.getPlaceId());
            content.put("title", herowPlaceInAppAction.getTitle());
            content.put("description", herowPlaceInAppAction.getDescription());
            content.put("tag", herowPlaceInAppAction.getTag());
            eventSink.success(content);
            return true;
        }

        @Override
        public boolean removeInAppAction(HerowPlaceInAppAction herowPlaceInAppAction, InAppActionRemoveStatus inAppActionRemoveStatus) {
            Logger.d(TAG, "remove in app action");
            Map<String, String> content = new HashMap();
            content.put("status", "REMOVE");
            content.put("id", herowPlaceInAppAction.getPlaceId());
            content.put("title", herowPlaceInAppAction.getTitle());
            content.put("description", herowPlaceInAppAction.getDescription());
            content.put("tag", herowPlaceInAppAction.getTag());
            eventSink.success(content);
            return true;
        }
    }
}
