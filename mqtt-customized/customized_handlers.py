import json
import math
# input
# {"xAngle":-73.08371735,"yAngle":-90}


# output
# -73.08371735
def XAngle(raw_data):
    return json.loads(raw_data["mqtt_message"])["xAngle"]

# output
# -90
def YAngle(raw_data):
    return json.loads(raw_data["mqtt_message"])["yAngle"]


def raw_value(raw_data):
    print(raw_data["mqtt_message"])
    return raw_data["mqtt_message"]
