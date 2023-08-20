import SwiftUI

struct CameraViewContainer: UIViewControllerRepresentable {
  var pointsProcessorHandler: (([CGPoint]) -> Void)?

  func makeUIViewController(context: Context) -> CameraViewController {
    let cameraView = CameraViewController()
    cameraView.pointsProcessorHandler = pointsProcessorHandler
    return cameraView
  }

  func updateUIViewController(
    _ uiViewController: CameraViewController,
    context: Context
  ) {
  }
}
