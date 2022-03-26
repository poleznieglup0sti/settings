# Настройка работы с git

## Первоначальная настройка git
git config --global user.name "John Doe" //Ваше имя
git config --global user.email "johndoe@example.com" //Ваш e-mail
git config --global core.editor nano //Текcтовый редактор для git
git config --global merge.tool vimdiff //Утилита сравнения
git config --list //Проверка всех настроек

## Настройка SSH-авторизации
ssh-keygen -t rsa -C "your_email@example.com"
