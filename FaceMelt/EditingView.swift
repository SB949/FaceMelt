import SwiftUI

struct EditingView: View {
    let image: UIImage
    @State private var blurCircles: [BlurCircle] = []
    @State private var selectedCircle: BlurCircle?
    @State private var blurIntensity: Double = 0.5
    @State private var processedImage: UIImage?
    @State private var isAutoDetectEnabled = true
    
    private let faceDetectionService = FaceDetectionService()
    private let imageProcessingService = ImageProcessingService()
    
    var body: some View {
        NavigationView {
            VStack {
                if let processedImage = processedImage {
                    Image(uiImage: processedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            GeometryReader { geometry in
                                ForEach(blurCircles) { circle in
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 2)
                                        .frame(width: circle.radius * 2, height: circle.radius * 2)
                                        .position(circle.center)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    updateCirclePosition(circle, to: value.location)
                                                }
                                        )
                                        .gesture(
                                            MagnificationGesture()
                                                .onChanged { scale in
                                                    updateCircleRadius(circle, scale: scale)
                                                }
                                        )
                                }
                            }
                        )
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                VStack {
                    Toggle("Auto-detect Faces", isOn: $isAutoDetectEnabled)
                        .padding()
                    
                    Slider(value: $blurIntensity, in: 0...1)
                        .padding()
                        .onChange(of: blurIntensity) { _ in
                            updateBlurIntensity()
                        }
                    
                    HStack {
                        Button("Add Blur") {
                            addBlurCircle()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Undo") {
                            undoLastAction()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Save") {
                            saveImage()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // Dismiss view
                    }
                }
            }
        }
        .onAppear {
            if isAutoDetectEnabled {
                detectFaces()
            }
        }
    }
    
    private func detectFaces() {
        faceDetectionService.detectFaces(in: image) { faceRects in
            blurCircles = faceRects.map { rect in
                BlurCircle(
                    center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: max(rect.width, rect.height) / 2,
                    blurIntensity: blurIntensity
                )
            }
            processImage()
        }
    }
    
    private func addBlurCircle() {
        let newCircle = BlurCircle(
            center: CGPoint(x: 200, y: 200),
            radius: 100,
            blurIntensity: blurIntensity
        )
        blurCircles.append(newCircle)
        processImage()
    }
    
    private func updateCirclePosition(_ circle: BlurCircle, to position: CGPoint) {
        if let index = blurCircles.firstIndex(where: { $0.id == circle.id }) {
            blurCircles[index].center = position
            processImage()
        }
    }
    
    private func updateCircleRadius(_ circle: BlurCircle, scale: CGFloat) {
        if let index = blurCircles.firstIndex(where: { $0.id == circle.id }) {
            blurCircles[index].radius *= scale
            processImage()
        }
    }
    
    private func updateBlurIntensity() {
        for index in blurCircles.indices {
            blurCircles[index].blurIntensity = blurIntensity
        }
        processImage()
    }
    
    private func processImage() {
        processedImage = imageProcessingService.applyBlurCircles(to: image, circles: blurCircles)
    }
    
    private func undoLastAction() {
        if !blurCircles.isEmpty {
            blurCircles.removeLast()
            processImage()
        }
    }
    
    private func saveImage() {
        guard let processedImage = processedImage else { return }
        UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil)
    }
} 