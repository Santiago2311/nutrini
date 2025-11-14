//
//  OrientationManager.swift
//  Interfaces
//
//  Created by Oriana I. Cañizales Hdz. on 21/09/25.
//

import SwiftUI

struct OrientationManager {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        }
    }
}

