# Third-Party Software

This file documents third-party software used by this repository and
clarifies ownership, license terms, modification status, and citation
requirements.

## SACDm

- Project: SACDm
- Original repository: https://github.com/WeisongZhao/SACDm
- Original authors: Weisong Zhao and contributors
- Paper: Weisong Zhao et al., "Enhanced detection of fluorescence fluctuation for high-throughput super-resolution imaging", Nature Photonics, 2023.
- DOI: https://doi.org/10.1038/s41566-023-01234-9
- License: Open Data Commons Open Database License v1.0, with non-commercial-use language stated in the SACDm repository README.

PISADM uses SACDm during fluctuation-based reconstruction. SACDm is
third-party software and is not owned by the PISADM authors.

## Included SACDm Copy

This repository may include a local SACDm copy under:

```text
SACDm-main/
```

The local SACDm copy is not identical to the upstream SACDm repository.
Some files have been modified and some local files have been added for use
with the PISADM workflow.

The differences are documented in:

```text
MODIFICATIONS.md
```

## License Boundary

The PISADM license applies only to PISADM-owned code and documentation. It
does not relicense SACDm, modified SACDm files, or any other third-party
materials.

SACDm files, including modified SACDm files in this repository, remain
subject to the original SACDm authors' ownership, license terms, citation
requirements, and non-commercial-use restrictions, to the extent applicable.

Users should review:

```text
LICENSE
MODIFICATIONS.md
SACDm-main/LICENSE.txt
SACDm-main/README.md
```

before using, redistributing, or publishing results generated with this
repository.

## Citation

If SACDm contributes to published results generated with PISADM, please cite
the SACDm paper in addition to any PISADM-related publication:

```text
Weisong Zhao et al., "Enhanced detection of fluorescence fluctuation for
high-throughput super-resolution imaging", Nature Photonics, 2023.
https://doi.org/10.1038/s41566-023-01234-9
```

## Redistribution Notes

If you redistribute this repository together with SACDm or any other
third-party software:

- Keep the original third-party license files.
- Keep original copyright notices and citation information.
- Keep links to the original repositories.
- Clearly state when third-party files have been modified.
- Do not apply the PISADM license to third-party files.

For SACDm-specific modifications, see `MODIFICATIONS.md`.
