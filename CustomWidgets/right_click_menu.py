import tkinter as tk


class RightClickMenu(tk.Menu):
    def __init__(self, parent_frame, *args, **kwargs):
        tk.Menu.__init__(self, parent_frame, *args, **kwargs)

        parent_frame.bind("<Enter>", lambda e: self.__bind_context_menu(parent_frame))
        parent_frame.bind("<Leave>", lambda e: self.__unbind_context_menu(parent_frame))

    def __bind_context_menu(self, parent_frame):
        parent_frame.bind_all("<<ContextMenu>>", lambda e: self.post(e.x_root, e.y_root))

    def __unbind_context_menu(self, parent_frame):
        parent_frame.unbind_all("<<ContextMenu>>")

    # def popup(self, event):
    #     try:
    #         self.tk_popup(event.x_root, event.y_root, 0)
    #     finally:
    #         self.grab_release()
