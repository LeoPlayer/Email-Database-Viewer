import tkinter as tk
from tkinter import ttk
from list_scrollable import ListScrollable


INIT_WIN_WIDTH = 1000
INIT_WIN_HEIGHT = 800


def menu_temp_func():
    print("button pressed")

    
class Application(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)

        # style = custom_style.CreateStyle()
        self.style = ttk.Style(self)
        self.style.configure('TPanedwindow', background="gray50")
        self.style.configure('Sash', sashthickness=5)
        self.style.configure("TFrame", background="red")

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

        # TOOLBAR
        self.frame_toolbar = ttk.Frame(self.master)
        import_button = ttk.Button(master=self.frame_toolbar, text="Import", command=self.temp_import_func)
        import_button.pack(side=tk.LEFT, padx=(5, 0))
        self.frame_toolbar.pack(fill=tk.X)

        # PANES
        self.pw = ttk.PanedWindow(orient=tk.HORIZONTAL)
        self.pw.pack(fill=tk.BOTH, expand=1)
        left = ttk.Frame(self.pw)
        self.pw.add(left)
        right = ttk.Frame(self.pw)
        self.pw.add(right)

        # LEFT LIST
        ListScrollable(left, "left data")

        ListScrollable(right, "right data")

        # SET SASH POSITION
        self.update()
        self.pw.sashpos(0, 170)

    def temp_import_func(self):
        print(self.pw.sashpos(0))


if __name__ == "__main__":
    root = tk.Tk()
    app = Application(root)

    # MENU (comment to see Tkinter Demo)
    menu_bar = tk.Menu(root)
    file_menu = tk.Menu(menu_bar, tearoff=0)
    file_menu.add_command(label="New", command=menu_temp_func)
    file_menu.add_command(label="Open", command=menu_temp_func)
    file_menu.add_command(label="Save", command=menu_temp_func)
    file_menu.add_separator()
    file_menu.add_command(label="Quit", command=root.quit)
    menu_bar.add_cascade(label="File", menu=file_menu)
    root.config(menu=menu_bar)

    app.mainloop()
