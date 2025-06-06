"""
GPU WIDGET
The install.sh script COPY this file to /usr/lib/python3.13/site-packages/libqtile/widget/gpu.py
Then this widget is imported and used as qtile_extras.widget.gpu.GPU, BECAUSE IF YOU IMPORT IT WITH utils.gpu_widget.GPU THE STYLE IS FUCKED UP don't ask me why.
"""

import subprocess
from libqtile.widget import base


class GPU(base.ThreadPoolText):
    """
    Widget to show NVIDIA GPU usage % by parsing `nvidia-smi` output.
    Updates every 5 seconds.
    """

    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("update_interval", 5.0, "Update interval in seconds"),
        ("format", "{usage}%", "Display format"),
    ]

    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(GPU.defaults)

    def poll(self):
        try:
            # Run nvidia-smi and get GPU utilization
            output = subprocess.check_output(
                ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"],
                encoding="utf-8"
            )
            usage = output.strip()
            return self.format.format(usage=usage)
        except Exception:
            # In case of error or no NVIDIA GPU, show N/A
            return self.format.format(usage="N/A")