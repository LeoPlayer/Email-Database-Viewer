import tkinter as tk


MACOS = "aqua"
WINDOWS = "win32"


def get_root(widget):
    if widget.master is None:
        return widget

    root = widget.winfo_toplevel()
    if root.master:
        root = root.master

    return root


def get_os(widget):
    return get_root(widget).tk.call("tk", "windowingsystem")


def scroll_function(scrollable_widget, event):
    scroll_amount = -event.delta if get_os(scrollable_widget) == MACOS else -event.delta // 10
    scrollable_widget.yview_scroll(scroll_amount, "units")
