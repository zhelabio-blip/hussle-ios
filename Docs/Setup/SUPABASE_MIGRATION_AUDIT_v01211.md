# Hussle Supabase migration audit — v0.12.11

## Почему предыдущий путь ломался

1. Первая схема не присвоила вычисленному расстоянию alias `distance_km`.
2. Скрипт состоял из множества отдельных команд без общей транзакции, поэтому часть объектов оставалась после ошибки.
3. Повторный запуск сталкивался с уже существующими enum types и policies.
4. Cleanup пытался удалять строки из системных Storage-таблиц. Supabase запрещает это, чтобы не создавать осиротевшие файлы.
5. Последующие миграции зависели от частично применённого состояния и содержали повторные определения policies/types.

## Что изменено

- Восемь последовательных файлов заменены одним согласованным bootstrap.
- Bootstrap обёрнут в `BEGIN … COMMIT`: при ошибке его собственные изменения откатываются.
- Cleanup удаляет только объекты Hussle в `public`, Auth trigger и известные RLS policies.
- В bootstrap нет `DELETE FROM storage.objects` и `DELETE FROM storage.buckets`.
- Storage buckets создаются через Dashboard, а доступ задаётся SQL policies.
- `discover_dogs` вычисляет `distance_km` в CTE и сортирует по существующему alias.
- Конечная схема сразу включает conversations, notifications, moderation и safety functions.

## Проверки

- PostgreSQL AST parsing через `pglast`: успешно, 164 statements.
- Проверено наличие `BEGIN` и `COMMIT`.
- Проверено отсутствие прямых DELETE/UPDATE/INSERT операций над `storage.objects` и `storage.buckets`.
- Проверены определения RPC, вызываемых iOS-клиентом.
- Проверены имена Storage buckets и policies.

## Ограничение

Файл синтаксически и структурно проверен вне Supabase. Окончательный статус `database-applied` появляется только после успешного Run в вашем реальном Supabase project.
