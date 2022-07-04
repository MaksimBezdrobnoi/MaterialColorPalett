import SwiftUI
import UIKit

struct ColorValues: Hashable {
    let number: Double
    let someColor: UIColor
}

struct ContentView: View {
    
    let staticColor: String = "#F27D48"
    
    var body: some View {

        VStack(spacing: 0) {
            Text("Colors")
            
            let colors = createColor(for: UIColor.hex(staticColor))
            
            ScrollView {
                ForEach(colors, id: \.self) { color in
                    createColorBox(for: Color(color.someColor), number: color.number)
                }
            }
        }
    }

    @ViewBuilder func createColorBox(for color: Color, number: Double) -> some View {
        Text("\(number)")
            .frame(width: 150, height: 150)
            .background(color)
        
    }
    
    func calculation(value: Int) -> Double {
        0.1 * Double(value)
    }

    func createColor(for color: UIColor) -> [ColorValues] {
        let r = color.rgba.red * 255
        let g = color.rgba.green * 255
        let b = color.rgba.blue * 255
        var swatch: [ColorValues] = []
        var values: [Double] = []
        for i in 1..<12 {
            values.append(calculation(value: i))
        }
        for value in values {
            let numberOfColor = (value*1000).rounded()
            let ds = 0.5 - value
            swatch.append (
                ColorValues(
                    number: numberOfColor,
                    someColor: UIColor(
                        red: r/255 + ((ds < 0 ? r/255 : (255 - r)/255) * ds),
                        green: g/255 + ((ds < 0 ? g/255 : (255 - g)/255) * ds),
                        blue: b/255 + ((ds < 0 ? b/255 : (255 - b)/255) * ds),
                        alpha: 1
                    )
                )
            )
        }
        return swatch
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RGBRatio: Equatable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
}

extension RGBRatio {

    init(_ hex: String) throws {
        var colorString = hex.uppercased()
        guard colorString.remove(at: colorString.startIndex) == "#" else {
            fatalError()
        }
        guard colorString.allSatisfy(\.isHexDigit), colorString.count == 6 else {
            fatalError()
        }
        var rgbValue: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)
        self = RGBRatio(
            red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0x0000FF)/255.0
        )
    }
}

extension UIColor {
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    static func hex(_ hex: String) -> UIColor {
        guard let color = try? RGBRatio(hex) else {
            fatalError("Incorrect hex candidate \(hex)")
        }
        return UIColor(red: color.red, green: color.green, blue: color.blue, alpha: 1)
    }
}
