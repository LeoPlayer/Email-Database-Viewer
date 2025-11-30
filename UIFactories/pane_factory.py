import tkinter as tk
from tkinter import ttk
from UIFactories.list_factory import create_left_list, create_right_list
from Frames.scrollable_frame import ScrollableFrame


def menu_temp_func():
    print("button pressed")


def temp_import_func():
    print(1)


def set_menu(root):
    menu_bar = tk.Menu(root)
    file_menu = tk.Menu(menu_bar, tearoff=0)
    file_menu.add_command(label="New", command=menu_temp_func)
    file_menu.add_command(label="Open", command=menu_temp_func)
    file_menu.add_command(label="Save", command=menu_temp_func)
    file_menu.add_separator()
    file_menu.add_command(label="Quit", command=root.quit)
    menu_bar.add_cascade(label="File", menu=file_menu)
    root.config(menu=menu_bar)


def set_toolbar(root, app):
    frame_toolbar = ttk.Frame(root)
    import_button = ttk.Button(master=frame_toolbar, text="Import", command=lambda: app.get_sash_pos(0))
    import_button.pack(side=tk.LEFT, padx=(5, 0))
    frame_toolbar.pack(fill=tk.X)


def create_left_pane(app):
    pane = ttk.Frame(app.pw)
    create_left_list(pane)
    return pane


def create_right_pane(app):
    # To add
    # e.g. search button

    body = ttk.Frame(app.pw)
    body.pack(fill=tk.BOTH, expand=True)
    pane = ScrollableFrame(body)
    create_right_list(pane)

    pane.update()

    return body
