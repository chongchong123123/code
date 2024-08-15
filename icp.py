import numpy as np
from scipy.spatial import KDTree


def icp(source_points, target_points, max_iterations=100, tolerance=1e-6):
    """
    Iterative Closest Point (ICP) algorithm for point cloud registration.

    Parameters:
        source_points (np.ndarray): Source point cloud (N x 3).
        target_points (np.ndarray): Target point cloud (M x 3).
        max_iterations (int): Maximum number of iterations.
        tolerance (float): Convergence tolerance.

    Returns:
        np.ndarray: Transformation matrix (4 x 4) that aligns source_points to target_points.
    """

    def closest_points(source, target):
        tree = KDTree(target)
        distances, indices = tree.query(source)
        return target[indices]

    def best_fit_transform(A, B):
        # Compute the centroid of each point cloud
        centroid_A = np.mean(A, axis=0)
        centroid_B = np.mean(B, axis=0)

        # Center the point clouds
        AA = A - centroid_A
        BB = B - centroid_B

        # Compute the covariance matrix
        H = np.dot(AA.T, BB)

        # Singular Value Decomposition
        U, _, Vt = np.linalg.svd(H)
        R = np.dot(Vt.T, U.T)

        # Ensure a right-handed coordinate system
        if np.linalg.det(R) < 0:
            Vt[-1, :] *= -1
            R = np.dot(Vt.T, U.T)

        # Compute translation
        t = centroid_B - np.dot(R, centroid_A)

        # Return the transformation matrix
        T = np.eye(4)
        T[:3, :3] = R
        T[:3, 3] = t
        return T

    # Initial transformation matrix
    T = np.eye(4)

    for _ in range(max_iterations):
        # Apply the current transformation to the source points
        source_homogeneous = np.hstack((source_points, np.ones((source_points.shape[0], 1))))
        transformed_source = (T @ source_homogeneous.T).T[:, :3]

        # Find closest points in the target point cloud
        closest_points_target = closest_points(transformed_source, target_points)

        # Compute the best-fit transform between the transformed source and the closest points in target
        T_delta = best_fit_transform(transformed_source, closest_points_target)

        # Update the transformation matrix
        T = T_delta @ T

        # Compute the mean squared error
        mean_error = np.mean(np.linalg.norm(closest_points_target - transformed_source, axis=1))

        # Check for convergence
        if mean_error < tolerance:
            break

    return T


# Example usage:
source_points = np.array([[0, 0, 0], [1, 0, 0], [0, 1, 0]])
target_points = np.array([[1, 1, 0], [2, 1, 0], [1, 2, 0]])

transformation_matrix = icp(source_points, target_points)
print("Transformation Matrix:\n", transformation_matrix)