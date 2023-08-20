import SwiftUI
struct HowToView: View {
    
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
                Text("To play the game raise your hand accordingly to the number of stars being presented")
                    .foregroundColor(.black)
                    .font(.title2)
                Spacer()
            }.padding([.top],75)
                .padding([.leading,.trailing], 20)
        }
    }
}
