#!/bin/bash

systemctl --user status pipewire


pactl info |grep "Server Name" --color
pactl list sinks
pactl list sinks |grep -E 'Name:|State:' --color

