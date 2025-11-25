from tkinter import ttk


class ListScrollable(ttk.Treeview):
    def __init__(self, container, text):
        scrollbar = ttk.Scrollbar(container)
        super().__init__(container, yscrollcommand=scrollbar.set, show="tree")
        scrollbar.configure(command=self.yview)
        scrollbar.pack(side="right", fill="y")
        self.pack(side="left", fill="both", expand=True)

        for i in range(100):
            self.insert("", "end", text=f"{text}: {i+1}")
