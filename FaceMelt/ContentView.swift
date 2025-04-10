import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isEditingViewPresented = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Text("FaceMelt")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Blur faces in your photos")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Select Photo")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage, isPresented: $isImagePickerPresented)
            }
            .fullScreenCover(isPresented: $isEditingViewPresented) {
                if let image = selectedImage {
                    EditingView(image: image)
                }
            }
            .onChange(of: selectedImage) { newImage in
                if newImage != nil {
                    isEditingViewPresented = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 