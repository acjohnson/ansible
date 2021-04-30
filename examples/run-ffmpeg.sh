#!/bin/bash

date

# remove broken files...
/usr/bin/find /library/TV\ Shows/ -name "*RECODE*" -size 44c -exec rm -f {} \;

# only run if ffmpeg isn't running
for pid in $(pidof ffmpeg); do
    if [ $pid != $$ ]; then
        echo "[$(date)] : Process is already running with PID $pid"
        exit 1
    fi
done

#source /root/ansible/venv/bin/activate

ansible-playbook -i 127.0.0.1, /root/ansible/playbook_ffmpeg.yml -e "ansible_python_interpreter=/usr/bin/python3"
ansible-playbook -i 127.0.0.1, /root/ansible/playbook_ffmpeg.yml -e "find_base=/library/Movies/ min_file_size=2300m ansible_python_interpreter=/usr/bin/python3"

date
#deactivate
