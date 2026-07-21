# Перед проверкой реальной регистрации

Архивы Hussle намеренно не содержат ваши Supabase credentials. Поэтому после распаковки новой Candidate Build необходимо один раз перенести локальный файл из рабочей v0.12.12:

1. Найдите в предыдущей рабочей папке `Configs/Secrets.xcconfig`.
2. Скопируйте его в `Configs` этой сборки рядом с `Secrets.xcconfig.example`.
3. В Terminal, находясь в корне новой сборки, выполните:
   `./Scripts/check_local_config.sh`
4. Должно появиться: `PASS: local Supabase configuration is present and valid.`
5. Затем выполните `xcodegen generate`, откройте новый `Hussle.xcodeproj`, сделайте Clean Build Folder и Build.

Не копируйте Secret key или service_role key. В клиенте используется только Publishable key.
