#!/usr/bin/env python3
"""Search Hopf bifurcation points for the asymmetric kernel in budengyao.pdf.

The program fixes ``tau`` and solves for positive pairs ``(omega, epsilon)``
that satisfy the characteristic equation at a chosen spatial mode ``n``.
It uses the real / imaginary parts of the characteristic equation after
substituting ``lambda = i * omega``:

    sin(omega * epsilon)
        = epsilon * (tau - epsilon) * omega**3 / (2 * d2 * u_bar * mu_n)
          + epsilon / tau * sin(omega * tau)

    cos(omega * epsilon)
        = (tau - epsilon) / tau
          + epsilon / tau * cos(omega * tau)
          - epsilon * (tau - epsilon) * (d1 * mu_n - f_u) * omega**2
            / (2 * d2 * u_bar * mu_n)

These are equivalent to equations (0.8) and (0.9) in budengyao.pdf and
directly characterize critical epsilon values for Hopf bifurcation.
"""

from __future__ import annotations

import argparse
import csv
import importlib
import math
import subprocess
import sys
from dataclasses import dataclass, asdict


def _pip_install(pkg: str) -> None:
    print(f"Installing {pkg} ...")
    subprocess.check_call(
        [
            sys.executable,
            "-m",
            "pip",
            "install",
            "--user",
            "--break-system-packages",
            pkg,
        ]
    )


def ensure_import(import_name: str, pip_name: str | None = None):
    if pip_name is None:
        pip_name = import_name
    try:
        return importlib.import_module(import_name)
    except ImportError:
        _pip_install(pip_name)
        return importlib.import_module(import_name)


np = ensure_import("numpy", "numpy")
root = ensure_import("scipy.optimize", "scipy").root


@dataclass(frozen=True)
class Params:
    d1: float = 0.3
    d2: float = 1.5
    r1: float = 0.1
    tau: float = 2.0
    u_bar: float = 1.0
    L: float = math.pi

    @property
    def f_u(self) -> float:
        # f(u) = r1 * u * (1 - u), so f'(u_bar = 1) = -r1
        return -self.r1

    def mu_n(self, n: int) -> float:
        # Neumann mode on (0, L): cos(n * pi * x / L)
        return (n * math.pi / self.L) ** 2


@dataclass(frozen=True)
class BranchPoint:
    n: int
    omega: float
    epsilon: float
    theta: float
    k: int
    mu_n: float
    residual_norm: float


def phase_theta(angle: float) -> float:
    theta = math.fmod(angle, 2.0 * math.pi)
    if theta < 0:
        theta += 2.0 * math.pi
    return theta


def hopf_system(vec: np.ndarray, n: int, params: Params) -> np.ndarray:
    omega, epsilon = float(vec[0]), float(vec[1])
    mu_n = params.mu_n(n)
    coupling = params.d2 * params.u_bar * mu_n
    drift = params.d1 * mu_n - params.f_u

    if omega <= 0 or epsilon <= 0 or epsilon >= params.tau:
        return np.array([1e3 + abs(omega), 1e3 + abs(epsilon)], dtype=float)

    sin_residual = (
        math.sin(omega * epsilon)
        - epsilon * (params.tau - epsilon) * omega**3 / (2.0 * coupling)
        - epsilon / params.tau * math.sin(omega * params.tau)
    )
    cos_residual = (
        math.cos(omega * epsilon)
        - (params.tau - epsilon) / params.tau
        - epsilon / params.tau * math.cos(omega * params.tau)
        + epsilon
        * (params.tau - epsilon)
        * drift
        * omega**2
        / (2.0 * coupling)
    )
    return np.array([sin_residual, cos_residual], dtype=float)


def refine_candidate(
    omega_guess: float,
    epsilon_guess: float,
    n: int,
    params: Params,
) -> BranchPoint | None:
    eps_tol = 1e-3
    omega_tol = 1e-3
    solved = root(
        hopf_system,
        x0=np.array([omega_guess, epsilon_guess], dtype=float),
        args=(n, params),
        method="hybr",
    )
    omega, epsilon = solved.x
    residual = hopf_system(np.array([omega, epsilon]), n, params)
    residual_norm = float(np.linalg.norm(residual, ord=2))

    if (not solved.success) and residual_norm > 1e-7:
        return None
    if omega <= omega_tol:
        return None
    if not (eps_tol < epsilon < params.tau - eps_tol):
        return None
    if residual_norm > 1e-6:
        return None

    theta = phase_theta(omega * epsilon)
    k = int(round((omega * epsilon - theta) / (2.0 * math.pi)))
    return BranchPoint(
        n=n,
        omega=float(omega),
        epsilon=float(epsilon),
        theta=float(theta),
        k=k,
        mu_n=params.mu_n(n),
        residual_norm=residual_norm,
    )


