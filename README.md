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
Currently runs on Linux and BSD based distributions.
Windows support would require rewriting fundamental project structures (dependency on `smartmontool`'s and `lsblk`'s API). Since using this program on Windows is not recommended (because a server should run either Linux or BSD) I would want to refrain from adding a second fundamental structure to the project, just to support an OS that is not suited for server use, compared to its competitors, anyway.
If you really need Windows support, then you need to have a fake `smartmontools` and fake `lsblk` installed on the OS. These fake tools need to have the exact API as their originals. Meaning, the JSON output of the former should be precisely the same. The modification for parsing a different `lsblk`'s would be minimal, so that one is less impactful and this change could be easily implemented. Basically, `lsblk` here just returns a list of devices under `/dev/`, delimited by a newline. Not hard to change this behaviour depending on the OS. However, changing the `SMART` API of `smartmontools` to the API of another `SMART` tool would require rewriting almost everything.

## Goals
1. Minimalism
2. Performance
3. Javascript-lessness!
4. Mobile-friendliness

## Project Status
This project is currently in alpha state. Some basic functionality is missing or incomplete.

## TODO
* ~~Convert `fakesmartctl.sh` to `fakesmartctl.nims`~~
* ~~Determine platform support~~
* Clients gathering storage media info across several servers
* Config file for devices and clients
* ~~Improve performance and efficiency (see TODOs in source)~~
* Improve CSS/HTML frontend (see TODOs in source)
* Add Settings in front-end (changing front-end colours, etc.)
* Add Management in front-end (adding clients, etc.)
* ~~Add build date to About page~~
* ~~Add Git revision to About page~~
* Aliasing devices in front-end
* Set up binary releases
* Set up CI
* Add Dockerfile
* Add docker-compose.yaml
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