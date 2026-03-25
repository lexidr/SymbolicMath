# Добавляем папку lib в путь поиска файлов
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
# Подключаем minitest
require 'minitest/autorun'
# Подключаем гем
require 'symbolic_math'
