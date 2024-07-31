import Foundation

struct Banner: Identifiable, Decodable, Equatable {
    let id: UUID  // รหัสแบนเนอร์
    let image: String  // URL รูปภาพแบนเนอร์

    init(id: UUID = UUID(), image: String) {
        self.id = id
        self.image = image
    }
}

struct Item: Identifiable, Decodable, Equatable {
    let id: UUID  // รหัสสินค้า
    let title: String  // ชื่อสินค้า
    let createdAt: Date  // วันที่สร้างสินค้า

    init(id: UUID = UUID(), title: String, createdAt: Date) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}
