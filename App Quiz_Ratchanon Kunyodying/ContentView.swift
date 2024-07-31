import SwiftUI

struct ContentView: View {
    @State private var banners: [Banner] = []  // เก็บข้อมูลแบนเนอร์
    @State private var items: [Item] = []  // เก็บข้อมูลรายการสินค้า
    @State private var currentPage = 1  // หน้าปัจจุบันสำหรับการทำ Pagination
    @State private var isLoading = false  // สถานะการโหลดข้อมูล
    @State private var selectedSortOption: SortOption = .name  // ตัวเลือกการเรียงข้อมูล

    var body: some View {
        NavigationView {
            VStack {
                // การแสดงรายการรูป Cover แบบ Horizontal Scroll
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(banners) { banner in
                            Image(uiImage: UIImage(named: banner.image) ?? UIImage())
                                .resizable()
                                .frame(width: 300, height: 150)
                                .cornerRadius(10)
                        }
                    }
                }.onAppear(perform: loadBanners)
                
                // Picker สำหรับการเรียงข้อมูล
                Picker("Sort by", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedSortOption) { _ in
                    sortItems()
                }
                
                // การแสดงรายการข้อมูล แบบ Infinite Scroll แบบ Vertical Scroll
                ScrollView {
                    LazyVStack {
                        ForEach(items) { item in
                            NavigationLink(destination: DetailView(item: item)) {
                                Text(item.title)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }.onAppear {
                                if item == items.last {
                                    loadMoreItems()
                                }
                            }
                        }
                    }
                }.onAppear(perform: loadItems)
            }
            .navigationTitle("Main Page")
        }
    }

    // ฟังก์ชันโหลดแบนเนอร์
    func loadBanners() {
        guard let url = URL(string: "https://60b7316f17d1dc0017b89435.mockapi.io/api/v1/banner") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Banner].self, from: data) {
                    DispatchQueue.main.async {
                        banners = decodedResponse
                    }
                    return
                }
            }
        }.resume()
    }

    // ฟังก์ชันโหลดรายการข้อมูล
    func loadItems() {
        guard let url = URL(string: "https://60b7316f17d1dc0017b89435.mockapi.io/api/v1/list?page=\(currentPage)&limit=20") else { return }
        isLoading = true

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Item].self, from: data) {
                    DispatchQueue.main.async {
                        items.append(contentsOf: decodedResponse)
                        currentPage += 1
                        isLoading = false
                        sortItems()
                    }
                    return
                }
            }
            isLoading = false
        }.resume()
    }

    // ฟังก์ชันโหลดเพิ่มเติมสำหรับ Infinite Scroll
    // โหลดรายการเพิ่มเติมจาก API และเพิ่มเข้าไปในรายการ items
    func loadMoreItems() {
        loadItems()
    }
    
    // ฟังก์ชันการเรียงรายการ
    func sortItems() {
        switch selectedSortOption {
        case .name:
            items.sort { $0.title < $1.title }
        case .date:
            items.sort { $0.createdAt > $1.createdAt }
        }
    }
}

// ตัวเลือกการเรียงรายการ
enum SortOption: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case name = "Name"
    case date = "Date"
}

#Preview {
    ContentView()
}
