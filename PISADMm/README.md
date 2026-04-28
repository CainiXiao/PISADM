# PISADM

PISADM is a MATLAB implementation of parallel image-scanning autocorrelation-deconvolution microscopy, combining multifocal illumination, scanning-position-wise SACD reconstruction, and focus-wise pixel reassignment.

The main workflow is provided in:

```matlab
PISADM.m
```

## Data Availability

The representative raw and reconstructed datasets used for the PISADM demo and for reproducing the main reconstruction workflow are hosted on Figshare.

- Figshare dataset: **[replace with Figshare title]**
- DOI / URL: **[replace with Figshare DOI or URL]**

Please download the dataset from Figshare before running the demo. After downloading, place the data in a local folder and update the `DataPath` variable in `PISADM.m` accordingly.

Suggested local folder structure:

```text
PISADM/
├── PISADM.m
├── SACDm-main/
├── data/                  # downloaded Figshare data can be placed here
│   └── <dataset files>
└── results/               # reconstructed outputs will be saved here
```

The Figshare dataset may include representative raw image sequences, reconstruction inputs, and reconstructed results. Large time-series microscopy data are not stored directly in this GitHub repository to keep the repository lightweight and easy to clone.

## Requirements

- MATLAB
- Image Processing Toolbox
- SACDm MATLAB code

This repository may include a local SACDm copy under `SACDm-main/`. The included SACDm copy is third-party software and is not owned by the PISADM authors. Some SACDm files in this repository have been modified for use with the PISADM workflow.

## Third-Party Software

PISADM uses SACDm during reconstruction:

- Original repository: https://github.com/WeisongZhao/SACDm
- Paper: Weisong Zhao et al., "Enhanced detection of fluorescence fluctuation for high-throughput super-resolution imaging", Nature Photonics, 2023.
- DOI: https://doi.org/10.1038/s41566-023-01234-9

According to the SACDm repository, SACDm and its related methods are for non-commercial use and are distributed under the Open Data Commons Open Database License v1.0.

For third-party ownership, license boundaries, and modified SACDm details, see:

```text
third_party.md
MODIFICATIONS.md
LICENSE
SACDm-main/LICENSE.txt
SACDm-main/README.md
```

If SACDm contributes to published results generated with PISADM, please cite the SACDm paper in addition to any PISADM-related publication.

## Installation

1. Download or clone this repository.

2. Confirm that the local SACDm folder is present:

```text
SACDm-main/SACDm/
```

3. Confirm that `PISADM.m` points to the local SACDm folder:

```matlab
addpath(genpath('SACDm-main\SACDm'));
```

If you choose not to use the included modified SACDm copy, download SACDm from the original repository and update the MATLAB path accordingly.

4. Download the representative data from Figshare and place it in a local data folder, for example:

```text
PISADM/data/
```

5. Update the `DataPath` variable in `PISADM.m` to point to the downloaded data.

## Usage

Open MATLAB, set the working folder to this repository, then run:

```matlab
PISADM
```

Before running, edit the data path and reconstruction parameters in `PISADM.m`, especially:

```matlab
DataPath
NA
Lambda
PixelSize
ImSize
IllPitch
ScanParameter
ShiftVectors
LatticeVectors
OffsetVector
PositionN
Frame
subFrame
TimePoints
Numz
```

The script saves the reconstructed result as:

```text
<input-data-name>PISADM.mat
<input-data-name>PISADM.tif
```

## File Structure

```text
PISADM.m             Main PISADM reconstruction script
SACDm-main/          Local SACDm copy used by the workflow
README.md           Project description and usage notes
LICENSE             PISADM license and third-party notices
third_party.md      Third-party software notice
MODIFICATIONS.md    Differences between local SACDm and upstream SACDm
```

The helper functions `generate_lattice` and `subpixel_shift` are included at the end of `PISADM.m` so that the PISADM workflow can be distributed as a single MATLAB file.

## Notes

- The current script uses a user-defined `DataPath`. Update it before running on a new machine.
- Large time-series microscopy datasets are hosted on Figshare rather than stored in this GitHub repository.
- The PISADM license applies only to PISADM-owned code and documentation.
- SACDm and modified SACDm files remain under the original SACDm authors' ownership and license terms.
- Do not remove original SACDm license, citation, or repository information if redistributing SACDm together with this project.

## Citation

If you use this code or dataset, please cite the related PISADM publication and the Figshare dataset. If SACDm contributes to your results, please also cite the SACDm paper listed above.

## License and Ownership

Copyright (c) 2026 PISADM authors. All rights reserved.

See `LICENSE` for PISADM license terms and third-party notices. See `third_party.md` and `MODIFICATIONS.md` for SACDm attribution and modification details.
