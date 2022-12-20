//
//  PokedexWidget.swift
//  PokedexWidget
//
//  Created by roykesydone on 2022/12/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), uiImage: UIImage())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), uiImage: UIImage())
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let number = Int.random(in: 1...905)
        URLSession.shared.dataTask(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(number).png")!){
            (data, response, error) in
            
            let currentDate = Date()
            
            if let data = data,
               let uiImage = UIImage(data: data){
                
                let entry = SimpleEntry(date: currentDate, uiImage: uiImage)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(TimeInterval(0))))
            completion(timeline)
        }.resume()
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let uiImage: UIImage?
}

struct PieSegment: Shape {
    var start: Angle
    var end: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.midX, startAngle: start, endAngle: end, clockwise: false)
        return path
    }
}

struct PokedexWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack{
            Color(red: 59/255, green: 53/255, blue: 61/255)
            Rectangle()
                .foregroundColor(.black)
                .frame(width: 95, height: 30)
            
            PieSegment(start: .degrees(180), end: .degrees(360))
                .foregroundColor(.red)
                .frame(width: 100)
                .offset(y:-2)
            PieSegment(start: .degrees(0), end: .degrees(180))
                .foregroundColor(.white)
                .frame(width: 100)
                .offset(y:2)
            
            Circle()
                .frame(width: 30)
                .foregroundColor(.black)
            Circle()
                .frame(width: 23)
                .foregroundColor(.white)
            //            Text(entry.date, style: .time)
            entry.uiImage.map{
                Image(uiImage: $0)
                    .resizable()
                //                    .frame(width: 50, height: 50)
            }
        }
    }
}

@main
struct PokedexWidget: Widget {
    let kind: String = "PokedexWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PokedexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pokedex")
        .description("Show adorable pokemon picture")
    }
}

struct PokedexWidget_Previews: PreviewProvider {
    static var previews: some View {
        PokedexWidgetEntryView(entry: SimpleEntry(date: Date(), uiImage: UIImage()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
