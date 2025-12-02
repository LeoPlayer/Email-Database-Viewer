import json
import ctypes
import tkinter as tk
from tkinter import ttk
from UIFactories import pane_factory
from CustomWidgets.left_frame import LeftFrame
from CustomWidgets.right_frame import RightFrame
from helpers import *

INIT_WIN_WIDTH = 1000
INIT_WIN_HEIGHT = 800


class Application(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)

        # STYLE
        self.style = ttk.Style(self)
        try:
            with open("style.json") as json_file:
                json_data = json.load(json_file)
                for t in json_data:
                    parameters = {}
                    for p in json_data[t]:
                        parameters.update({p: json_data[t][p]})
                    if len(parameters) != 0:
                        self.style.configure(t, **parameters)
        except Exception as e:
            print(e)

        # WINDOW SIZE AND POSITION
        # noinspection PyUnresolvedReferences
        self.master.title("Email Database Viewer")
        screen_width = self.master.winfo_screenwidth()
        screen_height = self.master.winfo_screenheight()
        pos_x = (screen_width - INIT_WIN_WIDTH) // 2
        pos_y = (screen_height - INIT_WIN_HEIGHT) // 2
        # noinspection PyUnresolvedReferences
        self.master.geometry(f"{INIT_WIN_WIDTH}x{INIT_WIN_HEIGHT}+{pos_x}+{pos_y}")

        # TOOLBAR
        pane_factory.set_toolbar(self.master, self)

        # PANES
        self.pw = ttk.PanedWindow(orient=tk.HORIZONTAL)
        self.pw.pack(fill=tk.BOTH, expand=1)
        left = LeftFrame(self.pw)
        # left.pack(fill=tk.BOTH, expand=True)
        self.pw.add(left, weight=0)
        right = RightFrame(self.pw)
        # change to 0 when viewer added
        self.pw.add(right, weight=1)

        # SET SASH POSITION
        self.update()
        self.pw.sashpos(0, 170)

    def get_sash_pos(self, index):
        print(self.pw.sashpos(index))


if __name__ == "__main__":
    root = tk.Tk()
    print()
    root.option_add('*tearOff', tk.FALSE)

    # Use ctrl+left click as right click on Mac
    if root.tk.call("tk", "windowingsystem") == "aqua":
        root.event_add("<<ContextMenu>>", "<Control-Button-1>")
    # Change dpi for windows
    elif root.tk.call("tk", "windowingsystem") == "win32":
        ctypes.windll.shcore.SetProcessDpiAwareness(True)

    app = Application(root)

    pane_factory.set_menu(root)

    app.mainloop()
