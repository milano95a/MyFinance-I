//
//  MonthlyExpensesBarGraphView.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 13/04/23.
//

import SwiftUI

struct BarChartData {
    var value: Double
    var text: String
}

struct Bar: Shape {
    var expense: Double
    
    init(_ expense: Double) {
        self.expense = expense
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let height = min(CGFloat(expense * 10), rect.height)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let topLeft = CGPoint(x: rect.minX, y: rect.maxY - height)
        let topRright = CGPoint(x: rect.maxX, y: rect.maxY - height)
        
        p.move(to: bottomLeft)
        p.addLine(to: topLeft)
        p.addLine(to: topRright)
        p.addLine(to: bottomRight)
        p.addLine(to: bottomLeft)
        
        return p
    }
}


struct BarChart: View {
    let data: [BarChartData]
    
    var body: some View {
        HStack {
            ForEach(data.indices, id: \.self) { index in
                BarShapeView(data: data[index])
            }
        }
        .padding()
    }
}

struct BarShapeView: View {
    let data: BarChartData
    
    var body: some View {
        VStack {
            Bar(data.value).fill(Color(red: 255/255, green: 69/255, blue: 58/255))
            Text("\(data.value.removeZerosFromEnd())")
                .lineLimit(1)
                .font(.system(size:8))
                .frame(minHeight: 20)
                .multilineTextAlignment(.center)
            Text("\(data.text)")
                .lineLimit(1)
                .font(.system(size:11))
                .frame(minHeight: 20)
        }.foregroundColor(.defaultTextColor)
    }
}










































struct BarShapeView_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(data: [
            BarChartData(value: 196.5, text: "Jan"),
            BarChartData(value: 6.7, text: "Feb"),
            BarChartData(value: 22.3, text: "Mar"),
            BarChartData(value: 16.3, text: "Apr"),
            BarChartData(value: 2.4, text: "May"),
            BarChartData(value: 10.5, text: "Jun"),
            BarChartData(value: 6.7, text: "Jul"),
            BarChartData(value: 22.3, text: "Aug"),
            BarChartData(value: 16.3, text: "Sep"),
            BarChartData(value: 8.4, text: "Oct"),
            BarChartData(value: 6.4, text: "Nov"),
            BarChartData(value: 70.4, text: "Dec"),
        ])
    }
}
