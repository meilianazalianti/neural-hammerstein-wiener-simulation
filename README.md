# Neural Hammerstein-Wiener Model for Magnesium Extraction Simulation

The Neural Hammerstein-Wiener (NHW) model is used to simulate the magnesium (Mg) extraction process from magnesium oxide (MgO) in a bittern-based solution. The NHW model was chosen for its ability to represent nonlinear systems composed of linear and nonlinear components, aligning with the complexity of the extraction process.

## Project Overview

The model aims to predict the percentage of magnesium (Mg%) extracted using experimental input variables. This approach utilizes a semi-empirical experimental dataset and applies a Neural Hammerstein-Wiener structure for system identification and modeling.

## Dataset

- **Source**: Semi-empirical experimental data by Sudibyo & Rahmat Sanjaya
- **Type**: MISO (Multiple Input Single Output)
- **Inputs**:
  - Mass of CaCl₂ (g)
  - Mass of Ca(OH)₂ (g)
  - Calcination Temperature (°C)
  - Magnesium content in bittern (%)
- **Output**:
  - Magnesium extracted (% Mg)

> The dataset consists of 20 original samples, augmented by a factor of 20 to obtain 100 data points. Inputs are formatted as a 4×100 matrix, and the output as a 1×100 vector.

## Methodology

- Implemented a **Neural Hammerstein-Wiener model** structure.
- Evaluated various combinations of dataset splitting and hidden neuron configurations.
- Model training and simulation were conducted to minimize prediction error.

## Results

The best-performing model achieved:

- **MSE**: 0.000012589
- **MAPE**: 2.9312%

These results demonstrate the model's high accuracy in simulating the Mg extraction process, outperforming other variations in dataset size and model complexity.

