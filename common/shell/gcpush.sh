#!/bin/bash
# Simple script to add, commit and push stuff to GitHub

git add .
git commit -m "$1"
git push
