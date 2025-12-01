import tkinter as tk
from tkinter import ttk
from CustomWidgets.right_click_menu import RightClickMenu
import lorem


def create_left_list(pane):
    scrollbar = ttk.Scrollbar(pane)
    left_list = ttk.Treeview(pane, yscrollcommand=scrollbar.set, show="tree")
    scrollbar.configure(command=left_list.yview)
    scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
    left_list.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

    right_click_menu = RightClickMenu(left_list)
    right_click_menu.add_command(label="Left Test 1", command=lambda: print("left test 1"))
    right_click_menu.add_command(label="Left Test 2", command=lambda: print("left test 2"))

    left_list.insert("", tk.END, "all", text="All Email Accounts", open=True)
    left_list.insert("all", tk.END, text="All Emails")
    left_list.insert("all", tk.END, text="Inbox")
    left_list.insert("all", tk.END, text="Sent")
    left_list.insert("all", tk.END, text="Flagged")
    left_list.insert("all", tk.END, text="Draft")
    left_list.insert("all", tk.END, text="Deleted")


def create_right_list(frame):
    right_click_menu = RightClickMenu(frame)
    right_click_menu.add_command(label="Right Test 1", command=lambda: print("right test 1"))
    right_click_menu.add_command(label="Right Test 2", command=lambda: print("right test 2"))

    for i in range(100):
        email_frame = tk.Frame(frame)
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

        seperator_frame = tk.Frame(frame, height=5)

        seperator_frame.pack(side=tk.TOP, fill=tk.BOTH, expand=True)
