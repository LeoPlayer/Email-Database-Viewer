from tkinter import ttk


def create_left_list(pane):
    scrollbar = ttk.Scrollbar(pane)
    left_list = ttk.Treeview(pane, yscrollcommand=scrollbar.set, show="tree")
    scrollbar.configure(command=left_list.yview)
    scrollbar.pack(side="right", fill="y")
    left_list.pack(side="left", fill="both", expand=True)

    for i in range(100):
        left_list.insert("", "end", text=f"left data: {i + 1}")


def create_right_list(pane):
    scrollbar = ttk.Scrollbar(pane)
    right_list = ttk.Treeview(pane, yscrollcommand=scrollbar.set, show="tree")
    scrollbar.configure(command=right_list.yview)
    scrollbar.pack(side="right", fill="y")
    right_list.pack(side="left", fill="both", expand=True)

    for i in range(100):
        right_list.insert("", "end", text=f"right data: {i + 1}")
