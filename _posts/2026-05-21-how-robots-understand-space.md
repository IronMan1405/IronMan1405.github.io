---
layout: post
title: "How Robots Understand Space"
date: 2026-05-20
---

## Coordinate Frames, Rotation Matrices, and the Geometry of Robot Motion

If i tell a robot arm to "move forward", what does forward actually mean?

Forward relative to the robot base? <br>
The current joint? <br>
The Camera? <br>
The end effector? <br>

Robots cannot rely on intuition. They need mathematics to describe space itself.

This is why robotics is built on coordinate frames and transformations.

## What are coordinate frames and why do they exist?

A frame is a fixed orientation of axes attached to a body to describe the body's position and orientation. 
Any frame can act as a reference system with respect to which we express the position and orientation of the body, or another body.

**World Frame** - The frame attached to signify the origin or axis orientations of the world/environment.

**Base Frame** - The frame attached to the non-moving base of the robot or manipulator.

**End-effector Frame** - The frame that is attached to the free end (or the output end) of the manipulator is an end-effector frame. And end-effector frame is also called the tool frame in some cases.

**Local Link Frames** - The frames used to represent each of the intermediate links on the manipulator.

<div style="display: flex; justify-content: center; gap: 48px;">
    <figure style="margin: 0; width: 300px; text-align: center;">
        <img src="/assets/images/CoordFrame1.png" style="width: 100%;">
        <figcaption>
            Source:
            <a href="https://roboticseabass.com/2024/06/30/how-do-robot-manipulators-move/">
                How do robot manipulators move
            </a>
        </figcaption>
    </figure>
    <figure style="margin: 0; width: 300px; text-align: center;">
        <img src="/assets/images/CoordFrame2.png" style="width: 90%;">
        <figcaption>
            Source: John J. Craig, Introduction to Robotics: Mechanics and Control
        </figcaption>
    </figure>
</div>

## Vectors and Positions

A particular position refers to a particular coordinate in the given frame. 
Positions are represented differently with respect to different frames.

For example, with respect to the base frame, if the position vector $p$ is given as

$$
P = 
\begin{bmatrix}
1 \\
2 \\
3 \\
\end{bmatrix}
$$

Consider a frame who's axis is translated along a direction from the base frame. 

Then with respect to this frame, $p$ might be given by a different vector, such as:

$$
P = 
\begin{bmatrix}
-2 \\
4 \\
1 \\
\end{bmatrix}
$$

We usually denote the reference frame of the position or coordinate in question by using a leading superscript, ${}^{A}p$ or ${}^{A}P$.
Where $\\{ A \\}$ is the coordinate frame in which $P$ is written.

## Rotation Matrices

Rotation matrices describe how one coordinate frame is oriented relative to another.
They allow vectors expressed in one frame to be re-expressed in another frame.

A rotation matrix acts as the translator between these two descriptions.

For example, if ${}^{A}P$ is a position vector relative to the frame $\\{ A \\}$, and we are to compute ${}^{B}P$ while we know the transformation matrix of $\\{ B \\}$ relative to $\\{ A \\}$, denoted by ${}_{B}^{A}R$, can be computed as:

$$
{}^{B}P = {}_{B}^{A}R \cdot {}^{A}P
$$


In 2-Dimensional spaces, if upon rotating the axes of a reference frame $\\{ A \\}$ by an angle $ \theta $ in an anti-clockwise manner we obtain $\\{ B \\}$. Then the rotation matrix of frame $\\{ B \\}$ relative to frame $\\{ A \\}$ is given by

$$
{}_{B}^{A}R =
\begin{bmatrix}
\cos\theta & -\sin\theta \\
\sin\theta & \cos\theta
\end{bmatrix}
$$

The column vectors of a rotation matrix are the coordinate vectors of basis vectors of $\\{ B \\}$ with respect to the basis of $\\{ A \\}$.

Since, in the case of coordinate frames we are dealing with the axes of the frame, the basis vectors are the unit vectors in the principal direction of the axes of the frame, 
i.e., $\hat{X}_B$, $\hat{Y}_B$, and $\hat{Z}_B$ 
are basis vectors of the frame $\{B\}$ and when written as a coordinate vector to the basis of the frame $\{A\}$, they are denoted by 
${}^{A}\hat{X}_B$, ${}^{A}\hat{Y}_B$, and ${}^{A}\hat{Z}_B$. 

And these unit vectors form the columns of $^{A}_{B}R$.

$$
{}_{B}^{A}R = 
\begin{bmatrix}
{}^{A}\hat{X}_B & {}^{A}\hat{Y}_B & {}^{A}\hat{Z}_B
\end{bmatrix}
$$


Each component of $^{A}_{B}R$ can be written in the form of dot product of pair of unit vectors:

