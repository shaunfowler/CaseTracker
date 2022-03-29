//
//  OrbIndicator.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/28/22.
//

import SwiftUI

struct OrbIndicator: View {

    var color: Color
    var size: CGFloat

    init(color: Color, size: CGFloat = 8.0) {
        self.color = color
        self.size = size
    }

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: size, height: size, alignment: .center)
            Circle()
                .foregroundColor(color.opacity(0.2))
                .frame(width: size * 2, height: size * 2, alignment: .center)
        }
    }
}

struct Orb_Previews: PreviewProvider {

    static var content: some View {
        HStack {
            OrbIndicator(color: .blue)
            OrbIndicator(color: .green)
            OrbIndicator(color: .yellow)
            OrbIndicator(color: .orange)
            OrbIndicator(color: .red)
            OrbIndicator(color: .gray)
        }
        .padding()
    }

    static var previews: some View {
        Group {
            content.preferredColorScheme(.light)
            content.preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 300, height: 200))
    }
}
