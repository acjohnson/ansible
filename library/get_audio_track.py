#!/usr/bin/env python3

import subprocess
import json
from ansible.module_utils.basic import AnsibleModule


def get_audio_track(input_file):
    # Run ffprobe to get audio stream information
    ffprobe_cmd = [
        'ffprobe',
        '-v', 'quiet',
        '-print_format', 'json',
        '-show_streams',
        '-select_streams', 'a',
        input_file
    ]
    output = subprocess.check_output(ffprobe_cmd)
    info = json.loads(output)
    audio_streams = info['streams']

    # Find the index of the English audio track
    english_track_index = None
    for i, audio_stream in enumerate(audio_streams):
        if 'tags' in audio_stream and 'language' in audio_stream['tags'] and audio_stream['tags']['language'].lower() == 'eng':
            english_track_index = i
            break

    if english_track_index is None:
        # If no English audio track is found, use the first audio track
        english_track_index = 0

    return english_track_index


def main():
    module = AnsibleModule(
        argument_spec=dict(
            input_file=dict(required=True, type='str'),
        )
    )

    input_file = module.params['input_file']

    try:
        audio_track = get_audio_track(input_file)
        module.exit_json(changed=False, audio_track=audio_track)
    except subprocess.CalledProcessError as e:
        module.fail_json(msg="Failed to get audio track: {}".format(str(e)))


if __name__ == '__main__':
    main()
