import tkinter as tk
from tkinter import ttk
from CustomWidgets.right_click_menu import RightClickMenu


class LeftFrame(ttk.Frame):
    def __init__(self, master):
        ttk.Frame.__init__(self, master)

        scrollbar = ttk.Scrollbar(self)
        self.tree = ttk.Treeview(self, yscrollcommand=scrollbar.set, show="tree")
        scrollbar.configure(command=self.tree.yview)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

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
