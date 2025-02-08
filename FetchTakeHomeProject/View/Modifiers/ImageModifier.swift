//
//  ImageModifier.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/7/25.
//

import SwiftUI

extension Image {
    func formatImage(maxHeight: CGFloat) -> some View {
        return self
            .resizable()
            .scaledToFit()
            .frame(height: maxHeight)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
