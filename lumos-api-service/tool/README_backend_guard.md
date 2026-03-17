# Backend Guard (Spring Boot + JPA)

## Run

```bash
python tool/verify_backend_checklists.py
python tool/verify_backend_checklists.py --strict
python tool/verify_backend_checklists.py --only=i18n --strict
```

## Output

- Console: list violations in format `file:line: [SEVERITY] RULE - reason`.
- JSON report: `backend_guard_report.json` (created in project root).

## Rule Coverage (current)

- `CLASS_MAX_LINES`
- `CONTROLLER_REST_CONTROLLER`
- `CONTROLLER_NO_TRANSACTIONAL`
- `CONTROLLER_NO_ENTITY_RESPONSE`
- `CONTROLLER_API_VERSIONING`
- `CONTROLLER_API_DOC_REQUIRED`
- `REPOSITORY_EXTENDS_JPA_REPOSITORY`
- `ENTITY_NO_LOMBOK_DATA`
- `ENTITY_HAS_ID`
- `ENTITY_NO_SERVICE_REPOSITORY_DEP`
- `ENTITY_RELATION_FETCH_LAZY`
- `ENTITY_MANY_TO_ONE_HAS_JOIN_COLUMN`
- `ENTITY_AUDIT_LIFECYCLE`
- `ENTITY_SHARED_FIELDS_MAPPED_SUPERCLASS`
- `ENTITY_HAS_VERSION_FOR_OPTIMISTIC_LOCK`
- `ENTITY_ENUMERATED_STRING`
- `SOFT_DELETE_NO_HARD_DELETE_CALL`
- `SOFT_DELETE_FIND_QUERY_FILTER`
- `MAPSTRUCT_MAPPER_REQUIRED`
- `MAPSTRUCT_NO_MANUAL_MAPPING_IN_SERVICE_CONTROLLER`
- `DTO_REQUEST_VALIDATION_ANNOTATION_REQUIRED`
- `DTO_VALIDATION_MESSAGE_MUST_USE_STATIC_CONSTANT`
- `LOMBOK_REQUIRED_ARGS_CONSTRUCTOR_FOR_SPRING_BEAN`
- `LOMBOK_ENTITY_GETTER_SETTER_REQUIRED`
- `LOMBOK_BUILDER_PREFERRED_FOR_DTO_CLASS`
- `NESTED_FOR_SHOULD_USE_STREAM_INNER_LOOP`
- `NO_ELSE_ALLOWED`
- `AUDIT_FIELDS_ENTITY_MUST_USE_SEPARATE_BASE_CLASS`
- `AUDIT_FIELDS_DTO_MUST_USE_SEPARATE_MODEL`
- `EXCEPTION_MUST_DECLARE_SERIAL_VERSION_UID`
- `VI_MESSAGES_MUST_BE_VIETNAMESE_ACCENTED`
- `NO_DIRECT_TRIM_USE_STRINGUTILS`
- `NO_DIRECT_BLANK_CHECK_USE_STRINGUTILS`
- `NO_DIRECT_STRING_PREDICATE_USE_STRINGUTILS`
- `QUERY_MUST_USE_NATIVE_SQL`
- `QUERY_SQL_KEYWORDS_MUST_BE_UPPERCASE`
- `JAVADOC_REQUIRED_FOR_CONTROLLER_AND_ENDPOINTS`
- `JAVADOC_REQUIRED_FOR_SERVICE_METHODS`
- `IF_STATEMENT_REQUIRES_PRECEDING_COMMENT`
- `THROW_STATEMENT_REQUIRES_PRECEDING_COMMENT`
- `FOR_STATEMENT_REQUIRES_PRECEDING_COMMENT`
- `STREAM_CALL_REQUIRES_PRECEDING_COMMENT`
- `RETURN_STATEMENT_REQUIRES_PRECEDING_COMMENT`
- `EXCEPTION_MESSAGE_MUST_USE_I18N_KEY`
- `ERROR_MESSAGE_KEYS_MUST_EXIST_IN_MESSAGE_BUNDLES`

## Rule Intent And Rationale

### Controller

