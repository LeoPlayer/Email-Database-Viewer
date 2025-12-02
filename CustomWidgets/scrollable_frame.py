import tkinter as tk
from tkinter import ttk
from CustomWidgets.auto_hide_scrollbar import AutoHideScrollbar
from helpers import *


class ScrollableFrame(tk.Frame):
    def __init__(self, frame):
        scrollbar = AutoHideScrollbar(frame, self)

        self.canvas = tk.Canvas(frame, yscrollcommand=scrollbar.set, yscrollincrement=3)
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        scrollbar.config(command=self.canvas.yview)

        self.canvas.bind('<Configure>', self.__fill_canvas, add="+")

        # base class initialization
        tk.Frame.__init__(self, frame)
        self.bind("<Enter>", self.__bind_scrolling, add="+")
        self.bind("<Leave>", self.__unbind_scrolling, add="+")

        # assign this obj (the inner frame) to the windows item of the canvas
        self.windows_item = self.canvas.create_window(0, 0, window=self, anchor=tk.NW)

    def __fill_canvas(self, event):
        self.canvas.itemconfig(self.windows_item, width=event.width)

    def __bind_scrolling(self, _):
        self.bind_all("<MouseWheel>", lambda e: scroll_function(self.canvas, e))

    def __unbind_scrolling(self, _):
        self.unbind_all("<MouseWheel>")

    # run whenever widgets are added
    def update(self):
        self.update_idletasks()
        self.canvas.config(scrollregion=self.canvas.bbox(self.windows_item))
