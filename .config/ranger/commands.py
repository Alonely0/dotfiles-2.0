from ranger.api.commands import Command
from ranger_udisk_menu.mounter import mount
import os


class asusctl(Command):
    """
    :asusctl <args>
    
    Send commands to asusctl
    """

    def execute(self):
        if self.arg(1) == "static":
            os.system(f"asusctl led-mode static -c {self.arg(2)}")
        else:
            os.system(f"asusctl led-mode {self.arg(1)}")
