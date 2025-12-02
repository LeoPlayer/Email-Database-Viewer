import tkinter as tk
from tkinter import ttk


class AutoHideScrollbar(ttk.Scrollbar):
    # size_widget is a widget with a reqheight of the entire scrolling region (> frame height when scrollbar necessary)
    def __init__(self, master, size_widget, *args, **kwargs):
        ttk.Scrollbar.__init__(self, master, *args, **kwargs)
        self.master.bind("<Configure>", lambda e: self.auto_hide(size_widget, e), add="+")

    def auto_hide(self, size_widget, e):
        if size_widget.winfo_reqheight() > e.height:
            self.pack(side=tk.RIGHT, fill=tk.Y)
        else:
            self.pack_forget()
