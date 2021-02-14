# pyfirmata-r

## Installation

On Ubuntu 20.04:

Install Arduino IDE

```sh
sudo apt install arduino
sudo usermod -aG dialout $USER
sudo shutdown -r now
```

and load StandardFirmata sketch.

Install [pyfirmata](https://pypi.org/project/pyFirmata/)

```sh
sudo apt install python3-venv
python3 -m venv venv
. venv/bin/activate
pip install pyfirmata
```

## How to play

```r
library(reticulate)

use_python("./venv/bin/python3", required = TRUE)

# check config
py_discover_config("pyfirmata")

pyfirmata <- import("pyfirmata")
board <- pyfirmata$Arduino("/dev/ttyACM0")

pin <- 14
board$digital[[pin]]$write(1)
```

## Shiny app

```r
library(shiny)
runApp("blink_app")
```
