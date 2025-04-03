//
//  ViewControllerModel.swift
//  BM_DemoApp
//
//  Created by surya-15302 on 03/04/25.
//

import UIKit
import BusinessMessagingSDK

class ViewControllerModel {
    func show(orgId: String, appId: String, domain: String) {
        BusinessMessaging.show(orgId: orgId, appId: appId, domain: domain)
    }
}
