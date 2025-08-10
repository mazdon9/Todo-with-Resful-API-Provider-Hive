# 📚 KHI NÀO DÙNG GÌ TRONG API LOGIC - Flutter/Dart

## 📖 Mục Lục
- [HTTP Methods](#http-methods)
- [Error Handling](#error-handling)
- [Async Patterns](#async-patterns)
- [Data Storage Patterns](#data-storage-patterns)
- [Connectivity Patterns](#connectivity-patterns)
- [State Management Patterns](#state-management-patterns)

---

## 🌐 HTTP Methods (Các Phương Thức HTTP)

### 1. **GET** - Lấy dữ liệu từ server

**🔹 Khi nào dùng:**
- Lấy danh sách items
- Lấy thông tin chi tiết
- Tìm kiếm/Lọc dữ liệu
- **KHÔNG** thay đổi dữ liệu trên server

**🔸 Syntax cố định và tùy chỉnh:**

```dart
// ✅ DÙNG GET khi lấy dữ liệu:
Future<List<Task>> getAllTasks() async {
//    ^^^^ có thể đặt tên khác   ^^^^ có thể đặt tên khác
//         👆 "Future" là SYNTAX CỐ ĐỊNH
  
  final response = await http.get(Uri.parse('$baseUrl/tasks'));
  //    ^^^^^^^^         ^^^^ ^^^  ^^^^^^^^         ^^^^^^^ 
  //    tên biến        syntax    syntax cố định    URL endpoint
  //    tùy ý           cố định   phải có           có thể đổi
  
  return _parseTaskList(response.body);
  //     ^^^^^^^^^^^^^  ^^^^^^^^^^^^
  //     tên method     syntax cố định
  //     tùy ý         (response.body)
}

// Ví dụ khác - Lấy tasks theo status:
Future<List<Task>> layTaskTheoTrangThai(String trangThai) async {
//                 ^^^^^^^^^^^^^^^^^^^^         ^^^^^^^^^
//                 tên method tùy ý             tên parameter tùy ý
  
  final uri = Uri.parse('$baseUrl/tasks').replace(
  //    ^^^                ^^^^^^^ syntax cố định
  //    tên biến tùy ý
    queryParameters: {
    // ^^^^^^^^^^^^^^^ syntax cố định
      'status': trangThai,  // 'status' - tên field API, trangThai - biến của bạn
      'limit': '20',        // 'limit' - tên field API, '20' - giá trị tùy ý
    },
  );
  
  final response = await http.get(uri);
  // Xử lý response...
}
```

**❌ KHÔNG dùng GET khi:**
- Tạo mới dữ liệu → Dùng POST
- Xóa dữ liệu → Dùng DELETE
- Cập nhật dữ liệu → Dùng PUT/PATCH

---

### 2. **POST** - Tạo mới dữ liệu

**🔹 Khi nào dùng:**
- Tạo mới record (bản ghi)
- Gửi form data
- Upload files
- Login/Authentication (xác thực)

```dart
// ✅ DÙNG POST khi tạo mới:
Future<Task> taoTaskMoi(String tieuDe, String moTa) async {
//           ^^^^^^^^^^         ^^^^^^         ^^^^
//           tên method tùy ý   tên param tùy ý

  final requestBody = {
  //    ^^^^^^^^^^^ tên biến tùy ý
    'title': tieuDe,        // 'title' - field API cố định, tieuDe - biến của bạn
    'description': moTa,    // 'description' - field API, moTa - biến của bạn  
    'status': 'pendiente',  // 'status' - field API, 'pendiente' - giá trị mặc định
  };

  final response = await http.post(
  //    ^^^^^^^^              ^^^^
  //    tên biến tùy ý        syntax cố định
    Uri.parse('$baseUrl/tasks'),
    //^^^^^^^ syntax cố định
    headers: {'Content-Type': 'application/json'},
    //^^^^^^^ syntax cố định  ^^^^^^^^^^^^^^^^^^ giá trị cố định
    body: json.encode(requestBody),
    //^^^ syntax cố định ^^^^^^ syntax cố định
  );

  if (response.statusCode == 201) { // 201 = Created (mã HTTP cố định)
  //  ^^^^^^^^^^^^^^^^^^^^^^^^ syntax cố định
    return Task.fromJson(json.decode(response.body));
    //     ^^^^^^^^^^^^^ ^^^^^^^^^^^ syntax cố định
  }
  throw Exception('Không thể tạo task');
  //^^^ syntax cố định
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 35-40
/// Trực tuyến: Tạo task qua API
await _apiService.createTask(title, description);
//    ^^^^^^^^^^^ tên service object
//                ^^^^^^^^^^  tên method
//                           ^^^^^ ^^^^^^^^^^^ tên parameters

/// Sau khi tạo thành công, reload tất cả tasks từ API để lấy ID đúng
final allTasks = await _apiService.getAllTasks();
//    ^^^^^^^^ tên biến tùy ý    ^^^^^^^^^^^ tên method
```

---

### 3. **PUT** - Cập nhật toàn bộ record

**🔹 Khi nào dùng:**
- Cập nhật toàn bộ object
- Thay thế toàn bộ resource
- Khi bạn có tất cả fields cần cập nhật

```dart
// ✅ DÙNG PUT khi cập nhật toàn bộ:
Future<Task> capNhatToanBoTask(Task taskCanCapNhat) async {
//           ^^^^^^^^^^^^^^^^^^      ^^^^^^^^^^^^^^
//           tên method tùy ý        tên parameter tùy ý

  final response = await http.put(
  //    ^^^^^^^^              ^^^
  //    tên biến tùy ý        syntax cố định
    Uri.parse('$baseUrl/tasks/${taskCanCapNhat.id}'),
    //^^^^^^^ syntax cố định        ^^^^^^^^^^^^^^^^ 
    //                               ID từ object
    headers: {'Content-Type': 'application/json'},
    //^^^^^^^ syntax cố định
    body: json.encode(taskCanCapNhat.toJson()),
    //^^^ syntax cố định    ^^^^^^^^^^^^^^^^
    //                      chuyển object thành JSON
  );

  if (response.statusCode == 200) { // 200 = OK (mã HTTP cố định)
    return Task.fromJson(json.decode(response.body));
    //     ^^^^^^^^^^^^^ syntax cố định
  }
  throw Exception('Cập nhật thất bại');
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 86-88
/// Trực tuyến: Cập nhật qua API và local storage (KHÔNG thêm vào sync queue)
await _apiService.updateTask(task);
//    ^^^^^^^^^^^ tên service object
//                ^^^^^^^^^^ tên method cố định
//                          ^^^^ parameter - object Task
```

---

### 4. **PATCH** - Cập nhật một phần

**🔹 Khi nào dùng:**
- Cập nhật chỉ vài fields
- Toggle status (chuyển đổi trạng thái)
- Partial updates (cập nhật từng phần)
- Tiết kiệm bandwidth (băng thông)

```dart
// ✅ DÙNG PATCH khi cập nhật một phần:
Future<Task> chuyenTrangThaiTask(String taskId, String trangThaiMoi) async {
//           ^^^^^^^^^^^^^^^^^^^         ^^^^^^         ^^^^^^^^^^^^
//           tên method tùy ý           param tùy ý     param tùy ý

  final response = await http.patch(
  //    ^^^^^^^^              ^^^^^
  //    tên biến tùy ý        syntax cố định
    Uri.parse('$baseUrl/tasks/$taskId'),
    //^^^^^^^ syntax cố định  ^^^^^^^ ID từ parameter
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'status': trangThaiMoi, // CHỈ gửi field cần thay đổi
      // 'status' - field API cố định, trangThaiMoi - giá trị từ parameter
    }),
  );
  // Xử lý response...
}

// Ví dụ khác - Toggle boolean:
Future<Task> hoanThanhTask(String taskId) async {
//           ^^^^^^^^^^^^^         ^^^^^^
//           tên method tùy ý       param tùy ý

  final response = await http.patch(
    Uri.parse('$baseUrl/tasks/$taskId'),
    body: json.encode({
      'completed': true,  // CHỈ gửi field completed
      // 'completed' - field API, true - giá trị boolean cố định
    }),
  );
}
```

**So sánh PUT vs PATCH:**
```dart
// PUT - Gửi toàn bộ object:
{
  "id": "123",
  "title": "Task đã cập nhật",
  "description": "Mô tả đã cập nhật", 
  "status": "completada",
  "created_at": "2023-01-01"
}

// PATCH - Chỉ gửi field cần thay đổi:
{
  "status": "completada"
}
```

---

### 5. **DELETE** - Xóa dữ liệu

**🔹 Khi nào dùng:**
- Xóa record (bản ghi)
- Xóa relationship (mối quan hệ)
- Clear data (xóa dữ liệu)

```dart
// ✅ DÙNG DELETE khi xóa:
Future<void> xoaTask(String taskId) async {
//           ^^^^^^^^         ^^^^^^
//           tên method tùy ý  param tùy ý
//   ^^^^ void = không trả về gì

  final response = await http.delete(
  //    ^^^^^^^^              ^^^^^^
  //    tên biến tùy ý        syntax cố định
    Uri.parse('$baseUrl/tasks/$taskId'),
    //^^^^^^^ syntax cố định  ^^^^^^^ ID từ parameter
  );

  if (response.statusCode == 200 || response.statusCode == 204) {
  //  ^^^^^^^^^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^^^^^^^^
  //  200 = OK                    204 = No Content
  //  Cả hai đều là success cho DELETE
    debugPrint('Xóa task thành công');
    //^^^^^^^^^ syntax cố định cho log
  } else {
    throw Exception('Xóa thất bại');
  }
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 119-121
/// Trực tuyến: Xóa qua API và local storage
await _apiService.deleteTask(taskId);
//    ^^^^^^^^^^^ tên service object
//                ^^^^^^^^^^ tên method
//                          ^^^^^^ parameter
```

---

## ⚠️ Error Handling (Xử Lý Lỗi)

### 1. **Try-Catch-Finally Pattern**

**🔹 Khi nào dùng:**
- **MỌI** API calls (luôn luôn!)
- Các thao tác quan trọng (critical operations)
- Khi cần cleanup resources (dọn dẹp tài nguyên)

```dart
// ✅ LUÔN LUÔN dùng try-catch cho API calls:
Future<List<Task>> layTatCaTasks() async {
//                 ^^^^^^^^^^^^^
//                 tên method tùy ý
  try {
  //^^^ syntax cố định
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    //    ^^^^^^^^ tên biến tùy ý
    
    if (response.statusCode == 200) {
    //  ^^^^^^^^^^^^^^^^^^^^^^^^ syntax cố định kiểm tra mã HTTP
      return _parseTaskList(response.body);
      //     ^^^^^^^^^^^^^^ tên method tùy ý
    } else {
      throw ApiException('HTTP ${response.statusCode}');
      //^^^ syntax cố định ^^^^^^^^^^^^ tên exception class tùy ý
    }
  } on SocketException {
  //^^ syntax cố định ^^^^^^^^^^^^^^^ exception type cố định
    throw NetworkException('Không có kết nối internet');
    //^^^ syntax cố định ^^^^^^^^^^^^^^^^ tên exception tùy ý
  } on TimeoutException {
  //^^ syntax cố định ^^^^^^^^^^^^^^^^ exception type cố định  
    throw NetworkException('Hết thời gian chờ');
  } on FormatException {
  //^^ syntax cố định ^^^^^^^^^^^^^^^ exception type cố định
    throw DataException('Định dạng response không hợp lệ');
    //^^^ syntax cố định ^^^^^^^^^^^^^ tên exception tùy ý
  } catch (e) {
  //^^^^^ syntax cố định
    throw UnknownException('Lỗi không xác định: $e');
    //^^^ syntax cố định  ^^^^^^^^^^^^^^^^ tên exception tùy ý
  } finally {
  //^^^^^^^ syntax cố định
    // Dọn dẹp tài nguyên nếu cần
    _client.close(); // Tên method tùy ý
  }
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 17-24
try {
  if (await _isOnline()) {
  //  ^^^^^ ^^^^^^^^^ tên method tùy ý
    final tasks = await _apiService.getAllTasks();
    //    ^^^^^ tên biến tùy ý
    await _storageService.saveAllTasks(tasks);
    //    ^^^^^^^^^^^^^^^ tên service object
    //                    ^^^^^^^^^^^^ tên method
    return tasks;
  } else {
    return await _storageService.getAllTasks();
  }
} catch (e) { // syntax cố định
  debugPrint('Error fetching tasks in TaskRepository: $e');
  //^^^^^^^^^ syntax cố định
  return await _storageService.getAllTasks(); // Fallback strategy
}
```

---

### 2. **Custom Exception Classes (Class Ngoại Lệ Tùy Chỉnh)**

**🔹 Khi nào dùng:**
- Cần xử lý các loại lỗi khác nhau
- UI cần hiển thị thông báo lỗi khác nhau
- Retry logic (logic thử lại) dựa trên loại lỗi

```dart
// ✅ Tạo custom exceptions:
abstract class ApiException implements Exception {
//^^^^^^ ^^^^^ syntax cố định ^^^^^^^^^^^ syntax cố định
  final String message;
  //^^^ syntax cố định
  const ApiException(this.message);
  //^^^ syntax cố định
}

// Các class exception cụ thể:
class LoiMang extends ApiException {
//^^^ syntax cố định ^^^^^^^ tên class tùy ý
  const LoiMang(String message) : super(message);
  //^^^ syntax cố định         ^^^^^^^^^^^^^^^^ syntax cố định
}

class LoiXacThuc extends ApiException {
//    ^^^^^^^^^^ tên class tùy ý
  const LoiXacThuc(String message) : super(message);
}

class LoiServer extends ApiException {
//    ^^^^^^^^^ tên class tùy ý
  const LoiServer(String message) : super(message);
}

// ✅ Sử dụng:
try {
  await apiCall();
  //    ^^^^^^^ tên method tùy ý
} on LoiMang catch (e) {
//^^ syntax cố định ^^^^^^^ tên exception tùy ý
  // Hiển thị UI offline
  hienThiThongBaoOffline();
  //^^^^^^^^^^^^^^^^^^ tên method tùy ý
} on LoiXacThuc catch (e) {
  // Chuyển về màn hình login
  chuyenDenManHinhLogin();
  //^^^^^^^^^^^^^^^^^ tên method tùy ý
} on ApiException catch (e) {
  // Hiển thị lỗi chung
  hienThiThongBaoLoi(e.message);
  //^^^^^^^^^^^^^^^ tên method tùy ý
}
```

---

### 3. **Fallback Strategy (Chiến Lược Dự Phòng)**

**🔹 Khi nào dùng:**
- Offline-first apps (ứng dụng ưu tiên offline)
- Tính năng quan trọng phải hoạt động
- Tối ưu hóa performance

```dart
// ✅ DÙNG fallback cho các thao tác quan trọng:
Future<List<Task>> layTatCaTasks() async {
//                 ^^^^^^^^^^^^^ tên method tùy ý
  try {
    // Thử API trước
    if (await _kiemTraKetNoiMang()) {
    //        ^^^^^^^^^^^^^^^^^ tên method tùy ý
      final tasks = await _apiService.getAllTasks();
      //    ^^^^^ tên biến tùy ý
      await _localStorage.luuTatCaTasks(tasks); // Cache cho offline
      //    ^^^^^^^^^^^^^ tên service tùy ý ^^^^^^^^^^^^^ tên method tùy ý
      return tasks;
    } else {
      // Fallback về local storage
      return await _localStorage.layTatCaTasks();
      //           ^^^^^^^^^^^^^ tên service tùy ý
    }
  } catch (e) {
    debugPrint('API thất bại, dùng dữ liệu local: $e');
    // Ngay cả khi online, fallback về local nếu API lỗi
    return await _localStorage.layTatCaTasks();
  }
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 67-73
/// Nếu API thất bại, thử tạo locally
try {
  final newTask = await _storageService.addTaskLocal(title, description);
  //    ^^^^^^^ tên biến tùy ý         ^^^^^^^^^^^ tên method
  debugPrint('Task created offline (fallback): ${newTask.title}');
  return newTask;
} catch (localError) {
//      ^^^^^^^^^^ tên biến tùy ý
  debugPrint('Error creating task locally: $localError');
  throw Exception('Repository: Failed to create task - $e');
  //^^^ syntax cố định
}
```

---

## ⏱️ Async Patterns (Mẫu Bất Đồng Bộ)

### 1. **async/await** - Thao Tác Tuần Tự

**🔹 Khi nào dùng:**
- Các thao tác phụ thuộc vào nhau
- Cần kết quả của call trước cho call sau
- Code đơn giản, dễ đọc

```dart
// ✅ DÙNG async/await khi thao tác phụ thuộc nhau:
Future<HoSoNguoiDung> layHoSoNguoiDung(String userId) async {
//     ^^^^^^^^^^^^^^ tên class tùy ý     ^^^^^^^^^ tên method tùy ý
//                                             ^^^^^^ param tùy ý
  // PHẢI chờ dữ liệu user trước
  final user = await layThongTinUser(userId);
  //    ^^^^ tên biến tùy ý ^^^^^^^^^^^^^^^ tên method tùy ý
  
  // SAU ĐÓ mới dùng user.id cho preferences  
  final preferences = await layTuyChinh(user.id);
  //    ^^^^^^^^^^^ tên biến tùy ý ^^^^^^^^^^ tên method tùy ý
  
  // Cuối cùng kết hợp chúng
  return HoSoNguoiDung(user: user, preferences: preferences);
  //     ^^^^^^^^^^^^^^ tên constructor tùy ý
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 38-46
/// Sau khi tạo thành công, reload tất cả tasks từ API để lấy ID đúng
final allTasks = await _apiService.getAllTasks();
//    ^^^^^^^^ tên biến tùy ý
await _storageService.saveAllTasks(allTasks);
//    ^^^^^^^^^^^^^^^ tên service object

/// Tìm task vừa được tạo
final createdTask = allTasks.lastWhere(
//    ^^^^^^^^^^^ tên biến tùy ý ^^^^^^^^^ method của List
  (task) => task.title == title && task.description == description,
  //^^^^ tên param tùy ý
);
```

---

### 2. **Future.wait** - Thao Tác Song Song

**🔹 Khi nào dùng:**
- Các thao tác độc lập với nhau
- Muốn tăng performance
- Loading nhiều nguồn dữ liệu

```dart
// ✅ DÙNG Future.wait khi thao tác độc lập:
Future<DuLieuDashboard> taiDashboard() async {
//     ^^^^^^^^^^^^^^^^ tên class tùy ý ^^^^^^^^^^^ tên method tùy ý
  
  // Tất cả calls này độc lập, có thể chạy song song
  final results = await Future.wait([
  //    ^^^^^^^ tên biến tùy ý ^^^^^^^^^^^ syntax cố định
    layTatCaTasks(),          // Độc lập
    layThongKeNguoiDung(),    // Độc lập  
    layThongBao(),            // Độc lập
    layDuLieuThoiTiet(),      // Độc lập
    // ^^^^^^^^^^^^^^^^^^^ tất cả đều là tên method tùy ý
  ]);
  
  return DuLieuDashboard(
  //     ^^^^^^^^^^^^^^^ tên constructor tùy ý
    tasks: results[0] as List<Task>,
    //     ^^^^^^^^^ syntax cố định để lấy kết quả
    stats: results[1] as ThongKeNguoiDung,
    //     ^^^^^^^^^ syntax cố định ^^^^^^^^^^^^^^^^ tên class tùy ý
    notifications: results[2] as List<ThongBao>,
    weather: results[3] as DuLieuThoiTiet,
    //       ^^^^^^^^^ syntax cố định ^^^^^^^^^^^^^^ tên class tùy ý
  );
}

// ❌ KHÔNG dùng Future.wait khi thao tác phụ thuộc nhau:
// SAI!
final results = await Future.wait([
  dangNhap(username, password),     // Cần này trước
  layHoSoNguoiDung(token),         // Phụ thuộc vào kết quả đăng nhập - SẼ LỖI!
  //               ^^^^^ token chưa có từ đăng nhập
]);
```

---

### 3. **Stream** - Dữ Liệu Thời Gian Thực

**🔹 Khi nào dùng:**
- Cập nhật real-time
- Kết nối WebSocket
- Upload file với progress
- Live data feeds

```dart
// ✅ DÙNG Stream cho dữ liệu real-time:
Stream<List<Task>> theoDoiTasks() {
//^^^^ syntax cố định ^^^^^^^^^^^ tên method tùy ý
  return _database.theoDoiTasks().map((data) {
  //     ^^^^^^^^^ tên object tùy ý ^^^^^^^^^^^^^ tên method tùy ý
  //                               ^^^ syntax cố định
    return data.map((json) => Task.fromJson(json)).toList();
    //     ^^^^ ^^^ syntax cố định ^^^^^^^^^^^^^ syntax cố định
  });
}

// ✅ Sử dụng trong UI:
StreamBuilder<List<Task>>(
//^^^^^^^^^^^ syntax cố định
  stream: taskRepository.theoDoiTasks(),
  //^^^^ syntax cố định ^^^^^^^^^^^^^^ tên object + method
  builder: (context, snapshot) {
  //^^^^^^ syntax cố định ^^^^^^^ ^^^^^^^^ tên param cố định
    if (snapshot.hasData) {
    //  ^^^^^^^^^^^^^^^^^ syntax cố định
      return DanhSachTask(tasks: snapshot.data!);
      //     ^^^^^^^^^^^^ tên widget tùy ý ^^^^^^^^^^^^^ syntax cố định
    }
    return CircularProgressIndicator();
    //     ^^^^^^^^^^^^^^^^^^^^^^^^^^ widget cố định
  },
)
```

---

### 4. **Timeout Pattern (Mẫu Hết Thời Gian Chờ)**

**🔹 Khi nào dùng:**
- API calls có thể chậm
- User experience quan trọng
- Mạng mobile không ổn định

```dart
// ✅ LUÔN dùng timeout cho API calls:
Future<List<Task>> layTasksCoTimeout() async {
//                 ^^^^^^^^^^^^^^^^^ tên method tùy ý
  try {
    final response = await http
    //    ^^^^^^^^ tên biến tùy ý
        .get(Uri.parse('$baseUrl/tasks'))
        .timeout(
        //^^^^^^ syntax cố định
          Duration(seconds: 10), // 10 giây timeout
          //^^^^^^ syntax cố định ^^^^^^^ thời gian tùy ý
          onTimeout: () {
          //^^^^^^^^ syntax cố định
            throw TimeoutException('Hết thời gian chờ sau 10 giây');
            //^^^ syntax cố định ^^^^^^^^^^^^^^^^ tên exception cố định
          },
        );
    
    return _parseTaskList(response.body);
    //     ^^^^^^^^^^^^^^ tên method tùy ý
  } on TimeoutException {
  //^^ syntax cố định ^^^^^^^^^^^^^^^^ exception type cố định
    // Xử lý timeout cụ thể
    throw LoiMang('Yêu cầu mất quá nhiều thời gian');
    //^^^ syntax cố định ^^^^^^^ tên exception tùy ý
  }
}
```

---

## 💾 Data Storage Patterns (Mẫu Lưu Trữ Dữ Liệu)

### 1. **Cache-First Strategy (Chiến Lược Cache Trước)**

**🔹 Khi nào dùng:**
- Dữ liệu không thay đổi thường xuyên
- Performance quan trọng
- Hỗ trợ offline

```dart
// ✅ DÙNG cache-first cho dữ liệu tĩnh:
Future<List<DanhMuc>> layDanhMuc() async {
//     ^^^^^^^^^^^^^^ tên class tùy ý ^^^^^^^^^ tên method tùy ý
  
  // Kiểm tra cache trước
  final cachedCategories = await _localStorage.layDanhMucDaLuu();
  //    ^^^^^^^^^^^^^^^^ tên biến tùy ý     ^^^^^^^^^^^^^ tên service tùy ý
  //                                                    ^^^^^^^^^^^^^^^^ tên method tùy ý
  if (cachedCategories.isNotEmpty) {
  //  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ syntax cố định
    return cachedCategories;
  }
  
  // Nếu cache trống, lấy từ API
  final categories = await _apiService.layDanhMuc();
  //    ^^^^^^^^^^ tên biến tùy ý
  await _localStorage.luuDanhMuc(categories);
  //    ^^^^^^^^^^^^^ tên service tùy ý ^^^^^^^^^^^ tên method tùy ý
  return categories;
}
```

---

### 2. **API-First Strategy (Chiến Lược API Trước)**

**🔹 Khi nào dùng:**
- Dữ liệu thay đổi thường xuyên
- Độ chính xác real-time quan trọng
- Cần dữ liệu mới nhất

```dart
// ✅ DÙNG API-first cho dữ liệu động:
Future<List<Task>> layTatCaTasks() async {
//                 ^^^^^^^^^^^^^ tên method tùy ý
  try {
    if (await _kiemTraOnline()) {
    //        ^^^^^^^^^^^^^^^ tên method tùy ý
      // Luôn thử API trước để có dữ liệu mới
      final tasks = await _apiService.getAllTasks();
      //    ^^^^^ tên biến tùy ý
      await _localStorage.luuTatCaTasks(tasks); // Cập nhật cache
      //    ^^^^^^^^^^^^^ tên service tùy ý ^^^^^^^^^^^^^ tên method tùy ý
      return tasks;
    } else {
      // Chỉ dùng cache khi offline
      return await _localStorage.layTatCaTasks();
    }
  } catch (e) {
    // Fallback về cache nếu API lỗi
    return await _localStorage.layTatCaTasks();
  }
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 17-24
if (await _isOnline()) {
//        ^^^^^^^^^^ tên method tùy ý
  /// Lấy tasks từ api và sau đó lưu vào local
  final tasks = await _apiService.getAllTasks();
  //    ^^^^^ tên biến tùy ý
  await _storageService.saveAllTasks(tasks);
  //    ^^^^^^^^^^^^^^^ tên service object ^^^^^^^^^^^^ tên method
  return tasks;
} else {
  /// Lấy tasks từ local hive
  return await _storageService.getAllTasks();
}
```

---

### 3. **Sync Queue Pattern (Mẫu Hàng Đợi Đồng Bộ)**

**🔹 Khi nào dùng:**
- Thao tác offline cần sync
- Mạng không ổn định
- Dữ liệu quan trọng không được mất

```dart
// ✅ DÙNG sync queue cho thao tác offline:
Future<Task> taoTaskOffline(String tieuDe, String moTa) async {
//           ^^^^^^^^^^^^^^         ^^^^^^         ^^^^
//           tên method tùy ý       param tùy ý    param tùy ý
  
  // 1. Tạo locally trước (phản hồi ngay lập tức)
  final localTask = await _localStorage.themTaskLocal(tieuDe, moTa);
  //    ^^^^^^^^^ tên biến tùy ý      ^^^^^^^^^^^^^ tên service tùy ý
  //                                                ^^^^^^^^^^^^^^ tên method tùy ý
  
  // 2. Thêm vào sync queue
  await _localStorage.themVaoHangDoiSync('create', localTask);
  //    ^^^^^^^^^^^^^ tên service tùy ý ^^^^^^^^^^^^^^^^ tên method tùy ý
  //                                    ^^^^^^^^ operation type
  
  // 3. Trả về ngay (không chờ sync)
  return localTask;
}

// 4. Sync khi online
Future<void> dongBoThaoTacCho() async {
//           ^^^^^^^^^^^^^^^^^ tên method tùy ý
  final pendingOps = await _localStorage.layThaoTacChoDongBo();
  //    ^^^^^^^^^^ tên biến tùy ý      ^^^^^^^^^^^^^ tên service tùy ý
  //                                                ^^^^^^^^^^^^^^^^^^^ tên method tùy ý
  
  for (final op in pendingOps) {
  //   ^^^^^^^^ syntax cố định ^^^^^^^^^^^ tên biến
    try {
      await _dongBoThaoTac(op);
      //    ^^^^^^^^^^^^^^ tên method tùy ý
      await _localStorage.danhDauHoanThanh(op.id);
      //    ^^^^^^^^^^^^^ tên service tùy ý ^^^^^^^^^^^^^^^^ tên method tùy ý
    } catch (e) {
      // Giữ trong queue để thử lại
      debugPrint('Sync thất bại, sẽ thử lại: $e');
    }
  }
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 240-290
for (final operation in pendingOperations) {
//   ^^^^^ syntax cố định ^^^^^^^^^ tên biến        ^^^^^^^^^^^^^^^^ tên biến
  try {
    final operationType = operation['operation'] as String;
    //    ^^^^^^^^^^^^^ tên biến tùy ý         ^^^^^^^^^^^ field name API
    final taskData = operation['task'] as Map<String, dynamic>;
    //    ^^^^^^^^ tên biến tùy ý      ^^^^ field name API
    
    switch (operationType) {
    //^^^^ syntax cố định
      case 'create':
      //^^^ syntax cố định ^^^^^^^^ giá trị operation
        if (taskId != null && taskId.startsWith('local_')) {
        //  ^^^^^^ tên biến      ^^^^^^^^^^^^^^^^^^^^^ logic check
          await _apiService.createTask(/* ... */);
        }
        break;
        //^^^^ syntax cố định
      // ... xử lý các operation khác
    }
    
    await _storageService.markSyncOperationCompleted(syncKey);
    //    ^^^^^^^^^^^^^^^ tên service object ^^^^^^^^^^^^^^^^^^^^^^^^^ tên method
    successfulSyncs++;
    //^^^^^^^^^^^^^ tên biến tùy ý
  } catch (e) {
    debugPrint('Failed to sync operation: $e');
    continue; // Tiếp tục thử các operation khác
    //^^^^^^^ syntax cố định
  }
}
```

---

## 🌐 Connectivity Patterns (Mẫu Kết Nối)

### 1. **Online/Offline Detection (Phát Hiện Trạng Thái Mạng)**

**🔹 Khi nào dùng:**
- Mọi app có tích hợp API
- Cần hiển thị trạng thái kết nối
- Bật/tắt tính năng theo điều kiện

```dart
// ✅ LUÔN kiểm tra connectivity:
Future<bool> _kiemTraOnline() async {
//           ^^^^^^^^^^^^^^^ tên method tùy ý
  try {
    final connectivityResult = await _connectivity.checkConnectivity();
    //    ^^^^^^^^^^^^^^^^^^ tên biến tùy ý     ^^^^^^^^^^^^^ tên object tùy ý
    //                                                      ^^^^^^^^^^^^^^^^^ method cố định
    return connectivityResult != ConnectivityResult.none;
    //     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ syntax cố định
  } catch (e) {
    debugPrint('Không thể kiểm tra kết nối: $e');
    return false; // Giả sử offline nếu kiểm tra thất bại
  }
}

// ✅ Sử dụng trong operations:
Future<List<Task>> layTatCaTasks() async {
//                 ^^^^^^^^^^^^^ tên method tùy ý
  if (await _kiemTraOnline()) {
  //        ^^^^^^^^^^^^^^^ tên method tùy ý
    return await _layTasksTuAPI();
    //           ^^^^^^^^^^^^^^^ tên method tùy ý
  } else {
    return await _layTasksTuLocal();
    //           ^^^^^^^^^^^^^^^^^ tên method tùy ý
  }
}
```

**Từ dự án của bạn:**
```dart
// lib/repositories/task_repository.dart - Dòng 343-350
Future<bool> _isOnline() async {
//           ^^^^^^^^^ tên method tùy ý
  try {
    final connectivityResult = await _connectivity.checkConnectivity();
    //    ^^^^^^^^^^^^^^^^^^ tên biến tùy ý     ^^^^^^^^^^^^^ tên object
    return connectivityResult != ConnectivityResult.none;
    //     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ syntax cố định
  } catch (e) {
    debugPrint('Repository: Failed to check internet connection - $e');
    return false;
  }
}
```

---

### 2. **Connectivity Listening (Lắng Nghe Thay Đổi Kết Nối)**

**🔹 Khi nào dùng:**
- Trạng thái kết nối real-time
- Auto-sync khi trở lại online
- UI status indicators

```dart
// ✅ Lắng nghe thay đổi connectivity:
class TaskProvider extends ChangeNotifier {
//    ^^^^^^^^^^^^ tên class tùy ý  ^^^^^^^^^^^^^^^^ class cố định
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //^^^^^^^^^^^^^^^^^ syntax cố định      ^^^^^^^^^^^^^^^^^^^^^^^^^ tên biến tùy ý
  bool _laOnline = true;
  //   ^^^^^^^^^ tên biến tùy ý
  
  void khoiTao() {
  //   ^^^^^^^ tên method tùy ý
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
    //^^^^^^^^^^^^^^^^^^^^^^^^ tên biến            ^^^^^^^^^^^^^ tên object
    //                                             ^^^^^^^^^^^^^^^^^^^^^ property cố định
    //                                                                   ^^^^^^ method cố định
      (ConnectivityResult result) {
      //^^^^^^^^^^^^^^^^^^ type cố định ^^^^^^ tên param tùy ý
        final wasOffline = !_laOnline;
        //    ^^^^^^^^^^ tên biến tùy ý
        _laOnline = result != ConnectivityResult.none;
        //^^^^^^^^ tên biến  ^^^^^^^^^^^^^^^^^^^^^^^^^^^ syntax cố định
        
        if (wasOffline && _laOnline) {
        //  ^^^^^^^^^^ biến local ^^^^^^^^ biến class
          // Vừa trở lại online - sync các thao tác pending
          dongBoThaoTacCho();
          //^^^^^^^^^^^^^^^ tên method tùy ý
        }
        
        notifyListeners(); // Cập nhật UI
        //^^^^^^^^^^^^^^^ method cố định
      },
    );
  }
  
  @override
  //^^^^^^^ syntax cố định
  void dispose() {
  //   ^^^^^^^ method cố định
    _connectivitySubscription?.cancel();
    //^^^^^^^^^^^^^^^^^^^^^^^^ tên biến ^^^^^^ method cố định
    super.dispose();
    //^^^ syntax cố định ^^^^^^^ method cố định
  }
}
```

---

## 🎛️ State Management Patterns (Mẫu Quản Lý Trạng Thái)

### 1. **Provider Pattern (Mẫu Provider)**

**🔹 Khi nào dùng:**
- App đơn giản đến trung bình
- State cần chia sẻ giữa các widgets
- Dễ hiểu và implement

```dart
// ✅ DÙNG Provider cho app state:
class TaskProvider extends ChangeNotifier {
//    ^^^^^^^^^^^^ tên class tùy ý  ^^^^^^^^^^^^^^^^ class cố định
  List<Task> _tasks = [];
  //^^^^^^^^ type cố định ^^^^^^ tên biến tùy ý
  bool _dangTai = false;
  //   ^^^^^^^^ tên biến tùy ý
  String _loi = '';
  //     ^^^^ tên biến tùy ý
  
  // Getters (bắt buộc có để UI truy cập)
  List<Task> get tasks => _tasks;
  //^^^^^^^^ type cố định ^^^^^ tên getter tùy ý
  bool get dangTai => _dangTai;
  //   ^^^ syntax cố định ^^^^^^^ tên getter tùy ý
  String get loi => _loi;
  
  // Methods
  Future<void> taiTasks() async {
  //           ^^^^^^^^^ tên method tùy ý
    _setDangTai(true);
    //^^^^^^^^^^ tên method tùy ý
    try {
      _tasks = await _repository.getAllTasks();
      //^^^^^ tên biến        ^^^^^^^^^^^ tên object ^^^^^^^^^^^ tên method
      _loi = '';
    } catch (e) {
      _loi = e.toString();
      //   ^^ tên biến ^^^^^^^^^^^ method cố định
    } finally {
      _setDangTai(false);
    }
  }
  
  void _setDangTai(bool dangTai) {
  //   ^^^^^^^^^^^ tên method tùy ý ^^^^ type cố định ^^^^^^^^ param tùy ý
    _dangTai = dangTai;
    //^^^^^^^ tên biến
    notifyListeners(); // Kích hoạt UI rebuild
    //^^^^^^^^^^^^^^^ method cố định
  }
}
```

**Từ dự án của bạn:**
```dart
// Sử dụng trong UI:
Consumer<TaskProvider>(
//^^^^^^ syntax cố định ^^^^^^^^^^^^ tên Provider class
  builder: (_, taskProvider, __) {
  //^^^^^^ syntax cố định ^ tên param tùy ý ^^^^^^^^^^^^^ tên param tùy ý ^^ tên param tùy ý
    if (taskProvider.isLoading) {
    //  ^^^^^^^^^^^^^ tên object ^^^^^^^^^ tên property
      return CircularProgressIndicator();
      //     ^^^^^^^^^^^^^^^^^^^^^^^^^^ widget cố định
    }
    
    if (taskProvider.error.isNotEmpty) {
    //  ^^^^^^^^^^^^^ tên object ^^^^^ property ^^^^^^^^^ method cố định
      return ErrorWidget(taskProvider.error);
      //     ^^^^^^^^^^^ widget tùy ý ^^^^^^^^^^^^^^^^^ property
    }
    
    return TaskList(tasks: taskProvider.tasks);
    //     ^^^^^^^^ widget tùy ý     ^^^^^^^^^^^^^^^^^ property
  },
)
```

---

### 2. **Repository Pattern (Mẫu Repository)**

**🔹 Khi nào dùng:**
- Cần trừu tượng hóa data sources
- Nhiều nguồn dữ liệu (API + Local)
- Testing và mocking
- Clean architecture

```dart
// ✅ DÙNG Repository để trừu tượng hóa data layer:
class TaskRepository {
//    ^^^^^^^^^^^^^^ tên class tùy ý
  final ApiService _apiService;
  //    ^^^^^^^^^^ type tùy ý  ^^^^^^^^^^^ tên biến tùy ý
  final StorageService _storageService;
  //    ^^^^^^^^^^^^^^ type tùy ý  ^^^^^^^^^^^^^^^ tên biến tùy ý
  
  TaskRepository(this._apiService, this._storageService);
  //^^^^^^^^^^^^ constructor tùy ý
  
  Future<List<Task>> getAllTasks() async {
  //                 ^^^^^^^^^^^ tên method tùy ý
    // Repository xử lý logic API vs Local
    if (await _kiemTraOnline()) {
    //        ^^^^^^^^^^^^^^^ tên method tùy ý
      final tasks = await _apiService.getAllTasks();
      //    ^^^^^ tên biến tùy ý
      await _storageService.saveAllTasks(tasks);
      //    ^^^^^^^^^^^^^^^ tên object ^^^^^^^^^^^^ tên method
      return tasks;
    } else {
      return await _storageService.getAllTasks();
    }
  }
}
```

**Lợi ích:**
- Provider chỉ cần gọi `repository.getAllTasks()`
- Provider không cần biết dữ liệu đến từ API hay local
- Dễ test bằng mock repository
- Có thể đổi data source mà không ảnh hưởng UI

---

## 🎯 Cây Quyết Định: Khi Nào Dùng Gì

### Quyết Định API Methods
```
Cần lấy dữ liệu? → GET
Cần tạo mới? → POST
Cần cập nhật toàn bộ record? → PUT
Cần cập nhật vài fields? → PATCH
Cần xóa? → DELETE
```

### Quyết Định Error Handling
```
Thao tác quan trọng? → try-catch với fallback
Cần UI khác nhau cho lỗi khác nhau? → Custom exceptions
Cần user action? → Thông báo lỗi cụ thể
Có thể retry tự động? → Retry logic
```

### Quyết Định Async Pattern
```
Thao tác độc lập? → Future.wait (song song)
Thao tác phụ thuộc? → async/await (tuần tự)
Dữ liệu real-time? → Stream
Có thể chậm? → Thêm timeout
```

### Quyết Định Storage Strategy
```
Dữ liệu thay đổi thường xuyên? → API-first
Dữ liệu ít thay đổi? → Cache-first
Cần hỗ trợ offline? → Sync queue
Performance quan trọng? → Cache với TTL
```

### Quyết Định State Management
```
App đơn giản? → setState
Độ phức tạp trung bình? → Provider
App phức tạp? → Bloc/Riverpod
Cần time travel debugging? → Redux
```

---

## 📝 Tóm Tắt Best Practices

### ✅ LUÔN LÀM:
- Dùng try-catch cho tất cả API calls
- Kiểm tra connectivity trước khi gọi API
- Implement timeout cho requests
- Cung cấp cơ chế fallback
- Cache dữ liệu cho offline
- Hiển thị loading states trong UI
- Xử lý tất cả trường hợp lỗi có thể
- Dùng specific exception types

### ❌ KHÔNG BAO GIỜ:
- Gọi API mà không xử lý lỗi
- Block UI thread với sync operations
- Bỏ qua network connectivity
- Lưu dữ liệu nhạy cảm dạng plain text
- Gọi API trong build() method
- Quên dispose resources
- Dùng sync operations cho file/network IO
- Bỏ qua user feedback (loading, errors)

### 🎯 KHI KHÔNG CHẮC:
- Bắt đầu đơn giản, optimize sau
- Ưu tiên user experience
- Lập kế hoạch cho offline scenarios
- Test với điều kiện mạng kém
- Cân nhắc giới hạn mobile data
- Luôn có fallback strategies

---

## 🚀 Ví Dụ Thực Tế Từ Dự Án Của Bạn

### Pattern 1: Tạo Với Fallback
```dart
// lib/repositories/task_repository.dart - Dòng 29-73
Future<Task> createTask(String title, String description) async {
//           ^^^^^^^^^^ tên method     ^^^^^ ^^^^^^^^^^^ param tùy ý
  try {
    if (await _isOnline()) {
    //        ^^^^^^^^^^ tên method tùy ý
      // ✅ Chiến lược Online: API trước
      await _apiService.createTask(title, description);
      //    ^^^^^^^^^^^ tên service object ^^^^^^^^^ tên method
      final allTasks = await _apiService.getAllTasks();
      //    ^^^^^^^^ tên biến tùy ý
      await _storageService.saveAllTasks(allTasks);
      return /* tìm task vừa tạo */;
    } else {
      // ✅ Chiến lược Offline: Local với sync queue
      final newTask = await _storageService.addTaskLocal(title, description);
      //    ^^^^^^^ tên biến tùy ý      ^^^^^^^^^^^^^^^ tên service object
      return newTask;
    }
  } catch (e) {
    // ✅ Chiến lược Fallback: Luôn thử local
    try {
      final newTask = await _storageService.addTaskLocal(title, description);
      return newTask;
    } catch (localError) {
    //      ^^^^^^^^^^ tên biến tùy ý
      throw Exception('Repository: Failed to create task - $e');
      //^^^ syntax cố định
    }
  }
}
```

### Pattern 2: Xử Lý Sync Queue
```dart
// lib/repositories/task_repository.dart - Dòng 240-290
Future<void> syncPendingOperations() async {
//           ^^^^^^^^^^^^^^^^^^^^ tên method tùy ý
  // ✅ Guard clause: Kiểm tra connectivity trước
  if (!await _isOnline()) {
  //  ^     ^^^^^^^^^^ tên method tùy ý
    debugPrint('Không thể sync: Không có kết nối internet');
    return;
  }

  final pendingOperations = await _storageService.getPendingSyncOperations();
  //    ^^^^^^^^^^^^^^^^^ tên biến tùy ý     ^^^^^^^^^^^^^^^ tên service object
  
  // ✅ Xử lý từng operation với error isolation
  int successfulSyncs = 0;
  //  ^^^^^^^^^^^^^^^ tên biến tùy ý
  for (final operation in pendingOperations) {
  //   ^^^^^ syntax cố định ^^^^^^^^^ tên biến    ^^^^^^^^^^^^^^^^^ tên biến
    try {
      // ✅ Xử lý các loại operation khác nhau
      switch (operationType) {
      //^^^^ syntax cố định ^^^^^^^^^^^^^ tên biến
        case 'create':
        //^^^ syntax cố định ^^^^^^^^ giá trị operation
          if (taskId?.startsWith('local_') == true) {
          //  ^^^^^^ tên biến ^^^^^^^^^^^^^^^^^^^^ logic check
            await _apiService.createTask(/* ... */);
          }
          break;
        // ... các cases khác
      }
      
      await _storageService.markSyncOperationCompleted(syncKey);
      //    ^^^^^^^^^^^^^^^ tên service ^^^^^^^^^^^^^^^^^^^^^^^^^^^ tên method
      successfulSyncs++;
    } catch (e) {
      // ✅ Tiếp tục với operations khác ngay cả khi một cái thất bại
      debugPrint('Failed to sync operation: $e');
      continue;
      //^^^^^^^ syntax cố định
    }
  }
  
  // ✅ Chỉ reload nếu thực sự sync được gì đó
  if (successfulSyncs > 0) {
  //  ^^^^^^^^^^^^^^^ tên biến
    final allTasks = await _apiService.getAllTasks();
    await _storageService.saveAllTasks(allTasks);
    await _storageService.clearCompledSyncOperations();
    //    ^^^^^^^^^^^^^^^ tên service ^^^^^^^^^^^^^^^^^^^^^^^^^^^ tên method
  }
}
```

---

## 🔍 Phân Biệt Syntax Cố Định vs Tùy Chỉnh

### **🔒 SYNTAX CỐ ĐỊNH** (không thể thay đổi):
- `Future`, `async`, `await`
- `try`, `catch`, `finally`, `throw`
- `http.get`, `http.post`, `http.put`, `http.patch`, `http.delete`
- `Uri.parse`, `json.encode`, `json.decode`
- `response.statusCode`, `response.body`
- `Stream`, `StreamBuilder`
- `extends`, `implements`, `abstract`, `class`
- `@override`, `super`

### **✏️ CÓ THỂ TÙY CHỈNH**:
- Tên class: `TaskRepository`, `TaskProvider`
- Tên method: `getAllTasks()`, `layTatCaTasks()`
- Tên biến: `response`, `tasks`, `error`
- Tên parameter: `title`, `description`, `taskId`
- Tên service object: `_apiService`, `_storageService`
- Exception class names: `ApiException`, `LoiMang`
- Field names trong JSON (phụ thuộc API): `'title'`, `'status'`

---

*Hy vọng guide này giúp bạn hiểu rõ khi nào dùng gì và phân biệt được syntax cố định vs tùy chỉnh! 🎯*