- `CLASS_MAX_LINES`: warns when a class file exceeds 300 lines. It discourages oversized classes that usually mix multiple responsibilities and become hard to review, test, and maintain.
- `CONTROLLER_REST_CONTROLLER`: requires files under `/controller/` to use `@RestController`. It forbids plain `@Controller` for REST endpoints and warns when a controller-like file exposes mappings without the REST annotation. The goal is to keep the HTTP layer explicitly JSON/API-oriented.
- `CONTROLLER_NO_TRANSACTIONAL`: forbids `@Transactional` in the controller layer. Transaction boundaries must stay in service logic so the controller remains a thin HTTP adapter.
- `CONTROLLER_NO_ENTITY_RESPONSE`: forbids returning JPA entities directly from controllers, including `ResponseEntity<Entity>`. Controllers must return DTOs or approved response wrappers to avoid ORM leakage, lazy-loading side effects, and accidental exposure of persistence fields.
- `CONTROLLER_API_VERSIONING`: warns when `@RequestMapping` does not use a versioned API path such as `/api/v1/...`. The intent is to keep route evolution explicit and safer for backward compatibility.
- `CONTROLLER_API_DOC_REQUIRED`: requires every endpoint mapping annotation to have a nearby `@Operation`. It forbids undocumented public endpoints because this repository treats API documentation as part of the contract.

### Repository And Query

- `REPOSITORY_EXTENDS_JPA_REPOSITORY`: requires repository interfaces under `/repository/` to extend `JpaRepository`, except projection repositories. It forbids custom repository interfaces that bypass the expected Spring Data JPA contract.
- `SOFT_DELETE_NO_HARD_DELETE_CALL`: forbids service code from calling hard-delete methods such as `delete(...)`, `deleteById(...)`, `deleteAll(...)`, or `deleteAllById(...)`. The rule protects a soft-delete data retention strategy.
- `SOFT_DELETE_FIND_QUERY_FILTER`: warns when repository `find...` methods do not clearly filter out soft-deleted records through the method name or a `@Query` clause. The intent is to prevent deleted records from leaking back into normal read flows.
- `QUERY_MUST_USE_NATIVE_SQL`: requires every repository `@Query` to set `nativeQuery = true`, and it also forbids JPQL/HQL-style entity references such as `from UserEntity`. The repository standard here is database-native SQL against real table and column names.
- `QUERY_SQL_KEYWORDS_MUST_BE_UPPERCASE`: requires SQL keywords inside `@Query` blocks to be uppercase. It forbids lowercase SQL keywords to preserve query readability and style consistency across the codebase.
- `MAPSTRUCT_MAPPER_REQUIRED`: when the project contains both entities and DTOs, it requires at least one MapStruct mapper interface under `/mapper/`. It forbids letting entity-to-DTO translation become an ad hoc pattern spread across services and controllers.

### Entity And Audit

- `ENTITY_NO_LOMBOK_DATA`: forbids Lombok `@Data` on JPA entities. The reason is that generated `equals`, `hashCode`, and `toString` methods are risky for JPA identity, proxies, and bi-directional relations.
- `ENTITY_HAS_ID`: requires every entity to declare an `@Id`. It forbids unmanaged persistence models that do not expose a primary identifier.
- `ENTITY_NO_SERVICE_REPOSITORY_DEP`: forbids entities from importing `service` or `repository` packages. The rule protects dependency direction so persistence models do not depend on higher application layers.
- `ENTITY_RELATION_FETCH_LAZY`: warns when relation annotations do not explicitly declare `fetch = FetchType.LAZY`. It discourages implicit fetch behavior because eager loading is harder to predict and can create performance regressions.
- `ENTITY_MANY_TO_ONE_HAS_JOIN_COLUMN`: requires every `@ManyToOne` association to define `@JoinColumn` explicitly. It forbids relying on inferred foreign-key names because schema contracts must stay obvious and stable.
- `ENTITY_AUDIT_LIFECYCLE`: warns when an entity contains `createdAt` or `updatedAt` but does not define either lifecycle callbacks (`@PrePersist` and `@PreUpdate`) or Spring Data auditing annotations (`@CreatedDate` and `@LastModifiedDate`). Audit fields are only valid when their lifecycle is enforced.
- `ENTITY_SHARED_FIELDS_MAPPED_SUPERCLASS`: warns when multiple entities repeat shared audit fields without using a `@MappedSuperclass`. The rule discourages duplicated audit structure and nudges the project toward a single reusable base entity.
- `ENTITY_HAS_VERSION_FOR_OPTIMISTIC_LOCK`: warns when an entity has no `@Version`. It encourages optimistic locking so concurrent updates do not silently overwrite each other.
- `ENTITY_ENUMERATED_STRING`: requires `@Enumerated(EnumType.STRING)`. It forbids ordinal enum persistence because enum reordering would corrupt persisted meaning.
- `AUDIT_FIELDS_ENTITY_MUST_USE_SEPARATE_BASE_CLASS`: forbids regular entities from declaring audit fields such as `createdAt`, `updatedAt`, `deletedAt`, `deleted`, or `isDeleted` directly unless they inherit from an audit base class or are themselves a `@MappedSuperclass`. Audit ownership must be centralized.

