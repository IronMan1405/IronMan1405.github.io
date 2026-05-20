---
layout: project
title: "Self Balancing Robot"
date: 2026-05-19

status: Completed
category: Robotics

tech: ESP32, MPU6050, LQR Control, Complementary Filter, MATLAB
duration: 5 Days
difficulty: Advanced

# github: https://github.com/IronMan1405/self-balancing-robot
# demo: https://youtube.com/your-demo-link
---

## Overview

A two-wheel self balancing robot designed using an LQR (Linear Quadratic Regulator) controller with Kalman filtering for state estimation.

Unlike traditional PID-based balancing bots, this system uses modern state-space control methods to achieve smoother stabilization and better dynamic response.

<!-- The controller parameters were initially designed and tested in MATLAB before being fine-tuned experimentally on the physical robot. -->
Initial controller gains were computed and tested in MATLAB before being refined experimentally on the physical robot.

This project focuses on control systems, sensor fusion, motor response timing, and tuning under real-world disturbances.

---

## Why I Built It

I wanted to build a project that combined mechanics, embedded systems, and mathematics into one real system.

Rather than using the traditional PID controller, I wanted to explore how modern control techniques like LQR and Kalman filtering behave on a real unstable system.

A self-balancing robot is a classic engineering challenge because tiny errors quickly amplify into instability.

The project became a practical introduction to:

- State-space modeling
- Optimal control
- Sensor fusion
- Real-world instability and noise
- The gap between simulation and hardware

---

## System Architecture

```text
MPU6050 → Complementary Filter → State Estimation → LQR Controller → Motor Driver
```

The MPU6050 provides accelerometer and gyroscope data.

A Complementary filter combines both sensor readings to estimate the robot’s tilt angle more reliably under noisy conditions.

The estimated state is then fed into the LQR controller, which computes the optimal corrective motor response required to stabilize the robot.

---

## MATLAB Tuning & Controller Design

The initial LQR gains were computed in MATLAB using the robot's estimated physical parameters, including center of mass values and system constants.

By supplying these values into the control equations, MATLAB was used to calculate the optimal gain matrix for stabilization.

These gains were then implemented on the robot and refined experimentally through real-world testing to account for factors such as:

- Motor imperfections
- Sensor noise
- Mechanical imbalance
- Latency and response differences

The final controller performance was achieved through a combination of theoretical gain calculation and practical tuning on hardware.

### State-space model

The robot was modeled as a simplified inverted pendulum system:

$$
A = 
\begin{bmatrix}
0 & 1 \\
\frac{mgl}{I} & 0
\end{bmatrix}
,\quad
B = 
\begin{bmatrix}
0 \\
\frac{1}{I}
\end{bmatrix}
$$

where,  
- *m* &rarr; Robot mass  
- *l* &rarr; COM height  
- *I* &rarr; Moment of Inertia

### LQR Gain Computation

Controller gains were calculated using MATLAB's `lqr()` function:

```matlab
Q = diag([50, 1]);
R = 0.1;

K = lqr(A, B, Q, R);
```

### Kalman Filtering

A Kalman filter was implemented to improve state estimation by the IMU and filter noisy signals:

```matlab
W = diag([1e-6, 1e-4]);
V = diag([1e-4, 1e-3]);

[L,~,~] = lqe(A, eye(2), C, W, V);
```

This significantly improved stability compared to raw sensor readings.

The complete MATLAB simulation and controller design script is available below.
<a class="project-button"
   href="/assets/code/self_balancing_lqg_controller.m"
   download>
   Download MATLAB Script
</a>

---

## Embedded Implementation

The balancing controller was implemented on an ESP32-C3 using real-time IMU feedback from the MPU6050.

While Kalman filtering was explored during MATLAB simulations, the final embedded implementation used a complementary filter for lightweight real-time state estimation on hardware.

The firmware handled:

* IMU sensor acquisition
* Angle estimation
* Angular velocity measurement
* LQR-based control output
* Motor direction and PWM control
* Runtime tuning through serial commands

### Complementary Filter

Tilt angle estimation was performed using a complementary filter that combined accelerometer and gyroscope measurements:

```cpp
float accel_angle = atan2((float)ax, (float)az);

float gyro_rate = gy * (250.0 / 32768.0) * DEG_TO_RAD;

angle = alpha * (angle + gyro_rate * dt)
        + (1.0 - alpha) * accel_angle;
```

This provided significantly smoother and more stable angle estimates compared to raw IMU readings.

---

### LQR Control Law

The control output was computed using the estimated angle and angular velocity:

```cpp
float u = -(K1 * theta + K2 * theta_dot);
u = constrain(u, -40, 40);
```

The gains $(K_1)$ and $(K_2)$ were initially obtained through MATLAB simulations and later refined experimentally on hardware.

---

### Runtime Gain Tuning

To accelerate real-world tuning, serial commands were implemented to modify controller gains live without recompiling firmware:

```cpp
if (input.startsWith("k1")) {
    K1 = input.substring(2).toFloat();
}

else if (input.startsWith("k2")) {
    K2 = input.substring(2).toFloat();
}
```

This made iterative tuning significantly faster during balancing tests and allowed rapid experimentation with controller response.

---

## Hardware Fine-Tuning

Although MATLAB provided stable initial gains, additional fine-tuning was required on the physical robot to compensate for:

- Motor imperfections
- Sensor noise
- Mechanical imbalance
- Latency and response differences

The final balancing behaviour was achieved through iterative real-world testing and refinement.

---

## Build Process

- Designed and assembled the chassis
- Mounted motors and wheel system
- Integrated MPU6050 sensor
- Implemented Kalman filter
- Developed LQR controller
- Tuned gains in MATLAB
- Fine-tuned experimentally on hardware
- Tested disturbance recovery and stability

---

## Challenges Faced

### Sensor Noise

Raw IMU data introduced jitter and unstable corrections.

**Fix:** Implemented Kalman filtering for smoother and more reliable state estimation.

### Oscillation

Initial LQR gains caused excessive oscillations and overcorrection.

**Fix:** Refined the LQR weighting matrices and experimentally tuned the response on hardware.

### Power Drop

Battery sag affected motor torque consistency.

**Fix:** Used a more stable power source during testing and tuning.

---

## What I Learned

- Real systems behave differently from simulations
- State estimation is just as important as control itself
- Mechanical imperfections strongly affect stability
- Small parameter changes can drastically change system response
- Practical tuning matters as much as theoretical design

---

## Project Repository

The complete project files, MATLAB simulations, controller implementation, and hardware code are available in the repository below.

<a class="project-button secondary"
   href="https://github.com/IronMan1405/self-balancing-robot"
   target="_blank">
   View Repository
</a>

---

## Future Improvements

- Bluetooth control mode
- OLED telemetry display
- Autonomous movement while balancing
- Better chassis aesthetics

---

## Final Thoughts

One of the most satisfying projects I’ve built.

Watching an inherently unstable machine teach itself balance through real-time feedback and control felt like engineering magic.