def deduplicate(points: list[BranchPoint], atol: float = 1e-6) -> list[BranchPoint]:
    unique: list[BranchPoint] = []
    for point in sorted(points, key=lambda item: (item.n, item.epsilon, item.omega)):
        if not any(
            point.n == seen.n
            and abs(point.epsilon - seen.epsilon) < atol
            and abs(point.omega - seen.omega) < atol
            for seen in unique
        ):
            unique.append(point)
    return unique


def search_mode(
    n: int,
    params: Params,
    epsilon_samples: int,
    omega_max: float,
    omega_samples: int,
) -> list[BranchPoint]:
    candidates: list[BranchPoint] = []
    epsilon_grid = np.linspace(1e-3, params.tau - 1e-3, epsilon_samples)
    omega_grid = np.linspace(0.2, omega_max, omega_samples)

    for epsilon_guess in epsilon_grid:
        for omega_guess in omega_grid:
            point = refine_candidate(omega_guess, epsilon_guess, n, params)
            if point is not None:
                candidates.append(point)

    return deduplicate(candidates)


def write_csv(points: list[BranchPoint], output_path: str) -> None:
    rows = [asdict(point) for point in points]
    with open(output_path, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "n",
                "mu_n",
                "epsilon",
                "omega",
                "theta",
                "k",
                "residual_norm",
            ],
        )
        writer.writeheader()
        writer.writerows(rows)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Search Hopf bifurcation points for the kernel in budengyao.pdf."
    )
    parser.add_argument("--d1", type=float, default=0.3)
    parser.add_argument("--d2", type=float, default=1.5)
    parser.add_argument("--r1", type=float, default=0.1)
    parser.add_argument("--tau", type=float, default=2.0)
    parser.add_argument("--u-bar", dest="u_bar", type=float, default=1.0)
    parser.add_argument("--L", type=float, default=math.pi)
    parser.add_argument("--n-min", type=int, default=1)
    parser.add_argument("--n-max", type=int, default=4)
    parser.add_argument("--epsilon-samples", type=int, default=24)
    parser.add_argument("--omega-max", type=float, default=20.0)
    parser.add_argument("--omega-samples", type=int, default=40)
    parser.add_argument("--csv", type=str, default="")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    params = Params(
        d1=args.d1,
        d2=args.d2,
        r1=args.r1,
        tau=args.tau,
        u_bar=args.u_bar,
        L=args.L,
    )

    all_points: list[BranchPoint] = []
    for n in range(args.n_min, args.n_max + 1):
        all_points.extend(
            search_mode(
                n=n,
                params=params,
                epsilon_samples=args.epsilon_samples,
                omega_max=args.omega_max,
                omega_samples=args.omega_samples,
            )
        )

    all_points = deduplicate(all_points)

    print("Parameters")
    print(
        f"  d1={params.d1}, d2={params.d2}, r1={params.r1}, tau={params.tau}, "
        f"u_bar={params.u_bar}, L={params.L}"
    )
    print(f"  equilibrium u_bar={params.u_bar}, f_u={params.f_u}")
    print()

    if not all_points:
        print("No critical points found in the current search box.")
        print("Try increasing --omega-max, --omega-samples, or --epsilon-samples.")
        return

    print("Critical points")
    for point in all_points:
        print(
            "  "
            f"n={point.n:>2d}, mu_n={point.mu_n:>8.4f}, "
            f"epsilon={point.epsilon:>10.6f}, omega={point.omega:>10.6f}, "
            f"theta={point.theta:>9.6f}, k={point.k:>2d}, "
            f"residual={point.residual_norm:.2e}"
        )

    if args.csv:
        write_csv(all_points, args.csv)
        print()
        print(f"Saved CSV: {args.csv}")


if __name__ == "__main__":
    main()
