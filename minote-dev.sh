#!/bin/bash
cd ~/source/minote
distrobox enter tw -- hx ~/source/minote/*.go ~/source/minote/ui/main_window.go ~/source/minote/ui/note_page.go -w ~/source/minote
