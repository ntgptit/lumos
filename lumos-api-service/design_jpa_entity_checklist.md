# ✅ DESIGN JPA ENTITY CHECKLIST

Checklist này tập trung vào chuẩn thiết kế JPA Entity cho Spring Boot, đảm bảo đúng domain, dễ bảo trì, tránh lỗi hiệu năng và lỗi mapping runtime.

---

## 1) Naming & Structure

| Tiêu chí | Mức độ |
|---------|--------|
| Mỗi Entity map rõ ràng với một bảng nghiệp vụ | Bắt buộc |
| Tên class dùng danh từ, có hậu tố `Entity` nếu team đang dùng convention này | Ưu tiên |
| Tên bảng/cột rõ nghĩa, nhất quán snake_case hoặc theo chuẩn DB của dự án | Bắt buộc |
| Không nhồi business logic phức tạp vào Entity | Bắt buộc |
| Nếu nhiều entity có field chung (`id`, `createdAt`, `updatedAt`, `deleted`) thì dùng `@MappedSuperclass` | Ưu tiên |

---

## 2) ID & Primary Key

| Tiêu chí | Mức độ |
|---------|--------|
| Luôn có khóa chính `@Id` | Bắt buộc |
| Strategy sinh ID phù hợp DB (`IDENTITY`, `SEQUENCE`) | Bắt buộc |
| Không tự set ID thủ công cho entity mới nếu dùng auto-generate | Bắt buộc |

---

## 3) Field Mapping

| Tiêu chí | Mức độ |
|---------|--------|
| Dùng `@Column` cho field quan trọng: `nullable`, `length`, `unique` khi cần | Bắt buộc |
| Dùng kiểu dữ liệu Java phù hợp với kiểu DB (ví dụ `Instant` cho timestamp) | Bắt buộc |
| Không hardcode magic values, dùng constants/enums/config | Bắt buộc |
| Trạng thái nghiệp vụ nên dùng `enum` + `@Enumerated(EnumType.STRING)` | Bắt buộc |
| Tránh mặc định `VARCHAR(255)` cho mọi text field; chọn length theo domain | Ưu tiên |
| Dùng `@Version` cho optimistic locking khi có cạnh tranh cập nhật | Ưu tiên |

---

## 4) Relationship Mapping

| Tiêu chí | Mức độ |
|---------|--------|
| Quan hệ được định nghĩa rõ: `@OneToMany`, `@ManyToOne`, `@OneToOne`, `@ManyToMany` | Bắt buộc |
| Mặc định ưu tiên `FetchType.LAZY` để tránh N+1 và tải thừa dữ liệu | Bắt buộc |
| Chỉ dùng `EAGER` khi có lý do rõ ràng và đã đo tác động | Bắt buộc |
| Tránh `ManyToMany` trực tiếp khi bảng trung gian có thêm metadata | Ưu tiên |
| Dùng `mappedBy` đúng phía owner/inverse để tránh tạo cột/bảng thừa | Bắt buộc |
| `@ManyToOne` cần khai báo `@JoinColumn` tường minh để rõ khóa ngoại | Bắt buộc |
| Hạn chế `cascade = CascadeType.ALL`; chỉ bật cascade cần thiết theo lifecycle thực tế | Ưu tiên |

---

## 5) Lifecycle & Audit

| Tiêu chí | Mức độ |
|---------|--------|
| Dùng `@PrePersist`, `@PreUpdate` hoặc auditing để set `createdAt/updatedAt` | Bắt buộc |
| Soft delete nên có cờ `deleted` và timestamp `deletedAt` nếu nghiệp vụ yêu cầu | Ưu tiên |
| Không viết logic phụ thuộc external service trong callback lifecycle | Bắt buộc |
| Nếu dùng Spring Data Auditing thì cấu hình `@EnableJpaAuditing` ở lớp config | Ưu tiên |

---

## 6) Equals / HashCode / ToString

| Tiêu chí | Mức độ |
|---------|--------|
| Không dùng `@Data` cho Entity | Bắt buộc |
| `equals/hashCode` phải ổn định, ưu tiên dựa trên id đã persisted | Bắt buộc |
| `toString` không kéo theo quan hệ LAZY gây vòng lặp hoặc query ngoài ý muốn | Bắt buộc |
| Không log dữ liệu nhạy cảm từ entity (`password`, `token`, secret fields) | Bắt buộc |

---

## 7) Validation & Integrity

| Tiêu chí | Mức độ |
|---------|--------|
| Dùng Bean Validation (`@NotNull`, `@Size`, `@NotBlank`) ở mức phù hợp | Ưu tiên |
| Ràng buộc DB quan trọng phải thể hiện ở schema/migration (FK, unique, index) | Bắt buộc |
| Không phụ thuộc hoàn toàn vào validation tầng API cho data integrity | Bắt buộc |

---

## 8) Performance & Query Safety

| Tiêu chí | Mức độ |
|---------|--------|
| Entity không chứa collection quá lớn mà không có chiến lược phân trang/query | Bắt buộc |
| Tránh truy cập quan hệ LAZY trong vòng lặp nóng mà không fetch plan | Bắt buộc |
| Dùng projection/DTO query khi chỉ cần một phần dữ liệu | Ưu tiên |
| Đảm bảo các cột filter/sort thường dùng có index phù hợp | Bắt buộc |
| Ưu tiên `JOIN FETCH` đúng chỗ để giảm số lượng query thay vì gọi lặp | Ưu tiên |
| Với truy vấn nặng, kiểm tra execution plan (`EXPLAIN ANALYZE`) trước khi tối ưu | Ưu tiên |

---

## 9) Migration & Compatibility

| Tiêu chí | Mức độ |
|---------|--------|
| Mọi thay đổi Entity đi kèm migration (Flyway/Liquibase) | Bắt buộc |
| Không đổi tên/drop cột trực tiếp mà không kế hoạch migrate dữ liệu | Bắt buộc |
| Review backward compatibility trước khi release | Bắt buộc |

---

## 10) Quick Anti-Patterns

| Anti-pattern | Khuyến nghị |
|--------------|-------------|
| `FetchType.EAGER` hàng loạt | Chuyển về LAZY + query theo use case |
| Entity trả thẳng ra API | Dùng DTO/Mapper |
| `@Data` trên Entity | Dùng `@Getter/@Setter` + kiểm soát equals/hashCode |
| Không có migration khi đổi entity | Bổ sung migration ngay |
| Đặt business logic nặng trong Entity | Chuyển sang Service domain logic |

---
