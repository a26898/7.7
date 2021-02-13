buildscr = 2
downlurl := "https://github.com/a26898/7.7/blob/main/Demo_7_4%20.exe?raw=true"
downllen := "https://raw.githubusercontent.com/a26898/7.7/main/verlen.ini"



Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM = 3
    Else
        BOM = 0

    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "UInt", &UniBuf, "Int", UniSize)

    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Int", 0, "Int", 0
                    , "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Str", AnsiString, "Int", AnsiSize
                    , "Int", 0, "Int", 0)
    Return AnsiString
}
WM_HELP(){
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}

OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs

SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verlen.ini
IniRead, buildupd, %a_temp%/verlen.ini, UPD, build
if buildupd =
{
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
    sleep, 2000
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
    {
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
        IfMsgBox OK
        {
            put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
            URLDownloadToFile, %downlurl%, %a_temp%/updt.exe
            sleep, 1000
            run, %a_temp%/updt.exe
            exitapp
        }
    }
}
SplashTextoff


Gui, show, center h570 w500,
Gui, Font, S10   Bold
Gui, Add, Picture, x0 y30 w1220 h700, C:\Program Files (x86)\МЗ\AHK_1.jpg
Gui, Add, Tab2, x0 y0 w1220 h25 cFF2400  +BackgroundTrans, Введите данные

Gui, Add, DropDownList,  x210 y60 vJWI,  Интерн|Фельдшер|Врач-Участковый|Врач-Терапевт|Врач-Хирург|Парамедик|Старший Специалист|Заведующий Отделением|Заместитель Главного Врача|Главный врач
Gui, Add, Edit, vTAG, 
Gui, Add, Edit, vName,
Gui, Add, Edit, vSurname,
Gui, Add, Edit, vMiddle_Name,
Gui, Add, DropDownList, vBol, ОКБ. г.Мирный|ЦГБ г.Невский|ЦГБ г.Приволжск
Gui, Add, DropDownList, vFloor, а
Gui, Add, DropDownList, vFemale, ла
Gui, Add, Edit, vDelay,
Gui, Add, Edit, vFast,
Gui, Add, DropDownList, vPartner, Напарник:
Gui, Add, Edit, vPartner_Name_surname,
Gui, Add, Button, y430  default xm, Применить


Gui, Add, Text, x10 y65  w300 h20 cFF2400  +BackgroundTrans , Звание:_________________
Gui, Add, Text, x10 y95  w300 h20 cFF2400  +BackgroundTrans , Тег: ___________________
Gui, Add, Text, x10 y127 w300 h20 cFF2400 +BackgroundTrans , Имя: ____________________
Gui, Add, Text, x10 y157 w300 h20 cFF2400 +BackgroundTrans , Фамилия:_______________
Gui, Add, Text, x10 y187 w300 h20 cFF2400 +BackgroundTrans , Отчество: ______________
Gui, Add, Text, x10 y217 w300 h20 cFF2400 +BackgroundTrans , Название больницы: _____
Gui, Add, Text, x10 y247 w300 h20 cFF2400 +BackgroundTrans , Пол: ___________________
Gui, Add, Text, x10 y277 w300 h20 cFF2400 +BackgroundTrans , Пол: ___________________
Gui, Add, Text, x10 y307 w300 h20 cFF2400 +BackgroundTrans , Задержка:______________
Gui, Add, Text, x10 y337 w300 h20 cFF2400 +BackgroundTrans , Пост:___________________
Gui, Add, Text, x10 y367 w300 h20 cFF2400 +BackgroundTrans , Напарник:_______________
Gui, Add, Text, x10 y397 w300 h20 cFF2400 +BackgroundTrans , Имя Фамилия напарника:_

Gui, Add, Text, x10 y480 w1220 h20 c000000   +BackgroundTrans,   Если пол женский, выберите "а и ла".
Gui, Add, Text, x10 y500 w1220 h20 c000000   +BackgroundTrans,   Если пол мужской, ничего не выбирайте.
Gui, Add, Text, x10 y520 w1220 h20 c000000   +BackgroundTrans,   Задержка рекомендуется 2000/3000.
Gui, Add, Text, x10 y540 w1220 h20 c000000   +BackgroundTrans,   Если у вас есть напарник, заполните поля.




;--------------------------------------------------------------------------------

