//import SwiftUI
//
//enum Panel: String {
//    case homepage = "Home"
//    case wallpapers = "Wallpaper"
//    case widgets = "Widget"
//    case customize = "Customize"
//    case settings = "Settings"
//}
//
//struct Sidebar: View {
//    @State var selection: Panel = .homepage
//    
//    var body: some View {
//        VStack {
//            //            Spacer()
//            TabButton(image: "icon3", panel: .homepage, selection: $selection)
//                .frame(width: 30, height: 30)
//                .padding()
//            //            Spacer()
//            TabButton(image: "icon2", panel: .wallpapers, selection: $selection)
//                .frame(width: 28, height: 30)
//                .padding()
//            //            Spacer()
//            TabButton(image: "icon8", panel: .widgets, selection: $selection)
//                .frame(width: 30, height: 30)
//                .padding()
//            Spacer()
//            TabButton(image: "icon4", panel: .customize, selection: $selection)
//                .frame(width: 30, height: 30)
//                .padding()
//        }
//        .padding()
//        .background(BlurEffect(material: .menu).ignoresSafeArea())
//    }
//    
//
//}
//
//struct Sidebar_Previews: PreviewProvider {
//    static var previews: some View {
//        Sidebar()
//    }
//}
//
//struct TabButton: View {
//    var image: String
//    var panel: Panel
//    @Binding var selection: Panel
//    
//    var body: some View {
//        Button(action: {
//            withAnimation(.easeInOut(duration: 0.1)) {
//                selection = panel
//            }
//        }) {
//            VStack {
//                Image(image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
////                    .frame(width: 30, height: 30)
//                    .foregroundColor(selection == panel ? .blue : Color(NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)))
////                    .padding(.vertical, 1)
////                Text(panel.rawValue)
//////                    .fontWeight(selection == panel ? .bold : .none)
//////                    .minimumScaleFactor(0.1)
////                    .font(.footnote)
////                    .foregroundColor(selection == panel ? .blue : .white)
//            }
////            .padding(.vertical)
//        }
////        .padding()
//        
//        .buttonStyle(.borderless)
////        .frame(width: 60, height: 50)
////        .frame(height: 45, alignment: .center)
//        .alignmentGuide(HorizontalAlignment.center) { viewDimensions in
//            viewDimensions[HorizontalAlignment.center]
//        }
//    }
//}
