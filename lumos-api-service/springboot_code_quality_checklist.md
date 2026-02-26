# ✅ CHECKLIST KIỂM TRA CHẤT LƯỢNG CODE SPRING BOOT 3 + JPA

Checklist này được thiết kế dựa trên best practices chính thức của Spring Boot, Spring Data JPA, Spring Security, cùng với nguyên tắc Clean Code, SOLID và kinh nghiệm thực chiến trong các hệ thống production. Mục tiêu: đảm bảo mã nguồn rõ ràng, dễ bảo trì, bảo mật và hiệu suất cao.

---

## 🎯 Yêu Cầu Cốt Lõi

| Tiêu chí | Mức độ |
|---------|--------|
| Code rõ ràng, dễ đọc, dễ bảo trì (Maintainability) | Bắt buộc |
| Code tránh lỗi tiềm ẩn, fail-fast và an toàn runtime (Reliability) | Bắt buộc |
| Code tối ưu hiệu suất theo use case thực tế (Performance) | Bắt buộc |
| Tuân thủ Java 17+ và best practices Spring Boot 3 + JPA | Bắt buộc |
| Tuân thủ Clean Code, SOLID, Design Patterns | Bắt buộc |

---

## 1️⃣ Code Structure & Convention

| Tiêu chí | Mức độ |
|---------|--------|
| Tên biến, phương thức, lớp rõ ràng, không viết tắt tùy tiện | Bắt buộc |
| Hàm nên ngắn gọn, không vượt quá 30 dòng nếu không cần thiết | Ưu tiên |
| Dùng `final` cho biến không thay đổi | Ưu tiên |
| Tránh hardcode — dùng constant hoặc enum | Bắt buộc |
| Không quá 3 tham số/method — nếu nhiều hơn, dùng DTO/Builder | Ưu tiên |
| Sắp xếp method: constructor → public → private | Ưu tiên |
| Áp dụng Guard Clauses / Early Return để tránh deep nesting | Bắt buộc |
| Tối ưu vòng lặp bằng break/continue khi phù hợp | Ưu tiên |
| Class dài quá ~300 dòng cần tách nhỏ theo SRP | Ưu tiên |
| Tránh lạm dụng annotation gây rối; annotation phải có mục đích rõ ràng | Ưu tiên |

---

## 2️⃣ Object-Oriented Design & Class Principles

| Tiêu chí | Mức độ |
|---------|--------|
| Tuân thủ nguyên tắc SOLID đầy đủ | Bắt buộc |
| Mỗi class đảm nhận đúng một trách nhiệm (SRP) | Bắt buộc |
| Ưu tiên composition hơn inheritance | Ưu tiên |
| Sử dụng Dependency Injection thay vì khởi tạo trực tiếp (new) | Bắt buộc |
| Tách interface nhỏ thay vì tạo interface lớn (ISP) | Ưu tiên |
| Tránh God Class — chia nhỏ nếu class quá lớn hoặc đa trách nhiệm | Bắt buộc |

---

## 3️⃣ Layered Architecture Compliance

| Tiêu chí | Mức độ |
|---------|--------|
| Tuân thủ phân tầng rõ ràng: Controller → Service → Repository | Bắt buộc |
| Không truy vấn DB trong Controller | Bắt buộc |
| Không viết business logic trong Repository | Bắt buộc |
| Không trả về Entity trực tiếp qua API — luôn dùng DTO | Bắt buộc |
| Dùng MapStruct / ModelMapper nếu cần map tự động | Ưu tiên |

---

## 4️⃣ Performance & Resource Management

| Tiêu chí | Mức độ |
|---------|--------|
| Dùng FetchType.LAZY mặc định để tránh N+1 query | Bắt buộc |
| Chỉ dùng FetchType.EAGER khi thực sự cần thiết | Bắt buộc |
| Sử dụng Pageable thay vì trả về toàn bộ danh sách | Bắt buộc |
| Sử dụng connection pool (HikariCP) mặc định của Spring Boot | Bắt buộc |
| Đóng tài nguyên đúng cách (try-with-resources) | Bắt buộc |
| Dùng @Transactional ở Service, tránh ở Controller | Bắt buộc |

---

## 5️⃣ REST API Best Practices

| Tiêu chí | Mức độ |
|---------|--------|
| Dùng @RestController thay vì @Controller | Bắt buộc |
| Trả về ResponseEntity<?>, không trả dữ liệu thô | Bắt buộc |
| Trả về HTTP status code đúng theo ngữ cảnh | Bắt buộc |
| Endpoint dùng danh từ (e.g. /users), không dùng động từ (/getUsers) | Ưu tiên |
| API phải có versioning rõ ràng (/api/v1/...) | Ưu tiên |
| Có tài liệu API bằng Swagger / Springdoc OpenAPI | Bắt buộc |

