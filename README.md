# Создание скриншотов в RobotFramework

### 1. Создание скриншотов в отчетах, с помощью ключевых слов RobotFramework'а.
Сделать скриншот в любом месте теста, на проверяемых страницах, можно с помощью встроенных в библиотеку SeleniumLibrary ключевых слов:
- **Capture Page Screenshot** - данное ключевое слово позволяет создать скриншот полностью всей страницы. В том месте автотеста, где оно было вызвано. 
Более подробную информацию о данном кейворде и его аргументах, можно почитать здесь - https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Capture%20Page%20Screenshot.
- **Capture Element Screenshot** - данное ключевое слово позволяет создать скриншот отдельного элемента на странице. 
Идентифицированного локатором, переданным в это ключевое слово, в качестве аргумента.
Более подробную информацию о данном кейворде и его аргументах, можно почитать здесь - https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Capture%20Element%20Screenshot.

Оба этих ключевых слова создают скриншоты, которые потом добавляются в общий файл отчета, о пройденных автотестах. 

#### Примеры использования в тестах:
    Open browser on the index page
        [Arguments]     ${url}      ${type_browsers}
        # Открываем браузер на главной странице
        Open Browser    ${url}      browser=${type_browsers}
        Maximize Browser Window
        # Делаем скриншот всей страницы, с помощью ключевого слова Capture Page Screenshot, чтобы убедиться, что мы находимся на главной странице.
        Capture Page Screenshot

    Open browser on the internal page
        [Arguments]     ${url}      ${type_browsers}
        # Открываем браузер на внутренней странице
        Open Browser    ${url}      browser=${type_browsers}
        Maximize Browser Window
        # Делаем скриншот отдельного блока, с помощью ключевого слова Capture Element Screenshot, чтобы убедиться, что он находится на странице.
        Capture Element Screenshot    id:image_id


### 2. Создание скриншотов страниц, с помощью библиотеки Screenshot. 
Ссылка на документацию библиотеки - https://robotframework.org/robotframework/latest/libraries/Screenshot.html. 

Эта библиотека имеет ряд ключевых слов, позволяющих создавать скриншоты внутри автотестов. 
Которые потом встраиваются в файл отчета, о пройденных автотестах.

### 3. Создание скриншотов страниц, внутри вспомогательных python-файлов.

Если в автотестах есть вспомогательные файлы на python(кастомные библиотеки кейвордов, лиснеры и т.д.), 
то внутри данных файлов, также можно делать скриншоты, которые потом будут встраиваться в общий файл с отчетностью. 
Используя возможности api библиотек RobotFramework'а. 

Более подробную информацию о ```api RobotFramework'а```, можно почитать здесь https://robot-framework.readthedocs.io/en/master/index.html.

Например, используя методы модуля BuiltIn - https://robot-framework.readthedocs.io/en/master/_modules/robot/libraries/BuiltIn.html, 
можно создавать скриншоты страниц, в python-файлах, **примерно так**:

    # Импортируем модуль BuiltIn, в файл.
    from robot.libraries.BuiltIn import BuiltIn 

    # Далее в необходимом методе, например если это лиснер RobotFramework'а, можно в его лог методе, делать скриншот страницы, в случае сбоя теста:    
    def log_message(self, msg):
        if msg.level == 'FAIL' and not msg.html:
            msg.html = True

            self.msg_level = msg.level

            # Получаем скриншот страницы, где не прошел тест, используя методы библиотеки BuiltIn. Для добавления его в файл отчета. 
            s2l = BuiltIn().get_library_instance('SeleniumLibrary')
            s2l.capture_page_screenshot()
            s2l.close_browser()

### 4. Дополнительные возможности, по работе с изображениями на RobotFramework'е.

Иногда, в рамках создания автотестов на RobotFramework'е, могут встречаться не совсем тривиальные задачи. Связанные с созданием скриншотов страниц. 
Например, может быть задача, когда нужно вначале сделать скриншот встроенными кейвордами, а потом после этого скриншота, 
добавить еще какое-либо статическое изображение в отчет. Из своей локальной директории. 

Решить эту задачу, можно **примерно так**:

Создав свой кастомный кейворд и указав его в параметре ```run_on_failure```, при импорте библиотеки SeleniumLibrary.

Данный параметр, по умолчанию, вызывает встроенный кейворд ```Capture Page Screenshot```, который делает скриншот страницы, в случае сбоя тестов. 

Это поведение, в случае сбоя тестов, можно переопределить, создав свой собственный кейворд и добавив его в качестве значения, для параметра - ```run_on_failure```:

    Library         SeleniumLibrary    run_on_failure=Create Page Screenshot

Далее создаем реализацию пользовательского кейворда ```Create Page Screenshot```:
    
    # Создание скриншотов в тесте, при сбое теста
    Create Page Screenshot
        # Создаем снимок экрана с помощью встроенного ключевого слова.
        Capture Page Screenshot
        # Вставляем нужное изображение в отчет, после скриншота. 
        # Используя возможности метода Log, которые позволяют встраивать html-код, внутри лог-сообщения. 
        # В том числе и изображения:
        Log    <img src="/pictures/3.jpg" width="802px">    html=true
        # Закрываем браузер
        Close Browser

[Ссылка на результат выполнения](https://drive.google.com/file/d/1yuUrjjTqK61E6Ul_tCCVJgBAR6h7DQHQ/view?usp=share_link), данного кейворда.

### 5. Отключение создания скриншотов, при сбое тестов. 
5.1 Иногда может понадобиться, вообще отключать создание скриншотов, при сбое тестов. 
Например, если скриншотов очень много и файл журнала, становится очень большим по размеру, что начинает сильно замедлять выполнение тестов. 
То можно просто отключить поведение по умолчанию, в импорте библиотеки SeleniumLibrary. 

Указав в параметре ```run_on_failure```, значение **NONE** или **NOTHING**:

    Library         SeleniumLibrary    run_on_failure=Nothing 

В данном случае скриншоты перестанут создаваться, при не отработавших тестах. 

5.2 Еще можно отключить поведение по умолчанию, используя ключевое слово ```Register Keyword To Run On Failure```.
https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Register%20Keyword%20To%20Run%20On%20Failure. 

Например:

    Open Browser
    # Выключаем создание скриншотов, используя параметр NONE или NOTHING, ключевого слова Register Keyword To Run On Failure.
    Register Keyword To Run On Failure      NONE 

### 6. Возможность управления созданием скриншотов, при сбоях в тестах.

Иногда может понадобиться возможность управления созданием скриншотов в тестах, при сбоях. 
Это можно сделать при помощи ключевого слова - ```Run Keyword If Test Failed```.
Например, в случае если все-таки тест не прошел, то в секции ```Teardown```, можно создать скриншот страницы, на которой произошел сбой теста:

    Teardown
        Run Keyword If Test Failed    Capture Page Screenshot 

