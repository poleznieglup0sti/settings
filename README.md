# Настройка работы с git

## Первоначальная настройка git
> git config --global user.name "MAV" //Ваше имя <br />
> git config --global user.email "johndoe@example.com" //Ваш e-mail <br />
> git config --global core.editor nano //Текcтовый редактор для git <br />
> git config --global merge.tool vimdiff //Утилита сравнения <br />
> git config --list //Проверка всех настроек <br />

## Настройка SSH-авторизации
> ssh-keygen -t rsa -C "your_email@example.com"
