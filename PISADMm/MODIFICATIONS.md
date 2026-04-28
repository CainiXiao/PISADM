# Modifications to SACDm

This file documents the differences between the SACDm copy in this
repository and the upstream SACDm repository.

## Upstream Reference

- Project: SACDm
- Upstream repository: https://github.com/WeisongZhao/SACDm
- Compared branch/archive: `master`
- Paper: Weisong Zhao et al., "Enhanced detection of fluorescence fluctuation for high-throughput super-resolution imaging", Nature Photonics, 2023.
- DOI: https://doi.org/10.1038/s41566-023-01234-9

The original SACDm source code, license terms, citation requirements, and
ownership remain with the original SACDm authors.

## Summary

The local `SACDm-main` folder is not identical to the upstream SACDm
repository. The local copy contains direct edits to several upstream files
and two additional files.

No upstream files are missing from the local copy.

## Modified Upstream Files

```text
SACDm-main/demo.m
SACDm-main/README.md
SACDm-main/SACDm/SACDm.m
SACDm-main/SACDm/Sparse/SparseHessian_core.m
SACDm-main/SACDm/Utils/Generate_PSF.m
SACDm-main/SACDm/Utils/imreadstack.m
SACDm-main/SACDm/Utils/kernel.m
```

## Added Local Files

```text
SACDm-main/SACDm/SACDm_9.m
SACDm-main/SACDm/Utils/kernel_9.m
```

## Detailed Changes

### SACDm-main/SACDm/SACDm.m

The local version changes the main SACDm function behavior:

- Returns two outputs instead of one:

```matlab
function [SACDresult,datadecon] = SACDm(imgstack, varargin)
```

- Changes the default `subfactor` from `0.8` to `0.5`.
- Suppresses several progress messages and timing output.
- Supports a 2D user-provided PSF by calling `fourierInterpolation` with
  `[params.mag,params.mag]` when `params.psf` is 2D.
- Allows `iter1 = 0`; in that case pre-RL deconvolution is skipped and
  `datadecon = stack`.
- Allows `iter2 = 0`; in that case post-RL deconvolution is skipped and
  `SACDresult = cum`.

These changes are algorithmically relevant because they can change the
reconstructed image compared with upstream SACDm.

### SACDm-main/SACDm/Utils/Generate_PSF.m

The local PSF generation changes the integrand by multiplying by `p`:

```matlab
h=@(r,p) 2*exp((1i*u*(p.^2))/2).*besselj(0,2*pi*r*NA/lamda.*p).*p;
```

The upstream version does not include the final `.*p` factor. This is an
algorithmic PSF change and can affect deconvolution results.

### SACDm-main/SACDm/Utils/imreadstack.m

The local version changes:

```matlab
info = imfinfo(imname);
```

to:

```matlab
info = (imname);
```

This changes `imreadstack` from reading TIFF metadata from a filename to
expecting metadata-like input directly. If `imname` is still a filename,
this local version may not behave like upstream SACDm.

### SACDm-main/SACDm/Sparse/SparseHessian_core.m

The local version comments out console output:

- The warning/message for fewer than three frames.
- Per-iteration timing display.

This appears to be a logging-only change.

### SACDm-main/SACDm/Utils/kernel.m

The local version only changes an inline comment near the `Generate_PSF`
call:

```matlab
psf=Generate_PSF(pixel,lambda,nn,NA,z);%nn
```

No functional difference was detected in this file.

### SACDm-main/demo.m

The local demo is substantially changed from the upstream demo:

- Uses a local MRC file path.
- Adds an external path for fluctuation simulation functions.
- Reads MRC data using `ReadMRC`.
- Sets custom parameters such as `ifsparsedecon`, `iter1`, `iter2`, and
  `NA`.
- Calls SACDm on a cropped stack.
- Saves output as MRC using `WriteMRC_withoutHead`.

This is a local experiment/demo adaptation, not a core library dependency
change.

### SACDm-main/README.md

The local README changes several links, including the Twitter link and
website URL. These are documentation-only differences.

### SACDm-main/SACDm/SACDm_9.m

This is an additional local SACDm variant. It is not present upstream. It
keeps verbose logging, uses `kernel_9`, sets `params.subfactor = 1`, and
returns `[SACDresult,datadecon]`.

### SACDm-main/SACDm/Utils/kernel_9.m

This is an additional local kernel helper. It calls:

```matlab
psf=Generate_PSF(pixel,lambda,4,NA,z);
```

instead of using the adaptive `nn` value selected above it. This can change
the generated PSF size/shape relative to upstream `kernel.m`.

## Redistribution Notes

If this modified SACDm copy is redistributed with PISADM:

- Keep the original SACDm license file.
- Keep the original SACDm citation and repository link.
- Clearly state that this is a modified SACDm copy.
- Do not apply the PISADM license to SACDm files.
- Respect the non-commercial-use language stated in the SACDm repository.

If possible, consider publishing the SACDm changes as a fork or as a patch
against the upstream SACDm repository so users can inspect the exact
differences.