!1:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Здравствуйте, я лечащий врач, %Name% %Surname%.{enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На груди висит бейдж: "%Bol%, %JWI% | %TAG% | %Surname% %Name% %Middle_Name%". {enter}
SendInput, {F6}
sleep %delay%
SendInput, Чем-то могу помочь? {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter}
return

!2:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Хорошо, пройдёмте за мной .{enter}
return


!3:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Хорошо, сейчас я осмотрю вас. {enter}
SendInput, {F6}
sleep %delay%
SendInput,  /me осмотрел%floor% пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, / do Пациент осмотрен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подумав, сделал%floor% соответствующие выводы о состоянии пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Выводы сделаны. {enter}
return


!4:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do В грудном кармане бланк выписки и ручка. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% бланк, ручку и записал%floor% диагноз с лекарством {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Бланк выписки заполнен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, / do На плече висит мед.сумка с нашивкой "%Bol%".{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% сумку, после чего достал%floor% из неё нужное лекарство {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Лекарство и бланк в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me передал%floor% лекарство и бланк пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Лекарство и бланк переданы. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /helpmed{space}
return


!5:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,Всего доброго, не болейте) {enter}
return


!6:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Хорошо, вы можете пройти лечение бесплатно в стационаре нашей больницы, проходите в палату. {enter}
return


!7:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На груди висит сумка с надписью "%Bol%".   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв сумку, резким движением взял%floor% миг и использовал таблетку по назначению  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Таблетка подействовала.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /helpmed{space}
return



!8:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /do Рация от мегафона на панели автомобиля. {enter}
SendInput, {F6}
sleep 250
SendInput, /me снял%floor% рацию с панели и сказал%floor% в неё {enter}
SendInput, {F6}
sleep 250
SendInput, /s [Мегафон] Водители{!} Уступаем дорогу карете скорой помощи{!} {enter}
return

!9:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 500
SendInput, /me взглянул%floor% на часы "%Bol% с фирменной гравировкой В моем сердце" {Enter}
m = 60
m -= %A_Min%
s = 60
s -= %A_Sec%
sleep 500
SendInput, {F6}
sleep 500
SendInput, /do Время на часах: %A_Hour%:%A_Min%:%A_Sec% | Дата : %A_DD%.%A_MM%.%A_YYYY% | .{enter}
SendInput, {F6}
sleep 250
SendInput, /paytime {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}
Return

!0:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /do На поясе висит рация. {enter}
SendInput, {F6}
sleep 250
SendInput /me сняв рацию начал%floor% что то говорить в нее {enter}
return


!Numpad1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /me повесил%floor% рацию обратно на пояс {enter}
SendInput, {F6}
sleep 250
SendInput /do Рация на поясе. {enter}
return

!Numpad2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 521
SendInput, /r [%TAG%] Разрешите, отехать на 15 минут по личным делам? {enter}
return

!Numpad3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /r [%TAG%]:Разрешаю. {enter}
return

!Numpad4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /r [%TAG%]:Отказано. {enter}
return

!Numpad5::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me  взял%floor% мед.диплом {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Мед.диплом в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% изучение  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Мед.диплом изучен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me передал%floor% мед.диплом человеку напротив {enter}
return



!Numpad6::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% паспорт из рук человека  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Паспорт в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me раскрыл%floor% паспорт, затем начал его изучение  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Паспорт изучен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% паспорт, затем передал его владельцу  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

!Numpad7::
SendInput, {F6}
sleep  %delay%
SendInput, Дайте, пожалуйста, свою медицинскую карту.  {enter}
return

!Numpad8::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% медицинскую карту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Медицинская карта в руках.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% медицинскую карту и изучил%floor%  её{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Медицинская карта изучена.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% штамп в графе годности {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Штамп поставлен.   {enter}
SendInput, {F6}
sleep 250
SendInput, /me отдал%floor% медицинскую карту человеку напротив  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /goden   {space}
return


!Numpad9::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, /r [%TAG%]:Взял%floor% перерыв{!}  {enter}
return

!Numpad0::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, /r [%TAG%]: Сдал%floor% смену{!} {enter}
return

:?:/Пост::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%]  Разрешите, выехать на пост:[%Fast%]? %Partner%%Partner_Name_surname% {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Выехал::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%]  Выехал%floor% на пост:[%Fast%] %Partner%%Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Дежурство::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%]  Пост [%Fast%].%Partner%%Partner_Name_surname% Состояние стабильное, вылечено: [ {space}
return

:?:/Окончил::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Окончил%floor% дежурство поста [%Fast%]. Еду на базу %Partner%%Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Город::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Разрешите, выехать на патрулирование города. %Partner%%Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Патрулирование::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Выехал%floor% на патрулирование города %Partner% %Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Патрул::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Патрулирование города. %Partner%%Partner_Name_surname% Состояние стабильное, вылечено:[ {space}
return

:?:/Еду::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Окончил%floor% патрулирование города. Еду на базу %Partner%%Partner_Name_surname%.  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Принял::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Принял%floor% %Partner%%Partner_Name_surname% Вызов: {space}
return

:?:/Место::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Прибыл%floor% %Partner%%Partner_Name_surname% Вызов: {space}
return

:?:/Ложный::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] %Partner%%Partner_Name_surname% Ложный вызов:    {space}
return

:?:/Госпитализация::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Госпитализация%Partner%%Partner_Name_surname% Вызов:  {space}
return

:?:/Помощь::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Помощь оказана на месте %Partner%%Partner_Name_surname% Вызов: {space}
return

:?:/ВЦГБ::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Госпитализирован %Partner%%Partner_Name_surname% Вызов:  {space}
return

:?:/ЦГБ::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Сдал%floor% АСМП %Partner%%Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Карта_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
Sendinput, /me взял%floor% мед.карту  {Enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Мед. карта в руках.  {Enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me положил%floor%  мед.карту на стол  {Enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Мед. карта на столе.  {Enter}
return

:?:/Карта_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput,  {F6}
Sleep 100
Sendinput, /do На столе лежит мед.карта и ручка.         {Enter}
SendInput,  {F6}
sleep  %delay%
Sendinput, /me взял%floor%  мед.карту и ручку         {Enter}
SendInput,  {F6}
sleep  %delay%
Sendinput, /do Мед.карта и ручка в руках.         {Enter}
SendInput,  {F6}
sleep  %delay%
Sendinput, /me заполнил%floor%  мед.карту       {Enter}
SendInput,  {F6}
sleep  %delay%
Sendinput, /do Мед.карта заполнена.         {Enter}
SendInput,  {F6}
sleep  %delay%
Sendinput, /me отдал%floor%  мед.карту          {Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/КПК::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Звук КПК: "Внимание{!} Поступление вызова{!}". {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor%  из кармана КПК, запустил%floor%  его {enter}
SendInput, {F6}
sleep 250
SendInput, /do КПК запущен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открывает базу поступивших вызовов {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Данные на экране. {enter}
SendInput, {F6}
sleep 250
SendInput, /me фиксирует последние данные GPS пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Данные зафиксированы. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor%  и убрал%floor%  КПК в карман  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/АСМП_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor%  на кнопку для опускания каталки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Каталка опущена.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно приподнял%floor%  человека и переложил%floor%  на каталку   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Человек на каталке.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor%  на кнопку для поднятия каталки   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Каталка поднята.   {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/АСМП_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Рация на поясе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сняв рацию с пояса, вызвал%floor%  через неё дежурного врача {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Дежурный врач подошёл к АСМП.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me передал%floor%  каталку с пациентом дежурному врачу  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Дежурный врач увез каталку в приемное отделение.  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/АСМП_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Каталка с пострадавшим в приёмном отделении. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me повез%female% каталку в операционную {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Каталка с пострадавшим у операционного стола. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% на кнопку для опускания каталки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Каталка опущена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно приподнял%floor% человека и переложил%floor% на кушетку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Человек на кушетке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сложил%floor% и убрал%floor% каталку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Каталка убрана. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/ЭКГ_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Электрокардиограф стоит у стены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подкатил%floor% электрокардиограф к пациенту {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электрокардиограф около пациента.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% медицинский спирт со стола и открыл%floor% его {enter}
SendInput, {F6}
sleep 250
SendInput, /do Открытый спирт в руке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обезжирил%floor% электроды на приборе и поставил%floor% спирт на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Места крепления электродов обезжирены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гель "Синтакт" лежит в шкафу.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% гель Синтакт и смазал электроды  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электроды смазаны.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% гель на стол {enter}
SendInput, {F6}
sleep 250
SendInput, /do Гель на столе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% обработанные электроды и прикрепил%floor% их к телу пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электроды закреплены.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подключил%floor% электроды к электрокардиографу и включил%floor% его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электрокардиограф включён.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me запустил%floor% прибор  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электрокардиограф записывает график ЭКГ.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me остановил%floor% запись и выключил прибор {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Прибор напечатал график. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% электроды с тела пациента и положил%floor%  их на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электроды на столе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me изучил%floor% график и поставил%floor% диагноз {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do График ЭКГ изучен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% проблемы с сердцем {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/ЭКГ_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,   У Вас проблемы с сердцем.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Обратитесь к своему врачу-терапевту, он вам выпишет направление.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Принимайте "Кардиомагнил", 1 таблетку под язык раз в неделю для профилактики. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Одну пачку этого лекарства я выпишу вам прямо сейчас. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Стоит он 450 рублей, Вы согласны? {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/ЭКГ_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Не волнуйтесь, с сердцем у Вас всё хорошо.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput,   Принимайте "Кардиомагнил", 1 таблетку под язык раз в неделю для профилактики.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Одну пачку этого лекарства я выпишу вам прямо сейчас. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Стоит он 450 рублей, Вы согласны? {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Шприц::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Препараты лежат на стеллаже.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% ампулу  и шприц {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Ампула и шприц в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me набрал%floor% в шприц содержимое ампулы  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Препарат в шприце.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me протер%female% место укола спиртовой салфеткой {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Место укола протерто.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me медленно вводит препарат в вену пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Препарат введен.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me приложил%floor% вату к месту укола {enter}   
SendInput, {F6}
sleep  %delay%
SendInput, Ватку держите 5 минут, потом выбросите в урну. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Вакцинация::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  /do На столе лежит всё необходимое для вакцинации.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ватный диск и спирт {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me промочил%floor% ватный диск в спирте {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Диск в спирте. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me продезинфицировал%floor% место ввода вакцины  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Место продезинфицировано. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выкинул%floor% ватный диск в урну {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% одноразовую иглу и новый одноразовый шприц {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Одноразовая игла и шприц в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% иглу на шприц  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% пробирку с вакциной   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пробирка в руках.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наполнил%floor% шприц вакциной  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Шприц наполнен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me убрал%floor% лишний воздух из шприца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Воздух убран из шприца. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% иглу в дельтовидную мышцу пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Игла в мышце. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% вакцину {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вакцина введена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вынул%floor% иглу {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me придавил%floor% место прокола заранее приготовленной ваткой в спирте {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Держите ватку так не менее 5-ти минут. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Зонд_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежит урогенитальный зонд. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% урогенитальный зонд со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас будет немного неприятно, потерпите {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% урогенитальный зонд в уретру пациента {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do Урогенитальный зонд в уретре. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% пробу с внутренней стенки уретры {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Проба взята. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% урогенитальный зонд из уретры человека {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Урогенитальный зонд в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе стоит микробиологический анализатор. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me засунул%floor% урогенитальный зонд в анализатор {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Урогенитальный зонд в анализаторе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% микробиологический анализатор {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Микробиологический анализатор включен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me запустил%floor% процесс диагностики мазка  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% патогенные бактерии {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/Зонд_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, К сожалению, у вас имеется шанс заболевания венерическим заболеванием. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Как можно скорей обратитесь к своему лечащему врачу{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Можете одеваться и спускаться вниз. {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return

:?:/Зонд_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Всё хорошо. Вы здоровы. Можете одеваться. {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return


:?:/Кровь::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Рядом стоит аппарат наркоза. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me подключил%floor% апппрпт наркоза к пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат включен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пациент уснул.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рядом стоит стол.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки надеты.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола вату и Йодонат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата и йодонат в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату йодонатом  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата смочена.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% обрабатывать область груди {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Операционное поле обработано.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит скальпель.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Скальпель в руках.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% надрез в области грудной клетки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Надрез сделан.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me делает разрезы мышц и жира {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Разрезы сделаны. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обнаружил%floor% легие и кровеносные сосуды  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обнаружил%floor% повреждённый сосуд {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нитки лежат на столе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% нитки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нитки в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% перекрывать поврежденный сосуд нитками  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Сосуд перевязан. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит катетер. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% катетер в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Катетер в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% выкачивать кровь из полости плевры {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кровь выкачена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат игла и нитки.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% нитки и иглу {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нитки и игла в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начинает зашивать разрезанные мышцы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Шов наложен на мышцы. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me зашивает кожу на груди {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит раствор хлорида натрия и вата.   {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ватку и раствор {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата и раствор в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату раствором хлорида натрия {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата смочена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обрабатывает швы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Швы обработаны. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Хирургический пластырь лежит на столе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  хирургический пластырь в руки{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пластырь в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me накладывает хирургический пластырь на швы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Хирургический пластырь наложен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отключил%floor%  аппарат наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат отключен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отсоеденил%floor%  аппарат наркоза от пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат отсоеденён. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Рентген_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Присаживайтесь. Кладите ногу/руку вот сюда и не двигайтесь. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включает рентген аппарат  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рентген аппарат включён и готов к работе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me фиксирует сустав в нужном положении  {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Сустав зафиксирован. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Не двигайтесь.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выполнил снимок  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Снимок выполнен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключает рентген аппарат  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат выключен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достав снимок из аппарата, рассматривает его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%  перелом на снимке  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Снимок изучен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me откладывает снимок на тумбочку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Снимок на тумбочке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Рентген_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, У Вас перелом. Необходимо наложить лангетку. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  лангетку со стола и наложил%floor%  на место перелома пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Лангетка наложена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрепил%floor%  лангетку на месте перелома {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Лангетка плотно закреплена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Приходите через неделю на повторный осмотр{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Рентген_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, У вас перелом. Я наложу Вам гипс. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Стол и стул для перевязки у окна. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Пересядьте вот сюда.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me указал%floor% на стул {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Мед.шкаф и раковина у стены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв шкаф, достал%floor% тазик и гипс  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Тазик и гипс в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me положив гипс на раковину и открыв кран, набирает воду в тазик {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Тазик наполнен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыв кран и поставив тазик на пол, погрузил%floor% в него гипс для размачивания {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гипс размочен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достаёт гипс из тазика  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гипс в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me накладывает гипс  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гипс наложен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Подождём немного, пока застынет. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me щупает гипс {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гипс застыл.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достав бинты, накладывает их поверх гипса  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Бинты наложены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Готово. Гипс не мочите две недели. Через две недели жду Вас на осмотр.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Если будет болеть, то пейте обезболивающее. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Рентген_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  У вас сильный ушиб. Я наложу вам эластичный бинт. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Препараты лежат на стеллаже. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стеллажа гель {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гель в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв гель, смазывает место ушиба  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Ушиб обработан.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыв гель, кладёт его на тумбочку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гель на тумбочке.  {enter}
SendInput, {F6}
sleep 250
SendInput, Вот гель, заберёте его потом.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Мед. сумка висит на плече.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достав%female% из мед.сумки эластичный бинт, накладывает его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Бинт наложен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Бинт носите одну неделю. Гелем мажьте в течение недели каждый день: утром и вечером.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, Перед нанесением геля, снимите бинт, затем нанесите гель, {enter}
SendInput, {F6}
sleep  %delay%
SendInput, подождите 3 минуты и снова забинтуйте. {enter}
return

:?:/Донор::
SendInput, {F6}
sleep 250
SendInput, /me взял%floor% донора за руку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Держит донора за руку. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me берет клеенчатый валик {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Клеёнчатый валик в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подкладывает клеёнчатый валик под локоть донора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Клеёнчатый валик под локтём. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me фиксирует руку донора ладонью кверху {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рука зафиксирована. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me берет пробирку и иглу с переходником с мед.лотка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пробирка и игла в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me присоединяет пробирку к игле {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пробирка подсоединена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me кладет собранную систему в мед.лоток {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Система лежит в мед.лотке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me берет жгут и спиртовую салфетку с мед.лотка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Салфетка и жгут в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обрабатывает спиртовой салфеткой область локтевого сгиба на руке донора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Область обработана. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me затягивает жгут на плече донора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Жгут затянут. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Сожмите, пожалуйста кулак{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me берет из мед.лотка собранную систему {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Система в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вводит иглу в вену {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Игла в вене. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снимает жгут с плеча донора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Жгут снят. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Можете разжать руку{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me медленно оттягивает поршень шприца вверх {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пробирка наполнилась кровью. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me прикладывает спиртовую салфетку к месту прокола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Салфетка приложена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выводит иглу из вены {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Игла выведена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отсоединяет пробирку от иглы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пробирка отсоеденина. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе стоит держатель для пробирок. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me помещает пробирку в держатель для пробирок {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пробирка в держателе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me кладет использованную иглу в мед.лоток {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Игла в мед.лотке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Спасибо за донорство{!} {enter}
return

:?:/Мрт::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте, сейчас вам необходимо лечь на выдвижной стол МРТ. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включает аппарат МРТ  {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Аппарат включен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включает сканирование {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Идет сканирование... {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отключает сканирование {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Сканирование отключено. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do На столе лежит блокнотик. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me записал результат МРТ в блокнотик {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Запись в блокнотике. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Все, можете одеваться, результаты придут в течении недели. {enter}
return

:?:/Нож::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me осмотрел%floor% рану больного {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола давящую повязку и наложил%floor% её сверху ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кровотечение остановлено. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола перекись водорода и ватку и обработал%floor% место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Место ранения обработано. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола шприц с обезбаливающим и сделал%floor% укол  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Обезболивающие подействовало. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола иголку с нитью и продел%floor% её  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Игла с нитью в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно зашил%floor% рану и обрезал%floor% концы нити {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана зашита.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зелёнку со стола и обработал%floor% место ранения  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана обработана.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% бинт со стола и перевязал%floor% место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана перевязана. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% давящую повязку и положил%floor% её на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Повязка на столе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Нос::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
Sendinput, /do Медицинская сумка на правом плече.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me снял%floor% сумку с плеча и поставил на землю  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Сумка снята.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me открыл%floor% сумку  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Сумка открыта.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do В правом отделении сумки лежит вата и бутылка с перекисью водорода.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me достал%floor% перекись водорода и вату из сумки  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Перекись водорода и вата в руках.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me смочил%floor% вату перекисью водорода  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Вата смочена перекисью водорода.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me поднес%female% ватку к ноздре пострадавшего  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Ватка у ноздри.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput,  /me ввел%floor% ватку в ноздрю пострадавшего {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Ватка в ноздре пострадавшего.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput,  Ходите так в течение 5-10 минут.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Желудк::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Около окна стоит стол. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do На столе лежит зонд и раствор чистой воды.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зонд и раствор воды  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начинает промывание желудка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Промывание желудка...  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Промывание желудка пациента выполнено. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вытащил%floor% трубку зонда и убрал%floor% инструменты {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Всего доброго, не болейте{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Аппендикс::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me одел%floor% стерильные перчатки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки надеты.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола шприц с обезбаливающим и сделал%floor% укол {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Обезбаливающее подействовало. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Около койки стоит аппарат для наркоза.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кислородную маску {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кислородная маска в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me надел%floor% маску на пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Маска на пациенте.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат работает.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель со стола и сделал%floor% надрез {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Надрез сделан.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выделил%floor% орган аппендикса щипцами и удалил%floor% его скальпелем {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Орган аппендикса удален. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обработал полость {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Полость обработана. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола иголку с нитью и продел%floor% её {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Игла с нитью в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно зашил рану и обрезал концы нити {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана зашита. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  зелёнку со стола и обработал%floor%  место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана обработана. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  бинт со стола и перевязал%floor%  место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана перевязана. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат для наркоза выключен. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me снял%floor% маску с пациента {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, Отдыхайте, и соблюдайте диету всего доброго) {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Грудь::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /d﻿o У стены стоит шкаф. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% шкаф {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На верхней полке лежат перчатки. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки с полки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки в руке.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки надеты на руки.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% шкаф  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шкаф закрыт. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Около койки стоит стол. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% маркер со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Маркер в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отметил%floor% места для надрезов  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Под грудью нарисованы линии. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me положил%floor% маркер на стол  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Маркер на столе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% шприц с обезболивающим со стола {enter}
sleep  %delay%
SendInput, {F6}
sleep  %delay%
SendInput, /do Шприц в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вколол%floor% обезболивающее в плечо пациента{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Около койки стоит аппарат для наркоза. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кислородную маску {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кислородная маска в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% маску на пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Маска на пациенте.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат работает. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Скальпель в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% надрезы по линиям {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Под грудью небольшие надрезы. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат силиконовые импланты. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% силиконовые импланты {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Импланты нужного размера в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно вставил%floor% импланты в надрезы﻿ {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Грудь увеличилась в размере. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола дезинфицирующие тампоны {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Тампоны в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обработал%floor% места надрезов {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Область под грудью чистая.﻿ {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% иголку с нитью со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Иголка с нитью в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me зашил%floor% надрезы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Под грудью швы. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ножницы со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Ножницы в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обрезал%floor% нить﻿ {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Под грудью аккуратные швы. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола обработанные зеленкой ватные тампоны {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Ватные тампоны в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обработал%floor% швы зеленкой {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Под грудью швы с зеленкой.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% стерильную эластичную повязку со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Повязка в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me перевязал%floor% пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат для наркоза выключен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% маску с пациента﻿ {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Маска снята.﻿﻿ {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Прибор_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}
sleep  %delay%
Sendinput, /do В углу комнаты стоит аппарат для компьютерной томографии.  {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput,  Ложитесь, пожалуйста на стол.  {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput,  Не двигайтесь{!}   {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me задвинул%floor% стол в прибор   {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /do Стол с пациентом в приборе.   {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me включил%floor% сканирование на аппарате   {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /do Аппарат отсканировал пациента.    {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me выключил%floor% сканирование на аппарате    {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /do Снимок на мониторе.     {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me изучает снимок     {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /do Анализ снимка...     {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me изучил%floor% снимок     {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /do Снимок изучен.     {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /try обнаружил%floor% на снимке отклонения     {Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Прибор_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}
sleep  %delay%
Sendinput, /do На снимке обнаружены отклонения.  {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, Есть небольшие отклонения. Но ничего страшного.  {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, Вам необходимо придерживаться режима сна и специальной диеты.  {Enter}
return


:?:/Прибор_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}
sleep  %delay%
Sendinput, /do На снимке не обнаружено отклонений. {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput,  Все хорошо. Ваш мозг не поврежден{!}  {Enter}
return

:?:/УЗИ::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% гель со стола и открыл%floor% его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Открытый гель в руке. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me выдавил%floor% гель на живот пациента и растёр%female% его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Зона для сканирования обработана гелем. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% тюбик с гелем и поставил%floor% на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Возле койки стоит аппарат для УЗИ. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат для УЗИ и взял%floor% датчик с аппарата {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Датчик УЗИ в руке. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me поводил%floor% датчиком по животу и изучил%floor% результаты {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Результаты УЗИ на мониторе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закончил%floor% осмотр и поставил%floor% датчик на место {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Датчик УЗИ на аппарате. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял салфетки со стола и передал их пациенту {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Пуля::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me осмотрел%floor% ранение {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас вытащим пулю. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола стерильные перчатки и надел%floor% их {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола перекись водорода и ватку  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Перекись и ватка в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обрабатал%floor% кожу вокруг ранения  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана обработана. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола шприц с обезболивающим и сделал%floor% укол  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Обезболивающие подействовало.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола щипцы и аккуратно достал%floor% пулю  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пуля извлечена.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола иголку с нитью и продел%floor% её {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Игла с нитью в руке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно зашил%floor% рану и обрезал%floor% концы нити {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана зашита.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зелёнку со стола и обработал %floor%место ранения  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана обработана. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% бинт со стола и перевязал%floor% место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рана перевязана. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Аппарат::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Раздевайтесь по пояс. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Вот подходите к аппарату и грудью прижмитесь к синему квадрату. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Так хорошо, приготовьтесь к снимку. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат для флюорографии у стены. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат включен и готов к снимку. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Глубоко вдохните и не дышите.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% снимок  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Выдыхаем, можете одеваться. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат выключен.  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return



:?:/Чувства_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me поднес%female% руку к сонной артерии пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me пытается нащупать пульс  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% пульс на сонной артерии {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}
return

:?:/Чувства_2::
SendInput, {F6}
sleep  %delay%
SendInput, /do Медицинская сумка на правом плече. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% сумку с плеча и поставил%floor% на землю {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Сумка на земле. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me открыл%floor% сумку{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Сумка открыта. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do В правом отделении сумки лежит вата и бутылка нашатыря. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% нашатырь и вату из сумки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нашатырь и вата в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату нашатырем {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата смочена нашатырем.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me провел%floor% ватой около носа человека {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me убирает вату и нашатырный спирт в сумку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата и нашатырь в сумке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me закрыл%floor% сумку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Сумка закрыта. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me одел%floor% сумку на правое плечо {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Медицинская сумка на правом плече. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Чувства_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me запрокинул%floor% голову пациента{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Голова запрокинута.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% одежду в которую одет пациент  {enter}
SendInput, {F6}
sleep 250
SendInput, /do Одежда пациента снята.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% делать непрямой массаж сердца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% делать искусственное дыхание "рот-в-рот" пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поднес%female% руку к сонной артерии пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try нащупал%floor% пульс на сонной артерии  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Алкоголь_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас проверим Вас на алкогольное опьянение. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пломбированный алкотестер в руке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% на кнопку включения {enter}
SendInput, {F6}
sleep  %delay%
SendInput,/do Алкотестер включен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /mе поднёс%female% алкотестер ко рту гражданина  {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Дыхните в трубочку  {enter}
SendInput, {F6}
sleep  20000
SendInput, /me измеряет уровень алкоголя в крови {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /try обнаружил%floor% результат выше нормы на алкотестере  {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Результат получен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% алкотестер и заменил%floor% трубку на алкотестере  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Алкоголь_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput,  Количество алкоголя в вашем организме, просто зашкаливает. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Я бы вам посоветовал%floor% меньше пить и заботиться о своём здоровье.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Алкоголь_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput,  Всё хорошо, алкоголь не был найден в вашем организме. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Можете идти.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/ФКС_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте. Сейчас я проведу Вам колоноскопию. {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, Снимайте штаны, нижнее бельё, ложитесь спиной ко мне, ноги сгибайте в коленях. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат стерильные перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки надеты. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На стойке висит эндоскоп. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% эндоскоп со стойки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Эндоскоп в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе стоит смазка. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% смазку в руку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Смазка в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смазал%floor% эндоскоп смазкой {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Эндоскоп смазан. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% смазку на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Смазка на столе. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить эндоскоп в ректальное отверстие пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Эндоскоп в прямой кишке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% визуальный осмотр состояния прямой кишки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% отклонения {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вынимать эндоскоп из ректального отверстия пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Эндоскоп вынут. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor%  эндоскоп в аппарат для дезинфекции {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Эндоскоп в аппарате для дезинфекции. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/ФКС_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, К сожалению, у вас есть некоторые заболевания прямой кишки. Советую обратиться к врачу. {enter}
SendInput, {F6}
return

:?:/ФКС_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, К счастью, с Вашей прямой кишкой всё в порядке{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Можете одеваться и спускаться. {enter}
SendInput, {F6}
sleep 500
SendInput, /timestamp {enter} {F12}
return

:?:/Вши_1::
SendMessage, 0x50,, 0x4090409,, A 
SendInput, {F6}
sleep  %delay%
SendInput, /do В правом кармане одноразовые перчатки.    {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% из правого кармана перчатки   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки в руках.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me одел%floor% перчатки на руки   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки на руках.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Хорошо, сейчас я вас осмотрю.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me осматривает голову пациента   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% у человека вши   {enter}
return

:?:/Вши_2::
SendMessage, 0x50,, 0x4090409,, A 
SendInput, {F6}
sleep  %delay%
SendInput, У вас обнаружены вши{!} {enter}
return

:?:/Вши_3::
SendMessage, 0x50,, 0x4090409,, A 
SendInput, {F6}
sleep  %delay%
SendInput, У вас не обнаружено вшей, вы можете быть свободны.   {enter}
return

:?:/Открытый::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Итак, приступим. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do В углу стоит хирургический стол.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки надеты.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% жгут со стола и наложил%floor% его выше места перелома  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кровотечение остановлено.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% шприц с обезбаливающим со стола  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Шприц в руке.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% обезболивающее в ногу пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Обезбаливающее подействовало.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me проталкнул%floor% кость во внутрь  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кость на месте.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% иглу в руки, продел%floor% в неё нить {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нить продета.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me зашил%floor% ранение  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Ранение зашито.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отложил%floor% нить с иглой на стол   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нить с иглой на столе.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% бинты со стола и перевязал %floor%ранение  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Ранение перевязано. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% дрель со стола подключил%floor% её к розетке  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Дрель подключена.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% дрель и сделал%floor% тонкие прорезы сквозь ногу  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На ноге прорезы.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me продел%floor% в ногу спицы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Спицы продета.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наложил%floor% на каждую спицу вату с двух сторон, прижав пробкой  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата наложена.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Два кольца лежат на столе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кольца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кольца в руке{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% кольца и наложил%floor% их   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кольца на ноге.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% кольца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кольца зафиксированы.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат 3 палки.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% палки и продел%floor% их сквозь отверстия колец  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Палки зафиксирована.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наложил%floor% палки и зафиксировал%floor% их гайками  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Палки зафиксированы. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Компрессионно-дистракционный аппарат наложен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Ожоги::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
Sendinput, /do Медицинская сумка на плече. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me снял%floor% сумку с плеча и поставил%floor% на тумбочку {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Сумка на тумбочке. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me сунул%floor% руку в сумку {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Рука в сумке. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me нащупал%floor% стерильные перчатки и взял%floor% их в руку {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Перчатки в руке. {enter}
SendInput, {F6}
sleep  %delay% 
Sendinput, /me достал%floor% из стерильные перчатки из сумки {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Стерильные перчатки снаружи. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me надел%floor% перчатки на руки {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Перчатки на руках. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me осмотрел%floor% пациента {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Пациент осмотрен. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me освободил%floor% место ожога от одежды {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Одежда в стороне. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me сделал%floor% оценку площади и глубины ожога {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Бутылка с холодной чистой водой в сумке. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me взял%floor% бутылку с чистой водой в руку и вынул%floor% из сумки {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Бутылка в руке. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me открутил%floor% крышку на бутылке {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Бутылка открыта. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me вылил%floor% воду на место ожога {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Ожог охлаждён. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me достал%floor% из сумки шприц с обезболивающим {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Шприц в руке. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me смочил%floor% шприц спиртовым раствором ватный тампон {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Шприц смочен. {enter}
SendInput, {F6} 
sleep  %delay%
Sendinput, /me обработав место укола, вколол%floor% обезболивающее пациенту {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Обезболивающее подействовало. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me взглянул в сумку {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do В сумке балончик . {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me достал%floor% из сумки баллончик с надписью "Пантенол" {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Баллончик в руке. {enter}
SendInput, {F6}
sleep  %delay% 
Sendinput, /me разбрызгал%floor% спрей на область ожога {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Спрей покрыл область ожога. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me посмотрел%floor% а другой отдел сумки {enter}
SendInput, {F6} 
sleep  %delay%
Sendinput, /do В другом отделе лежит стерильная салфетка . {enter}
SendInput, {F6}
sleep  %delay% 
Sendinput, /me достал%floor% из сумки стерильную салфетку {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Салфетка в руке. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me прикрыл%floor% салфеткой ожог {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Ожог обработан. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Все, ваш ожог обработан. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Одевайтесь и можете идти. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Глисты_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6} 
sleep  %delay%
SendInput,  Здравствуйте, сейчас мы проведем вам биoрезoнансную диагнoстику на паразитoв. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput,  Ложитесь на кушетку. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do На плече висит медицинская сумка. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me открыл%floor% сумку, после чего достал%floor% биорезонансный прибор {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do Прибор в руке. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, Снимите штаны и нижнее бельё по колено. {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return


:?:/Глисты_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6} 
sleep  %delay%
SendInput,  Хорошо,теперь расслабьтесь. {enter}
SendInput, {F6} 
sleep  %delay% 
SendInput, /me вводит трубочку биорезонансново прибора в анальное отверстие пациента {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do Трубочка введена. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me включает прибор {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do Прибор включен. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me cканирует кишечник пациента {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /try обнаружил%floor% электромагнитные колебания паразитов  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return


:?:/Глисты_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6} 
sleep  %delay% 
SendInput,  У вас обнаружены паразиты{!} {enter}
SendInput, {F6} 
sleep  %delay% 
SendInput,  Я выпишу Вам Гельминтокс Парантел . Его стоимость всего 450 рублей, вы согласны?  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Глисты_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6} 
sleep  %delay% 
SendInput,   У вас всё в порядке{!} {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Ребро_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас проведем сканирование, выясним серьезность, ложитесь. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me подключил%floor%  апппрпт наркоза к пациенту  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рентген аппарат стоит у стены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выкатывает аппарат к койке пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат у койки.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включает аппарат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат включен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наклоняет аппарат прислоняя прибор к спине пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат готов к сканированию.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола вату и Йодонат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me запускает сканирование {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата смочена.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Сканирование завершено.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вынимает снимок из аппарата  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Снимок в руке.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me задумчиво смотрит на снимок {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Скальпель в руках.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% перелом правого нижнего ребра  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Ребро_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me отложил%floor%  снимок на тумбочку  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Снимок на тумбочке.  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Соболезную вам, худшие опасения подтвердились.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%  
SendInput, Будем ставить вам Корсет.  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Перчатки на тумбочке. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me взяв перчатки с тумбочки надел%floor%  их {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Перчатки надеты. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me щупает место перелома {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Место перелома нащупано. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me резким движением рук вправляет кость в правильное положение {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Кость вправлена. {enter}
SendInput, {F6}
sleep  %delay%    
SendInput,  Сейчас достану обезболивающее и корсет. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Шкаф стоит у стены. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me открыл%floor%  дверцу шкафа {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Дверца шкафа открыта. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do На полке лежит Налгезин. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me взяв препарат в руку несет его пациенту {enter}
SendInput, {F6} 
sleep  %delay%  
SendInput, /do Аппарат в руке. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me потянул%floor%  препарат пациенту {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Разжуйте и проглотите, это снизит боль {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Дверца все еще открыта. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do На полке лежит корсет. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me взяв корсет, несет его пациенту {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me аккуратно надевает корсет на спину пациента {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Корсет надет. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me завязывает шнурки фиксируя корсет плотно на месте перелома {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Шнурки завязаны. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me проверяет фиксацию корсета {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Корсет зафиксирован плотно. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Вам с ним нужно будет проходить полторы-две недели {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  После нужно будет приехать к нам, повторно проведем сканирование {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Вообще не снимать и не мочить{!} Спать только на животе {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Сейчас я вам вколю обезболивающее  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Потому что как только перестанет действовать таблеточное – почувствуете резкую боль {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Препараты лежат на стеллаже. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me достал%floor% нужные препараты со стеллажа {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Шприц и Хлоргексидин в руке. {enter}
SendInput, {F6}
sleep  %delay%   
SendInput, /do Препараты лежат на стеллаже. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me достал%floor% нужный препарат со стеллажа {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Ватка в руке. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me смочил%floor% ватку Хлоргексидином {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Ватка смочена. {enter}
SendInput, {F6}
sleep  %delay%   
SendInput, /me снял%floor% со шприца колпачок {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Колпачок снят. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me набрав Хлоргексидин в шприц {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Шприц набран. {enter}
SendInput, {F6}
sleep  %delay%   
SendInput, /me приспустил%floor% штаны пациента {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Штаны спущены. {enter}
SendInput, {F6} 
sleep  %delay%  
SendInput, /me смазывает место будущего укола мокрой ваткой {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Место смазано. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me убрал%floor% Хлоргексидин на стеллаж {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Препараты на стеллаже. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me достал%floor% нужный препарат со стеллажа {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Налбуфин в руке. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me набрал%floor% в шприц Налбуфин {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Лекарство в шприце. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me введя шприц в место укола вводит лекарство внутрь {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Обезболивающее введено. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Урна в углу палаты. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me вытащив шприц бросил%floor% его в урну {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Шприц в урне. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me прислонил%floor% ватку к месту укола  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Ватка приложена. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Так. Прижимайте ватку, потом просто бросьте ее в урну. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Вам нужно полежать в таком положении минимум 1 час {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  После чего вы можете ехать домой {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return


:?:/Ребро_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Я выпишу Вам Фастум-гель. Его стоимость 450 рублей. Вы согласны? {enter}
return


:?:/Позвоночник::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do У стены стоит стол с необходимыми инструментами. {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me   взял%floor% антисептик с ватой {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Антисептик с ватой в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me обрабатывает операционное поле  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Операционное поле обработано. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рядом стоит аппарат наркоза. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me  включил%floor% аппарат наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат включен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  взял%floor% кислородную маску {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кислородная маска в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% кислородную маску на пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кислородная маска на пациенте. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  подключил%floor% пациента к аппарату искусственной вентиляции лёгких {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пациент подключен к аппарату. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат подачи хирургического цемента стоит в углу комнаты. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me передвинул%floor% аппарат поближе к койке {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат возле койки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  включил%floor% аппарат подачи хирургического цемента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат включен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  взял%floor% скальпель {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Скальпель в руке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% разрез в месте перелома позвоночника {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Разрез сделан. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do В стеллаже лежит троакар. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  взял%floor% троакар {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Троакар в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me постепенно ввел%floor%  троакар в позвоночник {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Троакар в позвоночнике. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе стоит аппарат подачи воздуха.
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат включен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подсоединил%floor% трубку аппарата к троакару {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Трубка подсоединена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% кнопку 'Подать воздух' {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат подал небольшое количество воздуха.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Позвонок выпрямился. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вытащил%floor% троакар из позвонка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Троакар извлечен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Трубка лежит на аппарате подачи хирургического цемента. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% трубку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Трубка в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  засунул%floor% трубку в позвонок {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Трубка в позвонке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me  нажал%floor% на кнопку 'Запуск' {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кнопка нажата. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me начал%floor% заливать цемент в позвоночник {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Бетон залит в позвоночник. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат подачи хирургического цемента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат выключен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me вытащил%floor% трубку из позвонка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Трубка извлечена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me положил%floor% трубку на аппарат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Трубка на аппарате. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput,  /me начал%floor% двигать аппарат к углу комнаты {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат в углу комнаты. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me взял%floor% в руки нитки и ножницы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нитки и ножницы в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me  отрезал%floor% нужное количество ниток {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нитки отрезаны. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сшивает место разреза кожи {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Место разреза сшито. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me  взял%floor% послеоперационный пластырь {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Послеоперационный пластырь в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наклеил%floor% пластырь на место шва {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Послеоперационный пластырь наклеен на шов. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me отключил%floor% пациента от аппарата искусственной вентиляции лёгких {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат выключен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  снял%floor% кислородную маску с пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Маска снята. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Операция прошла успешно. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас я вам одену корсет. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит корсет. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  взял%floor% корсет в руку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Корсет в руках. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me аккуратно одевает корсет на спину пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Корсет надет. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me плотно завязывает шнурки корсета {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Шнурки завязаны. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me проверяет фиксацию корсета {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Корсет зафиксирован плотно. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Теперь необходимо носить корсет как минимум 2 месяц {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Грыжа::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат перчатки и мед.маска.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки  {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, /do Перчатки в руке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки надеты.  {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do Рядом стоит аппарат наркоза.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подключил%floor% аппарат наркоза к пациенту  {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do Аппарат включен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пациент уснул.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% датчики от аппарата  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Датчики в руке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подключил%floor% датчики к пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Датчики подключены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Бутыль с Йодонатом стоит на стойке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% бутыль с Йодонатом с стойки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Бутыль с Йодонатом в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% бутыль с Йодонатом  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Бутыль открыт.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола вату  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата в руке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату йодонатом  {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, /do Вата смочена.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% обрабатывать место надреза  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Место надреза обработано.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит скальпель.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Скальпель в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% надрез в середине позвоночника  {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do Надрез сделан.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит ватный тампон.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ватный тампон со стола  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Ватный тампон в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вытер аккуратно кровь  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Кровь вытерта.  {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me взял%female% ранорасширитель с подноса  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Ранорасширитель в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me расширил%floor% надрез с помощью инструмента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Надрез расширен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me посмотрел%floor% на датчик пульса пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пульс пациента в норме.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зажим с подноса  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Зажим в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% инструмент для удаления связок и костей {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, /do Инструмент в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% удалять участки связок и костей  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Участки связок и костей удалены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% оценивать степень повреждения нервов  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Обнаружен смещенный диск.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зажим с подноса  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Зажим в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% инструмент для удаления грыжи  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Инструмент в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% удалять грыжу с диска позвоночника  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Позвоночная грыжа удалена.  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Хирургическая нить и игла лежат на столе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% с подноса хирургическую нить и иглу  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нить и игла в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% продевать нить в ушко иглы  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Нить продета.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor%  зашивать надрез на спине пациента   {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do Шов наложен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит раствор хлорида натрия и вата.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ватку и раствор  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Вата и раствор в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату раствором хлорида натрия  {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do Вата смочена.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% обрабатывать швы  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Швы обработаны.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Хирургический пластырь лежит на столе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% хирургический пластырь в руки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пластырь в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% накладывать хирургический пластырь на швы  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Хирургический пластырь наложен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отключил%floor% аппарат наркоза  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат отключен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отсоединил%floor% аппарат наркоза от пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат отсоединён.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Операция на этом закончена.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/АВД_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% с пациента одежду  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Одежда снята.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Мед. сумка весит на плече.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor%  мед. сумку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Мед. сумка открыта.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  сухое полотенце с полки и протер%female% тело пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Тело сухое.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отложил%floor% полотенце на стол  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Полотенце на столе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% полку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Полка открыта.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% АВД и электроды и включил%floor% его  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Апарат включен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% электроды и подключил их к АВД  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электроды подключены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% первый электрод и приклеил%floor% его на тело пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электрод приклеен  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% второй электрод и приклеил%floor% его на тело пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электрод приклеен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% на кнопку "Проанализировать"  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do АВД проанализировал%floor% состояние пациента.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% пульс  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/АВД_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do АВД начал издавать звуки.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% на кнопку "Пуск"  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do АВД подал%floor% электрический заряд.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поднес%female% руку к сонной артерии пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me пытается нащупать пульс  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% пульс на сонной артерии {enter}
SendInput, {F6}
sleep 250
SendInput,  /timestamp {enter}{F12}
return

:?:/АВД_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% АВД апарат и вытащил электроды  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Апарат отключен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% апарат на полку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Апарат на полке.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Клизма_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do В углу комнаты стоит шкаф.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do В шкафу необходимые вещи.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% шкаф  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Шкаф открыт.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% одноразовую пелёнку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пелёнка в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me постелил%floor%пелёнку на койку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пелёнка на койке.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Снимите всю нижнюю одежду.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Ложитесь на левый бок, согните ноги.   {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Клизма_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do  Шкаф открыт. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% клизму {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Клизма в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  В углу стоит стеллаж с препаратами.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  В стеллаже баночка с раствором "Энема клин".  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл стеллаж  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Стеллаж открыт.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% баночку раствором  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Баночка с раствором "Энема клин" в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв баночку, аккуратно ввёл%floor% раствор в клизму  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Раствор в клизме.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% баночку с оставшимся раствором в стеллаж  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Баночка в стеллаже.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% стеллаж  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Стеллаж закрыт. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Шкаф открыт.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% вазелиновое масло из шкафа  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Клизма с раствором и вазелиновое масло в руках.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% шкаф  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Шкаф закрыт.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смазал%floor% конец трубки клизмы вазелиновым маслом {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Конец трубки клизмы смазан.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me осторожно вводит трубку в задний проход пациента  {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do  Трубка в заднем проходе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% вводить раствор в пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  Весь раствор в пациенте.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вытащил%floor% трубку из заднегопрохода   {enter}
SendInput, {F6}  
sleep  %delay%
SendInput, /do  Трубка вытащена.  {enter}
SendInput, {F6}  
sleep  %delay%
SendInput,  Садитесь на туалет и ожидайте выхода каловых масс. Он находится в коридоре.  {enter}
SendInput, {F6}  
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Cколиоз_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, И так, приступим{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На плече висит медицинская сумка. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% сумку, после чего достал%floor% сколиометр {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Скалиометр в руке. {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /me прикладывает сколиометр к спинному позвоночнику пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снимает показания с прибора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Показания сняты. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смотрит результат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try увидел%floor%  что показания в норме {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return

:?:/Cколиоз_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Ох, да у вас искривление в позвоночнике{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Рекомендую вам прийти к нам позже и заказать корсет{!} {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return

:?:/Cколиоз_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Хорошо,у вас всё в порядке. {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return

:?:/Наркотики_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do На полке лежит различное оборудование.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% с полки экспресс тест на наркотики  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Экспресс-тест в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me распечатал%floor% герметичную оболочку баночки  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Экспресс-тест готов к исполь﻿зованию.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me передал%floor% тест человеку напротив  {enter}
SendInput, {F6}
sleep %delay%
SendInput, Возьмите.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, Вам необходимо заполнить контейнер уриной до вот этого уровня.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me показал%floor% на отметку в тестере  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Наркотики_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Давайте я посмотрю.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% тест у человека напротив   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Контейнер в руке.   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% тест-полоску из контейнера   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Тест-полоска в руках.   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me посмотрел%floor% на тест-полоску   {enter}
SendInput, {F6} 
sleep %delay%
SendInput, /try увидел%floor% на полоске положительный результат  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Наркотики_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do У человека обнаружено наркотическое опьянение.  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Наркотики_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, {F6}
sleep %delay%
SendInput, /do У человека не обнаружено наркотического опьянения.﻿﻿  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Капельница::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do Возле стола стоит стойка с капельницей. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% стойку с капельницей  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Стойка с капельницей в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me поставил%floor% стойку около кушетки с пациентом  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Стойка рядом с кушеткой.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки пакет с раствором рингера   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Пакет с раствором рингера в руке.  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep %delay%
SendInput, /me повесил%floor% пакет с раствором рингера на стойку   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Пакет висит на стойке. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки шприц-бабочку {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц-бабочка в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me присоединил%floor% ее к капельнице  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц-бабочка присоединена к капельнице. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки ампулу   {enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Ампула в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me расколол%floor% ее и влил%floor% содержимое в шприц   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц заполнился содержимым ампулы.   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me наложил%floor% жгут на руку пациента  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Жгут на руке пациента.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежит ватка с медицинским спиртом. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% ватку со столика и смочил%floor% ее в спирте {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ватка смочена в спирте.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me протер%female% место укола  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Место укола продезинфицировано.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me находит вену  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Вена найдена. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me убрал%floor% жгут с руки  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me вводит шприц-бабочку в вену  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Пациент под капельницей. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Тест_1::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
Sleep %delay%
SendInput, /do На столе лежит баночка. {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /me взял%floor% баночку в руку {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /do Баночка в руке. {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /me передал%floor% баночку человеку напротив {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, Возьмите, вам в неё нужно будет пописать. {Enter} 
SendInput, {F6}  
Sleep 200
SendInput, /timestamp {enter}{F12} 
return 

:?:/Тест_2::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
Sleep %delay%
SendInput, /do На столе лежит полоска с тестом. {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /me взял%floor% тест в руку {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /do Тест в руке. {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /me передал%floor% тест человеку напротив {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, После того, как вы пописали в баночку, {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, Окуните полоску, стрелочкой вниз. {Enter} 
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 

:?:/Тест_3::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
Sleep %delay%
SendInput, Так. Давайте сюда ваш тестик. {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /me взял%floor% тест в руку {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /do Тест в руке. {Enter} 
SendInput, {F6} 
Sleep %delay%
Sendinput, /me посмотрел%floor% на тест {Enter} 
SendInput, {F6} 
Sleep %delay%
SendInput, /try обнаружил%floor% две полоски {Enter} 
SendInput, {F6} 
Sleep  %delay%
SendInput, /do Результат выявлен. {Enter} 
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 

:?:/Тест_4::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
Sleep %delay%
SendInput, Вы беременны. {Enter} 
return 

:?:/Тест_5::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
Sleep %delay%
SendInput, Вы не беременны.  {Enter} 
return 

:?:/ФГДС_1::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6}
sleep %delay%
SendInput,  Здравствуйте. Сейчас я проведу Вам гастроскопию.  Ложитесь на кушетку на левый бок. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do На столике лежит капа. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% капу в руку {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Капа в руке. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput,   Так... Вот, откройте рот, закусите капу. {Enter} 
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 

:?:/ФГДС_2::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6}
sleep %delay%
SendInput, /me вставил%floor% капу в рот пациента {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Капа зафиксирована. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить гастроскоп в пищевод пациента {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Гастроскоп в пищеводе. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% изучать пищевод {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /try обнаружил%floor% отклонения {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me продолжил%floor% вводить гастроскоп в желудок пациента {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Гастроскоп в желудке. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% осматривать стенки желудка {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /try обнаружил%floor% отклонения {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me осмотрел%floor% двенадцатипёрстную кишку {Enter} 
SendInput, {F6}
sleep %delay% 
SendInput, /do Двенадцатипёрстная кишка осмотрена. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /try обнаружил%floor% отклонения {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вынимать гастроскоп из желудка пациента {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Гастроскоп вынут. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% гастроскоп в аппарат для дезинфекции {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Гастроскоп в аппарате для дезинфекции. {Enter} 
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 



:?:/Роды_1::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6}
sleep %delay%
SendInput, /do Помещение стерильное. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежат перчатки. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% перчатки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Перчатки в руке. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me надел%floor% перчатки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Перчатки надеты. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Вам удобно? {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me поправил%floor% положение ног роженицы {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ноги поправлены. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% чистую плёнку {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Плёнка в руках. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me накрыл%floor% ноги роженицы плёнкой {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ноги накрыты. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do В углу стоит аппарат КГТ. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me подсоединил%floor% аппарат КГТ к роженице {enter}
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
SendInput, {F6}
sleep %delay%
SendInput, /do Аппарат подсоединен. {enter}
SendInput, {F6}
sleep %delay%
SendInput, И так, начинаем тужиться. Дышите ровно. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шейка матки роженицы раскрывается. {enter}
SendInput, {F6} 
sleep %delay%
SendInput, Тужитесь ещё немного, ухватитесь за поручень или за что нибудь крепкое. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Осталось совсем чуть-чуть. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шейка матки роженицы раскрылась на 5 сантиметров. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Роды отошли. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Дышите, осталось совсем немного. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шейка матки раскрылась на 10 сантиметров.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Показалась головка малыша. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Сейчас терпите не в коем случае не тужитесь. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me помог%female% головке малыша высвободиться  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Головка малыша высвобождена. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me потянул%floor% за головку {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ребенок в руках. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me проверил%floor% состояние ребенка  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Состояние ребенка хорошее.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% осматривать ребенка на наличие пола {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ребенок осмотрен.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /try обнаружил%floor%, что новорожденный ребенок - мальчик  {enter}
return 

 

:?:/Роды_2::
SendInput, {F6}
sleep %delay%
SendInput, Поздравляю вас. {enter}
SendInput, {F6}
sleep %delay%
SendInput, У вас мальчик. {enter}SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 

 

:?:/Роды_3::
SendInput, {F6}
sleep %delay%
SendInput, Поздравляю вас. {enter}
SendInput, {F6}
sleep %delay%
SendInput, У вас девочка. {enter}
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 

:?:/Роды_4::
SendInput, {F6}
sleep %delay%
SendInput, /me обернул%floor% ребёнка в мягкую клеёнку {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ребёнок обернут. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% малыша на животик матери  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Малыш на животе.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе двое щипцов.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% со стола двое щипцов  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Щипцы в руках.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me нацепил%floor% щипцы на пуповину  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Щипцы нацеплены.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% со стола мед.ножницы  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ножницы в руках.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me обрезал%floor% пуповину  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Пуповина обрезана.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me удалил%floor% плаценту  {enter}
SendInput, {F6}
sleep %delay%
SendInput, Лежите и отдыхайте.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me собрал%floor% все мед.инструменты и положил%floor% их в лоток  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Мед.инструменты в лотке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, Вот и всё.  {enter}
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 


:?:/Транс::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do Возле стола стоит стойка с капельницей. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% стойку с капельницей  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Стойка с капельницей в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me поставил%floor% стойку около кушетки с пациентом  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Стойка рядом с кушеткой.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки пакет с раствором рингера   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Пакет с раствором рингера в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me повесил%floor% пакет с раствором рингера на стойку   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Пакет висит на стойке. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки шприц-бабочку {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц-бабочка в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me присоединил%floor% ее к капельнице  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц-бабочка присоединена к капельнице. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки ампулу   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ампула в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me расколол%floor% ее и влил%floor% содержимое в шприц   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц заполнился содержимым ампулы.   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me наложил%floor% жгут на руку пациента  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Жгут на руке пациента.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежит ватка с медицинским спиртом. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% ватку со столика и смочил%floor% ее в спирте {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ватка смочена в спирте.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me протер%female% место укола  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Место укола продезинфицировано.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me находит вену  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Вена найдена. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me убрал%floor% жгут с руки  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me вводит шприц-бабочку в вену  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Пациент под капельницей. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me подключил%floor% пациента к аппарату ИВЛ  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Аппарат ИВЛ подключён.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me посмотрел%floor% на стол {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столу лежат инструменты.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% скальпель в руку  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep %delay%
SendInput, /do Скальпель в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me сделал%floor% разрез на теле пациента  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Разрез сделан.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me отложил%floor% на стол скальпель и взял%floor% в руку щипцы  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Щипцы в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% изьятие половых органов  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% половые органы в капсулу  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Органы в капсуле.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% капсулу в руку  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Капсула в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me закрыл%floor%  капсулу  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Капсула закрыта.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me открыл%floor% дверцу ящика  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ящик открыт.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% капсулу в ящик  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Капсула в ящике.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Капсула с надписью  "Противоположный пол" на полке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% капсулу с противоположными органами  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep %delay%
SendInput, /do Капсула в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% капсулу на стол  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Капсула на столе.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me открыл%floor% капсулу  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Капсула открыта.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% в руку вновь щипцы  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do  Чистые щипцы в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% щипцами органы  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Органы в щипцах.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me аккуратно начал%floor% вставлять органы в разрез  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me отложил%floor% щипцы в сторону  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Иголка и нитка на столе.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% иголку и нитки в руки  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Нитка и иголка в руках.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me надкусил%floor% нитку для нужного размера  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Нитка нужного размера.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me  вставил%floor% нитку в ушко иголки  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Нитка в иголке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% зашивать место разреза  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Разрез зашит.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me убрал%floor% иголку на стол  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Иголка на столе.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Проспиртованная ватка на столе.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% ватку в руку  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Ватка в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me обработал%floor%  швы  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Швы обработаны.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me отложил%floor% ватку на стол  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep %delay%
SendInput, /do Ватка на столе.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Бинт в ящике.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% бинт в руку  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Бинт в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% накладывать  бинт на шов  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me закончив с бинтом, взял%floor%  в руки маркер со стола  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Маркер в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me пометил%floor% маркером изменения на лице  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do  Пометки сделаны.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me отложил%floor% маркер на стол  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Маркер на столе.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% новый скальпель в руку  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Скальпель в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me сделал%floor% надрезы  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Надрезы сделаны.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me сформировал%floor% новые форму лица  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me отложил%floor% скальпель на стол  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Скальпель на столе  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц с ботоксом в ящике.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% шприц с ботоксом  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц с ботоксом в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me вколол%floor% ботокс в лицо пациента  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Новые формы лица сформированы.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me отложил%floor% шприц в сторону  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц в стороне.   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц в ящике.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% шприц с гормонами нужного пола  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Шприц  в руке.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me вколол%floor% гормоны пациенту  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Гормоны внутри пациента.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me отключил%floor% пациента от аппарата ИВЛ    {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Пациент отключён от аппарата.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, Всё, операция прошла успешно.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, Препараты начали действовать. Поэтому полежите ещё немного и можете идти.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Матка_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте. Сейчас я проведу Гистероскопию. {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, Снимайте штаны, нижнее бельё. Садитесь в гинекологическое кресло. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/Матка_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат стерильные перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки надеты. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На стойке висит гистероскоп. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% гистероскоп со стойки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гистероскоп в руке. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить гистероскоп в матку пациентки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гистероскоп в матке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% осмотр матки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% отклонения {enter}
return


:?:/Матка_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput,  У Вас, есть патология.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рядом стоит аппарат наркоза. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me подключил%floor% апппрпт наркоза к пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат включен.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Пациент уснул.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me удалил%floor%  патологию {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Патология удалена. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат отключен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отсоеденил%floor%  аппарат наркоза от пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Аппарат отсоеденён. {enter}
return

:?:/Матка_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Патологий у Вас, нет{!}  {enter}
return



:?:/Цистоскопия_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте. Сейчас я проведу Цистоскопию. {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, Снимайте штаны, нижнее бельё. Садитесь в гинекологическое кресло. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return


:?:/Цистоскопия_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат стерильные перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do Перчатки надеты. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На стойке висит цистоскоп. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% цистоскоп со стойки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Цистоскоп в руке. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить  цистоскоп  в  уретру {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Цистоскоп  в  мочевом пузыре. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% осмотр  мочевого пузыря {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% отклонения {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return


:?:/Цистоскопия_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, У Вас, есть отклонения {!}  {enter}
return

:?:/Цистоскопия_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Отклонений  у Вас, нет{!}  {enter}
return

:?:/Цистоскопия_5::
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вынимать цистоскоп  из  уретры {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Цистоскоп  вынут. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor%  цистоскоп  в аппарат для дезинфекции {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Цистоскоп в аппарате для дезинфекции. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return




:?:/голова::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Миг. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/живот::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Но-Шпа. Её стоимость 450 рублей. Вы согласны? {enter}
return
:?:/диарея::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Активированый уголь. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/потенция::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Виагру. Её стоимость 450 рублей. Вы согласны? {enter}
return
:?:/геморрой::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Свечи Релиф. Их стоимость 450 рублей. Вы согласны? {enter}
return
:?:/ушиб::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Фастум-гель. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/ожог::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам спрей Пантенол. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/витамины::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Унивит. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/тошнота::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Церукал. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/изжога::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Омепразол. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/насморк::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Отривин. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/мигрень::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Амигренин. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/мочевой::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Цистон. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/печень::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Гепабене. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/аллергия::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Зодак. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/сердце::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Кардиомагнил. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/простуда::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Терафлю. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/кашельс::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 500
SendInput, Я выпишу Вам Лазолван. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/кашельв::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Амбробене. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/диабет::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Диабетон. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/горло::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Гексорал. Его стоимость 450 рублей. Вы согласны? {enter}
:?:/глаза::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Визин. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/судороги::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Магнелис. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/уши::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Отинум. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/почки::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Уролисан. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/суставы::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Фастум-гель. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/давлениев::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Андипал. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/давлениен::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Норадреналин. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/яйца::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Амоксиклав. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/сон::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Персен Ночь. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/зрение::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Виталюкс. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/память::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Гинкоум Эвалар. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/укачивание::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Драмина. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/курение::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Табекс. Его стоимость 450 рублей. Вы согласны? {enter}
return


Pause::Pause ; Assign the toggle-pause function to the "pause" key...
!p::Pause ; ... or assign it to Win+p or soSendInput, /me other hotkey.
return



ButtonПрименить:
GuiClose:
GuiEscape:
Gui, Submit


;--------------------------------------------------------------------------------
Gui, 2:show, center h700 w1220,
Gui, 2:Font, S10   Bold
Gui, 2 :Add, Picture, x0 y30 w1220 h700, C:\Program Files (x86)\МЗ\AHK_1.jpg
Gui, 2:Add, Tab2, x0 y0 w1220 h25 cFF2400  +BackgroundTrans, Бинды|РП Ситуации 1|РП Ситуации 2|Препараты

Gui,2: Tab, 1
Gui,2: Font, S10 C000000
Gui,2: Add, Text, x10 y60 w300 h20    cFF2400 +BackgroundTrans,   Alt+1
Gui,2: Add, Text, x10 y90 w300 h20    cFF2400 +BackgroundTrans ,  Alt+2
Gui,2: Add, Text, x10 y120 w300 h20  cFF2400 +BackgroundTrans ,  Alt+3
Gui,2: Add, Text, x10 y150 w300 h20  cFF2400 +BackgroundTrans ,  Alt+4
Gui,2: Add, Text, x10 y180 w300 h20  cFF2400 +BackgroundTrans ,  Alt+5
Gui,2: Add, Text, x10 y210 w300 h20  cFF2400 +BackgroundTrans ,  Alt+6
Gui,2: Add, Text, x10 y240 w300 h20  cFF2400 +BackgroundTrans ,  Alt+7
Gui,2: Add, Text, x10 y270 w300 h20  cFF2400 +BackgroundTrans ,  Alt+8
Gui,2: Add, Text, x10 y300 w300 h20  cFF2400 +BackgroundTrans ,  Alt+9
Gui,2: Add, Text, x10 y330 w300 h20  cFF2400 +BackgroundTrans ,  Alt+0
Gui,2: Add, Text, x10 y360 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num1
Gui,2: Add, Text, x10 y390 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num2
Gui,2: Add, Text, x10 y420 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num3
Gui,2: Add, Text, x10 y450 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num4
Gui,2: Add, Text, x10 y480 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num5
Gui,2: Add, Text, x10 y510 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num6
Gui,2: Add, Text, x10 y540 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num7
Gui, 2:Add, Text, x10 y570 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num8
Gui, 2:Add, Text, x10 y600 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num9
Gui, 2:Add, Text, x10 y630 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num0

Gui,2: Add, Text, x100 y60 w300 h20 +BackgroundTrans , [Приветствие]
Gui,2: Add, Text, x100 y90 w300 h20 +BackgroundTrans , [Беспокойствие]
Gui,2: Add, Text, x100 y120 w300 h20 +BackgroundTrans , [Осмотр]
Gui,2: Add, Text, x100 y150 w300 h20 +BackgroundTrans , [Передать препарат]
Gui,2: Add, Text, x100 y180 w300 h20 +BackgroundTrans , [Всего доброго, не болейте!]
Gui,2: Add, Text, x100 y210 w300 h20 +BackgroundTrans , [Если пациент отказался]
Gui,2: Add, Text, x100 y240 w300 h20 +BackgroundTrans , [Самолечение]
Gui,2: Add, Text, x100 y270 w300 h20 +BackgroundTrans , [Мегафон в АСМП]
Gui,2: Add, Text, x100 y300 w300 h20 +BackgroundTrans , [Посмотреть время]
Gui,2: Add, Text, x100 y330 w300 h20 +BackgroundTrans , [Рация]
Gui,2: Add, Text, x100 y360 w300 h20 +BackgroundTrans , [Рация]
Gui,2: Add, Text, x100 y390 w300 h20 +BackgroundTrans , [Разрешение отъехать]
Gui,2: Add, Text, x100 y420 w300 h20 +BackgroundTrans , [Разрешаю для 7-10 рангов]
Gui,2: Add, Text, x100 y450 w300 h20 +BackgroundTrans , [Отказываю для 7-10 рангов]
Gui,2: Add, Text, x100 y480 w300 h20 +BackgroundTrans , [Взять мед.диплом]
Gui,2: Add, Text, x100 y510 w300 h20 +BackgroundTrans ,  [Взять паспорт]
Gui,2: Add, Text, x100 y540 w300 h20 +BackgroundTrans ,  [Мед.комиссия для призывников]
Gui, 2:Add, Text, x100 y570 w300 h20 +BackgroundTrans ,  [Мед.комиссии для призывников]
Gui, 2:Add, Text, x100 y600 w300 h20 +BackgroundTrans ,  [Взял%floor% перерыв]
Gui, 2:Add, Text, x100 y630 w300 h20 +BackgroundTrans ,  [Сдал%floor% смену]

Gui, 2:Add, Text, x400 y60 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y75 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y90 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y105 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y120 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y135 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y150 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y165 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y180 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y195 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y210 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y225 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y270 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y285 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y300 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y315 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y330 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y345 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y360 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y375 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y390 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y405 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y420 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y435 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y450 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y465 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y480 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y495 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y510 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y525 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y540 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y555 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y565 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y585 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y600 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y615 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y630 w300 h20 c000000 +BackgroundTrans, |

Gui, 2: Add, Text, x410 y60  w300 h20 cFF2400 +BackgroundTrans ,  /Пост
Gui, 2: Add, Text, x410 y90  w300 h20  cFF2400 +BackgroundTrans, /Выехал
Gui, 2: Add, Text, x410 y120 w300 h20 cFF2400 +BackgroundTrans, /Дежурство
Gui, 2: Add, Text, x410 y150 w300 h20 cFF2400 +BackgroundTrans, /Окончил
Gui, 2: Add, Text, x410 y180 w300 h20 cFF2400 +BackgroundTrans, /Город
Gui, 2: Add, Text, x410 y210 w300 h20  cFF2400 +BackgroundTrans, /Патрулирование
Gui, 2: Add, Text, x410 y240 w300 h20  cFF2400 +BackgroundTrans , /Патрул
Gui, 2: Add, Text, x410 y270 w300 h20  cFF2400 +BackgroundTrans , /Еду
Gui, 2: Add, Text, x410 y300 w300 h20  cFF2400 +BackgroundTrans , /Принял
Gui, 2: Add, Text, x410 y330 w300 h20  cFF2400 +BackgroundTrans , /Место
Gui, 2: Add, Text, x410 y360 w300 h20  cFF2400 +BackgroundTrans , /Ложный
Gui, 2: Add, Text, x410 y390 w300 h20  cFF2400 +BackgroundTrans , /Госпитализация
Gui, 2: Add, Text, x410 y420 w300 h20  cFF2400 +BackgroundTrans , /ВЦГБ
Gui, 2: Add, Text, x410 y450 w300 h20  cFF2400 +BackgroundTrans , /ЦГБ


Gui, 2: Add, Text, x550 y60 w300 h20 +BackgroundTrans ,   [О выезде на пост]
Gui, 2: Add, Text, x550 y90 w300 h20 +BackgroundTrans ,   [Если разрешили]
Gui, 2: Add, Text, x550 y120 w300 h20 +BackgroundTrans,  [Каждые 5 минут на посте]
Gui, 2: Add, Text, x550 y150 w300 h20 +BackgroundTrans , [По окончании дежурства на посту]
Gui, 2: Add, Text, x550 y180 w300 h20 +BackgroundTrans , [О выезде на патруль]
Gui, 2: Add, Text, x550 y210 w300 h20 +BackgroundTrans , [Если разрешили]
Gui, 2: Add, Text, x550 y240 w300 h20 +BackgroundTrans , [Каждые 5 минут на патруле]
Gui, 2: Add, Text, x550 y270 w300 h20 +BackgroundTrans , [По окончании патрулирования]
Gui, 2: Add, Text, x550 y300 w300 h20 +BackgroundTrans , [О выезде на вызов]
Gui, 2: Add, Text, x550 y330 w300 h20 +BackgroundTrans , [По прибытии на место вызова]
Gui, 2: Add, Text, x550 y360 w300 h20 +BackgroundTrans , [Если вызов ложный]
Gui, 2: Add, Text, x550 y390 w300 h20 +BackgroundTrans , [Если вызов не ложный]
Gui, 2: Add, Text, x550 y420 w300 h20 +BackgroundTrans , [После госпитализации пациента]
Gui, 2: Add, Text, x550 y450 w300 h20 +BackgroundTrans , [По окончании работы]


Gui, 2:Add, Text, x810 y60 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x810 y75 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x810 y90 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x810 y105 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y120 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y135 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y150 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y165 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y180 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y195 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y210 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y225 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y270 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y285 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y300 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y315 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y330 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y345 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y360 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y375 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y390 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y405 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y420 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y435 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y450 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y465 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y480 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y495 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y510 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y525 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y540 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y555 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y565 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y585 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y600 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y615 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y630 w300 h20 c000000 +BackgroundTrans, |


Gui, 2:Add, Text, x820 y60 w300 h20 cFF2400  +BackgroundTrans , Звание:
Gui, 2:Add, Text, x820 y90 w300 h20 cFF2400  +BackgroundTrans , Тег: 
Gui, 2:Add, Text, x820 y120 w300 h20 cFF2400 +BackgroundTrans , Имя:
Gui, 2:Add, Text, x820 y150 w300 h20 cFF2400 +BackgroundTrans , Фамилия:
Gui, 2:Add, Text, x820 y180 w300 h20 cFF2400 +BackgroundTrans , Отчество:
Gui, 2:Add, Text, x820 y210 w300 h20 cFF2400 +BackgroundTrans , Название больницы:
Gui, 2:Add, Text, x820 y240 w300 h20 cFF2400 +BackgroundTrans , Пол: 
Gui, 2:Add, Text, x820 y270 w300 h20 cFF2400 +BackgroundTrans , Пол:
Gui, 2:Add, Text, x820 y300 w300 h20 cFF2400 +BackgroundTrans , Задержка:
Gui, 2:Add, Text, x820 y330 w300 h20 cFF2400 +BackgroundTrans , Пост:
Gui, 2:Add, Text, x820 y360 w300 h20 cFF2400 +BackgroundTrans , Напарник:
Gui, 2:Add, Text, x820 y390 w300 h20 cFF2400 +BackgroundTrans , ИФ напарниа:


Gui, 2:Add, Text, x980 y60 w900 h20 +BackgroundTrans ,  [%JWI%]
Gui, 2:Add, Text, x980 y90 w900 h20 +BackgroundTrans ,  [%TAG%]
Gui, 2:Add, Text, x980 y120 w900 h20 +BackgroundTrans, [%Name%]
Gui, 2:Add, Text, x980 y150 w300 h20 +BackgroundTrans , [%Surname%]
Gui, 2:Add, Text, x980 y180 w300 h20 +BackgroundTrans , [%Middle_Name%]
Gui, 2:Add, Text, x980 y210 w300 h20 +BackgroundTrans , [%Bol%]
Gui, 2:Add, Text, x980 y240 w300 h20 +BackgroundTrans , [%Floor%]
Gui, 2:Add, Text, x980 y270 w300 h20 +BackgroundTrans , [%Female%]
Gui, 2:Add, Text, x980 y300 w300 h20 +BackgroundTrans , [%delay%]
Gui, 2:Add, Text, x980 y330 w300 h20 +BackgroundTrans , [%Fast%]
Gui, 2:Add, Text, x980 y360 w300 h20 +BackgroundTrans , [%Partner%]
Gui, 2:Add, Text, x980 y390 w300 h20 +BackgroundTrans , [%Partner_Name_surname%]

Gui, 2:Tab, 2
Gui, 2:Font, S10 C000000
Gui, 2:Add, Text, x10 y60 w300 h20 cFF2400 +BackgroundTrans,  /Карта_1
Gui, 2:Add, Text, x10 y90 w300 h20 cFF2400 +BackgroundTrans ,  /Карта_2
Gui, 2:Add, Text, x10 y120 w300 h20 cFF2400 +BackgroundTrans , /КПК
Gui, 2:Add, Text, x10 y150 w300 h20 cFF2400 +BackgroundTrans , /АСМП_1
Gui, 2:Add, Text, x10 y180 w300 h20 cFF2400  +BackgroundTrans ,/АСМП_2
Gui, 2:Add, Text, x10 y210 w300 h20 cFF2400  +BackgroundTrans ,/АСМП_3
Gui, 2:Add, Text, x10 y240 w300 h20 cFF2400 +BackgroundTrans , /ЭКГ_1
Gui, 2:Add, Text, x10 y270 w300 h20 cFF2400  +BackgroundTrans ,/ЭКГ_2
Gui, 2:Add, Text, x10 y300 w300 h20 cFF2400  +BackgroundTrans ,/ЭКГ_3
Gui, 2:Add, Text, x10 y330 w300 h20 cFF2400 +BackgroundTrans , /Шприц 
Gui, 2:Add, Text, x10 y360 w300 h20 cFF2400 +BackgroundTrans , /Вакцинация
Gui, 2:Add, Text, x10 y390 w300 h20 cFF2400 +BackgroundTrans , /Зонд_1
Gui, 2:Add, Text, x10 y420 w300 h20 cFF2400 +BackgroundTrans , /Зонд_2
Gui, 2:Add, Text, x10 y450 w300 h20 cFF2400 +BackgroundTrans , /Зонд_3
Gui, 2:Add, Text, x10 y480 w300 h20 cFF2400 +BackgroundTrans , /Кровь
Gui, 2:Add, Text, x10 y510 w300 h20 cFF2400 +BackgroundTrans , /Рентген_1
Gui, 2:Add, Text, x10 y540 w300 h20 cFF2400 +BackgroundTrans , /Рентген_2
Gui, 2:Add, Text, x10 y570 w300 h20 cFF2400 +BackgroundTrans , /Рентген_3
Gui, 2:Add, Text, x10 y600 w300 h20 cFF2400 +BackgroundTrans , /Рентген_4
Gui, 2:Add, Text, x10 y630 w300 h20 cFF2400 +BackgroundTrans , /Донор

Gui, 2:Add, Text, x100 y60 w300 h20 +BackgroundTrans ,  [Взять мед. карту]
Gui, 2:Add, Text, x100 y90 w300 h20 +BackgroundTrans ,  [Вернуть мед. карту]
Gui, 2:Add, Text, x100 y120 w300 h20 +BackgroundTrans ,[КПК]
Gui, 2:Add, Text, x100 y150 w300 h20 +BackgroundTrans ,[АСМП погрузка]
Gui, 2:Add, Text, x100 y180 w300 h20 +BackgroundTrans , [АСМП выгрузка]
Gui, 2:Add, Text, x100 y210 w300 h20 +BackgroundTrans , [АСМП выгрузка оперепация]
Gui, 2:Add, Text, x100 y240 w300 h20 +BackgroundTrans , [ЭКГ]
Gui, 2:Add, Text, x100 y270 w300 h20 +BackgroundTrans , [ЭКГ удачно]
Gui, 2:Add, Text, x100 y300 w300 h20 +BackgroundTrans , [ЭКГ неудачно]
Gui, 2:Add, Text, x100 y330 w300 h20 +BackgroundTrans , [Аллергический приступ]
Gui, 2:Add, Text, x100 y360 w300 h20 +BackgroundTrans , [Вакцинация]
Gui, 2:Add, Text, x100 y390 w300 h20 +BackgroundTrans , [Взятие мазка]
Gui, 2:Add, Text, x100 y420 w300 h20 +BackgroundTrans , [Взятие мазка  удачно]
Gui, 2:Add, Text, x100 y450 w300 h20 +BackgroundTrans , [Взятие мазка не удачно]
Gui, 2:Add, Text, x100 y480 w300 h20 +BackgroundTrans , [Внутреннее кровотечение]
Gui, 2:Add, Text, x100 y510 w300 h20 +BackgroundTrans , [Рентген конечности]
Gui, 2:Add, Text, x100 y540 w300 h20 +BackgroundTrans , [Рентген  конечности удачно лангетка]
Gui, 2:Add, Text, x100 y570 w300 h20 +BackgroundTrans , [Рентген конечности удачно гипс]
Gui, 2:Add, Text, x100 y600 w300 h20 +BackgroundTrans ,  [Рентген конечности неудачно]
Gui, 2:Add, Text, x100 y630 w300 h20 +BackgroundTrans ,  [Донорство]

Gui, 2:Add, Text, x400 y60 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y75 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y90 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y105 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y120 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y135 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y150 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y165 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y180 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y195 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y210 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y225 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y270 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y285 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y300 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y315 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y330 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y345 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y360 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y375 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y390 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y405 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y420 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y435 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y450 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y465 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y480 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y495 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y510 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y525 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y540 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y555 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y565 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y585 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y600 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y615 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y630 w300 h20 c000000 +BackgroundTrans, |

Gui, 2:Add, Text, x410  y60  w300 h20 cFF2400 +BackgroundTrans , /Мрт
Gui, 2:Add, Text, x410  y90  w300 h20  cFF2400 +BackgroundTrans, /Нож
Gui, 2:Add, Text, x410  y120 w300 h20 cFF2400 +BackgroundTrans, /Нос
Gui, 2:Add, Text, x410  y150 w300 h20 cFF2400 +BackgroundTrans, /Желудк
Gui, 2:Add, Text, x410  y180 w300 h20 cFF2400 +BackgroundTrans, /Аппендикс
Gui, 2:Add, Text, x410  y210 w300 h20 cFF2400 +BackgroundTrans, /Грудь
Gui, 2:Add, Text, x410  y240 w300 h20 cFF2400 +BackgroundTrans, /Прибор_1
Gui, 2:Add, Text, x410  y270 w300 h20 cFF2400 +BackgroundTrans, /Прибор_2
Gui, 2:Add, Text, x410  y300 w300 h20 cFF2400 +BackgroundTrans ,/Прибор_3
Gui, 2:Add, Text, x410  y330 w300 h20 cFF2400 +BackgroundTrans, /УЗИ
Gui, 2:Add, Text, x410  y360 w300 h20 cFF2400 +BackgroundTrans, /Пуля
Gui, 2:Add, Text, x410  y390 w300 h20 cFF2400 +BackgroundTrans, /Аппарат 
Gui, 2:Add, Text, x410  y420 w300 h20 cFF2400 +BackgroundTrans, /Чувства_1
Gui, 2:Add, Text, x410  y450 w300 h20 cFF2400 +BackgroundTrans, /Чувства_2
Gui, 2:Add, Text, x410  y480 w300 h20 cFF2400 +BackgroundTrans, /Чувства_3
Gui, 2:Add, Text, x410  y510 w300 h20 cFF2400 +BackgroundTrans, /Алкоголь_1
Gui, 2:Add, Text, x410  y540 w300 h20 cFF2400 +BackgroundTrans, /Алкоголь_2
Gui, 2:Add, Text, x410  y570 w300 h20 cFF2400 +BackgroundTrans, /Алкоголь_3
Gui, 2:Add, Text, x410  y600 w300 h20 cFF2400 +BackgroundTrans, /ФКС_1
Gui, 2:Add, Text, x410  y630 w300 h20 cFF2400 +BackgroundTrans, /ФКС_2

Gui, 2:Add, Text, x510 y60 w300 h20 +BackgroundTrans , [МРТ]
Gui, 2:Add, Text, x510 y90 w300 h20 +BackgroundTrans , [Ножевое ранение]
Gui, 2:Add, Text, x510 y120 w300 h20 +BackgroundTrans ,[Носовое кровотечение]
Gui, 2:Add, Text, x510 y150 w300 h20 +BackgroundTrans ,[Отравление желудка]
Gui, 2:Add, Text, x510 y180 w300 h20 +BackgroundTrans , [Удаление аппендицита]
Gui, 2:Add, Text, x510 y210 w300 h20 +BackgroundTrans , [Увеличение груди]
Gui, 2:Add, Text, x510 y240 w300 h20 +BackgroundTrans , [Томография]
Gui, 2:Add, Text, x510 y270 w300 h20 +BackgroundTrans , [Томография удачно]
Gui, 2:Add, Text, x510 y300 w300 h20 +BackgroundTrans , [Томография неудачно]
Gui, 2:Add, Text, x510 y330 w300 h20 +BackgroundTrans , [Узи]
Gui, 2:Add, Text, x510 y360 w300 h20 +BackgroundTrans , [Пулевое ранение]
Gui, 2:Add, Text, x510 y390 w300 h20 +BackgroundTrans , [Флюрография]
Gui, 2:Add, Text, x510 y420 w300 h20 +BackgroundTrans , [Приведение в чувства]
Gui, 2:Add, Text, x510 y450 w300 h20 +BackgroundTrans , [Приведение чувства удачно]
Gui, 2:Add, Text, x510 y480 w300 h20 +BackgroundTrans ,  [Приведение в чувства не удачно]
Gui, 2:Add, Text, x510 y510 w300 h20 +BackgroundTrans ,  [Проверка на алкоголь]
Gui, 2:Add, Text, x510 y540 w300 h20 +BackgroundTrans ,  [Проверка на алкоголь удачно]
Gui, 2:Add, Text, x510 y570 w300 h20 +BackgroundTrans ,  [Проверка на алкоголь не удачно]
Gui, 2:Add, Text, x510 y600 w300 h20 +BackgroundTrans ,  [Колоноскопия]
Gui, 2:Add, Text, x510 y630 w300 h20 +BackgroundTrans ,  [Колоноскопия удачно]

Gui, 2:Add, Text, x780 y60 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x780 y75 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x780 y90 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x780 y105 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y120 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y135 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y150 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y165 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y180 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y195 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y210 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y225 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y240 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y255 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y270 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y285 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y300 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y315 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y330 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y345 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y360 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y375 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y390 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y405 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y420 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y435 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y450 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y465 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y480 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y495 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y510 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y525 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y540 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y555 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y565 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y585 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y600 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y615 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y630 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y645 w300 h20 +BackgroundTrans, |

Gui, 2:Add, Text, x790 y60  w300 h20 cFF2400  +BackgroundTrans , /ФКС_3
Gui, 2:Add, Text, x790 y90  w300 h20 cFF2400  +BackgroundTrans , /Вши_1
Gui, 2:Add, Text, x790 y120 w300 h20 cFF2400 +BackgroundTrans , /Вши_2
Gui, 2:Add, Text, x790 y150 w300 h20 cFF2400 +BackgroundTrans , /Вши_3
Gui, 2:Add, Text, x790 y180 w300 h20 cFF2400 +BackgroundTrans , /Открытый
Gui, 2:Add, Text, x790 y210 w300 h20 cFF2400 +BackgroundTrans , /Ожоги
Gui, 2:Add, Text, x790 y240 w300 h20 cFF2400 +BackgroundTrans , /Глисты_1
Gui, 2:Add, Text, x790 y270 w300 h20 cFF2400 +BackgroundTrans , /Глисты_2
Gui, 2:Add, Text, x790 y300 w300 h20 cFF2400 +BackgroundTrans , /Глисты_3
Gui, 2:Add, Text, x790 y330 w300 h20 cFF2400 +BackgroundTrans , /Глисты_4
Gui, 2:Add, Text, x790 y360 w300 h20 cFF2400 +BackgroundTrans , /Ребро_1
Gui, 2:Add, Text, x790 y390 w300 h20 cFF2400 +BackgroundTrans , /Ребро_2
Gui, 2:Add, Text, x790 y420 w300 h20 cFF2400 +BackgroundTrans , /Ребро_3
Gui, 2:Add, Text, x790 y450 w300 h20 cFF2400 +BackgroundTrans , /Позвоночник
Gui, 2:Add, Text, x790 y480 w300 h20 cFF2400 +BackgroundTrans , /Грыжа_1
Gui, 2:Add, Text, x790 y510 w300 h20 cFF2400 +BackgroundTrans , /AВД_1
Gui, 2:Add, Text, x790 y540 w300 h20 cFF2400 +BackgroundTrans , /AВД_2
Gui, 2:Add, Text, x790 y570 w300 h20 cFF2400 +BackgroundTrans , /AВД_3
Gui, 2:Add, Text, x790 y600 w300 h20 cFF2400 +BackgroundTrans , /Клизма_1 
Gui, 2:Add, Text, x790 y630 w300 h20 cFF2400 +BackgroundTrans , /Клизма_2

Gui, 2:Add, Text, x890 y60 w300 h20 +BackgroundTrans ,  [Колоноскопия не удачно]
Gui, 2:Add, Text, x890 y90 w300 h20 +BackgroundTrans ,  [Проверка на вши]
Gui, 2:Add, Text, x890 y120 w300 h20 +BackgroundTrans ,[Проверка на вши удачно]
Gui, 2:Add, Text, x890 y150 w300 h20 +BackgroundTrans , [Проверка на вши неудачно]
Gui, 2:Add, Text, x890 y180 w300 h20 +BackgroundTrans , [Открытый перелом]
Gui, 2:Add, Text, x890 y210 w300 h20 +BackgroundTrans , [Ожоги]
Gui, 2:Add, Text, x890 y240 w300 h20 +BackgroundTrans , [Проверка на глисты]
Gui, 2:Add, Text, x890 y270 w300 h20 +BackgroundTrans , [Проверка на глисты]
Gui, 2:Add, Text, x890 y300 w300 h20 +BackgroundTrans , [Проверка на глисты удачно]
Gui, 2:Add, Text, x890 y330 w300 h20 +BackgroundTrans , [Проверка на глисты неудачно]
Gui, 2:Add, Text, x890 y360 w300 h20 +BackgroundTrans , [Перелом рёбер]
Gui, 2:Add, Text, x890 y390 w300 h20 +BackgroundTrans , [Перелом рёбер удачно]
Gui, 2:Add, Text, x890 y420 w300 h20 +BackgroundTrans , [Перелом рёбер неудачно]
Gui, 2:Add, Text, x890 y450 w300 h20 +BackgroundTrans , [Перелом позвоночника]
Gui, 2:Add, Text, x890 y480 w300 h20 +BackgroundTrans,  [Удаление позвоночной грыжи]
Gui, 2:Add, Text, x890 y510 w300 h20 +BackgroundTrans , [Дефибриллятор]
Gui, 2:Add, Text, x890 y540 w300 h20 +BackgroundTrans , [Дефибриллятор]
Gui, 2:Add, Text, x890 y570 w300 h20 +BackgroundTrans , [Дефибриллятор]
Gui, 2:Add, Text, x890 y600 w300 h20 +BackgroundTrans , [Клизма]
Gui, 2:Add, Text, x890 y630 w300 h20 +BackgroundTrans , [Клизма]



Gui, 2:Tab, 3
Gui, 2:Font, S10 C000000
Gui, 2:Add, Text, x10 y60 w300 h20 cFF2400 +BackgroundTrans,  /Cколиоз_1
Gui, 2:Add, Text, x10 y90 w300 h20 cFF2400 +BackgroundTrans , /Cколиоз_2
Gui, 2:Add, Text, x10 y120 w300 h20 cFF2400 +BackgroundTrans , /Cколиоз_3
Gui, 2:Add, Text, x10 y150 w300 h20 cFF2400 +BackgroundTrans , /Наркотики_1
Gui, 2:Add, Text, x10 y180 w300 h20 cFF2400  +BackgroundTrans ,/Наркотики_2
Gui, 2:Add, Text, x10 y210 w300 h20 cFF2400  +BackgroundTrans ,/Наркотики_3
Gui, 2:Add, Text, x10 y240 w300 h20 cFF2400 +BackgroundTrans , /Наркотики_4
Gui, 2:Add, Text, x10 y270 w300 h20 cFF2400  +BackgroundTrans ,/Капельница
Gui, 2:Add, Text, x10 y300 w300 h20 cFF2400  +BackgroundTrans ,/Тест_1
Gui, 2:Add, Text, x10 y330 w300 h20 cFF2400 +BackgroundTrans , /Тест_2
Gui, 2:Add, Text, x10 y360 w300 h20 cFF2400 +BackgroundTrans , /Тест_3
Gui, 2:Add, Text, x10 y390 w300 h20 cFF2400 +BackgroundTrans , /Тест_4
Gui, 2:Add, Text, x10 y420 w300 h20 cFF2400 +BackgroundTrans , /Тест_5
Gui, 2:Add, Text, x10 y450 w300 h20 cFF2400 +BackgroundTrans , /ФГДС_1
Gui, 2:Add, Text, x10 y480 w300 h20 cFF2400 +BackgroundTrans , /ФГДС_2
Gui, 2:Add, Text, x10 y510 w300 h20 cFF2400 +BackgroundTrans , /Роды_1
Gui, 2:Add, Text, x10 y540 w300 h20 cFF2400 +BackgroundTrans , /Роды_2
Gui, 2:Add, Text, x10 y570 w300 h20 cFF2400 +BackgroundTrans , /Роды_3
Gui, 2:Add, Text, x10 y600 w300 h20 cFF2400 +BackgroundTrans , /Роды_4
Gui, 2:Add, Text, x10 y630 w300 h20 cFF2400 +BackgroundTrans , /Транс


Gui, 2:Add, Text, x120 y60 w300 h20 +BackgroundTrans , [Проверка на сколиоз]
Gui, 2:Add, Text, x120 y90 w300 h20 +BackgroundTrans , [Проверка на сколиоз  удачно]
Gui, 2:Add, Text, x120 y120 w300 h20 +BackgroundTrans , [Проверка на сколиоз неудачно]
Gui, 2:Add, Text, x120 y150 w300 h20 +BackgroundTrans , [Проверка на наркотики]
Gui, 2:Add, Text, x120 y180 w300 h20 +BackgroundTrans , [Проверка на наркотики]
Gui, 2:Add, Text, x120 y210 w300 h20 +BackgroundTrans , [Проверка на наркотики удачно]
Gui, 2:Add, Text, x120 y240 w300 h20 +BackgroundTrans , [Проверка на наркотики неудачно]
Gui, 2:Add, Text, x120 y270 w300 h20 +BackgroundTrans , [Капельница]
Gui, 2:Add, Text, x120 y300 w300 h20 +BackgroundTrans , [Тест на Беременность]
Gui, 2:Add, Text, x120 y330 w300 h20 +BackgroundTrans , [Тест на Беременность]
Gui, 2:Add, Text, x120 y360 w300 h20 +BackgroundTrans , [Тест на Беременность]
Gui, 2:Add, Text, x120 y390 w300 h20 +BackgroundTrans , [Тест на Беременность удачно]
Gui, 2:Add, Text, x120 y420 w300 h20 +BackgroundTrans , [Тест на Беременность неудачно]
Gui, 2:Add, Text, x120 y450 w300 h20 +BackgroundTrans , [Гастроскопия]
Gui, 2:Add, Text, x120 y480 w300 h20 +BackgroundTrans , [Гастроскопия]
Gui, 2:Add, Text, x120 y510 w300 h20 +BackgroundTrans , [Принятие родов]
Gui, 2:Add, Text, x120 y540 w300 h20 +BackgroundTrans , [Принятие родов удачно]
Gui, 2:Add, Text, x120 y570 w300 h20 +BackgroundTrans , [Принятие родов неудачно]
Gui, 2:Add, Text, x120 y600 w300 h20 +BackgroundTrans , [Принятие родов]
Gui, 2:Add, Text, x120 y630 w300 h20 +BackgroundTrans , [Хирургическая коррекция пола]

Gui, 2:Add, Text, x400 y60 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y75 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y90 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y105 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y120 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y135 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y150 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y165 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y180 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y195 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y210 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y225 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y270 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y285 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y300 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y315 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y330 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y345 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y360 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y375 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y390 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y405 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y420 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y435 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y450 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y465 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y480 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y495 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y510 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y525 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y540 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y555 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y565 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y585 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y600 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y615 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y630 w300 h20 c000000 +BackgroundTrans, |


Gui, 2:Add, Text, x410 y60  w300 h20 cFF2400  +BackgroundTrans , /Матка_1
Gui, 2:Add, Text, x410 y90  w300 h20 cFF2400  +BackgroundTrans , /Матка_2
Gui, 2:Add, Text, x410 y120 w300 h20 cFF2400 +BackgroundTrans , /Матка_3
Gui, 2:Add, Text, x410 y150 w300 h20 cFF2400 +BackgroundTrans , /Матка_4
Gui, 2:Add, Text, x410 y180 w300 h20 cFF2400 +BackgroundTrans , /Матка_5
Gui, 2:Add, Text, x410  y210 w300 h20 cFF2400 +BackgroundTrans, /Цистоскоп_1
Gui, 2:Add, Text, x410  y240 w300 h20 cFF2400 +BackgroundTrans, /Цистоскоп_2
Gui, 2:Add, Text, x410  y270 w300 h20 cFF2400 +BackgroundTrans, /Цистоскоп_3
Gui, 2:Add, Text, x410  y300 w300 h20 cFF2400 +BackgroundTrans ,/Цистоскоп_4
Gui, 2:Add, Text, x410  y330 w300 h20 cFF2400 +BackgroundTrans, /Цистоскоп_5



Gui, 2:Add, Text, x520 y60 w300 h20 +BackgroundTrans ,  [Гистероскопия]
Gui, 2:Add, Text, x520 y90 w300 h20 +BackgroundTrans ,  [Гистероскопия]
Gui, 2:Add, Text, x520 y120 w300 h20 +BackgroundTrans ,[Гистероскопия удачно]
Gui, 2:Add, Text, x520 y150 w300 h20 +BackgroundTrans , [Гистероскопия неудачно]
Gui, 2:Add, Text, x520 y180 w300 h20 +BackgroundTrans , [Гистероскопия]
Gui, 2:Add, Text, x520 y210 w300 h20 +BackgroundTrans , [Цистоскопия]
Gui, 2:Add, Text, x520 y240 w300 h20 +BackgroundTrans , [Цистоскопия]
Gui, 2:Add, Text, x520 y270 w300 h20 +BackgroundTrans , [Цистоскопия удачно]
Gui, 2:Add, Text, x520 y300 w300 h20 +BackgroundTrans , [Цистоскопия неудачно]
Gui, 2:Add, Text, x520 y330 w300 h20 +BackgroundTrans , [Цистоскопия]


Gui, 2:Tab, 4
Gui, 2:Font, S10 C000000
Gui, 2:Add, Text, x10 y60  w300 h20 cFF2400 +BackgroundTrans,   /Голова
Gui, 2:Add, Text, x10 y90  w300 h20 cFF2400  +BackgroundTrans,   /живот
Gui, 2:Add, Text, x10 y120 w300 h20 cFF2400  +BackgroundTrans,   /диарея
Gui, 2:Add, Text, x10 y150 w300 h20 cFF2400  +BackgroundTrans,   /потенция
Gui, 2:Add, Text, x10 y180 w300 h20 cFF2400  +BackgroundTrans,   /геморрой
Gui, 2:Add, Text, x10 y210 w300 h20 cFF2400  +BackgroundTrans,   /ушиб
Gui, 2:Add, Text, x10 y240 w300 h20 cFF2400  +BackgroundTrans,   /ожог
Gui, 2:Add, Text, x10 y270 w300 h20 cFF2400  +BackgroundTrans,   /витамин
Gui, 2:Add, Text, x10 y300 w300 h20 cFF2400  +BackgroundTrans,   /тошнота
Gui, 2:Add, Text, x10 y330 w300 h20 cFF2400  +BackgroundTrans,   /изжога
Gui, 2:Add, Text, x10 y360 w300 h20 cFF2400  +BackgroundTrans,   /насморк
Gui, 2:Add, Text, x10 y390 w300 h20 cFF2400  +BackgroundTrans,   /мигрень
Gui, 2:Add, Text, x10 y420 w300 h20 cFF2400  +BackgroundTrans,   /мочевой
Gui, 2:Add, Text, x10 y450 w300 h20 cFF2400  +BackgroundTrans,   /печень
Gui, 2:Add, Text, x10 y480 w300 h20 cFF2400  +BackgroundTrans,   /aллергия
Gui, 2:Add, Text, x10 y510 w300 h20 cFF2400  +BackgroundTrans,   /сердце
Gui, 2:Add, Text, x10 y540 w300 h20 cFF2400  +BackgroundTrans,   /простуда
Gui, 2:Add, Text, x10 y570 w300 h20 cFF2400  +BackgroundTrans,   /кашельс
Gui, 2:Add, Text, x10 y600 w300 h20 cFF2400  +BackgroundTrans,   /кашельв
Gui, 2:Add, Text, x10 y630 w300 h20 cFF2400  +BackgroundTrans,   /диабет

Gui, 2:Add, Text, x400 y60 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y75 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y90 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y105 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y120 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y135 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y150 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y165 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y180 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y195 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y210 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y225 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y240 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y255 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y270 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y285 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y300 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y315 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y330 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y345 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y360 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y375 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y390 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y405 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y420 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y435 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y450 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y465 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y480 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y495 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y510 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y525 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y540 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y555 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y565 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y585 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y600 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y615 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y630 w300 h20 c000000   +BackgroundTrans, |

Gui, 2:Add, Text, x100 y60 w300 h20 c000000   +BackgroundTrans,  [Выписать:Миг]
Gui, 2:Add, Text, x100  y90 w300 h20 c000000   +BackgroundTrans, [Выписать:Но-Шпу]
Gui, 2:Add, Text, x100  y120 w300 h20 c000000   +BackgroundTrans, [Выписать:Активированый уголь]
Gui, 2:Add, Text, x100  y150 w300 h20 c000000   +BackgroundTrans, [Выписать:Виагру]
Gui, 2:Add, Text, x100 y180 w300 h20  c000000   +BackgroundTrans, [Выписать:Свечи Релиф]
Gui, 2:Add, Text, x100  y210 w300 h20 c000000   +BackgroundTrans, [Выписать:Фастум-гель]
Gui, 2:Add, Text, x100  y240 w300 h20 c000000   +BackgroundTrans, [Выписать:Пантенол]
Gui, 2:Add, Text, x100 y270 w300 h20  c000000   +BackgroundTrans, [Выписать:Унивит]
Gui, 2:Add, Text, x100 y300 w300 h20  c000000   +BackgroundTrans, [Выписать:Церукал]
Gui, 2:Add, Text, x100  y330 w300 h20 c000000   +BackgroundTrans, [Выписать:Омепразол]
Gui, 2:Add, Text, x100 y360 w300 h20  c000000   +BackgroundTrans, [Выписать:Отривин]
Gui, 2:Add, Text, x100 y390 w300 h20  c000000   +BackgroundTrans, [Выписать:Амигренин]
Gui, 2:Add, Text, x100 y420 w300 h20  c000000   +BackgroundTrans, [Выписать:Цистон]
Gui, 2:Add, Text, x100 y450 w300 h20  c000000   +BackgroundTrans, [Выписать:Гепабене]
Gui, 2:Add, Text, x100 y480 w300 h20  c000000   +BackgroundTrans, [Выписать:Зодак]
Gui, 2:Add, Text, x100 y510 w300 h20  c000000   +BackgroundTrans, [Выписать:Кардиомагнил]
Gui, 2:Add, Text, x100 y540 w300 h20  c000000   +BackgroundTrans, [Выписать:Терафлю]
Gui, 2:Add, Text, x100 y570 w300 h20  c000000   +BackgroundTrans, [Выписать:Лазолван]
Gui, 2:Add, Text, x100 y600 w300 h20  c000000   +BackgroundTrans, [Выписать:Амбробене]
Gui, 2:Add, Text, x100 y630 w300 h20  c000000   +BackgroundTrans, [Выписать:Диабетон]

Gui, 2:Add, Text, x410 y60 w300 h20 cFF2400 +BackgroundTrans, /горло
Gui, 2:Add, Text, x410 y90 w300 h20 cFF2400 +BackgroundTrans, /глаза
Gui, 2:Add, Text, x410 y120 w300 h20 cFF2400 +BackgroundTrans, /судороги
Gui, 2:Add, Text, x410 y150 w300 h20 cFF2400 +BackgroundTrans, /уши
Gui, 2:Add, Text, x410 y180 w300 h20 cFF2400 +BackgroundTrans, /почки
Gui, 2:Add, Text, x410 y210 w300 h20 cFF2400 +BackgroundTrans, /суставы
Gui, 2:Add, Text, x410 y240 w300 h20 cFF2400 +BackgroundTrans, /давлениев
Gui, 2:Add, Text, x410 y270 w300 h20 cFF2400 +BackgroundTrans, /давлениен
Gui, 2:Add, Text, x410 y300 w300 h20 cFF2400 +BackgroundTrans, /яйца
Gui, 2:Add, Text, x410 y330 w300 h20 cFF2400 +BackgroundTrans, /сон
Gui, 2:Add, Text, x410 y360 w300 h20 cFF2400 +BackgroundTrans, /зрение
Gui, 2:Add, Text, x410 y390 w300 h20 cFF2400 +BackgroundTrans, /память
Gui, 2:Add, Text, x410 y420 w300 h20 cFF2400 +BackgroundTrans, /укачивание
Gui, 2:Add, Text, x410 y450 w300 h20 cFF2400 +BackgroundTrans, /курение
Gui, 2:Add, Text, x510 y60 w300 h20 c000000 +BackgroundTrans, [Выписать:Гексорал]
Gui, 2:Add, Text, x510 y90 w300 h20 c000000 +BackgroundTrans, [Выписать:Визин]
Gui, 2:Add, Text, x510 y120 w300 h20 c000000 +BackgroundTrans, [Выписать:Магнелис]
Gui, 2:Add, Text, x510 y150 w300 h20 c000000 +BackgroundTrans, [Выписать:Отинум
Gui, 2:Add, Text, x510 y180 w300 h20 c000000 +BackgroundTrans, [Выписать:Уролисан]
Gui, 2:Add, Text, x510 y210 w300 h20 c000000 +BackgroundTrans, [Выписать:Фастум-гель]
Gui, 2:Add, Text, x510 y240 w300 h20 c000000 +BackgroundTrans, [Выписать:Андипал]
Gui, 2:Add, Text, x510 y270 w300 h20 c000000 +BackgroundTrans, [Выписать:Норадреналин]
Gui, 2:Add, Text, x510 y300 w300 h20 c000000 +BackgroundTrans, [Выписать:Амоксиклав]
Gui, 2:Add, Text, x510 y330 w300 h20 c000000 +BackgroundTrans, [Выписать:Персен Ночь]
Gui, 2:Add, Text, x510 y360 w300 h20 c000000 +BackgroundTrans, [Выписать:Виталюкс]
Gui, 2:Add, Text, x510 y390 w300 h20 c000000 +BackgroundTrans, [Выписать:Эвалар]
Gui, 2:Add, Text, x510 y420 w300 h20 c000000 +BackgroundTrans, [Выписать:Драмина]
Gui, 2:Add, Text, x510 y450 w300 h20 c000000 +BackgroundTrans, [Выписать:Табекс]

Gui, 2:Add, Text, x800 y60 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x800 y75 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x800 y90 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x800 y105 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y120 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y135 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y150 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y165 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y180 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y195 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y210 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y225 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y240 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y255 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y270 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y285 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y300 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y315 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y330 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y345 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y360 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y375 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y390 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y405 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y420 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y435 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y450 w300 h20 c000000   +BackgroundTrans, |

Gui, 2:Tab
Gui, 2:Font, s12
Gui, 2:Add, Text, x10 y670 w1220 h20 c000000 +BackgroundTrans,  ✅ КПРП 2019-2021. Demo 7.8 Нажмите alt+p для паузы скрипта.
Gui, 2:Show



