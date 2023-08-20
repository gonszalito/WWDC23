import SwiftUI

struct ContentView: View {
    
    
    @State  var cameraOverlay = true
    
    @State var objectCount = 0
    
    @State var showViewHowTo = false
    @State var showViewAbout = false
    
    @State var isShowingModal = false
    
    @State private var overlayPoints: [CGPoint] = []
    @StateObject private var gameData = GameData()
    
    var body: some View {
        ZStack{
            
            if !gameData.gameStart {
                CameraViewContainer {
                    overlayPoints = $0
                    gameData.checkObjectsCount($0.count)
                    gameData.setObjectsCount($0.count)
                    objectCount = $0.count
                }
                .overlay(
                    FingersOverlay(with: overlayPoints)
                        .foregroundColor(.red)
                )
                .edgesIgnoringSafeArea(.all)
                
                if !cameraOverlay {
                    VStack {
                        Color.blue
                            .ignoresSafeArea()
                        
                    }
                    
                    
                    
                }
                
                
                Group{
                    VStack(alignment: .center) {
                        
                        Text("Counting Stars")
                            .font(.system(size: 48))
                            .bold()
                            .foregroundColor(.yellow)
                        
                        ZStack {
                            HStack {
                                
                                Button {
                                    showViewAbout.toggle()
                                } label: {
                                    Text("📚")
                                        .font(.largeTitle)
                                }
                                .buttonStyle(.bordered)
                                .background(cameraOverlay == false ? .white : .clear)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .padding([.leading],10)
                                
                                .sheet(isPresented: $showViewAbout) {
                                    AboutView()
                                }
                                .buttonStyle(.bordered)
                                
                                
                                
                                
                                Spacer()
                                
                            }
                            
                            
                            HStack{
                                Image(uiImage: "⭐️".image(sizes: 150)!)
                                    .padding([.leading],10)
                            }
                            HStack {
                                Spacer()
                                Button( "📷") {
                                    self.cameraOverlay = !cameraOverlay
                                }
                                .buttonStyle(.bordered)
                                .background(cameraOverlay == false ? .white : .clear)
                                .cornerRadius(10)
                                .font(.largeTitle)
                                .padding([.trailing],10)
                                
                            }
                        }.padding([.bottom],20)
                        
                        
                        
                        Button("Start") {
                            gameData.start()
                        }
                        .buttonStyle(.bordered)
                        .font(.largeTitle)
                        .tint(.yellow)
                        .frame(maxWidth: .infinity)
                        .padding([.bottom],5)
                        
                        //                        Button("How To Play") {
                        Button {
                            showViewHowTo.toggle()
                        } label: {
                            Text("How To Play")
                                .font(.largeTitle)
                        }
                        .buttonStyle(.bordered)
                        
                        .sheet(isPresented: $showViewHowTo) {
                            HowToView()
                        }
                        .buttonStyle(.bordered)
                        .tint(.yellow)
                        
                        Spacer()
                        
                    }.padding([.top],50)
                    
                }
                
                
            }else {
                CameraViewContainer {
                    overlayPoints = $0
                    //                    gameData.compute(position: $0)
                    gameData.checkObjectsCount($0.count)
                    gameData.setObjectsCount($0.count)
                    objectCount = $0.count
//                    self.countFingers(points: $0)
                    
                }
                .overlay(
                    FingersOverlay(with: overlayPoints)
                        .foregroundColor(.red)
                )
                .edgesIgnoringSafeArea(.all)
                
                //
                if !cameraOverlay {
                    VStack {
                        Color.blue
                            .ignoresSafeArea()
                    }
                }
                
                GameSceneViewContainer(startSpawning: $gameData.startSpawning, objectCount: $objectCount) {
                    gameData.didSpawn(count: $0)
                    gameData.setObjectsCount2(count: $0)
                }.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Button {
                        gameData.gameStart = !gameData.gameStart
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.gray)
                            .font(.title)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                
            }
            
            
        }
    }
    
//    func countFingers(points: [CGPoint]) {
//        let wrist = points[0]
//        let thumb = points[1]
//        let tip2 = points[2]
//        let tip3 = points[4]
//        let tip4 = points[5]
//        let tip5 = points[6]
//
//        //        print(yDistance)
//        var fingersUp = 0
//
//        for i in 1...points.count{
//            if (i == 1_) {
//                let xDistance = points[1].x - points[0].x
//                if (xDistance < -150){
//                    fingersUp += 1
//                }
//            }else {
//                let yDistance = points[i].y - points[0].y
//                if (yDistance < -150){
//                    fingersUp += 1
//                }
//            }
//
//
//        }
//        self.objectCount = fingersUp
//    }
    
}
