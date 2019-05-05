# ゼロから作るRAW現像 in R

- <https://moiz.booth.pm/items/1307327>
- <https://github.com/moizumi99/camera_raw_processing>

## Installation

On Ubuntu 18.04:

rawpy

```sh
sudo apt install python3-venv
python3 -m venv venv
. venv/bin/activate
pip install rawpy
```

imager

```sh
sudo apt install libfftw3-dev libx11-dev libtiff-dev
R -q
install.packages("imager")
```

RAW image

```sh
wget https://github.com/moizumi99/camera_raw_processing/raw/master/chart.jpg
```
