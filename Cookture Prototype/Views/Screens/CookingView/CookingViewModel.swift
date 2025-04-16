//
//  CookingViewModel.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-08.
//

import SwiftUI
import CoreML
import Vision
import AVFoundation

final class CookingViewModel: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var classificationLabel: String = ""
    @Published var classificationLabelProbabilities: [String: Double] = [:]
    @Published var cameraAuthorizationStatus: AVAuthorizationStatus = .notDetermined
    
    @Published var currentStepID: UUID? = nil
    
    // MARK: - Private Properties
    private var model: CooktureHandActionClassifier?
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    private var frameBuffer: [VNHumanHandPoseObservation] = []
    
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    // MARK: - Initializer
    // Overrides initializer of the superclass (NSObject)
    override init() {
        super.init() // Initialize the superclass (NSObject)
        configureModel()
        checkCameraPermissions()
    }
    
    // MARK: - Model Configuration
    private func configureModel() {
        do {
            self.model = try CooktureHandActionClassifier(configuration: MLModelConfiguration())
        } catch {
            print("Error initialising CooktureHandActionClassifier: \(error)")
        }
    }
    
    // MARK: - Capture Session Configuration
    private func configureCaptureSession() {
        // Adjust the sessionPreset if you want higher or lower quality
        captureSession.sessionPreset = .high
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front), let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Unable to access front camera.")
            return
        }
        
        // Add the video input
        if captureSession.canAddInput(videoDeviceInput) {
            captureSession.addInput(videoDeviceInput)
        }
        
        // Configure the video output
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // Start the capture session on a background thread
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            captureSession.startRunning()
        }
    }
    
    // MARK: - Camera Permisssion Check
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.cameraAuthorizationStatus = .authorized
            self.configureCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.cameraAuthorizationStatus = granted ? .authorized : .denied
                    if granted { self.configureCaptureSession() }
                }
            }
        case .denied, .restricted:
            self.cameraAuthorizationStatus = .denied
        @unknown default:
            self.cameraAuthorizationStatus = .denied
            print("WARNING: Unknown camera authorization status detected. Explictly making CameraManager's authorizationStatus .denied")
        }
    }
    
    // MARK: - Hand Pose Processing
    private func processHandPoseObservations(_ observations: [VNHumanHandPoseObservation]) {
        // For simplicity, it just uses the first (most confident) for each frame.
        if let observation = observations.first {
            frameBuffer.append(observation)
            
            // it can classify the sequence once it has 60 frames.
            if frameBuffer.count == 60 {
                classifyHandSequence(frameBuffer)
                frameBuffer.removeAll()
            }
        }
    }
    
    // MARK: - Hand Sequence Classification
    private func classifyHandSequence(_ observations: [VNHumanHandPoseObservation]) {
        guard let model = model else {
            print("Model not initialised")
            return
        }
        
        // The model expects a MultiArray (Float32 60 x 3 x 21) where:
        //   - 60 is the time dimension (frames),
        //   - 3 is for (x, y, confidence),
        //   - 21 is for the 21 keypoints (wrist, thumb joints, index joints, etc.).
        
        // Create the MLMultiArray
        let shape: [NSNumber] = [60, 3, 21]
        
        guard let mlMultiArray = try? MLMultiArray(shape: shape, dataType: .float32) else {
            print("Unable to create MLMultiArray of shape \(shape)")
            return
        }
        
        let jointKeys: [VNHumanHandPoseObservation.JointName] = [
            .wrist,
            .thumbCMC, .thumbMP, .thumbIP, .thumbTip,
            .indexMCP, .indexPIP, .indexDIP, .indexTip,
            .middleMCP, .middlePIP, .middleDIP, .middleTip,
            .ringMCP, .ringPIP, .ringDIP, .ringTip,
            .littleMCP, .littlePIP, .littleDIP, .littleTip
        ]
        
        // Populate mlMultiArray with the keypoints from each frame
        for (frameIndex, observation) in observations.enumerated() {
            do {
                let recognizedPoints = try observation.recognizedPoints(.all)
                
                for (jointIndex, jointName) in jointKeys.enumerated() {
                    if let point = recognizedPoints[jointName] {
                        let x = Float(point.location.x)
                        let y = Float(point.location.y)
                        let confidence = Float(point.confidence)
                        
                        // The layout is [frame, (0=x,1=y,2=confidence), jointIndex]
                        mlMultiArray[[frameIndex, 0, jointIndex] as [NSNumber]] = NSNumber(value: x)
                        mlMultiArray[[frameIndex, 1, jointIndex] as [NSNumber]] = NSNumber(value: y)
                        mlMultiArray[[frameIndex, 2, jointIndex] as [NSNumber]] = NSNumber(value: confidence)
                    } else {
                        // Failed to detect a particular joint; setting to 0.
                        mlMultiArray[[frameIndex, 0, jointIndex] as [NSNumber]] = 0
                        mlMultiArray[[frameIndex, 1, jointIndex] as [NSNumber]] = 0
                        mlMultiArray[[frameIndex, 2, jointIndex] as [NSNumber]] = 0
                    }
                }
            } catch {
                print("Error getting recognized points: \(error)")
                return
            }
        }
        
        // Perform inference
        do {
            let prediction = try model.prediction(poses: mlMultiArray)
            DispatchQueue.main.async {
                // Storing the classification result
                self.classificationLabel = prediction.label
                self.classificationLabelProbabilities = prediction.labelProbabilities
                print(prediction.label + " probability: \(String(describing: prediction.labelProbabilities[prediction.label]))")
            }
        } catch {
            print("Error performing model prediction: \(error)")
        }
    }
    
    // MARK: - UI Handling Functions
    func moveStep(recipe: Recipe, forward: Bool) {
        let currentIndex = recipe.steps.firstIndex(where: { $0.id == self.currentStepID })
        
        let destinationIndex = forward ? (currentIndex ?? 0) + 1 : (currentIndex ?? 0) - 1
        
        guard (0 ..< recipe.steps.count).contains(destinationIndex) else { return }
        
        withAnimation { self.currentStepID = recipe.steps[destinationIndex].id }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CookingViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // Determine the correct camera orientation based on the connection's videoOrientation
        let videoOrientation = connection.videoOrientation
        let imageOrientation: CGImagePropertyOrientation
        switch videoOrientation {
        case .portrait:
            imageOrientation = .right
        case .portraitUpsideDown:
            imageOrientation = .left
        case .landscapeRight:
            imageOrientation = .down
        case .landscapeLeft:
            imageOrientation = .up
        @unknown default:
            imageOrientation = .right
        }
        
        // Create a request handler
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: imageOrientation, options: [:])
        
        do {
            // Perform the request
            try requestHandler.perform([handPoseRequest])
            // If handPoseRequest produced results, process them
            if let observations = handPoseRequest.results, !observations.isEmpty {
                processHandPoseObservations(observations)
            }
        } catch {
            print("Error performing hand pose request: \(error)")
        }
    }
}

// MARK: - Classification Result Enumeration
// This is for a safe and easy result handling.
enum CooktureHandActionClassifierResult: String, CaseIterable, Identifiable {
    case swipeup = "Swipe up"
    case swipeDown = "Swipe down"
    case openFist = "Open fist"
    case closeFist = "Close fist"
    
    var id: Self { self } 
}
