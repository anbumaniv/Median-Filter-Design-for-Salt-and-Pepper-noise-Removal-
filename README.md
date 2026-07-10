# Median-Filter-Design-for-Salt-and-Pepper-noise-Removal-
Robust Decision-Based Hybrid Median Filtering Framework for Real-Time Mixed Impulse Noise Removal on FPGA

This repository contains the implementation and experimental resources associated with the research work:


# Project Overview

This work presents a hardware-efficient Robust Decision-Based Hybrid Median Filter (RDHMF) for removing high-density mixed impulse noise from grayscale and colour images. The proposed framework combines adaptive noisy-pixel detection, spatial correlation-based median estimation, directional weighted restoration, and majority-voting based recovery to achieve high restoration quality while maintaining low hardware complexity.

The complete hardware architecture has been implemented and validated on the PYNQ-Z2 (Xilinx Zynq-7000 XC7Z020) FPGA platform using Vivado 2022.1 and the PYNQ overlay framework. The proposed design is evaluated on Set-12, Kodak, and BSDS500 datasets under mixed impulse noise densities ranging from 10% to 90%.

# Repository Contents

This repository includes the following materials:

Verilog HDL source files for the complete RDHMF architecture
Hybrid comparator and spatial correlation-based median sorting modules
Vivado project files and FPGA implementation configuration
PYNQ overlay (.bit/.hwh) files for hardware deployment
Python/Jupyter Notebook scripts for FPGA execution
Benchmark datasets and representative test images


# Hardware Platform
FPGA Board: PYNQ-Z2

Device: AMD Xilinx XC7Z020-1CLG400C

Design Tool: Vivado ML Edition 2022.1

Processing System: Dual-Core ARM Cortex-A9

Software Environment: PYNQ v2.7 with Jupyter Notebook

# Datasets

The proposed framework is evaluated using the following benchmark datasets:

Set-12- https://www.kaggle.com/datasets/leweihua/set12-231008

Kodak Image Dataset -https://www.kaggle.com/datasets/balraj98/berkeley-segmentation-dataset-500-bsds500

BSDS500 Dataset- https://www.kaggle.com/datasets/sherylmehta/kodak-dataset

Mixed impulse noise consisting of 80% fixed-valued salt-and-pepper noise and 20% random-valued impulse noise is added at densities ranging from 10% to 90%.

# Evaluation Metrics

The restoration performance is evaluated using:

Peak Signal-to-Noise Ratio (PSNR)

Structural Similarity Index (SSIM)

Mean Squared Error (MSE)

Image Enhancement Factor (IEF)

# The hardware implementation is evaluated using:

FPGA resource utilization

Critical path delay

Throughput

Power consumption

Reproducibility

This repository provides the complete implementation resources required to reproduce the experimental results reported in the manuscript, including HDL source files, FPGA configuration, evaluation scripts, and representative datasets.
