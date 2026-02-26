📍 Geo-Task – Ứng dụng Nhắc nhở dựa trên vị trí
1. 🚀 Giới thiệu

Geo-Task là ứng dụng nhắc việc dựa trên vị trí (Location-Based Reminder), thay vì nhắc theo thời gian.

Ví dụ:

Khi đi ngang qua siêu thị → "Mua sữa nhé!"

Khi về tới nhà → "Đừng quên đổ rác"

Khi đến công ty → "Gửi báo cáo tuần"

Ứng dụng sử dụng Geofencing để theo dõi vị trí và trigger thông báo khi người dùng đi vào hoặc rời khỏi một khu vực đã định nghĩa.

2. 🎯 Mục tiêu sản phẩm (MVP)
Core Features

 Tạo nhắc việc theo vị trí

 Chọn vị trí trên bản đồ

 Thiết lập bán kính kích hoạt (50m – 1000m)

 Chọn loại trigger:

 Khi đến (Enter)

 Khi rời đi (Exit)

 Bật/tắt nhắc việc

 Thông báo Local Notification khi kích hoạt

 Hoạt động background

3. 🧱 Kiến trúc đề xuất (Flutter Clean Architecture)
lib/
 ├── core/
 │   ├── services/
 │   │   ├── location_service.dart
 │   │   ├── geofence_service.dart
 │   │   └── notification_service.dart
 │   ├── utils/
 │   └── constants/
 │
 ├── features/
 │   └── reminder/
 │       ├── data/
 │       │   ├── models/
 │       │   ├── datasources/
 │       │   └── repositories/
 │       │
 │       ├── domain/
 │       │   ├── entities/
 │       │   ├── repositories/
 │       │   └── usecases/
 │       │
 │       └── presentation/
 │           ├── pages/
 │           ├── widgets/
 │           └── stores/ (MobX)
 │
 └── main.dart
4. 🗺️ Công nghệ sử dụng
Flutter Packages

geolocator

geofence_service

flutter_local_notifications

google_maps_flutter

permission_handler

hive (hoặc isar)

mobx + flutter_mobx

5. 📦 Entity Model
class GeoReminder {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final double radius; // meters
  final GeoTriggerType triggerType; // enter | exit
  final bool isActive;
  final DateTime createdAt;
}
enum GeoTriggerType {
  enter,
  exit,
}
6. ⚙️ Luồng hoạt động
1️⃣ Tạo Reminder

User chọn vị trí trên bản đồ

Nhập nội dung nhắc việc

Chọn bán kính

Chọn trigger type

Lưu vào local database

Đăng ký geofence

2️⃣ Theo dõi Background

App đăng ký geofence với hệ thống

OS theo dõi vị trí ngay cả khi app đóng

Khi user enter/exit vùng:

Trigger callback

Hiển thị Local Notification

3️⃣ Notification Flow
Geofence Trigger
        ↓
GeofenceService Callback
        ↓
NotificationService.show()
        ↓
User nhận thông báo
7. 🔐 Quyền hệ thống cần xin
Android

ACCESS_FINE_LOCATION

ACCESS_BACKGROUND_LOCATION

POST_NOTIFICATIONS

iOS

WhenInUse Location

Always Location

Background Modes:

Location updates

8. 🎨 UI Screens
1. Home Screen

Danh sách reminder

Toggle bật/tắt

Nút thêm mới

2. Add Reminder Screen

Google Map

Chọn vị trí bằng tap

Slider chỉnh bán kính

TextField nhập nội dung

Dropdown chọn trigger type

3. Reminder Detail Screen

Map preview

Edit / Delete

9. 🧠 Edge Cases cần xử lý

User tắt GPS

User tắt quyền background

iOS kill app

Android battery optimization

Overlapping geofence

Quá nhiều geofence (Android giới hạn ~100)

10. 🔥 Tính năng nâng cao (Future Version)

 Phân loại tag (Công việc, Gia đình, Mua sắm)

 Lặp lại mỗi ngày

 Đồng bộ Firebase

 Chia sẻ reminder cho người khác

 AI gợi ý vị trí thường đến

 Widget ngoài màn hình chính

 Smart radius tự điều chỉnh theo tốc độ di chuyển

11. ⚡ Tối ưu hiệu năng

Không poll vị trí liên tục

Dùng native geofencing thay vì stream location

Giới hạn số geofence active

Batch register geofence

12. 🧪 Test Cases

Đi vào vùng → có thông báo

Rời khỏi vùng → có thông báo

Tắt bật reminder

Restart máy → vẫn hoạt động

App bị kill → vẫn hoạt động

13. 💰 Monetization Idea

Miễn phí tối đa 3 reminder

Premium:

Không giới hạn reminder

Sync cloud

Widget

Multi-device

14. 📈 Điểm mạnh của sản phẩm

Thực tế

Khác biệt với reminder truyền thống

Ứng dụng cao trong đời sống

Dễ viral nếu UX tốt

15. 🎯 Roadmap
Phase 1 (2 tuần)

MVP core

Android trước

Phase 2

iOS

UX polish

Animation

Phase 3

Cloud sync

Subscription

16. 🏆 Mục tiêu cuối cùng

Tạo ra một ứng dụng:

Nhẹ

Chính xác

Tiết kiệm pin

Hoạt động ổn định background

UX đơn giản nhất có thể

✅ Yêu cầu AI khi generate code

Áp dụng Clean Architecture

Tách file rõ ràng

Không viết tất cả vào 1 file

Tối ưu background service

Viết code production-ready

Có xử lý permission đầy đủ

Có error handling

Có logging