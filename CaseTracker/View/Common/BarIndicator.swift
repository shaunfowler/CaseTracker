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
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(color)
                .padding(2)
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(color.opacity(0.3))
        }
        .frame(width: width, alignment: .center)
    }
}

struct BarIndicator_Previews: PreviewProvider {

    static var content: some View {
        HStack {
            BarIndicator(color: .blue, width: 20)
            BarIndicator(color: .blue, width: 5)
            BarIndicator(color: .blue)
            BarIndicator(color: .green)
            BarIndicator(color: .yellow)
            BarIndicator(color: .orange)
            BarIndicator(color: .red)
            BarIndicator(color: .gray)
        }
        .padding()
        .background(Color.ctBackgroundSecondary)
    }

    static var previews: some View {
        Group {
            content.preferredColorScheme(.light)
            content.preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 160, height: 100))
    }
}
