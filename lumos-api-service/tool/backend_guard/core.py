#!/usr/bin/env python3
"""
Backend checklist guard for Spring Boot + JPA.

Run:
  python tool/verify_backend_checklists.py
  python tool/verify_backend_checklists.py --strict
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


RULE_CLASS_MAX_LINES = "CLASS_MAX_LINES"
RULE_CONTROLLER_REST = "CONTROLLER_REST_CONTROLLER"
RULE_CONTROLLER_TX = "CONTROLLER_NO_TRANSACTIONAL"
RULE_CONTROLLER_ENTITY_RESPONSE = "CONTROLLER_NO_ENTITY_RESPONSE"
RULE_CONTROLLER_API_VERSION = "CONTROLLER_API_VERSIONING"
RULE_CONTROLLER_API_DOC = "CONTROLLER_API_DOC_REQUIRED"
RULE_REPOSITORY_EXTENDS_JPA = "REPOSITORY_EXTENDS_JPA_REPOSITORY"
RULE_ENTITY_NO_DATA = "ENTITY_NO_LOMBOK_DATA"
RULE_ENTITY_HAS_ID = "ENTITY_HAS_ID"
RULE_ENTITY_NO_LAYER_DEP = "ENTITY_NO_SERVICE_REPOSITORY_DEP"
RULE_ENTITY_RELATION_FETCH = "ENTITY_RELATION_FETCH_LAZY"
RULE_ENTITY_MANY_TO_ONE_JOIN = "ENTITY_MANY_TO_ONE_HAS_JOIN_COLUMN"
RULE_ENTITY_AUDIT_LIFECYCLE = "ENTITY_AUDIT_LIFECYCLE"
RULE_SHARED_MAPPED_SUPERCLASS = "ENTITY_SHARED_FIELDS_MAPPED_SUPERCLASS"
RULE_ENTITY_OPTIMISTIC_LOCK = "ENTITY_HAS_VERSION_FOR_OPTIMISTIC_LOCK"
RULE_ENTITY_ENUM_STRING = "ENTITY_ENUMERATED_STRING"
RULE_SOFT_DELETE_NO_HARD_DELETE = "SOFT_DELETE_NO_HARD_DELETE_CALL"
RULE_SOFT_DELETE_FIND_FILTER = "SOFT_DELETE_FIND_QUERY_FILTER"
RULE_MAPSTRUCT_MAPPER_REQUIRED = "MAPSTRUCT_MAPPER_REQUIRED"
RULE_MAPSTRUCT_NO_MANUAL_MAPPING = "MAPSTRUCT_NO_MANUAL_MAPPING_IN_SERVICE_CONTROLLER"
RULE_DTO_VALIDATION_ANNOTATION = "DTO_REQUEST_VALIDATION_ANNOTATION_REQUIRED"
RULE_DTO_VALIDATION_MESSAGE_CONSTANT = "DTO_VALIDATION_MESSAGE_MUST_USE_STATIC_CONSTANT"
RULE_LOMBOK_REQUIRED_ARGS_CONSTRUCTOR = "LOMBOK_REQUIRED_ARGS_CONSTRUCTOR_FOR_SPRING_BEAN"
RULE_LOMBOK_ENTITY_GETTER_SETTER = "LOMBOK_ENTITY_GETTER_SETTER_REQUIRED"
RULE_LOMBOK_BUILDER_PREFERRED = "LOMBOK_BUILDER_PREFERRED_FOR_DTO_CLASS"
RULE_NESTED_FOR_STREAM = "NESTED_FOR_SHOULD_USE_STREAM_INNER_LOOP"
RULE_NO_ELSE = "NO_ELSE_ALLOWED"
RULE_AUDIT_ENTITY_SEPARATE_CLASS = "AUDIT_FIELDS_ENTITY_MUST_USE_SEPARATE_BASE_CLASS"
RULE_AUDIT_DTO_SEPARATE_CLASS = "AUDIT_FIELDS_DTO_MUST_USE_SEPARATE_MODEL"
RULE_EXCEPTION_SERIAL_VERSION_UID = "EXCEPTION_MUST_DECLARE_SERIAL_VERSION_UID"
RULE_VI_MESSAGES_ACCENTED = "VI_MESSAGES_MUST_BE_VIETNAMESE_ACCENTED"
RULE_NO_DIRECT_TRIM = "NO_DIRECT_TRIM_USE_STRINGUTILS"
RULE_NO_DIRECT_BLANK_CHECK = "NO_DIRECT_BLANK_CHECK_USE_STRINGUTILS"
RULE_NO_DIRECT_STRING_PREDICATE = "NO_DIRECT_STRING_PREDICATE_USE_STRINGUTILS"
RULE_QUERY_NATIVE_SQL_ONLY = "QUERY_MUST_USE_NATIVE_SQL"
RULE_QUERY_KEYWORD_UPPERCASE = "QUERY_SQL_KEYWORDS_MUST_BE_UPPERCASE"
RULE_JAVADOC_CONTROLLER_REQUIRED = "JAVADOC_REQUIRED_FOR_CONTROLLER_AND_ENDPOINTS"
RULE_JAVADOC_SERVICE_REQUIRED = "JAVADOC_REQUIRED_FOR_SERVICE_METHODS"
RULE_IF_REQUIRES_COMMENT = "IF_STATEMENT_REQUIRES_PRECEDING_COMMENT"

SEVERITY_ERROR = "ERROR"
SEVERITY_WARNING = "WARN"

JAVA_EXTENSION = ".java"
CLASS_MAX_LINES = 300
REPORT_FILE = "backend_guard_report.json"

RELATION_PATTERN = re.compile(r"@\s*(OneToMany|ManyToOne|ManyToMany|OneToOne)\s*(\((.*?)\))?")
REQUEST_MAPPING_PATTERN = re.compile(r'@\s*RequestMapping\s*\(\s*"([^"]+)"')
ENTITY_RESPONSE_PATTERN = re.compile(r"\bResponseEntity<\s*\w+Entity\s*>")
DIRECT_ENTITY_RETURN_PATTERN = re.compile(r"\bpublic\s+(\w+Entity)\s+\w+\s*\(")
INTERFACE_PATTERN = re.compile(r"\binterface\s+\w+")
EXTENDS_JPA_PATTERN = re.compile(r"\bextends\s+JpaRepository<")
IMPORT_SERVICE_OR_REPO_PATTERN = re.compile(r"^import\s+.*\.(service|repository)\.", re.MULTILINE)
ENTITY_CLASS_PATTERN = re.compile(r"@\s*Entity\b")
MAPPED_SUPERCLASS_PATTERN = re.compile(r"@\s*MappedSuperclass\b")
MAPSTRUCT_MAPPER_PATTERN = re.compile(r"@\s*Mapper\b")
ID_ANNOTATION_PATTERN = re.compile(r"@\s*Id\b")
LOMBOK_DATA_PATTERN = re.compile(r"@\s*Data\b")
PRE_PERSIST_PATTERN = re.compile(r"@\s*PrePersist\b")
PRE_UPDATE_PATTERN = re.compile(r"@\s*PreUpdate\b")
CREATED_DATE_PATTERN = re.compile(r"@\s*CreatedDate\b")
LAST_MODIFIED_DATE_PATTERN = re.compile(r"@\s*LastModifiedDate\b")
VERSION_PATTERN = re.compile(r"@\s*Version\b")
ENUMERATED_PATTERN = re.compile(r"@\s*Enumerated\b")
ENUMERATED_STRING_PATTERN = re.compile(r"@\s*Enumerated\s*\(\s*EnumType\.STRING\s*\)")
HARD_DELETE_CALL_PATTERN = re.compile(r"\.\s*delete(ById|All|AllById)?\s*\(")
FIND_METHOD_PATTERN = re.compile(r"^\s*(?:Page<.*>|List<.*>|Optional<.*>|[\w<>?,\s]+)\s+find\w*\s*\(")
MAPPING_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*(GetMapping|PostMapping|PutMapping|PatchMapping|DeleteMapping)\b")
OPERATION_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*Operation\b")
QUERY_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*Query\b")
REST_CONTROLLER_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*RestController\b")
PUBLIC_METHOD_START_PATTERN = re.compile(r"^\s*public\s+.+\(.+\).*")
IF_STATEMENT_PATTERN = re.compile(r"^\s*if\s*\(")
MANUAL_MAPPING_NEW_PATTERN = re.compile(r"\bnew\s+\w+(Entity|Dto|DTO|Response|Request)\s*\(")
DTO_VALIDATION_ANNOTATION_PATTERN = re.compile(
    r"@\s*(Valid|NotNull|NotBlank|NotEmpty|Size|Pattern|Min|Max|Positive|PositiveOrZero|Negative|NegativeOrZero|Email|Past|PastOrPresent|Future|FutureOrPresent|AssertTrue|AssertFalse)\b"
)
VALIDATION_ANNOTATION_START_PATTERN = re.compile(
    r"@\s*(NotNull|NotBlank|NotEmpty|Size|Pattern|Min|Max|Positive|PositiveOrZero|Negative|NegativeOrZero|Email|Past|PastOrPresent|Future|FutureOrPresent|AssertTrue|AssertFalse)\b"
)
VALIDATION_LITERAL_MESSAGE_PATTERN = re.compile(r'message\s*=\s*"[^"]*"')
SPRING_BEAN_PATTERN = re.compile(r"@\s*(Service|Component|RestController|Controller|Configuration)\b")
REQUIRED_ARGS_CONSTRUCTOR_PATTERN = re.compile(r"@\s*RequiredArgsConstructor\b")
FINAL_FIELD_PATTERN = re.compile(r"^\s*private\s+final\s+[\w<>, ?]+\s+\w+\s*;")
CONSTRUCTOR_PATTERN = re.compile(r"^\s*public\s+([A-Z]\w*)\s*\(")
LOMBOK_GETTER_OR_SETTER_PATTERN = re.compile(r"@\s*(Getter|Setter)\b")
MANUAL_GETTER_OR_SETTER_PATTERN = re.compile(r"^\s*public\s+[\w<>, ?\[\]]+\s+(get|set|is)[A-Z]\w*\s*\(")
LOMBOK_BUILDER_PATTERN = re.compile(r"@\s*Builder\b")
RECORD_PATTERN = re.compile(r"\brecord\s+[A-Z]\w*\s*\(")
PRIVATE_FIELD_PATTERN = re.compile(r"^\s*private\s+[\w<>, ?\[\]]+\s+\w+\s*;")
FOR_PATTERN = re.compile(r"^\s*for\s*\(")
ELSE_PATTERN = re.compile(r"\belse\b")
CLASS_DECLARATION_PATTERN = re.compile(r"\bclass\s+([A-Z]\w*)\s*(?:extends\s+([A-Z]\w*))?")
AUDIT_FIELD_DECLARATION_PATTERN = re.compile(
    r"\b(createdAt|updatedAt|deletedAt|deleted|isDeleted)\b"
)
EXCEPTION_CLASS_PATTERN = re.compile(r"\bclass\s+([A-Z]\w*Exception)\s+extends\s+[\w.]*Exception\b")
SERIAL_VERSION_UID_PATTERN = re.compile(
    r"private\s+static\s+final\s+long\s+serialVersionUID\s*=\s*[-]?\d+L\s*;"
)
VIETNAMESE_ACCENTED_CHAR_PATTERN = re.compile(r"[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ]")
DIRECT_TRIM_PATTERN = re.compile(r"\.\s*trim\s*\(")
DIRECT_IS_BLANK_PATTERN = re.compile(r"\.\s*isBlank\s*\(")
NULL_OR_BLANK_PATTERN = re.compile(r"==\s*null.*\|\|.*\.isBlank\s*\(")
DIRECT_STARTS_WITH_PATTERN = re.compile(r"\.\s*startsWith\s*\(")
DIRECT_ENDS_WITH_PATTERN = re.compile(r"\.\s*endsWith\s*\(")
DIRECT_CONTAINS_PATTERN = re.compile(r"\.\s*contains\s*\(")
DIRECT_EQUALS_PATTERN = re.compile(r"\.\s*equals\s*\(")
DIRECT_EQUALS_IGNORE_CASE_PATTERN = re.compile(r"\.\s*equalsIgnoreCase\s*\(")
NULL_OR_EMPTY_SAME_VAR_PATTERN = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*==\s*null\s*\|\|\s*\1\s*\.\s*isEmpty\s*\(")
NOT_NULL_AND_EMPTY_SAME_VAR_PATTERN = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*!=\s*null\s*&&\s*\1\s*\.\s*isEmpty\s*\(")
NOT_NULL_AND_NOT_EMPTY_SAME_VAR_PATTERN = re.compile(
    r"\b([A-Za-z_][A-Za-z0-9_]*)\s*!=\s*null\s*&&\s*!\s*\1\s*\.\s*isEmpty\s*\("
)
JPQL_ENTITY_FROM_PATTERN = re.compile(r"\bfrom\s+[A-Z]\w+\b")
LOWERCASE_SQL_KEYWORD_PATTERNS = [
    re.compile(r"\bselect\b"),
    re.compile(r"\bfrom\b"),
    re.compile(r"\bwhere\b"),
    re.compile(r"\bjoin\b"),
    re.compile(r"\bleft\b"),
    re.compile(r"\bright\b"),
    re.compile(r"\binner\b"),
    re.compile(r"\bouter\b"),
    re.compile(r"\bon\b"),
    re.compile(r"\band\b"),
    re.compile(r"\bor\b"),
    re.compile(r"\bunion\b"),
    re.compile(r"\ball\b"),
    re.compile(r"\bwith\b"),
    re.compile(r"\brecursive\b"),
    re.compile(r"\border\s+by\b"),
    re.compile(r"\bgroup\s+by\b"),
    re.compile(r"\bupdate\b"),
    re.compile(r"\bset\b"),
    re.compile(r"\bin\b"),
    re.compile(r"\bis\b"),
    re.compile(r"\bnull\b"),
    re.compile(r"\blower\s*\("),
    re.compile(r"\bupper\s*\("),
    re.compile(r"\bcount\s*\("),
]


@dataclass(frozen=True)
class Violation:
    rule: str
    severity: str
    file: str
    line: int
    reason: str
    snippet: str

    def to_console(self) -> str:
        return f"{self.file}:{self.line}: [{self.severity}] {self.rule} - {self.reason} :: {self.snippet}"


@dataclass(frozen=True)
class FileContext:
    path: Path
    rel_path: str
    text: str
    lines: list[str]


class Rule:
    name: str

    def check(self, file_ctx: FileContext, project_ctx: "ProjectContext") -> Iterable[Violation]:
        raise NotImplementedError


@dataclass
class ProjectContext:
    root: Path
    java_files: list[FileContext]
    strict: bool


class MaxClassLinesRule(Rule):
    name = RULE_CLASS_MAX_LINES

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        line_count = len(file_ctx.lines)
        if line_count <= CLASS_MAX_LINES:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=1,
                reason=f"Class file exceeds {CLASS_MAX_LINES} lines (found {line_count}).",
                snippet=file_ctx.rel_path,
            )
        ]


class ControllerRestRule(Rule):
    name = RULE_CONTROLLER_REST

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        if "@RestController" in file_ctx.text:
            return []
        line = _first_line_of(file_ctx.lines, "@Controller")
        if line > 0:
            return [
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=line,
                    reason="Controller must use @RestController.",
                    snippet=file_ctx.lines[line - 1].strip(),
                )
            ]
        line = _first_line_by_contains_any(
            file_ctx.lines,
            ["@GetMapping", "@PostMapping", "@PutMapping", "@PatchMapping", "@DeleteMapping"],
        )
        if line <= 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=line,
                reason="Controller-like file should declare @RestController.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class ControllerTransactionalRule(Rule):
    name = RULE_CONTROLLER_TX

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        line = _first_line_regex(file_ctx.lines, r"@\s*Transactional\b")
        if line <= 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line,
                reason="Do not put @Transactional in controller layer.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class ControllerEntityResponseRule(Rule):
    name = RULE_CONTROLLER_ENTITY_RESPONSE

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = raw.strip()
            if ENTITY_RESPONSE_PATTERN.search(stripped) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Controller must not return Entity directly; use DTO.",
                        snippet=stripped,
                    )
                )
                continue
            if DIRECT_ENTITY_RETURN_PATTERN.search(stripped) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Controller method return type must not be Entity.",
                    snippet=stripped,
                )
            )
        return violations


class ControllerApiVersionRule(Rule):
    name = RULE_CONTROLLER_API_VERSION

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        for index, raw in enumerate(file_ctx.lines, start=1):
            match = REQUEST_MAPPING_PATTERN.search(raw)
            if match is None:
                continue
            value = match.group(1)
            if re.match(r"^/api/v\d+/", value) is not None:
                return []
            return [
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason='Request mapping should be versioned, example: "/api/v1/...".',
                    snippet=raw.strip(),
                )
            ]
        return []


class ControllerApiDocRule(Rule):
    name = RULE_CONTROLLER_API_DOC

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if MAPPING_ANNOTATION_PATTERN.search(raw) is None:
                continue
            previous = _previous_non_blank_lines(file_ctx.lines, index, 5)
            has_operation = any(OPERATION_ANNOTATION_PATTERN.search(text) is not None for _, text in previous)
            if has_operation:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Endpoint mapping requires @Operation for API documentation.",
                    snippet=raw.strip(),
                )
            )
        return violations


class RepositoryJpaRule(Rule):
    name = RULE_REPOSITORY_EXTENDS_JPA

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/repository/" not in file_ctx.rel_path:
            return []
        if "/repository/projection/" in file_ctx.rel_path:
            return []
        if INTERFACE_PATTERN.search(file_ctx.text) is None:
            return []
        if EXTENDS_JPA_PATTERN.search(file_ctx.text) is not None:
            return []
        line = _first_line_regex(file_ctx.lines, r"\binterface\s+\w+")
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line if line > 0 else 1,
                reason="Repository interface should extend JpaRepository.",
                snippet=file_ctx.lines[line - 1].strip() if line > 0 else file_ctx.rel_path,
            )
        ]


class EntityNoDataRule(Rule):
    name = RULE_ENTITY_NO_DATA

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        line = _first_line_regex(file_ctx.lines, r"@\s*Data\b")
        if line <= 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line,
                reason="@Data is forbidden on JPA Entity.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class EntityHasIdRule(Rule):
    name = RULE_ENTITY_HAS_ID

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if ID_ANNOTATION_PATTERN.search(file_ctx.text) is not None:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=1,
                reason="Entity must declare @Id field.",
                snippet=file_ctx.rel_path,
            )
        ]


class EntityLayerDependencyRule(Rule):
    name = RULE_ENTITY_NO_LAYER_DEP

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        match = IMPORT_SERVICE_OR_REPO_PATTERN.search(file_ctx.text)
        if match is None:
            return []
        line = _line_for_offset(file_ctx.lines, match.start())
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line,
                reason="Entity must not depend on service/repository layer.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class EntityRelationFetchRule(Rule):
    name = RULE_ENTITY_RELATION_FETCH

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            relation_match = RELATION_PATTERN.search(raw)
            if relation_match is None:
                continue
            annotation_args = relation_match.group(3) or ""
            if "fetch = FetchType.LAZY" in annotation_args:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason=f"{relation_match.group(1)} should explicitly use fetch = FetchType.LAZY.",
                    snippet=raw.strip(),
                )
            )
        return violations


class EntityManyToOneJoinColumnRule(Rule):
    name = RULE_ENTITY_MANY_TO_ONE_JOIN

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if re.search(r"@\s*ManyToOne\b", raw) is None:
                continue
            window = _next_non_blank_lines(file_ctx.lines, index, 5)
            has_join = any("@JoinColumn" in text for _, text in window)
            if has_join:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="@ManyToOne should define @JoinColumn explicitly.",
                    snippet=raw.strip(),
                )
            )
        return violations


class EntityAuditLifecycleRule(Rule):
    name = RULE_ENTITY_AUDIT_LIFECYCLE

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        has_created_or_updated = "createdAt" in file_ctx.text or "updatedAt" in file_ctx.text
        if not has_created_or_updated:
            return []
        has_pre_persist = PRE_PERSIST_PATTERN.search(file_ctx.text) is not None
        has_pre_update = PRE_UPDATE_PATTERN.search(file_ctx.text) is not None
        has_created_date = CREATED_DATE_PATTERN.search(file_ctx.text) is not None
        has_last_modified = LAST_MODIFIED_DATE_PATTERN.search(file_ctx.text) is not None
        if has_pre_persist and has_pre_update:
            return []
        if has_created_date and has_last_modified:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=1,
                reason="Entity has createdAt/updatedAt but missing lifecycle/auditing setup.",
                snippet=file_ctx.rel_path,
            )
        ]


class SharedFieldsMappedSuperclassRule(Rule):
    name = RULE_SHARED_MAPPED_SUPERCLASS

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if file_ctx != project_ctx.java_files[0]:
            return []
        entity_files = [f for f in project_ctx.java_files if ENTITY_CLASS_PATTERN.search(f.text) is not None]
        if len(entity_files) < 2:
            return []
        has_mapped_superclass = any(MAPPED_SUPERCLASS_PATTERN.search(f.text) is not None for f in project_ctx.java_files)
        if has_mapped_superclass:
            return []
        common_entities: list[FileContext] = []
        for entity in entity_files:
            if "createdAt" not in entity.text:
                continue
            if "updatedAt" not in entity.text:
                continue
            common_entities.append(entity)
        if len(common_entities) < 2:
            return []
        targets = ", ".join(f.rel_path for f in common_entities[:3])
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=common_entities[0].rel_path,
                line=1,
                reason="Multiple entities share audit fields; consider @MappedSuperclass base entity.",
                snippet=targets,
            )
        ]


class EntityVersionRule(Rule):
    name = RULE_ENTITY_OPTIMISTIC_LOCK

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if VERSION_PATTERN.search(file_ctx.text) is not None:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=1,
                reason="Entity should define @Version for optimistic locking in concurrent updates.",
                snippet=file_ctx.rel_path,
            )
        ]


class EntityEnumeratedStringRule(Rule):
    name = RULE_ENTITY_ENUM_STRING

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if ENUMERATED_PATTERN.search(raw) is None:
                continue
            if ENUMERATED_STRING_PATTERN.search(raw) is not None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="@Enumerated must use EnumType.STRING.",
                    snippet=raw.strip(),
                )
            )
        return violations


class SoftDeleteNoHardDeleteRule(Rule):
    name = RULE_SOFT_DELETE_NO_HARD_DELETE

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/service/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if HARD_DELETE_CALL_PATTERN.search(raw) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Hard delete call detected. Use soft delete strategy.",
                    snippet=raw.strip(),
                )
            )
        return violations


class SoftDeleteFindFilterRule(Rule):
    name = RULE_SOFT_DELETE_FIND_FILTER

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/repository/" not in file_ctx.rel_path:
            return []
        lines = file_ctx.lines
        violations: list[Violation] = []
        for index, raw in enumerate(lines, start=1):
            if FIND_METHOD_PATTERN.search(raw) is None:
                continue
            stripped = raw.strip()
            if "Deleted" in stripped:
                continue
            prev_window = _previous_non_blank_lines(lines, index, 40)
            has_query_annotation = any("@Query" in text for _, text in prev_window)
            query_context = " ".join(text for _, text in prev_window)
            has_query_with_deleted = has_query_annotation and "deleted" in query_context.lower()
            if has_query_with_deleted:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason='Repository find-method should include deleted filter (e.g. "...AndDeletedFalse").',
                    snippet=stripped,
                )
            )
        return violations


class MapStructRequiredRule(Rule):
    name = RULE_MAPSTRUCT_MAPPER_REQUIRED

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if file_ctx != project_ctx.java_files[0]:
            return []
        has_entity = any("/entity/" in f.rel_path and ENTITY_CLASS_PATTERN.search(f.text) is not None for f in project_ctx.java_files)
        has_dto = any("/dto/" in f.rel_path for f in project_ctx.java_files)
        if not has_entity or not has_dto:
            return []

        mapper_files = [f for f in project_ctx.java_files if "/mapper/" in f.rel_path]
        has_mapstruct_mapper = any(
            MAPSTRUCT_MAPPER_PATTERN.search(f.text) is not None and INTERFACE_PATTERN.search(f.text) is not None
            for f in mapper_files
        )
        if has_mapstruct_mapper:
            return []

        target_file = mapper_files[0].rel_path if len(mapper_files) > 0 else file_ctx.rel_path
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=target_file,
                line=1,
                reason="Project has Entity + DTO but missing MapStruct mapper interface (@Mapper).",
                snippet='Define mapper under "/mapper/" using @Mapper.',
            )
        ]


class MapStructNoManualMappingRule(Rule):
    name = RULE_MAPSTRUCT_NO_MANUAL_MAPPING

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/service/" not in file_ctx.rel_path and "/controller/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if MANUAL_MAPPING_NEW_PATTERN.search(raw) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Manual DTO/Entity construction detected; prefer MapStruct mapper.",
                    snippet=raw.strip(),
                )
            )
        return violations


class DtoValidationAnnotationRule(Rule):
    name = RULE_DTO_VALIDATION_ANNOTATION

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/dto/request/" not in file_ctx.rel_path:
            return []
        if DTO_VALIDATION_ANNOTATION_PATTERN.search(file_ctx.text) is not None:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=1,
                reason="Request DTO must define validation annotations (jakarta.validation.*).",
                snippet=file_ctx.rel_path,
            )
        ]


class DtoValidationMessageConstantRule(Rule):
    name = RULE_DTO_VALIDATION_MESSAGE_CONSTANT

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/dto/request/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        lines = file_ctx.lines
        for index, raw in enumerate(lines, start=1):
            if VALIDATION_ANNOTATION_START_PATTERN.search(raw) is None:
                continue
            block = _collect_annotation_block(lines, index, 6)
            if block.strip() == "":
                continue
            if VALIDATION_LITERAL_MESSAGE_PATTERN.search(block) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason='Validation annotation message must use static constant, not string literal.',
                    snippet=raw.strip(),
                )
            )
        return violations


class LombokRequiredArgsConstructorRule(Rule):
    name = RULE_LOMBOK_REQUIRED_ARGS_CONSTRUCTOR

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if SPRING_BEAN_PATTERN.search(file_ctx.text) is None:
            return []
        final_fields = [raw for raw in file_ctx.lines if FINAL_FIELD_PATTERN.search(raw) is not None]
        if len(final_fields) == 0:
            return []
        if REQUIRED_ARGS_CONSTRUCTOR_PATTERN.search(file_ctx.text) is not None:
            return []
        class_name = _detect_primary_class_name(file_ctx.lines)
        has_constructor = False
        if class_name != "":
            constructor_regex = re.compile(rf"^\s*public\s+{re.escape(class_name)}\s*\(")
            has_constructor = any(constructor_regex.search(raw) is not None for raw in file_ctx.lines)
        if has_constructor:
            return [
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=1,
                    reason="Spring bean uses constructor injection; prefer @RequiredArgsConstructor to reduce boilerplate.",
                    snippet=file_ctx.rel_path,
                )
            ]
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=1,
                reason="Spring bean with final dependencies should use @RequiredArgsConstructor.",
                snippet=file_ctx.rel_path,
            )
        ]


class LombokEntityGetterSetterRule(Rule):
    name = RULE_LOMBOK_ENTITY_GETTER_SETTER

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if LOMBOK_GETTER_OR_SETTER_PATTERN.search(file_ctx.text) is not None:
            return []
        manual_methods = [raw for raw in file_ctx.lines if MANUAL_GETTER_OR_SETTER_PATTERN.search(raw) is not None]
        if len(manual_methods) < 4:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=1,
                reason="Entity has many manual getters/setters; consider Lombok @Getter/@Setter.",
                snippet=file_ctx.rel_path,
            )
        ]


class LombokBuilderPreferredRule(Rule):
    name = RULE_LOMBOK_BUILDER_PREFERRED

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/dto/" not in file_ctx.rel_path:
            return []
        if RECORD_PATTERN.search(file_ctx.text) is not None:
            return []
        if " class " not in f" {file_ctx.text} ":
            return []
        if LOMBOK_BUILDER_PATTERN.search(file_ctx.text) is not None:
            return []
        field_count = sum(1 for raw in file_ctx.lines if PRIVATE_FIELD_PATTERN.search(raw) is not None)
        if field_count < 3:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=1,
                reason="DTO class has multiple fields; prefer Lombok @Builder for object construction.",
                snippet=file_ctx.rel_path,
            )
        ]


class NestedForShouldUseStreamRule(Rule):
    name = RULE_NESTED_FOR_STREAM

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        lines = file_ctx.lines
        for index, raw in enumerate(lines, start=1):
            if FOR_PATTERN.search(raw) is None:
                continue
            outer_indent = _indent_level(raw)
            window = _next_non_blank_lines(lines, index, 30)
            for line_no, candidate in window:
                if line_no <= index:
                    continue
                if FOR_PATTERN.search(candidate) is None:
                    continue
                inner_indent = _indent_level(candidate)
                if inner_indent <= outer_indent:
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_WARNING,
                        file=file_ctx.rel_path,
                        line=line_no,
                        reason="Nested for-loop detected; prefer Stream for inner iteration to reduce nesting.",
                        snippet=candidate.strip(),
                    )
                )
                break
        return violations


class NoElseRule(Rule):
    name = RULE_NO_ELSE

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue
            if ELSE_PATTERN.search(line) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="else/else-if is forbidden. Use guard clauses and early return.",
                    snippet=raw.strip(),
                )
            )
        return violations


class AuditEntitySeparateClassRule(Rule):
    name = RULE_AUDIT_ENTITY_SEPARATE_CLASS

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if MAPPED_SUPERCLASS_PATTERN.search(file_ctx.text) is not None:
            return []
        declaration = _find_class_declaration(file_ctx.lines)
        extends_name = declaration[1] if declaration is not None else ""
        if "Audit" in extends_name:
            return []
        audit_field_lines = _find_audit_field_lines(file_ctx.lines)
        if len(audit_field_lines) == 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=audit_field_lines[0][0],
                reason="Entity must place audit fields in a separate base class (MappedSuperclass).",
                snippet=audit_field_lines[0][1].strip(),
            )
        ]


class AuditDtoSeparateClassRule(Rule):
    name = RULE_AUDIT_DTO_SEPARATE_CLASS

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/dto/" not in file_ctx.rel_path:
            return []
        if "Audit" in file_ctx.rel_path:
            return []
        audit_field_lines = _find_audit_field_lines(file_ctx.lines)
        if len(audit_field_lines) == 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=audit_field_lines[0][0],
                reason="DTO must use separate audit model instead of direct audit fields.",
                snippet=audit_field_lines[0][1].strip(),
            )
        ]


class ExceptionSerialVersionUidRule(Rule):
    name = RULE_EXCEPTION_SERIAL_VERSION_UID

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/exception/" not in file_ctx.rel_path:
            return []
        if EXCEPTION_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if SERIAL_VERSION_UID_PATTERN.search(file_ctx.text) is not None:
            return []
        line = _first_line_regex(file_ctx.lines, r"\bclass\s+[A-Z]\w*Exception\b")
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line if line > 0 else 1,
                reason="Exception class must declare static final long serialVersionUID.",
                snippet=file_ctx.lines[line - 1].strip() if line > 0 else file_ctx.rel_path,
            )
        ]


class NoDirectTrimRule(Rule):
    name = RULE_NO_DIRECT_TRIM

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue
            if "StringUtils.trim(" in line:
                continue
            if DIRECT_TRIM_PATTERN.search(line) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Direct .trim() is forbidden. Use StringUtils from Apache Commons Lang3.",
                    snippet=raw.strip(),
                )
            )
        return violations


class NoDirectBlankCheckRule(Rule):
    name = RULE_NO_DIRECT_BLANK_CHECK

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue
            if "StringUtils.isBlank(" in line or "StringUtils.isNotBlank(" in line:
                continue
            if NULL_OR_BLANK_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct null/blank check is forbidden. Use StringUtils.isBlank/isNotBlank.",
                        snippet=raw.strip(),
                    )
                )
                continue
            if DIRECT_IS_BLANK_PATTERN.search(line) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Direct .isBlank() is forbidden. Use StringUtils.isBlank/isNotBlank.",
                    snippet=raw.strip(),
                )
            )
        return violations


class NoDirectStringPredicateRule(Rule):
    name = RULE_NO_DIRECT_STRING_PREDICATE

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue

            has_stringutils_call = (
                "StringUtils.isEmpty(" in line
                or "StringUtils.isNotEmpty(" in line
                or "StringUtils.contains(" in line
                or "StringUtils.equals(" in line
                or "StringUtils.equalsIgnoreCase(" in line
                or "Strings.CS.startsWith(" in line
                or "Strings.CS.endsWith(" in line
                or "Strings.CI.startsWith(" in line
                or "Strings.CI.endsWith(" in line
            )
            if has_stringutils_call:
                continue

            if NULL_OR_EMPTY_SAME_VAR_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct null/empty check is forbidden. Use StringUtils.isEmpty/isNotEmpty.",
                        snippet=raw.strip(),
                    )
                )
                continue

            if NOT_NULL_AND_EMPTY_SAME_VAR_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct null/empty check is forbidden. Use StringUtils.isEmpty/isNotEmpty.",
                        snippet=raw.strip(),
                    )
                )
                continue

            if NOT_NULL_AND_NOT_EMPTY_SAME_VAR_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct null/empty check is forbidden. Use StringUtils.isEmpty/isNotEmpty.",
                        snippet=raw.strip(),
                    )
                )
                continue

            if DIRECT_STARTS_WITH_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct .startsWith() is forbidden. Use Apache Commons Lang3 Strings.CS/CI.startsWith.",
                        snippet=raw.strip(),
                    )
                )
                continue

            if DIRECT_ENDS_WITH_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct .endsWith() is forbidden. Use Apache Commons Lang3 Strings.CS/CI.endsWith.",
                        snippet=raw.strip(),
                    )
                )
                continue

            if DIRECT_CONTAINS_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct .contains() is forbidden. Use StringUtils.contains.",
                        snippet=raw.strip(),
                    )
                )
                continue

            if DIRECT_EQUALS_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct .equals() is forbidden for String comparison. Use StringUtils.equals.",
                        snippet=raw.strip(),
                    )
                )
                continue

            if DIRECT_EQUALS_IGNORE_CASE_PATTERN.search(line) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Direct .equalsIgnoreCase() is forbidden. Use StringUtils.equalsIgnoreCase.",
                    snippet=raw.strip(),
                )
            )
        return violations


class QueryMustUseNativeSqlRule(Rule):
    name = RULE_QUERY_NATIVE_SQL_ONLY

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/repository/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if QUERY_ANNOTATION_PATTERN.search(raw) is None:
                continue
            block = _collect_annotation_block(file_ctx.lines, index, 20)
            if "nativeQuery = true" not in block:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="@Query must use native SQL: set nativeQuery = true.",
                        snippet=raw.strip(),
                    )
                )
                continue
            if JPQL_ENTITY_FROM_PATTERN.search(block) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="@Query must reference real table/column names, not JPA entity names.",
                    snippet=raw.strip(),
                )
            )
        return violations


class QueryKeywordUppercaseRule(Rule):
    name = RULE_QUERY_KEYWORD_UPPERCASE

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/repository/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if QUERY_ANNOTATION_PATTERN.search(raw) is None:
                continue
            block = _collect_annotation_block(file_ctx.lines, index, 40)
            for keyword_pattern in LOWERCASE_SQL_KEYWORD_PATTERNS:
                if keyword_pattern.search(block) is None:
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="SQL keywords in @Query must be uppercase.",
                        snippet=raw.strip(),
                    )
                )
                break
        return violations


class JavaDocControllerRule(Rule):
    name = RULE_JAVADOC_CONTROLLER_REQUIRED

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        lines = file_ctx.lines
        violations: list[Violation] = []

        for index, raw in enumerate(lines, start=1):
            if REST_CONTROLLER_ANNOTATION_PATTERN.search(raw) is None:
                continue
            if _has_javadoc_above(lines, index, 10):
                break
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Controller class must define JavaDoc.",
                    snippet=raw.strip(),
                )
            )
            break

        for index, raw in enumerate(lines, start=1):
            if MAPPING_ANNOTATION_PATTERN.search(raw) is None:
                continue
            if _has_javadoc_above(lines, index, 12):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Endpoint mapping must define JavaDoc.",
                    snippet=raw.strip(),
                )
            )

        return violations


class JavaDocServiceRule(Rule):
    name = RULE_JAVADOC_SERVICE_REQUIRED

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        if "/service/" not in file_ctx.rel_path:
            return []
        lines = file_ctx.lines
        violations: list[Violation] = []
        class_name = _detect_primary_class_name(lines)

        for index, raw in enumerate(lines, start=1):
            stripped = raw.strip()
            if not PUBLIC_METHOD_START_PATTERN.search(stripped):
                continue
            if " class " in stripped:
                continue

            signature = _collect_method_signature(lines, index, 8)
            return_type = _extract_return_type(signature)
            method_name = _extract_method_name(signature)
            if method_name == "":
                continue
            if method_name == class_name:
                continue

            param_names = _extract_param_names(signature)
            javadoc = _extract_javadoc_above(lines, index, 20)
            if javadoc == "":
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Service method must have JavaDoc with @param/@return.",
                        snippet=stripped,
                    )
                )
                continue

            for param_name in param_names:
                if f"@param {param_name}" in javadoc:
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason=f"Service JavaDoc missing @param for '{param_name}'.",
                        snippet=stripped,
                    )
                )
                break

            if return_type == "void":
                continue
            if "@return" in javadoc:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Service JavaDoc missing @return.",
                    snippet=stripped,
                )
            )

        return violations


class IfRequiresCommentRule(Rule):
    name = RULE_IF_REQUIRES_COMMENT

    def check(self, file_ctx: FileContext, project_ctx: ProjectContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        lines = file_ctx.lines
        for index, raw in enumerate(lines, start=1):
            if IF_STATEMENT_PATTERN.search(raw) is None:
                continue
            if _has_comment_above(lines, index, 4):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="if statement must have a preceding comment explaining the condition.",
                    snippet=raw.strip(),
                )
            )
        return violations


def _check_vietnamese_messages(root: Path) -> list[Violation]:
    file_path = root / "src" / "main" / "resources" / "messages_vi.properties"
    if not file_path.exists():
        return [
            Violation(
                rule=RULE_VI_MESSAGES_ACCENTED,
                severity=SEVERITY_ERROR,
                file="src/main/resources/messages_vi.properties",
                line=1,
                reason="Missing messages_vi.properties.",
                snippet="messages_vi.properties",
            )
        ]

    lines = file_path.read_text(encoding="utf-8").splitlines()
    violations: list[Violation] = []
    relative = file_path.relative_to(root).as_posix()
    for index, raw in enumerate(lines, start=1):
        stripped = raw.strip()
        if stripped == "" or stripped.startswith("#"):
            continue
        if "=" not in stripped:
            continue
        key, value = stripped.split("=", 1)
        _ = key
        normalized = value.strip()
        if normalized == "":
            continue
        has_alpha = any(ch.isalpha() for ch in normalized)
        if not has_alpha:
            continue
        if VIETNAMESE_ACCENTED_CHAR_PATTERN.search(normalized) is not None:
            continue
        violations.append(
            Violation(
                rule=RULE_VI_MESSAGES_ACCENTED,
                severity=SEVERITY_ERROR,
                file=relative,
                line=index,
                reason="Vietnamese message must contain accented Vietnamese characters.",
                snippet=raw.strip(),
            )
        )
    return violations


def _collect_java_files(root: Path) -> list[FileContext]:
    source_roots = [
        root / "src" / "main" / "java",
        root / "src" / "test" / "java",
    ]
    files: list[FileContext] = []
    for source_root in source_roots:
        if not source_root.exists():
            continue
        for path in source_root.rglob(f"*{JAVA_EXTENSION}"):
            text = path.read_text(encoding="utf-8")
            lines = text.splitlines()
            rel_path = path.relative_to(root).as_posix()
            files.append(FileContext(path=path, rel_path=rel_path, text=text, lines=lines))
    files.sort(key=lambda item: item.rel_path)
    return files


def _first_line_of(lines: list[str], token: str) -> int:
    for index, raw in enumerate(lines, start=1):
        if token in raw:
            return index
    return -1


def _first_line_by_contains_any(lines: list[str], tokens: list[str]) -> int:
    for index, raw in enumerate(lines, start=1):
        for token in tokens:
            if token in raw:
                return index
    return -1


def _first_line_regex(lines: list[str], regex: str) -> int:
    pattern = re.compile(regex)
    for index, raw in enumerate(lines, start=1):
        if pattern.search(raw) is not None:
            return index
    return -1


def _line_for_offset(lines: list[str], offset: int) -> int:
    running = 0
    for index, raw in enumerate(lines, start=1):
        running += len(raw) + 1
        if offset < running:
            return index
    return 1


def _next_non_blank_lines(lines: list[str], start_line: int, limit: int) -> list[tuple[int, str]]:
    results: list[tuple[int, str]] = []
    index = start_line
    while index < len(lines):
        raw = lines[index]
        if raw.strip() == "":
            index += 1
            continue
        results.append((index + 1, raw))
        if len(results) >= limit:
            return results
        index += 1
    return results


def _previous_non_blank_lines(lines: list[str], start_line: int, limit: int) -> list[tuple[int, str]]:
    results: list[tuple[int, str]] = []
    index = start_line - 2
    while index >= 0:
        raw = lines[index]
        if raw.strip() == "":
            index -= 1
            continue
        results.append((index + 1, raw))
        if len(results) >= limit:
            return results
        index -= 1
    return results


def _collect_annotation_block(lines: list[str], start_line: int, max_lines: int) -> str:
    parts: list[str] = []
    open_paren = 0
    seen_paren = False
    index = start_line - 1
    end = min(len(lines), index + max_lines)
    while index < end:
        line = lines[index]
        parts.append(line)
        open_paren += line.count("(")
        open_paren -= line.count(")")
        if line.count("(") > 0:
            seen_paren = True
        if seen_paren and open_paren <= 0:
            break
        if not seen_paren and index > start_line - 1:
            break
        index += 1
    return " ".join(parts)


def _detect_primary_class_name(lines: list[str]) -> str:
    class_pattern = re.compile(r"\bclass\s+([A-Z]\w*)\b")
    for raw in lines:
        match = class_pattern.search(raw)
        if match is None:
            continue
        return match.group(1)
    return ""


def _find_class_declaration(lines: list[str]) -> tuple[str, str] | None:
    for raw in lines:
        match = CLASS_DECLARATION_PATTERN.search(raw)
        if match is None:
            continue
        class_name = match.group(1) or ""
        extends_name = match.group(2) or ""
        return (class_name, extends_name)
    return None


def _find_audit_field_lines(lines: list[str]) -> list[tuple[int, str]]:
    matches: list[tuple[int, str]] = []
    for index, raw in enumerate(lines, start=1):
        stripped = _strip_line_comment(raw).strip()
        if stripped == "":
            continue
        if AUDIT_FIELD_DECLARATION_PATTERN.search(stripped) is None:
            continue
        if "class " in stripped:
            continue
        matches.append((index, raw))
    return matches


def _indent_level(line: str) -> int:
    count = 0
    for char in line:
        if char == " ":
            count += 1
            continue
        if char == "\t":
            count += 4
            continue
        break
    return count


def _strip_line_comment(line: str) -> str:
    index = line.find("//")
    if index < 0:
        return line
    return line[:index]


def _has_javadoc_above(lines: list[str], start_line: int, max_lookback: int) -> bool:
    start_index = start_line - 2
    end_index = max(-1, start_index - max_lookback)
    for index in range(start_index, end_index, -1):
        raw = lines[index].strip()
        if raw == "":
            continue
        if raw.startswith("/**"):
            return True
        if raw.startswith("*") or raw.startswith("*/") or raw.startswith("@"):
            continue
        return False
    return False


def _has_comment_above(lines: list[str], start_line: int, max_lookback: int) -> bool:
    start_index = start_line - 2
    end_index = max(-1, start_index - max_lookback)
    for index in range(start_index, end_index, -1):
        raw = lines[index].strip()
        if raw == "":
            continue
        if raw.startswith("//"):
            return True
        if raw.startswith("@"):
            continue
        return False
    return False


def _extract_javadoc_above(lines: list[str], start_line: int, max_lookback: int) -> str:
    start_index = start_line - 2
    end_index = max(-1, start_index - max_lookback)
    parts: list[str] = []
    in_javadoc = False
    for index in range(start_index, end_index, -1):
        raw = lines[index].strip()
        if raw == "":
            if in_javadoc:
                continue
            continue
        if raw.startswith("/**"):
            parts.append(raw)
            in_javadoc = True
            break
        if raw.startswith("*") or raw.startswith("*/"):
            parts.append(raw)
            in_javadoc = True
            continue
        if raw.startswith("@"):
            continue
        if in_javadoc:
            continue
        return ""
    if not in_javadoc:
        return ""
    parts.reverse()
    return "\n".join(parts)


def _collect_method_signature(lines: list[str], start_line: int, max_lines: int) -> str:
    index = start_line - 1
    end = min(len(lines), index + max_lines)
    parts: list[str] = []
    while index < end:
        raw = lines[index].strip()
        parts.append(raw)
        if raw.endswith("{") or raw.endswith(";"):
            break
        index += 1
    return " ".join(parts)


def _extract_return_type(signature: str) -> str:
    normalized = " ".join(signature.split())
    match = re.search(
        r"\bpublic\s+(?:default\s+)?(?:static\s+)?(?:final\s+)?([A-Za-z0-9_<>\[\], ?]+?)\s+[A-Za-z_][A-Za-z0-9_]*\s*\(",
        normalized,
    )
    if match is None:
        return ""
    return match.group(1).strip()


def _extract_method_name(signature: str) -> str:
    normalized = " ".join(signature.split())
    match = re.search(
        r"\bpublic\s+(?:default\s+)?(?:static\s+)?(?:final\s+)?[A-Za-z0-9_<>\[\], ?]+\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(",
        normalized,
    )
    if match is None:
        return ""
    return match.group(1)


def _extract_param_names(signature: str) -> list[str]:
    normalized = " ".join(signature.split())
    start = normalized.find("(")
    end = normalized.rfind(")")
    if start < 0 or end < 0 or end <= start:
        return []
    params_segment = normalized[start + 1:end].strip()
    if params_segment == "":
        return []
    params = [chunk.strip() for chunk in params_segment.split(",")]
    param_names: list[str] = []
    for param in params:
        tokens = [t for t in param.split(" ") if t not in {"final"} and not t.startswith("@")]
        if len(tokens) == 0:
            continue
        candidate = tokens[-1].replace("...", "").strip()
        if candidate == "":
            continue
        param_names.append(candidate)
    return param_names


def _print_summary(violations: list[Violation]) -> None:
    if len(violations) == 0:
        print("Backend checklist guard passed.")
        return

    errors = sum(1 for v in violations if v.severity == SEVERITY_ERROR)
    warnings = sum(1 for v in violations if v.severity == SEVERITY_WARNING)
    if errors > 0:
        print(f"Backend checklist guard failed. errors={errors}, warnings={warnings}")
    else:
        print(f"Backend checklist guard completed with warnings. warnings={warnings}")
    for violation in violations:
        print(violation.to_console())


def _write_report(root: Path, violations: list[Violation]) -> None:
    payload = {
        "summary": {
            "total": len(violations),
            "errors": sum(1 for v in violations if v.severity == SEVERITY_ERROR),
            "warnings": sum(1 for v in violations if v.severity == SEVERITY_WARNING),
        },
        "violations": [
            {
                "rule": v.rule,
                "severity": v.severity,
                "file": v.file,
                "line": v.line,
                "reason": v.reason,
                "snippet": v.snippet,
            }
            for v in violations
        ],
    }
    report_path = root / REPORT_FILE
    report_path.write_text(json.dumps(payload, ensure_ascii=True, indent=2), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Spring Boot backend checklist guard.")
    parser.add_argument("--root", default=".", help="Project root directory. Default: current directory.")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Fail when warning violations exist.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    java_files = _collect_java_files(root)
    if len(java_files) == 0:
        print("No Java files found under src/main/java or src/test/java.")
        return 1

    project_ctx = ProjectContext(root=root, java_files=java_files, strict=args.strict)
    rules: list[Rule] = [
        MaxClassLinesRule(),
        ControllerRestRule(),
        ControllerTransactionalRule(),
        ControllerEntityResponseRule(),
        ControllerApiVersionRule(),
        ControllerApiDocRule(),
        RepositoryJpaRule(),
        EntityNoDataRule(),
        EntityHasIdRule(),
        EntityLayerDependencyRule(),
        EntityRelationFetchRule(),
        EntityManyToOneJoinColumnRule(),
        EntityAuditLifecycleRule(),
        SharedFieldsMappedSuperclassRule(),
        EntityVersionRule(),
        EntityEnumeratedStringRule(),
        SoftDeleteNoHardDeleteRule(),
        SoftDeleteFindFilterRule(),
        MapStructRequiredRule(),
        MapStructNoManualMappingRule(),
        DtoValidationAnnotationRule(),
        DtoValidationMessageConstantRule(),
        LombokRequiredArgsConstructorRule(),
        LombokEntityGetterSetterRule(),
        LombokBuilderPreferredRule(),
        NestedForShouldUseStreamRule(),
        NoElseRule(),
        AuditEntitySeparateClassRule(),
        AuditDtoSeparateClassRule(),
        ExceptionSerialVersionUidRule(),
        NoDirectTrimRule(),
        NoDirectBlankCheckRule(),
        NoDirectStringPredicateRule(),
        QueryMustUseNativeSqlRule(),
        QueryKeywordUppercaseRule(),
        JavaDocControllerRule(),
        JavaDocServiceRule(),
        IfRequiresCommentRule(),
    ]

    violations: list[Violation] = []
    for file_ctx in java_files:
        for rule in rules:
            found = list(rule.check(file_ctx, project_ctx))
            if len(found) == 0:
                continue
            violations.extend(found)

    violations.extend(_check_vietnamese_messages(root))

    _write_report(root, violations)
    _print_summary(violations)

    has_error = any(v.severity == SEVERITY_ERROR for v in violations)
    if has_error:
        return 1
    if args.strict and len(violations) > 0:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