### DTO, Mapping, And Construction

- `MAPSTRUCT_NO_MANUAL_MAPPING_IN_SERVICE_CONTROLLER`: warns when service or controller code manually constructs DTOs, entities, requests, or responses with `new ...`. It discourages hand-written mapping logic in orchestration layers and pushes that responsibility into dedicated mappers.
- `DTO_REQUEST_VALIDATION_ANNOTATION_REQUIRED`: requires request DTOs under `/dto/request/` to contain Jakarta Bean Validation annotations. It forbids unchecked request models because input validation must happen at the contract boundary.
- `DTO_VALIDATION_MESSAGE_MUST_USE_STATIC_CONSTANT`: forbids string literals inside validation annotation `message = "..."` attributes. Validation messages must come from named static constants so the i18n and message-key contract stays centralized.
- `LOMBOK_REQUIRED_ARGS_CONSTRUCTOR_FOR_SPRING_BEAN`: for Spring beans with `final` dependencies, it requires `@RequiredArgsConstructor`; if explicit constructor injection exists, it downgrades to a warning. The rule reduces boilerplate while preserving constructor-based dependency injection.
- `LOMBOK_ENTITY_GETTER_SETTER_REQUIRED`: warns when an entity contains many manual getters and setters without Lombok `@Getter` or `@Setter`. It discourages repetitive accessor boilerplate in persistence models.
- `LOMBOK_BUILDER_PREFERRED_FOR_DTO_CLASS`: warns when a DTO class with several fields is not a `record` and does not use `@Builder`. The goal is to make DTO construction clearer and less error-prone than long constructors or scattered setters.
- `AUDIT_FIELDS_DTO_MUST_USE_SEPARATE_MODEL`: forbids non-audit DTOs from carrying audit fields directly. Audit metadata must live in a dedicated audit model instead of leaking into regular request or response shapes.
- `EXCEPTION_MUST_DECLARE_SERIAL_VERSION_UID`: requires custom exception classes under `/exception/` to declare `serialVersionUID`. It enforces a standard Java exception contract and avoids leaving serialization behavior implicit.

### Flow, Documentation, And Intent Comments

- `NESTED_FOR_SHOULD_USE_STREAM_INNER_LOOP`: warns when a `for` loop contains a nested inner `for` loop with deeper indentation. It discourages excessive loop nesting and prefers a Stream-based inner iteration when that makes intent clearer.
- `NO_ELSE_ALLOWED`: forbids `else` and `else if` anywhere in scanned Java code. The repository standard is fail-fast flow with guard clauses, early returns, and flatter control structures.
- `JAVADOC_REQUIRED_FOR_CONTROLLER_AND_ENDPOINTS`: requires JavaDoc above controller classes and above each endpoint mapping. It forbids public HTTP entry points that are not self-documented.
- `JAVADOC_REQUIRED_FOR_SERVICE_METHODS`: requires every public service method to have JavaDoc, including `@param` entries for each parameter and `@return` for non-void methods. It forbids opaque service contracts because the service layer carries business meaning.
- `IF_STATEMENT_REQUIRES_PRECEDING_COMMENT`: for production behavior code under service, mode, security, and controller packages, it requires a nearby comment above each `if`. It forbids condition branches that do not explain their business or defensive intent.
- `THROW_STATEMENT_REQUIRES_PRECEDING_COMMENT`: requires a nearby comment above each `throw` in the same production packages. It forbids silent exception paths where the reason for failing is not explained.
- `FOR_STATEMENT_REQUIRES_PRECEDING_COMMENT`: requires a nearby comment above each `for` loop in the same production packages. It forbids loop logic whose purpose is not made explicit.
- `STREAM_CALL_REQUIRES_PRECEDING_COMMENT`: requires a nearby comment above each `.stream(...)` call in the same production packages. It forbids stream pipelines that hide their behavioral purpose behind fluent syntax.
- `RETURN_STATEMENT_REQUIRES_PRECEDING_COMMENT`: requires a nearby comment above each `return` in the same production packages. It forbids business return paths that end abruptly without clarifying why that path is correct.

