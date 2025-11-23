import tkinter as tk
from tkinter import ttk

INIT_WIN_WIDTH = 1000
INIT_WIN_HEIGHT = 800

def temp_import_func():
    print("import button pressed")


class Application(tk.Frame):
    def __init__(self, master: tk.Tk):
        super().__init__(master)

        # noinspection PyUnresolvedReferences
        self.master.title("Email Database Viewer")
        screen_width = self.master.winfo_screenwidth()
        screen_height = self.master.winfo_screenheight()
        pos_x = (screen_width - INIT_WIN_WIDTH) // 2
        pos_y = (screen_height - INIT_WIN_HEIGHT) // 2

        # noinspection PyUnresolvedReferences
        self.master.geometry(f"{INIT_WIN_WIDTH}x{INIT_WIN_HEIGHT}+{pos_x}+{pos_y}")

        frame_toolbar = tk.Frame(self.master, bg="gray90")

        import_button = tk.Button(master=frame_toolbar, text="Import", command=temp_import_func)
        import_button.pack(side=tk.LEFT, padx=(5, 0))

        frame_toolbar.pack(fill=tk.X)


if __name__ == "__main__":
    root = tk.Tk()
    app = Application(master=root)
    app.mainloop()

# def menu_command():
#     print("メニューが選択されました")
#
# menubar = tk.Menu(root)
# filemenu = tk.Menu(menubar, tearoff=0)
# filemenu.add_command(label="新規", command=menu_command)
# filemenu.add_command(label="開く", command=menu_command)
# filemenu.add_command(label="保存", command=menu_command)
# filemenu.add_separator()
# filemenu.add_command(label="終了", command=root.quit)
# menubar.add_cascade(label="ファイル", menu=filemenu)
#
# root.config(menu=menubar)


# # ウィジェットの配置
# label = tk.Label(root, text="Label")
# label.place(x=50, y=50)
#
# button = tk.Button(root, text="Button")
# button.place(relx=0.5, rely=0.5, anchor=tk.CENTER)

