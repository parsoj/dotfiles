# In ~/.config/ipython/profile_default/startup/00-aliases.py
from IPython.core.magic import Magics, magics_class, line_magic

@magics_class
class CustomExitMagics(Magics):
    @line_magic
    def q(self, line=''):
        """Exit IPython session."""
        self.shell.ask_exit()

try:
    ip = get_ipython()
    if ip:
        ip.register_magics(CustomExitMagics)
        # print("Custom 'q' magic command to exit IPython loaded.")
except NameError:
    # This handles cases where the script might be run outside an IPython session
    pass
except Exception as e:
    # print(f"Error loading custom 'q' magic for IPython: {e}")
    pass