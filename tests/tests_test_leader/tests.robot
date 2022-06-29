*** Settings ***
Documentation   Tests test leader.
Library     ../../Library/SeleniumLibraryHelper.py
# Подключаем файл с основными переменными и ключевыми словами из папки ${EXECDIR}${/}resources/.
Resource        ${EXECDIR}${/}resources/functional_tests/resources.robot    # Ключевые слова, для данных автотестов.
# Прописываем необходимые теги, для запуска данных тестов, в каких-либо тестовых наборах.
Default Tags    Smoke  Regression  Sanitaze  No_parallel




*** Test Cases ***
# Создаем в тест-кейсах, 2 основных теста данного набора. По ui и api проверкам.
Проверить поиск google
    [Tags]              Проверка работы поиска google
    # Основное ключевое слово, для данного тест-кейса.
     Check google search        ${url_ui}

Получение информации о пользователях
    [Tags]              Информация о пользователях
    # Создаем переменную содержащую необходимый эндпоинт.
    ${url_single_user} =	Set Variable	/api/single_user
    # Открываем соединение с базовым url.
    Создать соединение
    # Основное ключевое слово, для данного тест-кейса. В котором будем производить api-запрос и делать проверки.
    Getting information about users       ${url_single_user}
    # Закрываем соединение.
    Закрыть все соединения


*** Keywords ***
# КЛЮЧЕВЫЕ СЛОВА, по 2 основным тестам данного набора. По ui и api проверкам.

Check google search
    [Arguments]     ${url}
    # Открываем браузер на главной странице google.
    Open browser on the page      ${url}      ${browser}  # Определяет тип браузера в котором будет произв. проверка. Прописывается в аргум. запуска: --variable BROWSER:chrome.

    # Создаем переменную с текстом ошибки, если проверка в данном ключевом слове не отработала. Для отправления этого текста в слак.
    Set Suite Variable      ${text_message}    на страничке не отработали 1 или 2 проверки.


    # Вводим в строку поиска 'купить кофемашину bork c804' и нажимаем кнопку 'Поиск в Google'.
    Wait until Page Contains Element	${google_input_search}
    Press Keys      xpath: ${google_input_search}        купить кофемашину bork c804
    # Wait Until Element Is Visible   xpath: ${google_button_search}    timeout=20s
    # Click Element   xpath: ${google_button_search}

    # Т.к. submit ${google_button_search}, перекрывает выпадающий список, вместо него нажимаем 'Enter'.
    Press Keys     xpath: ${google_input_search}    RETURN
    sleep  5

    # Проверяем, что на странице результатов присутствует - mvideo.ru.
    Page Should Contain     mvideo!.ru
    log to console      Страница с результатами содержит mvideo.ru.

     # Проверяем, что на странице результатов, результатов указанного поиска 'купить кофемашину bork c804', больше 10.
    Wait until Page Contains Element	${google_titles_result}
    ${titles_result_count}   Get Element Count   xpath: ${google_titles_result}
    Should Be True	${titles_result_count} > 10        msg=Результатов по 'купить кофемашину bork c804' менее 10!
    log to console      На странице результатов поиска google, результатов по 'купить кофемашину bork c804' - больше 10.

    # Если данное ключевое слово отработало без ошибок, создаем переменную ${success} со значением True, для продолжения теста.
    ${success} =    Set Variable    True
    [Return]    ${success}

    # Закрываем браузер.
    Finish the test


Getting information about users
    [Arguments]     ${url}
    # Создаем переменную сьюита содержащую url данного запроса, необходимый для отправления его в слак. В случае, если запрос по указанному url не отработал.
    Set Suite Variable     ${REQUEST_URL}    ${url}

    # Вызываем ключевое слово, проверяющее статус ответа, по указанному url. Он должен быть равен 200.
    Check Status 200        ${url}
    # Проверяем, после отправления get-запроса, что третье значение поля name, в data, равно 'true red'.
    ${response}     GET On Session        conn     ${url}
                    Should be equal    ${response.json()["data"][2]['name']}      true red       msg=Name of the third value in data, is not 'true red'!
    log to console      Status code = 200, Name of the third value in data, equal - 'true red'.