### String Handling

- `NO_DIRECT_TRIM_USE_STRINGUTILS`: forbids direct `.trim()` calls unless the code is already using `StringUtils.trim(...)`. String normalization must go through the shared utility convention rather than ad hoc direct method calls.
- `NO_DIRECT_BLANK_CHECK_USE_STRINGUTILS`: forbids direct `.isBlank()` calls and manual null-or-blank checks such as `value == null || value.isBlank()`. Blank handling must use `StringUtils.isBlank(...)` or `StringUtils.isNotBlank(...)` for consistency and null safety.
- `NO_DIRECT_STRING_PREDICATE_USE_STRINGUTILS`: forbids manual null-or-empty checks and direct string predicates such as `startsWith`, `endsWith`, `contains`, `equals`, and `equalsIgnoreCase`. It also rejects deprecated Commons Lang patterns such as `StringUtils.equals(...)`, `StringUtils.equalsIgnoreCase(...)`, and `StringUtils.compareIgnoreCase(...)`. The rule pushes the codebase toward the approved `StringUtils` and `Strings.CS/CI` APIs with explicit null-safe semantics.

### I18n And Message Bundles

- `EXCEPTION_MESSAGE_MUST_USE_I18N_KEY`: in production Java code under controller, service, mode, security, exception, and error packages, it forbids hardcoded user-facing text in thrown exceptions, `ResponseStatusException`, and `messageSource.getMessage(...)` calls. Those paths must use message keys instead. A nearby comment marker `backend-guard: allow-technical-literal` is the only documented escape hatch for purely technical literals.
- `VI_MESSAGES_MUST_BE_VIETNAMESE_ACCENTED`: requires `messages_vi.properties` to exist and requires Vietnamese message values with alphabetic text to contain proper accented Vietnamese characters. It forbids non-accented Vietnamese translations because they degrade the quality of the user-facing i18n contract.
- `ERROR_MESSAGE_KEYS_MUST_EXIST_IN_MESSAGE_BUNDLES`: requires every key declared in `ErrorMessageKeys.java` to exist in `messages.properties`, `messages_en.properties`, and `messages_vi.properties`. It forbids drift between code-level message keys and the actual message bundles that the application resolves at runtime.

Comment-intent rules above are enforced for production behavior code under `src/main/java/**` in service, mode, security, and controller packages. The purpose is to explain business or behavioral intent, not to force synthetic comments into tests or thin persistence glue.

Backend i18n rules above target user-facing error paths. Hardcoded natural-language text in exception or message-source resolution paths is forbidden; use `ErrorMessageKeys` plus `messages*.properties`. Purely technical invariant text may be allowed only when a nearby comment carries the marker `backend-guard: allow-technical-literal` and explains why the literal is not client-facing.

## Notes

- Guard is regex/static-scan based (fail-fast, no AST dependency).
- `--strict` will fail build on warnings.
- `--only=i18n --strict` is the recommended backend localization gate when you want to block hardcoded user-facing text and missing message bundle keys without failing on unrelated style warnings.
- Deprecated Apache Commons Lang3 APIs such as `StringUtils.equals(...)`, `StringUtils.equalsIgnoreCase(...)`, and `StringUtils.compareIgnoreCase(...)` should not be used. Prefer `Strings.CS.equals(...)`, `Strings.CI.equals(...)`, `Strings.CI.compare(...)`, or other non-deprecated utilities that match the intent.
