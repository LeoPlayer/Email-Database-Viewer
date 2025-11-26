import json
import tkinter as tk
from tkinter import ttk
from UIFactories.pane_factory import set_menu, set_toolbar, create_left_pane, create_right_pane

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
                print(json_data)
        except Exception as e:
            print(e)

        # WINDOW SIZE AND POSITION
        # noinspection PyUnresolvedReferences
        self.master.title("Email Database Viewer")
        self.master["bg"] = "white"
        screen_width = self.master.winfo_screenwidth()
        screen_height = self.master.winfo_screenheight()
        pos_x = (screen_width - INIT_WIN_WIDTH) // 2
        pos_y = (screen_height - INIT_WIN_HEIGHT) // 2
        # noinspection PyUnresolvedReferences
        self.master.geometry(f"{INIT_WIN_WIDTH}x{INIT_WIN_HEIGHT}+{pos_x}+{pos_y}")

        set_toolbar(self.master)

        # PANES
        self.pw = ttk.PanedWindow(orient=tk.HORIZONTAL)
        self.pw.pack(fill=tk.BOTH, expand=1)
        left = create_left_pane(self)
        self.pw.add(left)
        right = create_right_pane(self)
        self.pw.add(right)

        # SET SASH POSITION
        self.update()
        self.pw.sashpos(0, 170)


if __name__ == "__main__":
    root = tk.Tk()
    app = Application(root)

    set_menu(root)

    app.mainloop()
