import logging

from slackclient import SlackClient

logger = logging.getLogger(__name__)

# Функционал отправляющий сообщения в слак от бота.
slack_client = SlackClient('YOUR_TOKEN')

# Функция формирующая текст с ошибками, для отправления его в чат ботом.
def message_text_formation(url, text_message):
    message_slack = f'Ошибка на {url}: {text_message}'
    print(message_slack)

    # Вызываем функцию, отправляющую сообщения в чат.
    send_message(message_slack)

def send_message(msg):
    slack_client.api_call(
        "chat.postMessage",
        channel='for-experiments-bot-automated-tests',
        text=msg,
        username='bot_autotest',
        icon_emoji=':robot_face:'
    )

