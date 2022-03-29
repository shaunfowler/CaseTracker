//
//  BarIndicator.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/29/22.
//

import SwiftUI

struct BarIndicator: View {

    var color: Color
    var width: CGFloat

    init(color: Color, width: CGFloat = 8.0) {
        self.color = color
        self.width = width
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(color)
                .frame(width: width / 2, alignment: .center)
            Rectangle()
                .foregroundColor(color.opacity(0.2))
                .frame(width: width, alignment: .center)
        }
        .clipShape(RoundedRectangle(cornerRadius: 2))
    }
}

struct BarIndicator_Previews: PreviewProvider {

    static var content: some View {
        HStack {
            BarIndicator(color: .blue)
            BarIndicator(color: .green)
            BarIndicator(color: .yellow)
            BarIndicator(color: .orange)
            BarIndicator(color: .red)
            BarIndicator(color: .gray)
        }
        .padding()
    }

    static var previews: some View {
        Group {
            content.preferredColorScheme(.light)
            content.preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}
