//
//  NotificationService.swift
//  FlutterNotificationServiceExtension
//
//  Created by Connecthings on 19/07/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import HerowNotificationServiceExtension

class NotificationService: HerowNotificationService {
    public override func getAppGroup() -> String? {
        return "group.connecthings.herow"
    }
}
