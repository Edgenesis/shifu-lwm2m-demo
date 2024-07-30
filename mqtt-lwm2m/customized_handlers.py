import json

# input
# {"xAngle":-73.08371735,"yAngle":-90}


def XAngle(raw_data):
    return json.loads(raw_data["mqtt_message"])["xAngle"]


def YAngle(raw_data):
    return json.loads(raw_data["mqtt_message"])["yAngle"]


def raw_value(raw_data):
    print(raw_data["mqtt_message"])
    return raw_data["mqtt_message"]
