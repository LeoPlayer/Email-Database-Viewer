# Source - https://stackoverflow.com/a
# Posted by Honest Abe, modified by community. See post 'Timeline' for change history
# Retrieved 2025-12-01, License - CC BY-SA 4.0

import tkinter # Tkinter -> tkinter in Python 3
from Menus.right_click_menu import RightClickMenu

class FancyListbox(tkinter.Listbox):

    def __init__(self, parent, *args, **kwargs):
        tkinter.Listbox.__init__(self, parent, *args, **kwargs)

        self.popup_menu = RightClickMenu(self)
        self.popup_menu.add_command(label="Delete",
                                    command=self.delete_selected)
        self.popup_menu.add_command(label="Select All",
                                    command=self.select_all)

    def delete_selected(self):
        for i in self.curselection()[::-1]:
            self.delete(i)

    def select_all(self):
        self.selection_set(0, 'end')


root = tkinter.Tk()
flb = FancyListbox(root, selectmode='multiple')
for n in range(10):
    flb.insert('end', n)
flb.pack()
root.mainloop()
