# Данный файл с ресурсами объединяет 2 вида автотестов: ui и api. Чтобы показать в тестовом, сразу два вида автотестов.
# В идеале конечно нужно разделять эти два вида автотестов, на 2 файла ресурсов.

# Подключаем возможные необходимые, для работы библиотеки.
*** Settings ***
Documentation   Keywords for check work buttons
Library         SeleniumLibrary    timeout=30.0    screenshot_root_directory=./screenshot     run_on_failure=Create Page Screenshot
Library         Collections
Library         DateTime
Library         String
Library	        Screenshot
Library         RequestsLibrary
Library         DateTime
Library         String
Library         ../../Library/SeleniumLibraryHelper.py
# Подключаем общие для всех тестов, page object переменные.
Variables       ${EXECDIR}${/}page_objects/Elements.py

*** Variables ***
# Создаем переменные с базовыми url, для тест-кейсов по ui и api автотестам.
${url_ui}      https://www.google.com/
${url_api}         https://reqres.in


*** Keywords ***
#---ОБЩИЕ КЛЮЧЕВЫЕ СЛОВА, КАК ДЛЯ UI, ТАК И ДЛЯ API АВТОТЕСТОВ----#

# UI:
# Открываем браузер.
Open browser on the page
    [Arguments]     ${url}      ${type_browsers}
    Open Browser    ${url}      browser=${type_browsers}
    #Set Window Size     1600	900
    Maximize Browser Window
    Set Suite Variable     ${name_browsers}    ${type_browsers}

# Завершаем тест
Finish the test
    # Закрываем браузер и завершаем тест.
    [Teardown]    Close Browser
    Sleep   2

# Создание скриншотов в тесте, при сбое теста
Create Page Screenshot
    # Создание снимка экрана с помощью встроенного ключевого слова
    Capture Page Screenshot
    # Вставить нужное изображение в отчет, после скриншота
    Log    <b style="color:#15c; font-size:16px;">Insert your image, after the screenshot:<b>	INFO	html=true
    Log    <img src="/pictures/3.jpg" width="802px">    html=true
    # Закрываем браузер
    Close Browser


# API:
Создать соединение
    Create session     conn     ${url_api}    disable_warnings=1

Закрыть все соединения
    Delete all sessions

Check Status 200
    [Arguments]    ${url}
    ${response}     GET On Session       conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!
    ...                 msg=При выполнении GET ${url} был получен код состояния, отличный от 200 ОК.















