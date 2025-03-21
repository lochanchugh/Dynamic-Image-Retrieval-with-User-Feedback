//
//  ContentView.swift
//  Image Retrieval
//
//  Created by Lochan on 21/03/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var imageURL: String = ""
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false
    
    @State private var showError: Bool = false
//
    @State private var errorMessage: String = ""
    
    @State private var isGrayscale: Bool = false
    @State private var circleColor: Color = .gray

    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(circleColor)
                .frame(width: 30, height: 30)
                .padding()

            
            
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                
                    .scaledToFit()
                    .grayscale(isGrayscale ? 1 : 0)
                    .frame(height: 200)
                    .cornerRadius(10)
                
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(10)
                    .overlay(Text("No Image Loaded").foregroundColor(.white))
            }

            
            
            TextField("Enter image URL", text: $imageURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: loadImage) {
                
                Text("Load Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                
            }

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            
            

            Toggle("Grayscale", isOn: $isGrayscale)
                .padding()
            

            Spacer()
        }
        .padding()
    }
    
    private func loadImage() {
        isLoading = true
        showError = false
        
        errorMessage = ""
        circleColor = .gray
        image = nil

        
        
        guard !imageURL.isEmpty, let url = URL(string: imageURL) else {
            isLoading = false
            showError = true
            errorMessage = "Invalid URL"
            circleColor = .red
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    showError = true
                    errorMessage = error.localizedDescription
                    circleColor = .red
                    return
                }
                
                

                if let data = data, let uiImage = UIImage(data: data) {
                    image = uiImage
                    circleColor = .green
                } else {
                    showError = true
                    errorMessage = "Failed to load image"
                    circleColor = .red
                }
            }
            
        }.resume()
        
        
    }
}

#Preview {
    ContentView()
}
