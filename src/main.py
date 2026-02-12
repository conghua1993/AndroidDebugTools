import os
import sys
import json
import threading
import subprocess
import tkinter as tk
from tkinter import ttk,messagebox


APP_TITLE = "Android Command GUI Tool"
WINDOW_SIZE = "1100x650"
CREATE_NO_WINDOW = 0x08000000


def enable_dpi_awareness(root):
    if sys.platform.startswith("win"):
        try:
            from ctypes import windll
            windll.shcore.SetProcessDpiAwareness(1)
        except Exception:
            pass
    scaling = root.winfo_fpixels("1i") / 72
    root.tk.call("tk", "scaling", scaling)


def load_configs(conf_file):
    path = os.path.join(os.path.abspath("."), conf_file)

    with open(path, "r" ,encoding = "utf-8") as f:
        data = json.load(f)
    return data.get("groups", []), data.get("ui", {})

class App(tk.Tk):
    def __init__(self, groups, ui_conf):
        super().__init__()
        
        self.groups = groups
        self.ui_conf = ui_conf
        self.title(APP_TITLE)
        self.geometry(WINDOW_SIZE)
        self.minsize(900, 500)
        
        enable_dpi_awareness(self)
        self._build_ui()

    def _build_ui(self):
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill=tk.BOTH, expand=True)

        self.main_tab = ttk.Frame(self.notebook)
        
        self.notebook.add(self.main_tab, text="Command")

        self._build_main_tab()
    
    def _build_main_tab(self):
        paned = ttk.PanedWindow(self.main_tab, orient=tk.VERTICAL)
        paned.pack(fill=tk.BOTH, expand=True)

        cmd_container = ttk.Frame(paned)
        paned.add(cmd_container, weight=6)
    
        cmd_frame = ttk.LabelFrame(cmd_container, text="Command Panel")
        cmd_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=8)

        items_per_column = self.ui_conf.get("items_per_column", 5)
        max_columns = ((len(self.groups) - 1) // items_per_column + 1) * 3

        for c in range(max_columns):
            cmd_frame.columnconfigure(c, weight=1 if c % 3 == 1 else 0)

        for idx, group in enumerate(self.groups):
            col = idx // items_per_column
            row = idx % items_per_column

            print("col" + str(group))
            ttk.Label(cmd_frame,
                      text=group.get("name","")
                      ).grid(row=row, column=col*3, padx=(6,2), pady=4, sticky="w")
            
            items = group.get("items",[])
            if not items:
                continue

            item_map = {i["name"]: i for i in items}
            var = tk.StringVar(value=items[0]["name"])

            ttk.Combobox(
                cmd_frame,
                textvariable=var,
                values=list(item_map.keys()),
                state="readonly",

            ).grid(row=row, column=col * 3 + 1, padx=4, pady=4, sticky="ew")

            ttk.Button(cmd_frame,
                       text="Run",
                       width=6,
                       command=lambda v=var, m=item_map:
                            self.run_command(m[v.get()])
            ).grid(row=row, column=col * 3 + 2, padx=6, pady=4)

        self.output_text = self._create_output_panel(paned, "Output", 4)

    def _create_output_panel(self, paned, title, weight):
        contanier = ttk.Frame(paned)
        paned.add(contanier, weight = weight)

        frame = ttk.LabelFrame(contanier, text=title)
        frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=8)

        frame.rowconfigure(0, weight=1)
        frame.columnconfigure(0, weight=1)

        text = tk.Text(
            frame,
            wrap=tk.WORD,
            font=("Consolas", 10),
            bg="black",
            fg="#00ff00",
            insertbackground="#00ff00"
        )
        text.grid(row=0, column=0, sticky="nsew")
        text.config(state=tk.DISABLED)
        return text
    
    def run_command(self, item):
        command = item.get("cmd")
        workspace = item.get("workspace")

        cwd = os.path.abspath(workspace) if workspace else os.getcwd()

        self._append_output(
            self.output_text,
            f"$ {command}\n[cwd] {cwd} \n\n",
            clear=True
        )

        def task():
            try:
                print("task running")
                proc = subprocess.Popen(
                    ["cmd", "/C", command],
                    cwd=cwd,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    creationflags=CREATE_NO_WINDOW
                )
                for line in proc.stdout:
                    self.after(0, self._append_output, self.output_text, line)
            except Exception as e:
                self.after(
                    0,
                    self._append_output,
                    self.output_text,
                    f"\n [ERROR] {e}\n"
                )
        threading.Thread(target=task, daemon=True).start()
    def _append_output(self, widget, text, clear=False):
        widget.config(state=tk.NORMAL)
        if clear:
            widget.delete(1.0, tk.END)
        widget.insert(tk.END, text)
        widget.see(tk.END)
        widget.config(state=tk.DISABLED)


if __name__ == "__main__":
    groups, ui_conf = load_configs("commands.json")
    app = App(groups, ui_conf)
    app.mainloop()