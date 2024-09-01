import datetime


def timestamp_to_json(results):
    # Инициализация списка
    data = []

    # Обработка результатов
    for row in results:
        timestamp = row[0]

        # Преобразование timestamp в JSON-совместимый формат
        # (в зависимости от ваших требований)
        if isinstance(timestamp, datetime.datetime):
            timestamp_json = timestamp.isoformat()
        elif isinstance(timestamp, datetime.date):
            timestamp_json = timestamp.isoformat()
        else:
            timestamp_json = str(timestamp)

        # Добавление timestamp в список
        data.append({"timestamp": timestamp_json})
    return data
