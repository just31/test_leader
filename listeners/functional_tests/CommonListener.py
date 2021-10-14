import logging

from robot.libraries.BuiltIn import BuiltIn
from urllib.parse import urlparse

# Импортируем все необходимые функции из вспомогательного модуля utils:
import sys
sys.path.append("listeners/")
from utils import *

logger = logging.getLogger(__name__)

# Формируем класс, для общего листенера, по функциональным тестам.
class CommonListener(object):
    ROBOT_LISTENER_API_VERSION = 3

    # В конструкторе класса, можем принимать различные переменные, переданные в аргументах запуска 'args'. Например можно передать название теста.
    def __init__(self, args):
        self.ROBOT_LIBRARY_LISTENER = self

        self.test_name = args

    # Метод отлавливающий ошибки, в прохожении всех тест-кейсов. И формирующий текст для сообщения в слак, по ним.
    def log_message(self, msg):
        if msg.level == 'FAIL' and not msg.html:
            msg.html = True

            self.msg_level = msg.level

            # Получаем переменные с текстом ошибки, для отравления его в слак. И с url странички.
            text_message = BuiltIn().get_variable_value('${text_message}')
            url = BuiltIn().get_variable_value('${url}')

            # Вызываем функцию, формирующую текст для слака.
            message_text_formation(url, text_message)

    # Метод вызывающийся в конце всего тестового прогона.
    # Его можно использовать в тестах, в которых необходимо совершать какие либо действия, после прогона всего тестового набора.
    def close(self):
        pass
