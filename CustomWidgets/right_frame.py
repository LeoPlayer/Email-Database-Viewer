import tkinter as tk
from tkinter import ttk
from CustomWidgets.right_click_menu import RightClickMenu
from CustomWidgets.scrollable_frame import ScrollableFrame
import lorem


class RightFrame(ttk.Frame):
    def __init__(self, master):
        ttk.Frame.__init__(self, master)

        self.sc_frame = ScrollableFrame(self)

        right_click_menu = RightClickMenu(self.sc_frame)
        right_click_menu.add_command(label="Right Test 1", command=lambda: print("right test 1"))
        right_click_menu.add_command(label="Right Test 2", command=lambda: print("right test 2"))

        for i in range(100):
            email_frame = tk.Frame(self.sc_frame)
            t = tk.Text(email_frame, height=1, width=80, highlightthickness=0)
            t.insert("1.0", "text 1: " + str(i + 1) + ", " + lorem.text())
            t.grid(row=0, column=0, sticky=tk.E)
            t2 = tk.Text(email_frame, height=1, width=80, highlightthickness=0)
            t2.insert("1.0", "time")
            t2.grid(row=0, column=1, sticky=tk.W)
            t3 = tk.Text(email_frame, height=1, width=80, highlightthickness=0)
            t3.insert("1.0", "text 2: " + str(i + 1))
            t3.grid(row=1, column=0, columnspan=2, sticky=tk.NSEW)

            email_frame.columnconfigure(0, weight=1)
            email_frame.columnconfigure(1, weight=1)

            email_frame.pack(side=tk.TOP, fill=tk.BOTH, expand=True)

            seperator_frame = tk.Frame(self.sc_frame, height=5)

            seperator_frame.pack(side=tk.TOP, fill=tk.BOTH, expand=True)

        self.sc_frame.update()
