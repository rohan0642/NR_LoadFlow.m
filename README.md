⚡ Load Flow Analysis Using Newton–Raphson Method (MATLAB)
📌 Project Overview

This project implements Load Flow (Power Flow) Analysis of a power system using the Newton–Raphson (NR) method in MATLAB.
The objective is to determine the steady-state bus voltages (magnitude and angle) of a power system under given load and generation conditions.

The implementation is fully software-based, uses numerical methods, and follows standard power system analysis theory.

🎯 Objectives

To model a multi-bus power system using bus and line data

To form the bus admittance matrix (Y-bus)

To solve the nonlinear power flow equations using the Newton–Raphson iterative method

To compute:

Bus voltage magnitudes

Bus voltage phase angles

To study convergence behavior of the NR method

🧠 Why Newton–Raphson Method?

The Newton–Raphson method is preferred for load flow analysis because:

It has quadratic convergence

It is suitable for large-scale power systems

It converges faster than Gauss–Seidel

It is widely used in industry and commercial power system software

🛠️ Software & Tools Used

MATLAB

No external toolboxes required

Pure script-based implementation (no Simulink)

🏗️ System Description
Bus Types
Bus Type	Description	Known Quantities	Unknown Quantities
Slack	Reference bus	Voltage magnitude & angle	P, Q
PV	Generator bus	P, V	Q, δ
PQ	Load bus	P, Q	V, δ
📊 Input Data
1. Bus Data Format
[ Bus No | Bus Type | P (pu) | Q (pu) | V (pu) | δ (rad) ]

2. Line Data Format
[ From Bus | To Bus | R | X | B/2 ]

⚙️ Algorithm Steps

1. Read bus data and line data
2. Form the Y-bus admittance matrix
3. Initialize voltage magnitudes and angles
4. Compute real and reactive power at each bus
5. Calculate power mismatches (ΔP, ΔQ)
6. Apply Newton–Raphson iteration with damping
7. Update voltage magnitude and angle
8. Repeat until convergence
9. Display final results

🔁 Convergence Criteria

The iteration stops when:

max(|ΔP|, |ΔQ|) < 1e-6

📈 Output Results

The program outputs:

Number of iterations required for convergence

Final bus voltage magnitudes (per unit)

Final bus voltage angles (degrees)

Sample Output
Converged in 4 iterations

Final Bus Voltages (pu):
1.0600
1.0400
0.98xx

Final Bus Angles (degrees):
0
-2.xx
-5.xx

🧮 Numerical Stability

A damping factor is used in the update step to:

Avoid divergence

Prevent NaN values

Improve numerical stability

This approach is commonly used in practical power flow solvers.
