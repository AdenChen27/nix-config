#!/bin/bash

SESSION="course"

# Paths
BASE="$HOME/Library/CloudStorage/Box-Box/Courses"
LATEX="$HOME/Box/latex"

# Start new detached tmux session with LaTeX window as first
tmux new-session -d -s $SESSION -n LaTeX "cd '$LATEX'; exec \$SHELL"

# Create and configure remaining windows
tmux new-window -t $SESSION:1 -n MATH205 "cd '$BASE/MATH205'; exec \$SHELL"
tmux new-window -t $SESSION:2 -n ECON21030 "cd '$BASE/ECON21030'; exec \$SHELL"
tmux new-window -t $SESSION:3 -n ECON202 "cd '$BASE/ECON202'; exec \$SHELL"
tmux new-window -t $SESSION:4 -n SOSC133 "cd '$BASE/SOSC133'; exec \$SHELL"
tmux new-window -t $SESSION:5 -n temp "cd ~; exec \$SHELL"

# Attach to session
tmux attach -t $SESSION
tmux select-window -t 5
