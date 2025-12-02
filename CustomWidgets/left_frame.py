import tkinter as tk
from tkinter import ttk
from CustomWidgets.right_click_menu import RightClickMenu
from CustomWidgets.auto_hide_scrollbar import AutoHideScrollbar
from helpers import *


class LeftFrame(ttk.Frame):
    def __init__(self, master):
        ttk.Frame.__init__(self, master)

        self.tree = ttk.Treeview(self, show="tree")
        scrollbar_frame = tk.Frame(self)
        tk.Frame(scrollbar_frame, width=0, height=0).pack()
        scrollbar = AutoHideScrollbar(scrollbar_frame, self.tree)
        scrollbar_frame.pack(side=tk.RIGHT, fill=tk.Y)
        # scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.tree.configure(yscrollcommand=scrollbar.set)
        self.tree.pack(side=tk.TOP, fill=tk.X)
        scrollbar.configure(command=self.tree.yview)

        self.right_click_menu = RightClickMenu(self.tree)
        self.right_click_menu.add_command(label="Left Test 1", command=lambda: print("left test 1"))
        self.right_click_menu.add_command(label="Left Test 2", command=lambda: print("left test 2"))

        self.tree.insert("", tk.END, "all", text="All Email Accounts", open=True)
        self.tree.insert("all", tk.END, text="All Emails")
        self.tree.insert("all", tk.END, text="Inbox")
        self.tree.insert("all", tk.END, text="Sent")
        self.tree.insert("all", tk.END, text="Flagged")
        self.tree.insert("all", tk.END, text="Draft")
        self.tree.insert("all", tk.END, text="Deleted")
