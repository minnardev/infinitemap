#!/bin/sh

#
# Copyright © 2015-2021 Gradle, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

app_name="Gradle"

# Прогресс-бар Gradle для Unix
# Добавляет поддержку цветного вывода в терминале
CLI_COLOR=""
if [ -t 1 ]; then
    CLI_COLOR="1"
fi

# Циклические ссылки на себя
if [ -n "$GRADLE_HOME" ] ; then
    if [ -x "$GRADLE_HOME/bin/gradle" ] ; then
        exec "$GRADLE_HOME/bin/gradle" "$@"
    else
        echo "WARNING: В переменной окружения GRADLE_HOME указан неверный путь."
    fi
fi

# Определение корня проекта (каталог, в котором находится gradlew)
if [ -n "$PROJECT_DIR" ] ; then
    if [ -x "$PROJECT_DIR/gradlew" ] ; then
        exec "$PROJECT_DIR/gradlew" "$@"
    else
        echo "WARNING: В переменной окружения PROJECT_DIR указан неверный путь."
    fi
fi

# Если PATH содержит gradle, используем его
gradle_cmd_path="`type -p gradle 2>/dev/null`"

if [ -n "$gradle_cmd_path" ] ; then
    exec "$gradle_cmd_path" "$@"
fi

# Определение каталога, в котором находится gradlew
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
APP_NAME="Gradle"
APP_HOME="$SCRIPT_DIR"

# Добавление JVM-опций здесь
DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'

# Поиск Java
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME установлен в неверное значение: $JAVA_HOME.
Пожалуйста, установите переменную окружения JAVA_HOME на корректный путь."
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME не установлена.
Установите переменную окружения JAVA_HOME на корректный путь."
fi

# Поиск JAR-файла обёртки
if [ -n "$GRADLE_OPTS" ] ; then
    DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS $GRADLE_OPTS"
fi

# Для совместимости
if [ -n "$JAVA_OPTS" ] ; then
    DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS $JAVA_OPTS"
fi

# Создание каталога для кэша
GRADLE_USER_HOME="${GRADLE_USER_HOME:-$HOME/.gradle}"
WRAPPER_JAR="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"
WRAPPER_PROPS="$APP_HOME/gradle/wrapper/gradle-wrapper.properties"

if [ ! -f "$WRAPPER_JAR" ] ; then
    echo "WARNING: gradle-wrapper.jar не найден. Пожалуйста, убедитесь, что он существует."
    exit 1
fi

# Вывод справки
help () {
    echo "Usage: $0 [option...] task..."
    echo
    echo "  --help, -h            Shows this help message."
    echo
    echo "  --version, -v         Prints version info."
    echo
    echo "  --stacktrace, -s      Prints stacktrace for exceptions."
    echo
    echo "  --info, -i            Sets log level to INFO."
    echo
    echo "  --debug, -d           Sets log level to DEBUG."
    echo
    echo "  --quiet, -q           Sets log level to WARN."
    echo
    echo "  --no-daemon, -N       Do not use the Gradle daemon."
    echo
    echo "  --offline, -o         Execute build without network access."
    echo
    echo "  --project-dir, -p     Specify the project dir."
    echo
    echo "  --gradle-user-home    Specify the Gradle user home."
    echo
    echo "  --configuration-file  Specify the gradle configuration file."
    echo
    echo "  --stop                Stops the Gradle daemon."
    echo
    echo "  --max-workers, -m     Set the maximum number of workers."
    echo
    echo "  --parallel            Build projects in parallel."
    echo
    echo "  --configure-on-demand Only configure projects that are required for the build."
    echo
    echo "  --build-cache, -b     Use build cache."
    echo
    echo "  --no-rebuild          Do not rebuild project dependencies."
    echo
    echo "  --continuous, -ct     Continuous build."
    echo
    echo "  --rerun-tasks, -i     Do not skip up-to-date tasks."
    echo
    echo "  --watch-fs, -w        Watch file system for changes."
    echo
    echo "  --dry-run, -n         Executes tasks without executing actions."
    echo
    echo "  --write-locks, -wl    Write dependency locks."
    echo
    echo "  --update-locks, -ul   Update dependency locks."
}

# Парсинг аргументов
while [ $# -gt 0 ] ; do
    case "$1" in
        --help|-h)
            help
            exit 0
            ;;
        --version|-v)
            exec "$JAVACMD" "$DEFAULT_JVM_OPTS" "$@"
            ;;
        *)
            break
            ;;
    esac
done

# Выполнение Gradle через JAR-файл обёртки
exec "$JAVACMD" "$DEFAULT_JVM_OPTS" \
    -classpath "$WRAPPER_JAR" \
    org.gradle.wrapper.GradleWrapperMain \
    "$@"
