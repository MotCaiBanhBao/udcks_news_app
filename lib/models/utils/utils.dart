import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/user_model.dart';

extension TypeOfTopicsParseToString on TypeOfTopics {
  String toSortString() {
    if (this == TypeOfTopics.khoaKyThuat) {
      return "KhoaKiThuat";
    } else if (this == TypeOfTopics.khoaKinhTe) {
      return "KhoaKinhTe";
    } else if (this == TypeOfTopics.khoaSuPham) {
      return "KhoaSuPham";
    } else if (this == TypeOfTopics.cacTopicKhac) {
      return "CacTopicKhac";
    } else {
      return "ToanTruong";
    }
  }
}

extension TypeOfNotificationParseToString on TypeOfNotification {
  String toSortString() {
    if (this == TypeOfNotification.thoiKhoaBieu) {
      return "ThoiKhoaBieu";
    } else if (this == TypeOfNotification.thongBaoCuaGiaoVien) {
      return "ThongBaoCuaGiaoVien";
    } else {
      return "ThongBaoCuaTruong";
    }
  }
}

extension UserRoleParseToString on UserRole {
  String toSortString() {
    if (this == UserRole.canBo) {
      return "CanBo";
    } else if (this == UserRole.giaoVien) {
      return "GiaoVien";
    } else if (this == UserRole.sinhVien) {
      return "SinhVien";
    } else {
      return "Khach";
    }
  }
}

extension ParseToEnum on String {
  TypeOfTopics toTypeOfTopic() {
    if (this == TypeOfTopics.khoaKyThuat.toSortString()) {
      return TypeOfTopics.khoaKyThuat;
    } else if (this == TypeOfTopics.khoaKinhTe.toSortString()) {
      return TypeOfTopics.khoaKinhTe;
    } else if (this == TypeOfTopics.khoaSuPham.toSortString()) {
      return TypeOfTopics.khoaSuPham;
    } else if (this == TypeOfTopics.toanTruong.toSortString()) {
      return TypeOfTopics.toanTruong;
    } else {
      return TypeOfTopics.cacTopicKhac;
    }
  }

  TypeOfNotification toTypeOfNotification() {
    if (this == TypeOfNotification.thoiKhoaBieu.toSortString()) {
      return TypeOfNotification.thoiKhoaBieu;
    } else if (this == TypeOfNotification.thongBaoCuaGiaoVien.toSortString()) {
      return TypeOfNotification.thongBaoCuaGiaoVien;
    } else {
      return TypeOfNotification.thongBaoCuaTruong;
    }
  }

  UserRole toUserRole() {
    if (this == UserRole.canBo.toSortString()) {
      return UserRole.canBo;
    } else if (this == UserRole.giaoVien.toSortString()) {
      return UserRole.giaoVien;
    } else if (this == UserRole.khach.toSortString()) {
      return UserRole.khach;
    } else {
      return UserRole.sinhVien;
    }
  }
}