$$
{}_{B}^{A}R = 
\begin{bmatrix}
{}^{A}\hat{X}_B & {}^{A}\hat{Y}_B & {}^{A}\hat{Z}_B
\end{bmatrix}
=
\begin{bmatrix}
\hat{X}_B \cdot \hat{X}_A & \hat{Y}_B \cdot \hat{X}_A & \hat{Z}_B \cdot \hat{X}_A \\
\hat{X}_B \cdot \hat{Y}_A & \hat{Y}_B \cdot \hat{Y}_A & \hat{Z}_B \cdot \hat{Y}_A \\
\hat{X}_B \cdot \hat{Z}_A & \hat{Y}_B \cdot \hat{Z}_A & \hat{Z}_B \cdot \hat{Z}_A
\end{bmatrix}
$$

The leading superscripts in the above form have been omitted, as they are of little significance as long as the frame relative to which both the unit vectors being dotted is same. 

Also, we observe that:

$$
{}_{B}^{A}R = 
\begin{bmatrix}
{}^{A}\hat{X}_B & {}^{A}\hat{Y}_B & {}^{A}\hat{Z}_B
\end{bmatrix}
=
\begin{bmatrix}
{}^{B}\hat{X}_A^T \\ 
{}^{B}\hat{Y}_A^T \\ 
{}^{B}\hat{Z}_A^T
\end{bmatrix}
\\
\implies
{}_{B}^{A}R = 
{}_{A}^{B}R^T
$$

It is also easily verified that the inverse of a rotation matrix is equal to its transpose:

$$
{}_{A}^{B}R \cdot {}_{A}^{B}R^T = I_3 \\
\implies
{}_{A}^{B}R = {}_{B}^{A}R^{-1} = {}_{B}^{A}R^T
$$

Rotation matrices are orthonormal matrices.

Meaning:

- their columns are unit vectors,
- all columns are mutually perpendicular,
- lengths and angles are preserved under rotation.

This property is why the inverse of a rotation matrix is equal to its transpose.

## Representing Translation

The way rotation Matrices describe the relative orientation of coordinate frames, translation vectors describe the relative displacement between coordinate frames.

A rotation matrix alone cannot fully describe the pose of a rigid body, since two frames may have different origins even if their axes remain parallel.

For example, two robotic arm links may have the same orientation while being displaced by some distance in space. 
To represent this displacement, we use a translation vector:

$$
P = 
\begin{bmatrix}
x \\
y \\
z
\end{bmatrix}
$$

If we have a position vector ${}^{B}P$ in $\\{ B \\}$, and the origin of $\\{ B \\}$ relative to $\\{ A \\}$ is given by ${}^{A}P_{BORG}$.
We can then obtain ${}^{A}P$ by performing vector addition:

$$
{}^{A}P = 
{}^{B}P + 
{}^{A}P_{BORG}
$$

<div style="display: flex; justify-content: center; gap: 48px;">
    <figure style="margin: 0; width: 600px; text-align: center;">
        <img src="/assets/images/TranslationalMapping.png" style="width: 85%;">
        <figcaption>
            Source: John J. Craig, Introduction to Robotics: Mechanics and Control
        </figcaption>
    </figure>
</div>

## Homogeneous Transformation Matrices

To fully represent the pose of a rigid body, robotics combines the rotation and translation matrices into a single mathematical object called the *homogeneous transformation matrix*.

In real robots, most frames are a result of transformation of one frame by both rotation *and* translation. In such cases we can compute the position vector relative to the transformed frame by first finding its position vector in an intermediate frame that has the same orientation as the resulting frame, and then translate it.

$$
{}^{A}P = 
{}_{B}^{A}R \,
{}^{B}P + 
{}^{A}P_{BORG}
$$

<div style="display: flex; justify-content: center; gap: 48px;">
    <figure style="margin: 0; width: 600px; text-align: center;">
        <img src="/assets/images/GeneralTransform.png" style="width: 85%;">
        <figcaption>
            Source: John J. Craig, Introduction to Robotics: Mechanics and Control
        </figcaption>
    </figure>
</div>

However, we would like to think of transformations from one frame to another as a single operator in matrix form that enables us to write the above equation as:

$$
{}^{A}P = 
{}_{B}^{A}T \,
{}^{B}P
$$

Where we call ${}_{B}^{A}T$ the transformation matrix of $\\{ B \\}$ relative to $\\{ A \\}$.
In order to write the original transformation equation in the matrix operator form, we use `4x1` position vectors and `4x4` matrix operator, that has the structure:

$$
\begin{bmatrix}
{}^{A}P \\
1
\end{bmatrix}
=
\left[
\begin{array}{c|c}
  {}_{B}^{A}R & {}^{A}P_{BORG} \\
  \hline
  0 \quad 0 \quad 0 & 1
\end{array}
\right]
\begin{bmatrix}
{}^{B}P \\
1
\end{bmatrix}
$$

Homogeneous coordinates allow translation to be represented as matrix multiplication.

Without the additional coordinate, translation and rotation cannot be combined into a single linear operator.

A robotic manipulator is fundamentally a chain of coordinate transformations.
Every movement of a robot arm is ultimately described through rotations and translations between coordinate frames.

Before a robot can interact with the world, it must first understand how to represent space itself.