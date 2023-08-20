import UIKit
import AVFoundation
import Vision

protocol CountFingerDelegate {
    func setFingerCount(number: Int)
}

class CameraViewController: UIViewController, CountFingerDelegate {
    
    func setFingerCount(number: Int) {
        
    }
    
    
    var fingerDelegate :CountFingerDelegate?
    
    var fingerCount: Int = 0
    
    
    // swiftlint:disable:next force_cast
    
    private var cameraView: CameraPreview { view as! CameraPreview }
    private var objecCount: Int!
    
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    
    private var permissionGranted = false
    
    private var cameraFeedSession: AVCaptureSession?
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 2
        return request
    }()
    
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    
    var ammountFinger: ((Int) -> Void)?
    
    override func loadView() {
        fingerDelegate = self
        view = CameraPreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            if cameraFeedSession == nil {
                try setupAVSession()
                cameraView.previewLayer.session = cameraFeedSession
                cameraView.previewLayer.videoGravity = .resizeAspectFill
            }
            DispatchQueue.global(qos: .background).async {
                self.cameraFeedSession?.startRunning()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
            
        case .notDetermined:
            requestPermission()
            
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }
    
    
    func setupAVSession() throws {
        // Select a front facing camera, make an input.
        guard let videoDevice = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front)
        else { return }
        
        guard let deviceInput = try? AVCaptureDeviceInput(
            device: videoDevice
        ) else { return }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        guard session.canAddInput(deviceInput)  else { return }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }     else { return }
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    func processPoints(_ fingerTips: [CGPoint]) {
        // Convert points from AVFoundation coordinates to UIKit coordinates.
        let convertedPoints = fingerTips.map {
            cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        
        
        pointsProcessorHandler?(convertedPoints)
    }
    
    func processFingers(_ fingerDistance: [CGFloat]) {
        let convertedPositions = fingerDistance
        
        ammountFinger?(convertedPositions.count)
    }
    
    
    
    func process2Points(_ points: [CGPoint?]) {
        
        // Convert points from AVFoundation coordinates to UIKit coordinates.
        let previewLayer = cameraView.previewLayer
        var pointsConverted: [CGPoint] = []
        for point in points {
            pointsConverted.append(previewLayer.layerPointConverted(fromCaptureDevicePoint: point!))
        }
        
        let thumbTip = pointsConverted[0]
        let wrist = pointsConverted[pointsConverted.count - 1]
        
        let xDistance  = thumbTip.x - wrist.x
        let yDistance  = thumbTip.y - wrist.y
        
        //        print(yDistance)
        //
        
        var fingerCount = 0
        for i in 1...6{
            if (i == 1_) {
                let xDistance = points[i]!.x - points[0]!.x
                if (xDistance < -150){
                    fingerCount += 1
                }
            }else {
                let yDistance = points[i]!.y - points[0]!.y
                if (xDistance < -150){
                    fingerCount += 1
                }
            }
            
            fingerDelegate?.setFingerCount(number: fingerCount)
            //        }
            
            //        if(yDistance > 50){
            //
            //
            //                        if self.restingHand{
            //                            print("👎")
            //
            //
            //                        }
            //
            //                    }else if(yDistance < -50){
            //
            //                        if self.restingHand{
            //
            //                            print("👍")
            //                            self.restingHand = false
            //
            //                        }
            //                    }
            //                    else{
            //                        print("✋")
            //                        self.restingHand = true
            //                    }
            //                    print(yDistance)
            //        print(xDistance)
            
            cameraView.showPoints(pointsConverted)
        }
        
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
   
  
    
  func captureOutput( _ output: AVCaptureOutput,didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
      
      var thumbTip: CGPoint?
      var wrist: CGPoint?
      var indexTip: CGPoint?
      var middleTip: CGPoint?
      var ringTip:CGPoint?
      var littleTip: CGPoint?
      
      var fingerTips: [CGPoint] = []
      var fingerPositions: [CGFloat] = []
      

    defer {
      DispatchQueue.main.sync {
//          self.process2Points([littleTip, wrist])
          self.processPoints(fingerTips)
          
      }
    }

    let handler = VNImageRequestHandler(
      cmSampleBuffer: sampleBuffer,
      orientation: .up,
      options: [:]
    )
    do {
      // Perform VNDetectHumanHandPoseRequest
      try handler.perform([handPoseRequest])

      // Continue only when at least a hand was detected in the frame. We're interested in maximum of two hands.
      guard
        let results = handPoseRequest.results?.prefix(2),
        !results.isEmpty
      else {
        return
      }

      var recognizedPoints: [VNRecognizedPoint] = []

      try results.forEach { observation in
        // Get points for all fingers.
        let fingers = try observation.recognizedPoints(.all)

//          if let wristPoint = fingers[.wrist] {
//              recognizedPoints.append(wristPoint)
//          }
//
        // Look for tip points.
          if let thumbTipPoint = fingers[.thumbTip] {
          recognizedPoints.append(thumbTipPoint)
        }
        if let indexTipPoint = fingers[.indexTip] {
          recognizedPoints.append(indexTipPoint)
        }
        if let middleTipPoint = fingers[.middleTip] {
          recognizedPoints.append(middleTipPoint)
        }
        if let ringTipPoint = fingers[.ringTip] {
          recognizedPoints.append(ringTipPoint)
        }
        if let littleTipPoint = fingers[.littleTip] {
          recognizedPoints.append(littleTipPoint)
        }
      }

        guard let observation = handPoseRequest.results?.first else {
            cameraView.showPoints([])
            return
        }
//
//        // Get points for all fingers
//        let thumbPoints = try observation.recognizedPoints(.thumb)
//        let wristPoints = try observation.recognizedPoints(.all)
//        let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
//        let middleFingerPoints = try observation.recognizedPoints(.middleFinger)
//        let ringFingerPoints = try observation.recognizedPoints(.ringFinger)
//        let littleFingerPoints = try observation.recognizedPoints(.littleFinger)
//
//        // Extract individual points from Point groups.
//        guard let thumbTipPoint = thumbPoints[.thumbTip],
//              let indexTipPoint = indexFingerPoints[.indexTip],
//              let middleTipPoint = middleFingerPoints[.middleTip],
//              let ringTipPoint = ringFingerPoints[.ringTip],
//              let littleTipPoint = littleFingerPoints[.littleTip],
//              let wristPoint = wristPoints[.wrist]
//        else {
//            cameraView.showPoints([])
//            return
//        }
//
//        let confidenceThreshold: Float = 0.7
//        guard   thumbTipPoint.confidence > confidenceThreshold &&
//                indexTipPoint.confidence > confidenceThreshold &&
//                middleTipPoint.confidence > confidenceThreshold &&
//                ringTipPoint.confidence > confidenceThreshold &&
//                littleTipPoint.confidence > confidenceThreshold &&
//                wristPoint.confidence > confidenceThreshold
//
//        else {
//            cameraView.showPoints([])
//            return
//        }
//
////         Convert points from Vision coordinates to AVFoundation coordinates.
//        thumbTip = CGPoint(x: thumbTipPoint.location.x, y: 1 - thumbTipPoint.location.y)
//        wrist = CGPoint(x: wristPoint.location.x, y: 1 - wristPoint.location.y)
//        littleTip = CGPoint(x: littleTipPoint.location.x, y: 1 - littleTipPoint.location.y)
//        ringTip = CGPoint(x: ringTipPoint.location.x, y: 1 - ringTipPoint.location.y)
//        middleTip = CGPoint(x: middleTipPoint.location.x, y: 1-middleTipPoint.location.y)
//        indexTip = CGPoint(x: indexTipPoint.location.x, y: 1-indexTipPoint.location.y)
//
//        DispatchQueue.main.async {
//
//
//            self.process2Points([wrist,thumbTip,littleTip,ringTip,middleTip,indexTip])
////            self.process2Points([littleTip, wrist])
////            self.process2Points([ringTip, wrist])
////            self.process2Points([middleTip, wrist])
////            self.process2Points([indexTip, wrist])
////            self.process2Points([thumbTip, wrist])
//        }
//


      fingerTips = recognizedPoints.filter {
        // Ignore low confidence points.
        $0.confidence > 0.95
      }
      .map {
        // Convert points from Vision coordinates to AVFoundation coordinates.
        CGPoint(x: $0.location.x, y: 1 - $0.location.y)

      }

    } catch {
        //If error happens stop the session
        cameraFeedSession?.stopRunning()
        print(error.localizedDescription)
    }
  }
}
