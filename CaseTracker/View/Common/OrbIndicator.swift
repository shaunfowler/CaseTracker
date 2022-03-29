//
//  OrbIndicator.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/28/22.
//

import SwiftUI

struct OrbIndicator: View {

    var color: Color
    var orbSize: CGFloat

    init(color: Color, orbSize: CGFloat = 8.0) {
        self.color = color
        self.orbSize = orbSize
    }

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: orbSize, height: orbSize, alignment: .center)
            Circle()
                .foregroundColor(color.opacity(0.2))
                .frame(width: orbSize * 2, height: orbSize * 2, alignment: .center)
        }
    }
}

struct Orb_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OrbIndicator(color: .ctRed)
            OrbIndicator(color: .ctBlue)
            OrbIndicator(color: .ctRed)
            OrbIndicator(color: .ctYellow)
            OrbIndicator(color: .ctOrange)
            OrbIndicator(color: .ctGray)
            OrbIndicator(color: .ctGray)
        }
        .previewLayout(.sizeThatFits)
    }
}
