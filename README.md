# Photos-ish

> 2024년 8월 21일 기준으로 Xcode 15.3 이상의 버전으로 앱을 실행할 경우 CPU 사용량이 비정상적으로 증가하는 버그가 있습니다. 데이터를 읽어오는 과정에서 발생하는 버그일 것이라고 추측하고 있으며 15.2 이하의 버전을 사용하거나 Scheme의 Run target Diagnostics 탭에서 Main Thread Checker와 Thread Performance Checker를 모두 비활성화하면 문제없이 작동됩니다. - [참고](https://forums.developer.apple.com/forums/thread/747858)

## 기술 스택
* SwiftUI
* SwiftData
* Swift Concurrency

## 주요 기능
- 앨범 생성 및 삭제
- Landscape 모드
- 좋아하는 사진 설정
- 사진 Paging

## 구현 내용
### Preloading Data
<img width="200" src="https://github.com/user-attachments/assets/2c1085e9-77b5-47d1-b684-64730d0b1655">

```swift
private func preload(images: [CatResponse]) {
	let recents = Album(name: "Recents", date: Date(), isEditable: false)
	let favorites = Album(name: "Favorites", date: Date(), isEditable: false)
	context.insert(recents)
	context.insert(favorites)
	
	images.forEach {
		let photo = Photo(url: $0.url, date: .now)
		context.insert(photo)
		recents.photos.append(photo)
	}
}
```
* 처음 앱을 실행시킬 경우 2개의 앨범과 서버로 부터 받아온 100장의 사진을 데이터베이스에 미리 저장
* 이미지를 서버로 부터 받아오는 동안 로딩 뷰 표시
* 앨범과 사진은 다대다 관계를 가지고 있고 데이터베이스에 저장하는 순서가 매우 중요 - [참고](https://www.hackingwithswift.com/quick-start/swiftdata/how-to-create-many-to-many-relationships)
	* 앨범과 사진 객체를 SwiftData의 Model Context에 insert한 후에 앨범의 photos 배열을 업데이트

### Image Resizing&Caching
```swift
private let cache = NSCache<NSString, UIImage>()

func downsample(from urlString: String, to pointSize: CGSize, scale: CGFloat, completed: @escaping (UIImage?) -> Void) {
	DispatchQueue.global(qos: .userInteractive).async { [weak self] in
		let cacheKey = NSString(string: urlString + "\(pointSize)")
		
		if let image = self?.cache.object(forKey: cacheKey) {
			completed(image)
			return
		}
		
		guard let url = URL(string: urlString) else {
			print("Invalid URL")
			completed(nil)
			return
		}
		
		let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
		guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else {
			print("Failed to create image source")
			completed(nil)
			return
		}
		
		let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
		let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
										 kCGImageSourceShouldCacheImmediately: true,
								   kCGImageSourceCreateThumbnailWithTransform: true,
										  kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
		
		guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
			print("Failed to downsample")
			completed(nil)
			return
		}
		
		let image = UIImage(cgImage: downsampledImage)
		self?.cache.setObject(image, forKey: cacheKey)
		completed(image)
	}
}
```
* 더 나은 사용자 경험을 위해 이미지를 리사이징하고 캐싱하는 함수를 구현

### Paging View 구현
<img width="200" src="https://github.com/user-attachments/assets/5a547a20-41d8-4dc8-8ca0-b02039d7351b">

* 사진을 스와이프 하여 넘길 수 있게 LazyHGrid를 사용한 Paging View 구현
	* scrollPosition modifier를 사용하여 GridView에서 선택한 사진 위치로 스크롤 이동

### Landscape 모드 구현
<img width="200" src="https://github.com/user-attachments/assets/a3c322c9-cc3f-489b-91c6-54c8214477de">

```swift
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
```

* 디바이스 방향에 따라 레이아웃이 변화하는 기능 구현.

### Dynamic Alert
```swift
.alert(alertType?.title ?? "Alert", isPresented: $isShowingAlert, presenting: alertType) { alert in
	switch alert {
	case .add:
		TextField(alert.title, text: $titleText)
			.font(.footnote)
		Button("Save") { saveAlbum() }
		Button("Cancel", role: .cancel) { titleText = "" }
	case .delete(let album):
		Button("Delete", role: .destructive) { context.delete(album) }
		Button("Cancel", role: .cancel) {}
	case .invalidURL, .invalidResponse, .invalidData, .unknown:
		Button("OK") {}
	}
} message: { alert in
	Text(alert.message)
}
```
* 앨범 추가/삭제 및 네트워킹 에러 등 상황에 따라 각각 다른 스타일의 Alert를 표시하기 위해 dynamic alert 구현
### Editing Mode
<img height="300" src="https://github.com/user-attachments/assets/24f41282-34b4-4009-8639-a9ab8b857fe4"> <img height="300" src="https://github.com/user-attachments/assets/4ff513e3-9923-497a-97c9-e136fc81a0ad">

* 앨범 삭제가 가능한 편집모드 구현
	* 기본 앨범은 삭제가 불가능 하도록 삭제 버튼을 표시하지 않고 opacity값을 조정하여 편집 불가능 여부를 표시
* 앨범에 사진 추가 시 원하는 사진을 선택할 수 있도록 사진 선택이 가능한 Grid View를 Sheet 로 표시
### Favorites
<img height="300" src="https://github.com/user-attachments/assets/f811ac00-822c-4223-9786-39453c8f0e0e"> <img height="300" src="https://github.com/user-attachments/assets/a741d673-a1c7-44c7-91ac-81b2b7348399">

* 사진에 favorite 마크를 하면 하트를 표시하고 자동으로 Favorites 앨범에 사진이 추가되도록 구현

## 문제점 해결

### Lazy Grid 터치 반경 오류
```swift
LazyVGrid(columns: columns, count: columnCount)) {
	ForEach(photos, id: \.self) { photo in
		RemoteImageView()
			.contentShape(Rectangle())
			/* ... */
	}
}
```
GridView에서 사진의 모서리쪽을 터치하면 다른 사진이 터치되는 오류가 발생했으나 사진을 표시하는 뷰에 contentShape modifier를 사용하여 뷰의 터치 영역을 직사각형으로 정의하여 해결

### 사진 삭제 후 UI 업데이트
```swift
private func deletePhoto() {
	guard let photo = scrolledID,
		  let photoIndex = album.photos.firstIndex(of: photo) else { return }

	if !album.isEditable {
		context.delete(album.photos[photoIndex]) // doesn't update ui
	}
	
	album.photos.remove(at: photoIndex) // update ui
	dismissIfAlbumIsEmpty()
}
```
Paging View에서 SwiftData의 Model Context의 delete 메서드를 통해 사진을 삭제해도 UI가 업데이트가 되지 않는 오류가 있었으나 직접 앨범 객체의 photo 배열에서 사진을 삭제하여 해결

### 스크롤 위치 업데이트
```swift
@State private var scrolledID: Photo?
let photos: [Photo]

var body: some View {
	/* ... */
	.onChange(of: photos) { oldValue, newValue in
		updateScrolledID(from: oldValue, to: newValue)
	}
}

private func updateScrolledID(from oldValue: [Photo], to newValue: [Photo]) {
	guard let photo = scrolledID,
		  let photoIndex = oldValue.firstIndex(of: photo) else { return }
	
	if let updatedID = newValue[safe: photoIndex] {
		scrolledID = updatedID
	} else {
		scrolledID = newValue.last
	}
}
```
* Paging View에서 사진을 삭제해서 UI가 업데이트 되어도 현재 스크롤 위치를 추적하는 scrolledID는 자동으로 업데이트가 되지 않는 것을 발견
* onChange modifier를 사용하여 사진을 담고있는 photos 배열을 추적하고 변경 사항이 생길 때마다 scrolledID를 업데이트 하도록 구현
