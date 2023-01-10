using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Waypoint : MonoBehaviour
{
    public List<Waypoint> successors;
    public Color gizmoColor = Color.yellow;

    public Waypoint GetSuccessor()
    {
        if (successors.Count > 0) {
            return successors[0]; // TODO: Pick at random?
        } else {
            return null;
        }
    }

    void OnDrawGizmos()
    {
        Gizmos.color = gizmoColor;
        if (successors != null) {
            foreach (Waypoint successor in successors) {
                Gizmos.DrawLine(transform.position, successor.transform.position);
            }
        }

        Gizmos.DrawIcon(transform.position, "icon_gizmos_waypoint.png", true);
    }
}
