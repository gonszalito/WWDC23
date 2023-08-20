import SwiftUI
struct AboutView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            VStack {
                Button {
                  presentationMode.wrappedValue.dismiss()

                } label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
            
            VStack {
                Text("This Swift Playgrounds Game was made using Vision and works by detecting the players hand along with the coordinates of the tip and by detecting the number of tips detected we can get the number of fingers")
                    .foregroundColor(.black)
                    .font(.title2)
                    .padding(.bottom, 10)
                
                
                Text("Technologies used include : Vision to detect hand poses, AVFoundation to capture video, SpriteKit to present the objects")
                    .foregroundColor(.black)
                    .font(.title2)
                Spacer()
            }.padding([.top],75)
                .padding([.leading,.trailing], 20)
        }
    }
}
