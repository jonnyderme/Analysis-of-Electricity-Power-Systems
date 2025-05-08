# Analysis of Electricity Power Systems
## Calculation of the optimal start-up, operation and reservation schedule of (thermal and hydroelectric) units of a private producer

---

### Optional Assignment for "Analysis of Electricity Power Systems" Coursework (2023)
Assignment for the "Analysis of Electricity Power Systems" Course  
Faculty of Engineering, AUTh  
School of Electrical and Computer Engineering  
Electronics and Computers Department

📚 *Course:* Computer Graphics                   
🏛️ *Faculty:* AUTh - School of Electrical and Computer Engineering  
📅 *Semester:* 7th Semester, 2023–2024

---

## 📌 Problem Description
A small private electricity producer  owns two (2) thermal and three (3) hydroelectric generation units. The technical specifications of these units are provided in **Table 1**. The producer participates in the **day-ahead electricity market**, assuming that the clearing prices for the next 24 hours are known through forecasts. As a **price-taker**, the producer cannot influence the market price due to holding a small market share.

The goal is to **maximize expected profit** by calculating the **optimal unit commitment, dispatch schedule, and start-up/shutdown planning** for the thermal and hydro units over a 24-hour period.

## 🎯 Objective
Maximize profit from electricity sales in the day-ahead market while adhering to technical and operational constraints.

## 📊 Model Overview
The problem is formulated as a **Mixed-Integer Programming (MIP)** model with binary and continuous decision variables.

### Sets
- `i ∈ I`: Set of all generation units
- `j ∈ J`: Set of hydro units (subset of `I`)
- `t ∈ T`: Set of hours in the 24-hour scheduling horizon

### Variables
- `p_i(t)`: Output power of unit `i` at hour `t` (MW)
- `u_i(t) ∈ {0,1}`: 1 if unit `i` is online at hour `t`
- `y_i(t) ∈ {0,1}`: 1 if unit `i` starts up at hour `t`
- `z_i(t) ∈ {0,1}`: 1 if unit `i` shuts down at hour `t`

### Parameters
- `λ_t`: Market clearing price at hour `t` (€/MWh)
- `Pmin_i`, `Pmax_i`: Min/max output of unit `i` (MW)
- `Emin_j`, `Emax_j`: Min/max energy for hydro unit `j` (MWh)
- `b_i`: Variable cost of unit `i` (€/MWh)
- `NLC_i`: No-load cost (€/h)
- `SDC_i`: Shutdown cost (€)
- `SUC_i`: Startup cost (€)
- `UT_i`, `DT_i`: Minimum uptime/downtime (h)
- `RU_i`, `RD_i`: Ramp up/down limits (MW/h)
- `Tmax`: Number of scheduling hours (24)
- `Pini_i`: Initial power output at `t=0` (MW)
- `Tini_i`: Initial on/off time at `t=0` (h)
- `uini_i ∈ {0,1}`: Initial unit status at `t=0`

### Objective Function
Maximize:
```
Profit = Σ_t Σ_i [λ_t * p_i(t) - NLC_i * u_i(t) - b_i * p_i(t) - SUC_i * y_i(t) - SDC_i * z_i(t)]
```

## ✅ Constraints
- Minimum up/down time
- Logical startup/shutdown transitions
- One change (start or stop) per hour
- Power bounds (`Pmin`, `Pmax`)
- Ramp rate limits (`RU`, `RD`)
- Energy limits for hydro units (`Emin`, `Emax`)
- Initial conditions for all variables

## 🛠 Tools
- **GAMS**
- **GAMS** (for MIP modeling)
- **GLPK/CBC/Gurobi** (solver)

## 📁 Files
- `main.py`: Main script for model formulation and solution
- `data.csv`: Input data for units and market prices
- `README.md`: Project documentation

## 📈 Goal
Create an automated system to determine the most profitable 24-hour operational plan for all generation units under market and technical constraints.

---

© 2025 – Power Systems Optimization Project
