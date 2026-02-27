// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Geo-Task';

  @override
  String get homeHintBanner => 'Giữ ứng dụng chạy để nhận nhắc nhở theo vị trí.';

  @override
  String get homeEmptyTitle => 'Chưa có nhắc nhở nào';

  @override
  String get homeEmptySubtitle => 'Nhấn + để thêm một nhắc nhở theo vị trí.';

  @override
  String get homeEmptyAddButton => 'Thêm nhắc nhở';

  @override
  String get deleteReminderTitle => 'Xoá nhắc nhở?';

  @override
  String deleteReminderMessage(String title) {
    return 'Xoá \"$title\"? Hành động này không thể hoàn tác.';
  }

  @override
  String get deleteReminderCancel => 'Huỷ';

  @override
  String get deleteReminderConfirm => 'Xoá';

  @override
  String get testNotificationSent => 'Đã gửi thông báo thử';

  @override
  String get editTooltip => 'Sửa';

  @override
  String get deleteTooltip => 'Xoá';

  @override
  String get testNotificationTooltip => 'Thông báo thử (debug)';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsDarkMode => 'Chế độ tối';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get addReminderTitle => 'Thêm nhắc nhở';

  @override
  String get editReminderTitle => 'Sửa nhắc nhở';

  @override
  String get addReminderSearchHint => 'Tìm kiếm địa điểm';

  @override
  String get addReminderMapHint => 'Chạm vào bản đồ để chọn vị trí nhắc nhở.';

  @override
  String get addReminderTitleLabel => 'Tiêu đề';

  @override
  String get addReminderTitleHint => 'vd. Mua sữa';

  @override
  String get addReminderDescriptionLabel => 'Mô tả (không bắt buộc)';

  @override
  String get addReminderDescriptionHint => 'vd. Đừng quên nhé!';

  @override
  String get addReminderRadiusLabel => 'Bán kính';

  @override
  String get addReminderNotifyWhenLabel => 'Thông báo khi';

  @override
  String get addReminderEnterLabel => 'Vào vùng';

  @override
  String get addReminderExitLabel => 'Ra khỏi vùng';

  @override
  String get addReminderSaveButton => 'Lưu nhắc nhở';

  @override
  String get addReminderUpdateButton => 'Cập nhật nhắc nhở';

  @override
  String get addReminderDeleteButton => 'Xoá nhắc nhở';

  @override
  String get addReminderTitleRequired => 'Vui lòng nhập tiêu đề';

  @override
  String get addReminderFieldRequired => 'Bắt buộc';

  @override
  String addReminderSaveFailed(String error) {
    return 'Lưu không thành công: \"$error\"';
  }
}
