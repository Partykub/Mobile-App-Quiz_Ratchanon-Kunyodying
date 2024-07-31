import SwiftUI

struct DetailView: View {
    var item: Item  // รับข้อมูลรายการที่ต้องการแสดงรายละเอียด

    var body: some View {
        ScrollView {
            VStack {
                // แสดงรูปภาพของสินค้า
                AsyncImage(url: URL(string: item.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    ProgressView()
                }
                // แสดงชื่อสินค้า
                Text(item.title)
                    .font(.largeTitle)
                    .padding()
                // แสดงรายละเอียดสินค้า
                Text(item.description)
                    .padding()
            }
        }
        .navigationTitle("Description")
    }
}