---

## 6️⃣ Security Best Practices

| Tiêu chí | Mức độ |
|---------|--------|
| Mã hóa password bằng BCrypt hoặc Argon2 | Bắt buộc |
| Dùng JWT  để xác thực | Bắt buộc |
| Tránh SQL Injection — dùng Query Param hoặc Prepared Statement | Bắt buộc |
| Không log / trả về dữ liệu nhạy cảm (token, password, stacktrace) | Bắt buộc |
| Không dùng @CrossOrigin("*") ở production | Bắt buộc |
| Giới hạn CORS cho domain xác định | Ưu tiên |
| Dùng @PreAuthorize / @Secured nếu có phân quyền | Ưu tiên |
| Không expose internal ID trực tiếp nếu domain yêu cầu an toàn cao; ưu tiên UUID/public id | Ưu tiên |
| API cần auth thì ưu tiên JWT hoặc OAuth2 thay cho session-based auth | Ưu tiên |

---

## 7️⃣ Error Handling & Logging

| Tiêu chí | Mức độ |
|---------|--------|
| Xử lý lỗi tập trung bằng @ControllerAdvice | Bắt buộc |
| Không dùng catch(Exception) — cần rõ loại exception | Bắt buộc |
| Log đúng cấp độ (INFO, WARN, ERROR), không dùng DEBUG ở production | Ưu tiên |
| Không log dữ liệu nhạy cảm | Bắt buộc |
| Dùng logging template: logger.info("User {} logged in", userId) | Ưu tiên |

---

## 8️⃣ Lombok Usage Rules

| Tiêu chí | Mức độ |
|---------|--------|
| Ưu tiên Lombok để giảm boilerplate: `@Getter`, `@Setter`, `@Builder`, `@RequiredArgsConstructor` | Bắt buộc |
| Với Service/Component dùng constructor injection + `@RequiredArgsConstructor` (không field injection) | Bắt buộc |
| DTO bất biến ưu tiên `@Value` hoặc `record`; DTO mutable mới dùng `@Data` | Ưu tiên |
| Không dùng `@Data` cho JPA Entity để tránh `equals/hashCode/toString` ngoài ý muốn | Bắt buộc |
| Entity chỉ dùng annotation tường minh (`@Getter/@Setter`) và kiểm soát `equals/hashCode` theo id | Bắt buộc |
| Khi cần log object, tránh `@ToString` làm lộ dữ liệu nhạy cảm | Bắt buộc |
| Không lạm dụng Lombok làm mờ business logic; code tạo ra phải dễ đọc và dễ debug | Ưu tiên |

---

## 9️⃣ Apache Commons Lang3 Usage

| Tiêu chí | Mức độ |
|---------|--------|
| Ưu tiên `StringUtils` (`isBlank`, `isNotBlank`, `trimToNull`, `equalsIgnoreCase`) thay cho xử lý chuỗi thủ công | Bắt buộc |
| Ưu tiên `ObjectUtils`/`BooleanUtils` cho null-safe checks thay vì if lồng sâu | Ưu tiên |
| Dùng `Validate` cho fail-fast input validation ở service/util layer | Ưu tiên |
| Dùng `RandomStringUtils`/`RandomUtils` khi cần test data, không tự viết tiện ích ngẫu nhiên lặp lại | Tùy chọn |
| Tránh import wildcard; chỉ import class thực sự dùng để giữ code rõ ràng | Bắt buộc |
| Không lạm dụng tiện ích Apache nếu Java chuẩn đã đủ rõ ràng (ưu tiên readability) | Ưu tiên |

---

## 🔟 Java Stream Usage Rules

| Tiêu chí | Mức độ |
|---------|--------|
| Ưu tiên Stream cho các tác vụ map/filter/group giúp code ngắn gọn, thay vì vòng lặp dài lặp lại | Ưu tiên |
| Dùng method reference (`Class::method`) khi rõ nghĩa để tăng readability | Ưu tiên |
| Giữ pipeline ngắn gọn; nếu quá phức tạp thì tách thành biến trung gian hoặc method riêng | Bắt buộc |
| Không dùng Stream nếu vòng lặp `for` đơn giản sẽ rõ ràng hơn | Bắt buộc |
| Tránh side effects trong `map/filter` (không mutate state ngoài luồng xử lý) | Bắt buộc |
| Chỉ dùng `parallelStream()` khi đã benchmark và chứng minh có lợi về hiệu năng | Bắt buộc |
| Khi cần xử lý null-safe collection, kết hợp `Optional` hoặc trả về empty list thay vì `null` | Ưu tiên |
| Không chain quá sâu gây khó debug; ưu tiên fail-fast và guard clauses trước khi vào stream pipeline | Ưu tiên |

---
