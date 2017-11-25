#!/bin/bash
#   This file is part of VHDL-FIFO.
# 
#   VHDL-FIFO is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   VHDL-FIFO is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   You should have received a copy of the GNU Lesser General Public License
#   along with VHDL-FIFO.  If not, see <http://www.gnu.org/licenses/>.

rm -f work-obj08.cf Fifo.ghw
ghdl -a --std=08 Fifo.vhd
ghdl -a --std=08 Fifo_tb.vhd
ghdl -e --std=08 Fifo_tb
ghdl -r --std=08 Fifo_tb --wave=Fifo.ghw
