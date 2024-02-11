import math

def get_opacity_hex_value(opacity: int):
    if opacity > 255 or opacity < 0:
        opacity = 255
    return '%02x' % math.ceil(((opacity / 100) * 255))

def add_opacity_to_hex(hex_code: str, opacity: int):
    opacity_value = get_opacity_hex_value(opacity)
    return f"{hex_code}{opacity_value}"