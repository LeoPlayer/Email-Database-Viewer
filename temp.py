# Source - https://stackoverflow.com/a
# Posted by Mike - SMT
# Retrieved 2025-11-30, License - CC BY-SA 4.0

import tkinter as tk

root = tk.Tk()
root.rowconfigure(0, weight=1)
root.columnconfigure(0, weight=1)
root.columnconfigure(1, weight=1)

def on_mousewheel1(event):
    canvas.yview_scroll(int(-1*(event.delta/120)), "units")

def on_mousewheel2(event):
    canvas2.yview_scroll(int(-1*(event.delta/120)), "units")

def set_binds_canvas1(event):
    frame.bind_all("<MouseWheel>", on_mousewheel1)

def set_binds_canvas2(event):
    frame2.bind_all("<MouseWheel>", on_mousewheel2)

# setup for first canvas
frame = tk.Frame(root)
frame.rowconfigure(0, weight=1)
frame.columnconfigure(0, weight=1)
frame.grid(row=0,column=0, sticky="nsew")

canvas = tk.Canvas(frame, scrollregion=(0,0,500,500))
canvas.grid(row=0, column=0, sticky="nsew")

lbl = tk.Label(canvas, text="Some random text!")
entry = tk.Entry(canvas)
txt = tk.Text(canvas)

canvas.create_window((100, 100), window=lbl)
canvas.create_window((100, 50), window=entry)
canvas.create_window((350, 400), window=txt)

vbar=tk.Scrollbar(frame, orient="vertical")
vbar.grid(row=0, column=1, sticky="ns")
vbar.config(command=canvas.yview)
canvas.config(yscrollcommand=vbar.set)

# setup for second canvas
frame2 = tk.Frame(root)
frame2.rowconfigure(0, weight=1)
frame2.columnconfigure(0, weight=1)
frame2.grid(row=0,column=1, sticky="nsew")

canvas2 = tk.Canvas(frame2, scrollregion=(0,0,500,500))
canvas2.grid(row=0, column=0, sticky="nsew")

lbl2 = tk.Label(canvas2, text="Some random text!")
entry2 = tk.Entry(canvas2)
txt2 = tk.Text(canvas2)

canvas2.create_window((100, 100), window=lbl2)
canvas2.create_window((100, 50), window=entry2)
canvas2.create_window((350, 400), window=txt2)

vbar2=tk.Scrollbar(frame2, orient="vertical")
vbar2.grid(row=0, column=1, sticky="ns")
vbar2.config(command=canvas2.yview)
canvas2.config(yscrollcommand=vbar2.set)

frame.bind("<Enter>", set_binds_canvas1)
frame2.bind("<Enter>", set_binds_canvas2)

root.mainloop()
