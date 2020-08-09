![GitHub](https://img.shields.io/badge/license-GPL--3.0-informational?style=plastic)
![Liberapay patrons](https://img.shields.io/liberapay/patrons/Akito?style=plastic)

## What
This is a server that fetches SMART information from the system it runs on. The SMART information is then retrievable at http://127.0.0.1:50232.

## Why
There are many monitoring tools with WebUIs out there, but they are bloated and focus on all kinds of information of the server they are running on, except [SMART](https://en.wikipedia.org/wiki/S.M.A.R.T.) information, which is the only information I really need.
So I decided to create my own tool with a WebUI that shows precisely what I need. Nothing less, nothing more.

## How
Get the project and prepare it:
```
git clone https://github.com/theAkito/smartwatch.git
cd smartwatch
nimble configure
```
To build the project use one of the predefined tasks:
```
nimble fbuild
```
for the release build or
```
cp fakesmartctl.sh /usr/bin/fakesmartctl
nimble dbuild
```
for the debug/development build.

Run the server like this:
```
./smartwatch --port=50232 --dir=./smartwatchstatic
```
The arguments' values above are implicitly used, when running the server without arguments.

Note, that the server needs `root` permissions to be able to run.
This is one of the prerequisites for getting SMART information from hardware.

## Where
Currently runs on Debian based distributions. Linux is generally supported, but currently not accounted for; neither testing-wise nor dependency-checking-wise.
Windows support, could theoretically be possible, however it is not planned and not probable.
(You shouldn't run a server with Windows on it, anyway...)

## Goals
1. Minimalism
2. Performance
3. Javascript-lessness!
4. Mobile-friendliness

## Project Status
This project is currently in alpha state. Some basic functionality is missing or incomplete.

## TODO
* Clients gathering storage media info across several servers
* Config file for devices and clients
* Improve performance and efficiency (see TODOs in source)
* Improve CSS/HTML frontend (see TODOs in source)
* Add Settings in front-end (changing front-end colours, etc.)
* Add Management in front-end (adding clients, etc.)
* Add build date to About page
* Add Git revision to About page
* Aliasing devices in front-end
* Set up binary releases
* Set up CI
* Publish on Nimble

## License
Copyright (C) 2020  Akito <the@akito.ooo>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.