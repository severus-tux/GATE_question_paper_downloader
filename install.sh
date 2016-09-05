#!/bin/bash

# This is a very minimal installer. This needs to update

touch $PWD/GATE_question_paper_downloader.desktop
echo "[Desktop Entry]
Version=0.1
Name=GATE_question_paper_downloader
Comment=This app is designed to download previous year gate question papers in bulk from http://gate.iitm.ac.in/ (IIT Madras).
Type=Application
Terminal=false
Icon=$PWD/gate-qpd.png
Exec=$PWD/GATE_question_paper_downloader.sh">$PWD/GATE_question_paper_downloader.desktop

chmod a+x $PWD/GATE_question_paper_downloader.sh
chmod a+x $PWD/GATE_question_paper_downloader.desktop
